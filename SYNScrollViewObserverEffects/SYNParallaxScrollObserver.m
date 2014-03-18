//
//  SYNParallaxScrollObserver.m
//  SYNParallaxObserverExample
//
//  Created by Sam Corder on 2/26/14.
//  Copyright (c) 2014 Synapptic Labs. All rights reserved.
//

#import "SYNParallaxScrollObserver.h"

@interface SYNParallaxScrollObserver ()

@property (weak, nonatomic) UIScrollView *parallaxedScrollView;

@end



@implementation SYNParallaxScrollObserver

- (instancetype)initWithObservedScrollView:(UIScrollView *) observedScrollView parallaxedScrollView:(UIScrollView *) parallaxedScrollView
{
    self = [super initWithObservedScrollView:observedScrollView];
    if (self) {
        self.parallaxedScrollView = parallaxedScrollView;
        self.maxOffset = CGPointZero;
        self.minOffset = CGPointMake(0, -5);
        self.parallaxRatio = 5.0f;
    }
    return self;
}

- (void)observedContentOffsetChanged:(CGPoint) point
{
    CGPoint parallaxed = [self parallaxPoint:point];
    [self.parallaxedScrollView setContentOffset:parallaxed animated:NO];
    if (self.delegate) {
        [self.delegate parallaxObserver:self changedParallaxedOffset:parallaxed];
    }
}

- (CGPoint)parallaxPoint:(CGPoint) point
{
    CGPoint p = CGPointMake([self parallaxValue:point.x min:self.minOffset.x max:self.maxOffset.x], [self parallaxValue:point.y min:self.minOffset.y max:self.maxOffset.y]);
    return p;
}

- (CGFloat)parallaxValue:(CGFloat) value min:(CGFloat) min max:(CGFloat) max
{
    CGFloat pv = value/self.parallaxRatio;
    if (max > 0.0f) {
        pv = MIN(max, pv);
    }else if (pv < min) {
        pv = min;
    }
    return pv;
}
@end
