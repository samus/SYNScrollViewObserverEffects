//
//  SYNViewController.m
//  Example
//
//  Created by Sam Corder on 2/26/14.
//  Copyright (c) 2014 Synapptic Labs. All rights reserved.
//

#import "SYNViewController.h"

#import "SYNParallaxScrollObserver.h"
#import "SYNBlurScrollObserver.h"

@interface SYNViewController () <SYNParallaxScrollObserverDelegate>
@property (strong, nonatomic) SYNParallaxScrollObserver *parallaxObserver;

@property (weak, nonatomic) IBOutlet UIScrollView *observed;
@property (weak, nonatomic) IBOutlet UIScrollView *parallaxed;
@property (weak, nonatomic) IBOutlet UIImageView *sampleImageView;
@property (strong, nonatomic) UIImage *originalImage;

@property (strong, nonatomic) NSOperationQueue *renderQueue;
@property(nonatomic, strong) id blurObserver;
@end

@implementation SYNViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.parallaxObserver = [[SYNParallaxScrollObserver alloc] initWithObservedScrollView:self.observed parallaxedScrollView:self.parallaxed];
    self.parallaxObserver.maxOffset = CGPointMake(0, 42);
    self.parallaxObserver.parallaxRatio = 5;
    self.parallaxObserver.delegate = self;
    [self.parallaxObserver startObserving];

    self.blurObserver = [[SYNBlurScrollObserver alloc] initWithObservedScrollView:self.observed blurredImageView:self.sampleImageView];
    [self.blurObserver startObserving];
}

- (void) parallaxObserver:(SYNParallaxScrollObserver *)observer changedParallaxedOffset:(CGPoint)offset
{
//    if (CGPointEqualToPoint(CGPointZero, offset) || offset.y < 0) {
//        self.sampleImageView.image = self.originalImage;
//        [self.renderQueue cancelAllOperations];
//        return;
//    }
//
//    float radius = floorf(offset.y/2);
//
//    if ([self shouldBlurForRadius:radius]) {
//        [self.renderQueue addOperationWithBlock:^{
//            UIImage *blurredImage = [self.originalImage applyBlurWithRadius:radius tintColor:nil saturationDeltaFactor:1.0 maskImage:nil];
//            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                self.sampleImageView.image = blurredImage;
//            }];
//        }];
//    }
}


@end
