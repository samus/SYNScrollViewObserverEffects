//
// Created by Sam Corder on 3/7/14.
// Copyright (c) 2014 Synapptic Labs. All rights reserved.
//

#import "SYNScrollObserver.h"


@interface SYNScrollObserver () {
    BOOL _isObserving;
}

@property (weak, nonatomic) UIScrollView *observedScrollView;

@end

static void *ContentOffsetContext = &ContentOffsetContext;

@implementation SYNScrollObserver {
}

- (instancetype)initWithObservedScrollView:(UIScrollView *)observedScrollView
{
    self = [super init];

    if (self) {
        self.observedScrollView = observedScrollView;
        self.maxOffset = CGPointZero;
        self.minOffset = CGPointMake(0, -5);
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

- (void)observedContentOffsetChanged:(CGPoint)point
{
}

- (CGFloat)offSetForObservationDirectionWithPoint:(CGPoint)point
{
    if (self.observeDirection == SYNScrollDirectionVertical) {
        return point.y;
    } else {
        return point.x;
    }
}

@end