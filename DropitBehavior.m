//
//  DropitBehavior.m
//  Dropit
//
//  Created by easonchen on 15/7/29.
//  Copyright (c) 2015年 easonchen. All rights reserved.
//

#import "DropitBehavior.h"

@interface DropitBehavior()

@property (strong,nonatomic) UIGravityBehavior *gravity;
@property (strong,nonatomic) UICollisionBehavior *collision;
@property (strong,nonatomic) UIDynamicItemBehavior *animationOptions;

@end

@implementation DropitBehavior

- (UIGravityBehavior *)gravity
{
    if (!_gravity) {
        _gravity=[[UIGravityBehavior alloc] init];
    }
    return _gravity;
}

- (UICollisionBehavior *)collision
{
    if (!_collision) {
        _collision=[[UICollisionBehavior alloc] init];
        _collision.translatesReferenceBoundsIntoBoundary=YES;
    }
    return _collision;
}

- (UIDynamicItemBehavior *)animationOptions
{
    if (!_animationOptions) {
        _animationOptions=[[UIDynamicItemBehavior alloc] init];
        _animationOptions.allowsRotation=NO;
    }
    return _animationOptions;
}

- (void)addItem:(id<UIDynamicItem>)item
{
    [self.gravity addItem:item];
    [self.collision addItem:item];
    [self.animationOptions addItem:item];
}

- (void)removeItem:(id<UIDynamicItem>)item
{
    [self.gravity removeItem:item];
    [self.collision removeItem:item];
    [self.animationOptions removeItem:item];
}

- (instancetype)init
{
    self=[super init];
    if (self) {
        [self addChildBehavior:self.gravity];
        [self addChildBehavior:self.collision];
        [self addChildBehavior:self.animationOptions];
    }
    return self;

}

@end
