//
//  SYNNavBarHideScrollObserver.h
//  SYNParallaxObserverExample
//
//  Created by Sam Corder on 3/13/14.
//  Copyright (c) 2014 Synapptic Labs. All rights reserved.
//

#import "SYNScrollObserver.h"

@interface SYNNavBarHideScrollObserver : SYNScrollObserver
@property (nonatomic) float travelThreshold;

- (instancetype)initWithObservedScrollView:(UIScrollView *)observedScrollView navigationController:(UINavigationController *)navigationController;
@end
