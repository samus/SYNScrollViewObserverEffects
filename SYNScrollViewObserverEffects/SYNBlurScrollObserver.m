//
//  SYNBlurScrollObserver.m
//  SYNParallaxObserverExample
//
//  Created by Sam Corder on 3/7/14.
//  Copyright (c) 2014 Synapptic Labs. All rights reserved.
//  The blur routine is Copyright © 2013 Apple Inc. All rights reserved.
//  See WWDC 2013 License

#import "SYNBlurScrollObserver.h"

@import Accelerate;

#import <float.h>

const int kMaxBlur = 69;
const int kMinBlur = 0;

@interface SYNBlurScrollObserver ()
@property(nonatomic, strong) UIImage *originalImage;
@property(nonatomic, strong) UIImageView *blurredImageView;
@property(nonatomic, strong) NSOperationQueue *renderQueue;
@property(nonatomic) NSInteger lastRadius;
@end

@implementation SYNBlurScrollObserver

- (instancetype)initWithObservedScrollView:(UIScrollView *)observedScrollView blurredImageView:(UIImageView *)blurredImageView {
    return [self initWithObservedScrollView:observedScrollView blurredImageView:blurredImageView damper:10.0f];
}

- (instancetype)initWithObservedScrollView:(UIScrollView *)observedScrollView blurredImageView:(UIImageView *)blurredImageView damper:(CGFloat)damper
{
    return [self initWithObservedScrollView:observedScrollView blurredImageView:blurredImageView damper:damper minOffset:CGPointZero];
}

- (instancetype)initWithObservedScrollView:(UIScrollView *) observedScrollView blurredImageView:(UIImageView *)blurredImageView damper:(CGFloat)damper minOffset:(CGPoint)minOffset
{
    self = [super initWithObservedScrollView:observedScrollView];
    if (self) {
        self.blurredImageView = blurredImageView;
        self.originalImage = blurredImageView.image;
        self.damper = damper;
        self.renderQueue = [[NSOperationQueue alloc] init];
        self.renderQueue.name = @"Blur Queue";
        self.lastRadius = 0;
        self.minOffset = minOffset;
        [self observedContentOffsetChanged:observedScrollView.contentOffset];
    }
    return self;
}

- (void)observedContentOffsetChanged:(CGPoint)point {
    if (CGPointEqualToPoint(CGPointZero, point) || point.x < self.minOffset.x || point.y < self.minOffset.y) {
        [self.renderQueue cancelAllOperations];
        if (self.blurredImageView.image != self.originalImage) {
            self.blurredImageView.image = self.originalImage;
        }
        return;
    }

    float radius = floorf((point.y - self.minOffset.y) / self.damper);

    if ([self shouldBlurAtPoint:point withRadius:radius] == NO) {
        return;
    }
    
    NSBlockOperation *renderOp = [[NSBlockOperation alloc]init];
    __weak __typeof__(renderOp) weakOp = renderOp;
    __weak __typeof__(self) weakSelf = self;
    [renderOp addExecutionBlock:^{
        __typeof__(weakSelf) strongSelf = weakSelf;
        UIImage *blurredImage = [strongSelf applyBlurToImage:strongSelf.originalImage withRadius:radius tintColor:nil saturationDeltaFactor:1.0 maskImage:nil];
        
        if (weakOp.isCancelled == NO) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                strongSelf.blurredImageView.image = blurredImage;
            }];
        }
    }];
    [self.renderQueue addOperation:renderOp];

}

- (BOOL)shouldBlurAtPoint:(CGPoint)point withRadius:(CGFloat)radius {
    long r = (NSInteger) floor(radius);
    BOOL blur = r != _lastRadius && r < kMaxBlur && r > kMinBlur;
    _lastRadius = r;
    return blur;
}

