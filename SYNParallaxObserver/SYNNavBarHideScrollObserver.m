//
//  SYNNavBarHideScrollObserver.m
//  SYNParallaxObserverExample
//
//  Created by Sam Corder on 3/13/14.
//  Copyright (c) 2014 Synapptic Labs. All rights reserved.
//

#import "SYNNavBarHideScrollObserver.h"

@interface SYNNavBarHideScrollObserver ()
@property (weak, nonatomic) UIScrollView *observedScrollView;
@property (strong, nonatomic) UINavigationController *navController;
@property (nonatomic) CGPoint navBarOrigin;
@property (nonatomic) CGPoint lastOffsetPoint;
@end

@implementation SYNNavBarHideScrollObserver {
    float minY;
    float maxY;
}

- (instancetype)initWithObservedScrollView:(UIScrollView *)observedScrollView navigationController:(UINavigationController *)navigationController
{
    self = [super initWithObservedScrollView:observedScrollView];

    if (self) {
        self.navController = navigationController;
        self.navBarOrigin = navigationController.navigationBar.frame.origin;
        self.lastOffsetPoint = CGPointZero;

        minY = -24;
        maxY = self.navBarOrigin.y;
    }

    return self;
}

- (void)observedContentOffsetChanged:(CGPoint)point
{
    if ([self isBouncingAtPoint:point]) {
        return;
    }

    float distance = [self distanceScrolled:point];
    float alpha = [self shiftNavBar:self.navController.navigationBar verticalPoints:distance];
    [self setNavBarSubViewsAlpha:alpha];

    self.lastOffsetPoint = point;
}

- (float)distanceScrolled:(CGPoint)point
{
    return self.lastOffsetPoint.y - point.y;
}

- (BOOL)isBouncingAtPoint:(CGPoint)point
{
    BOOL bouncingTop = point.y * -1 >= self.observedScrollView.contentInset.top;
    BOOL bouncingBottom = (point.y >= (self.observedScrollView.contentSize.height - self.observedScrollView.bounds.size.height));

    return bouncingTop || bouncingBottom;
}

- (float)shiftNavBar:(UINavigationBar *)navBar verticalPoints:(float)vpoints
{
    CGRect barRect = self.navController.navigationBar.frame;

    CGPoint barPt = barRect.origin;

    barPt.y += vpoints;

    if (barPt.y <= minY) {
        barPt.y = minY;
    } else if (barPt.y >= maxY) {
        barPt.y = maxY;
    }

    barRect.origin = barPt;
    navBar.frame = barRect;

    return [self percentOfMaxAtPoint:barPt];
}

- (float)percentOfMaxAtPoint:(CGPoint)point
{
    float min = 0;
    float max = maxY - min;
    float y = point.y - min;
    float percentage = y / max;

    percentage = percentage > 1.0 ? 1.0 : percentage; //Limit to 1.0

    return percentage;
}

- (void)setNavBarSubViewsAlpha:(float)alpha
{
    for (UIView *sub in [self.navController.navigationBar subviews]) {
        NSString *name = NSStringFromClass([sub class]);

        if ([name isEqualToString:@"_UINavigationBarBackground"] || [name isEqualToString:@"_UINavigationBarBackIndicatorView"]) {
            continue;
        }

        sub.alpha = alpha;
    }
}

@end
