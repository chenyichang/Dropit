//
//  DropitBehavior.h
//  Dropit
//
//  Created by easonchen on 15/7/29.
//  Copyright (c) 2015年 easonchen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropitBehavior : UIDynamicBehavior

- (void)addItem:(id<UIDynamicItem>)item;
- (void)removeItem:(id<UIDynamicItem>)item;

@end
