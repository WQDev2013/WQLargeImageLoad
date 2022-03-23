//
//  WQImageView.m
//  WQDev2021
//
//  Created by chenweiqiang on 2022/2/12.
//

#import "WQImageView.h"
@interface WQImageView() {
    UIImage *originImage;
    CGFloat imageScale;
}
@end

@implementation WQImageView

- (void)setImage: (UIImage *)image {
    originImage = image ;
    [self setBackgroundColor : [UIColor whiteColor ]];
    imageScale = self.frame.size.width/ image.size.width;
    int lev = ceil(log2(1/imageScale))+1;
    CATiledLayer *tiledLayer = (CATiledLayer *)[self layer];
    tiledLayer.levelsOfDetail = 1;
    tiledLayer.levelsOfDetailBias = lev;
}

+ (Class)layerClass {
    return [CATiledLayer class];
}

- (void)drawRect: (CGRect)rect {
    NSLog(@"drawrect=");
    @autoreleasepool {
        CGRect imageCutRect = CGRectMake (rect.origin.x / imageScale,
                                          rect.origin.y / imageScale ,
                                          rect.size.width / imageScale ,
                                          rect.size.height / imageScale);
        NSLog(@"==%@",NSStringFromCGRect(imageCutRect));
        CGImageRef imageRef = CGImageCreateWithImageInRect (originImage.CGImage, imageCutRect);
        UIImage *tileImage = [UIImage imageWithCGImage: imageRef];
        CGContextRef context = UIGraphicsGetCurrentContext();
        UIGraphicsPushContext(context);
        [tileImage drawInRect :rect];
        CGImageRelease (imageRef);
        UIGraphicsPopContext();
    }
}


@end
