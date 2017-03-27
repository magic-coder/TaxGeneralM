/************************************************************
 Class    : UIImage+YZ.h
 Describe : 自定义的UIImage图片处理类，包含自定义方法
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-03-24
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import <UIKit/UIKit.h>

@interface UIImage (YZ)

// 根据视图的大小来计算图片的大小
+ (UIImage *)imageNamed:(NSString *)name scaleToSize:(CGSize)size;

// 根据大小裁剪图片
+ (UIImage *)clipImage:(UIImage *)image rect:(CGRect)rect;

@end
