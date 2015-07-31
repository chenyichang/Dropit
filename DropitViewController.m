//
//  DropitViewController.m
//  Dropit
//
//  Created by easonchen on 15/7/29.
//  Copyright (c) 2015年 ___FULLUSERNAME___. All rights reserved.
//

#import "DropitViewController.h"
#import "DropitBehavior.h"
#import "BezierView.h"

@interface DropitViewController ()<UIDynamicAnimatorDelegate>

@property (weak, nonatomic) IBOutlet  BezierView *gameView;

@property (strong,nonatomic) UIDynamicAnimator *animator;
@property (strong,nonatomic) DropitBehavior *behavior;
//attach behavior
@property (strong,nonatomic) UIAttachmentBehavior *attachment;
@property (strong,nonatomic) UIView *dropingView;

@end

@implementation DropitViewController

- (UIDynamicAnimator *)animator
{
    if (!_animator) {
        _animator=[[UIDynamicAnimator alloc] initWithReferenceView:self.gameView];
        _animator.delegate=self;
    }
    return _animator;
}

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator
{
    [self removeCompleteRows];
}

- (BOOL)removeCompleteRows
{
    NSMutableArray *dropsToRemove=[[NSMutableArray alloc] init];
    
    for (CGFloat y=self.gameView.bounds.size.height-DROP_SIZE.height/2; y>0; y-=DROP_SIZE.height) {
        BOOL rowIsComplete=YES;
        NSMutableArray *dropsFound=[[NSMutableArray alloc] init];
        for (CGFloat x=DROP_SIZE.width/2; x<(self.gameView.bounds.size.width-DROP_SIZE.width/2); x+=DROP_SIZE.width) {
            UIView *hitView=[self.gameView hitTest:CGPointMake(x, y)	 withEvent:NULL];
            if ([hitView superview]==self.gameView) {
                [dropsFound addObject:hitView];
            }
            else{
                rowIsComplete=NO;
                break;
            }
        }
        if (![dropsFound count]) {
            break;
        }
        if (rowIsComplete) {
            [dropsToRemove addObjectsFromArray:dropsFound];
        }
    }
    
    if ([dropsToRemove count]) {
        for (UIView *dropView in dropsToRemove) {
            [self.behavior removeItem:dropView];
        }
        [self animateRemoveDrops:dropsToRemove];
    }
    
    return NO;
}

static const CGFloat dropsDuration=3.0;

- (void)animateRemoveDrops:(NSArray *)dropsToremove
{
    [UIView animateWithDuration:dropsDuration animations:^{
        for (UIView *drop in dropsToremove) {
            int x=(arc4random()%(int)(self.gameView.bounds.size.width*5))-(int)self.gameView.bounds.size.width*2;
            int y=(int)self.gameView.bounds.size.height;
            drop.center=CGPointMake(x, -y);
        }
    } completion:^(BOOL finished) {
        [dropsToremove makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }];
}

- (DropitBehavior *)behavior
{
    if (!_behavior) {
        _behavior=[[DropitBehavior alloc] init];
        [self.animator addBehavior:_behavior];
    }
    return _behavior;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)tap:(UITapGestureRecognizer *)sender {
    [self drop];
}


- (IBAction)grabDrop:(UIPanGestureRecognizer *)sender {
    CGPoint gesturePoint=[sender locationInView:self.gameView];
    if (sender.state==UIGestureRecognizerStateBegan) {
        [self attachDroppingViewToPoint:gesturePoint];
    }
    else if(sender.state==UIGestureRecognizerStateChanged){
        self.attachment.anchorPoint=gesturePoint;
    }
    else if(sender.state==UIGestureRecognizerStateEnded){
        [self.animator removeBehavior:self.attachment];
        self.gameView.path=nil;
    }
}

- (void)attachDroppingViewToPoint:(CGPoint)anchorPoint
{
    if (self.dropingView) {
        self.attachment=[[UIAttachmentBehavior alloc] initWithItem:self.dropingView attachedToAnchor:anchorPoint];
        UIView *droppingView=self.dropingView;
        __weak DropitViewController *weakSelf=self;
        self.attachment.action=^{
            UIBezierPath *path=[[UIBezierPath alloc] init];
            [path moveToPoint:weakSelf.attachment.anchorPoint];
            [path addLineToPoint:droppingView.center];
            weakSelf.gameView.path=path;
        };
        self.dropingView=nil;
        [self.animator addBehavior:self.attachment];
    }
}

static const CGSize DROP_SIZE={40,40};

- (void)drop
{
    CGRect frame;
    frame.origin=CGPointZero;
    frame.size=DROP_SIZE;
    int x=(arc4random()%(int)self.gameView.bounds.size.width)/DROP_SIZE.width;
    frame.origin.x=x*DROP_SIZE.width;
    
    UIView *dropView=[[UIView alloc]initWithFrame:frame];
    dropView.backgroundColor=[self randomColor];
    [self.gameView addSubview:dropView];
    
    [self.behavior addItem:dropView];
    self.dropingView=dropView;
}

- (UIColor *)randomColor
{
    switch (arc4random()%5) {
        case 0:
            return [UIColor redColor];
        case 1:
            return [UIColor yellowColor];
        case 2:
            return [UIColor orangeColor];
        case 3:
            return [UIColor greenColor];
        case 4:
            return [UIColor purpleColor];
        default:
            return [UIColor blackColor];
    }
}

@end
