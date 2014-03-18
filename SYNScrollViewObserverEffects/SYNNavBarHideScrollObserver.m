//
//  SYNNavBarHideScrollObserver.m
//  SYNParallaxObserverExample
//
//  Created by Sam Corder on 3/13/14.
//  Copyright (c) 2014 Synapptic Labs. All rights reserved.
//

#import "SYNNavBarHideScrollObserver.h"

@interface SYNNavBarHideScrollObserver ()
@property (nonatomic, weak) UIScrollView *observedScrollView;
@property (nonatomic, weak) UIViewController *scrollViewController;
@property (nonatomic, weak) UINavigationController *navController;
@property (nonatomic) CGPoint navBarOrigin;
@property (nonatomic) CGPoint lastOffsetPoint;
@end

static NSString *kNavShowViewControllerNotification = @"UINavigationControllerWillShowViewControllerNotification";

@implementation SYNNavBarHideScrollObserver {
    float minY;
    float maxY;
    float travelAmount;
    BOOL _isObserving;
}

- (instancetype)initWithObservedScrollView:(UIScrollView *)observedScrollView inViewController:(UIViewController *)viewController
{
    self = [super initWithObservedScrollView:observedScrollView];

    if (self) {
        self.scrollViewController = viewController;
        self.navController = viewController.navigationController;
        self.navBarOrigin = self.navController.navigationBar.frame.origin;
        self.lastOffsetPoint = CGPointZero;
        self.travelThreshold = 40.0f;
        minY = -24;
        maxY = self.navBarOrigin.y;
    }

    return self;
}

- (void)startObserving
{
    [super startObserving];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewControllerChange:) name:kNavShowViewControllerNotification object:self.navController];

    _isObserving = YES;
}

- (void)dealloc
{
    if (_isObserving) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kNavShowViewControllerNotification object:self.navController];
        _isObserving = NO;
    }
}

- (void)viewControllerChange:(NSNotification *)notification
{
    [self resetNavBar];
}

- (void)resetNavBar
{
    CGRect barRect = self.navController.navigationBar.frame;

    barRect.origin = self.navBarOrigin;
    self.navController.navigationBar.frame = barRect;
    [self setNavBarSubViewsAlpha:1.0];
}

- (void)observedContentOffsetChanged:(CGPoint)point
{
    if ([self isVisible] == NO || [self isBouncingAtPoint:point]) {
        return;
    }

    float distance = [self distanceScrolled:point];
    travelAmount += distance;
    float threshold = self.travelThreshold * -1;
    travelAmount = travelAmount < threshold ? threshold : travelAmount;
    travelAmount = travelAmount > 0 ? 0 : travelAmount;

    if (travelAmount <= threshold || distance > 0.0) {
        float alpha = [self shiftNavBar:self.navController.navigationBar verticalPoints:distance];
        [self setNavBarSubViewsAlpha:alpha];
    }

    self.lastOffsetPoint = point;
}

- (float)distanceScrolled:(CGPoint)point
{
    return self.lastOffsetPoint.y - point.y;
}

- (BOOL)isVisible
{
    return self.navController.visibleViewController == self.scrollViewController;
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
