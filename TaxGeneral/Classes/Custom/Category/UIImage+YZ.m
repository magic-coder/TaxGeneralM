//
//  UIImage+YZ.m
//  TaxGeneralM
//
//  Created by Apple on 2017/3/17.
//  Copyright © 2017年 Yanzheng. All rights reserved.
//

#import "UIImage+YZ.h"

@implementation UIImage (YZ)

#pragma mark - 根据视图的大小来计算图片的大小
+ (UIImage *)imageNamed:(NSString *)name scaleToSize:(CGSize)size{
    UIImage *image = [UIImage imageNamed:name];
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

#pragma mark - 裁剪图片
+ (UIImage *)clipImage:(UIImage *)image rect:(CGRect)rect{
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    UIImage *thumbScale = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return thumbScale;
}

@end
