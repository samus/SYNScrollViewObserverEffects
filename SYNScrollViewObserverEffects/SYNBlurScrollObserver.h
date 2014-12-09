//
//  SYNBlurScrollObserver.h
//  SYNParallaxObserverExample
//
//  Created by Sam Corder on 3/7/14.
//  Copyright (c) 2014 Synapptic Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYNScrollObserver.h"

@interface SYNBlurScrollObserver : SYNScrollObserver

@property (nonatomic) float damper;

- (instancetype)initWithObservedScrollView:(UIScrollView *) observedScrollView blurredImageView:(UIImageView *)blurredImageView;
- (instancetype)initWithObservedScrollView:(UIScrollView *)observedScrollView blurredImageView:(UIImageView *)blurredImageView damper:(float)damper;

@end
