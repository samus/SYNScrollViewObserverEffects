//
//  SYNParallaxScrollObserver.m
//  SYNParallaxObserverExample
//
//  Created by Sam Corder on 2/26/14.
//  Copyright (c) 2014 Synapptic Labs. All rights reserved.
//

#import "SYNParallaxScrollObserver.h"

@interface SYNParallaxScrollObserver () {
    BOOL _isObserving;
}
@property (weak, nonatomic) UIScrollView *observedScrollView;
@property (weak, nonatomic) UIScrollView *parallaxedScrollView;

@end

static void * ContentOffsetContext = &ContentOffsetContext;

@implementation SYNParallaxScrollObserver

- (instancetype)initWithObservedScrollView:(UIScrollView *) observedScrollView parallaxedScrollView:(UIScrollView *) parallaxedScrollView
{
    self = [super init];
    if (self) {
        self.observedScrollView = observedScrollView;
        self.parallaxedScrollView = parallaxedScrollView;
        self.maxOffset = CGPointZero;
        self.minOffset = CGPointMake(0, -5);
        self.parallaxRatio = 5.0f;
    }
    return self;
}

- (void)startObserving
{
    [self.observedScrollView addObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset)) options:NSKeyValueObservingOptionNew context:ContentOffsetContext];
    _isObserving = YES;
}

- (void)dealloc
{
    if (_isObserving) {
        [self.observedScrollView removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset))];
        _isObserving = NO;
    }

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSString *contentOffset = NSStringFromSelector(@selector(contentOffset));
    if (context == ContentOffsetContext && [keyPath isEqualToString:contentOffset]) {
        CGPoint pt = [change[NSKeyValueChangeNewKey] CGPointValue];
        [self observedContentOffsetChanged:pt];
    }
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
