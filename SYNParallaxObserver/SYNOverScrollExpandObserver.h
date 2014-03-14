//
// Created by Sam Corder on 3/8/14.
// Copyright (c) 2014 Synapptic Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYNScrollObserver.h"


@interface SYNOverScrollExpandObserver : SYNScrollObserver
@property(nonatomic) CGFloat damper;

- (instancetype)initWithObservedScrollView:(UIScrollView *) observedScrollView expandView:(UIView *)expandView;
@end