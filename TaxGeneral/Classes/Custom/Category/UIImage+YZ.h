//
//  UIImage+YZ.h
//  TaxGeneralM
//
//  Created by Apple on 2017/3/17.
//  Copyright © 2017年 Yanzheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (YZ)

// 根据视图的大小来计算图片的大小
+ (UIImage *)imageNamed:(NSString *)name scaleToSize:(CGSize)size;

// 根据大小裁剪图片
+ (UIImage *)clipImage:(UIImage *)image rect:(CGRect)rect;

@end
