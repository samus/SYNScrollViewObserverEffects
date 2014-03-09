//
// Created by Sam Corder on 3/8/14.
// Copyright (c) 2014 Synapptic Labs. All rights reserved.
//

#import "SYNOverScrollExpandObserver.h"


@interface SYNOverScrollExpandObserver ()
@property(nonatomic, strong) UIView *expandView;
@end

@implementation SYNOverScrollExpandObserver {

}

- (instancetype)initWithObservedScrollView:(UIScrollView *) observedScrollView expandView:(UIView *)expandView
{
    self = [super initWithObservedScrollView:observedScrollView];
    if (self) {
        self.expandView = expandView;
        self.damper = 7.0f;
    }
    return self;
}

- (void)observedContentOffsetChanged:(CGPoint)point
{
    CGFloat offset = [self offSetForObservationDirectionWithPoint:point];

    if (offset >= 0 ) //&& CGAffineTransformEqualToTransform(CGAffineTransformIdentity, self.expandView.transform) == NO
    {
        [UIView animateWithDuration:.25 animations:^{
            self.expandView.transform = CGAffineTransformIdentity;
        }];

        return;
    }

    CGFloat scale = 1.0 + (offset / self.damper * -0.01);

    if([self shouldTransformToScale:scale]){
        self.expandView.layer.transform = CATransform3DMakeScale(scale, scale, 1.0);
    }

}

- (BOOL)shouldTransformToScale:(CGFloat) scale
{
    static float lastScale = 0.0;

    float diff = ABS(scale - lastScale);
    lastScale = scale;

    return diff > .001;
}

@end