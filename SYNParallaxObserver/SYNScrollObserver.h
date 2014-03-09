//
// Created by Sam Corder on 3/7/14.
// Copyright (c) 2014 Synapptic Labs. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SYNScrollObserver : NSObject

@property (nonatomic) CGPoint maxOffset;
@property (nonatomic) CGPoint minOffset;

- (instancetype)initWithObservedScrollView:(UIScrollView *) observedScrollView;
- (void)startObserving;

@end