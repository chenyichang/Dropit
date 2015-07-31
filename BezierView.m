//
//  BezierView.m
//  Dropit
//
//  Created by easonchen on 15/7/31.
//  Copyright (c) 2015年 easonchen. All rights reserved.
//

#import "BezierView.h"

@implementation BezierView

- (void)setPath:(UIBezierPath *)path
{
    _path=path;
    [self setNeedsDisplay];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [self.path stroke];
}


@end