//This blur is taken from Apple's UIImage+ImageEffects category as shown in WWDC 2013
- (UIImage *)applyBlurToImage:(UIImage *)image withRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage {
    // Check pre-conditions.
    if (image.size.width < 1 || image.size.height < 1) {
        NSLog(@"*** error: invalid size: (%.2f x %.2f). Both dimensions must be >= 1: %@", image.size.width, image.size.height, image);
        return nil;
    }
    if (!image.CGImage) {
        NSLog(@"*** error: image must be backed by a CGImage: %@", image);
        return nil;
    }
    if (maskImage && !maskImage.CGImage) {
        NSLog(@"*** error: maskImage must be backed by a CGImage: %@", maskImage);
        return nil;
    }

    CGRect imageRect = {CGPointZero, image.size};
    UIImage *effectImage = image;

    BOOL hasBlur = blurRadius > __FLT_EPSILON__;
    BOOL hasSaturationChange = fabs(saturationDeltaFactor - 1.) > __FLT_EPSILON__;
    if (hasBlur || hasSaturationChange) {
        UIGraphicsBeginImageContextWithOptions(image.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectInContext = UIGraphicsGetCurrentContext();
        CGContextScaleCTM(effectInContext, 1.0, -1.0);
        CGContextTranslateCTM(effectInContext, 0, -image.size.height);
        CGContextDrawImage(effectInContext, imageRect, image.CGImage);

        vImage_Buffer effectInBuffer;
        effectInBuffer.data = CGBitmapContextGetData(effectInContext);
        effectInBuffer.width = CGBitmapContextGetWidth(effectInContext);
        effectInBuffer.height = CGBitmapContextGetHeight(effectInContext);
        effectInBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectInContext);

        UIGraphicsBeginImageContextWithOptions(image.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectOutContext = UIGraphicsGetCurrentContext();
        vImage_Buffer effectOutBuffer;
        effectOutBuffer.data = CGBitmapContextGetData(effectOutContext);
        effectOutBuffer.width = CGBitmapContextGetWidth(effectOutContext);
        effectOutBuffer.height = CGBitmapContextGetHeight(effectOutContext);
        effectOutBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext);

        if (hasBlur) {
            // A description of how to compute the box kernel width from the Gaussian
            // radius (aka standard deviation) appears in the SVG spec:
            // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
            //
            // For larger values of 's' (s >= 2.0), an approximation can be used: Three
            // successive box-blurs build a piece-wise quadratic convolution kernel, which
            // approximates the Gaussian kernel to within roughly 3%.
            //
            // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
            //
            // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
            //
            CGFloat inputRadius = blurRadius * [[UIScreen mainScreen] scale];
            NSUInteger radius = floor(inputRadius * 3. * sqrt(2 * M_PI) / 4 + 0.5);
            if (radius % 2 != 1) {
                radius += 1; // force radius to be odd so that the three box-blur methodology works.
            }
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
        }
        BOOL effectImageBuffersAreSwapped = NO;
        if (hasSaturationChange) {
            CGFloat s = saturationDeltaFactor;
            CGFloat floatingPointSaturationMatrix[] = {
                    0.0722 + 0.9278 * s, 0.0722 - 0.0722 * s, 0.0722 - 0.0722 * s, 0,
                    0.7152 - 0.7152 * s, 0.7152 + 0.2848 * s, 0.7152 - 0.7152 * s, 0,
                    0.2126 - 0.2126 * s, 0.2126 - 0.2126 * s, 0.2126 + 0.7873 * s, 0,
                    0, 0, 0, 1,
            };
            const int32_t divisor = 256;
            NSUInteger matrixSize = sizeof(floatingPointSaturationMatrix) / sizeof(floatingPointSaturationMatrix[0]);
            int16_t saturationMatrix[matrixSize];
            for (NSUInteger i = 0; i < matrixSize; ++i) {
                saturationMatrix[i] = (int16_t) roundf(floatingPointSaturationMatrix[i] * divisor);
            }
            if (hasBlur) {
                vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
                effectImageBuffersAreSwapped = YES;
            }
            else {
                vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
            }
        }
        if (!effectImageBuffersAreSwapped)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        if (effectImageBuffersAreSwapped)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }

    // Set up output context.
    UIGraphicsBeginImageContextWithOptions(image.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef outputContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(outputContext, 1.0, -1.0);
    CGContextTranslateCTM(outputContext, 0, -image.size.height);

    // Draw base image.
    CGContextDrawImage(outputContext, imageRect, image.CGImage);

    // Draw effect image.
    if (hasBlur) {
        CGContextSaveGState(outputContext);
        if (maskImage) {
            CGContextClipToMask(outputContext, imageRect, maskImage.CGImage);
        }
        CGContextDrawImage(outputContext, imageRect, effectImage.CGImage);
        CGContextRestoreGState(outputContext);
    }

    // Add in color tint.
    if (tintColor) {
        CGContextSaveGState(outputContext);
        CGContextSetFillColorWithColor(outputContext, tintColor.CGColor);
        CGContextFillRect(outputContext, imageRect);
        CGContextRestoreGState(outputContext);
    }

    // Output image is ready.
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return outputImage;
}
@end
