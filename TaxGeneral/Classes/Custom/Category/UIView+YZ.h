/************************************************************
 Class    : UIView+YZ.h
 Describe : 在UIView的基础上扩展了一些获取常用属性的方法
 Company  : Prient
 Author   : Yanzheng
 Date     : 2016-08-04
 Version  : 1.0
 Declare  : Copyright © 2016 Yanzheng. All rights reserved.
 ************************************************************/

#import <UIKit/UIKit.h>

@interface UIView (YZ)

/************************ 属性 ************************/
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize size;

@property (nonatomic, assign) CGFloat originX;
@property (nonatomic, assign) CGFloat originY;

@property (nonatomic, assign) CGFloat frameRight;
@property (nonatomic, assign) CGFloat frameBottom;

@property (nonatomic, assign) CGFloat frameWidth;
@property (nonatomic, assign) CGFloat frameHeight;

/************************ 类方法 ************************/
- (BOOL) containsSubView:(UIView *)subView;
- (BOOL) containsSubViewOfClassType:(Class)aClass;


@end
