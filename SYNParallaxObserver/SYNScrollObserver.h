//
// Created by Sam Corder on 3/7/14.
// Copyright (c) 2014 Synapptic Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SYNScrollObservationDirection) {
    SYNScrollDirectionVertical,
    SYNScrollDirectionHorizontal
};

@interface SYNScrollObserver : NSObject

@property(nonatomic) CGPoint maxOffset;
@property(nonatomic) CGPoint minOffset;

@property(nonatomic) enum SYNScrollObservationDirection observeDirection;

- (instancetype)initWithObservedScrollView:(UIScrollView *)observedScrollView;

- (CGFloat)offSetForObservationDirectionWithPoint:(CGPoint)point;

- (void)startObserving;

@end