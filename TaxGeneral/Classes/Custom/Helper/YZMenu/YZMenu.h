/************************************************************
 Class    : YZMenu.h
 Describe : 自定义按钮气泡弹出气泡菜单效果
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-02-27
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import <Foundation/Foundation.h>
#import "YZMenuItem.h"


// Menu将要显示的通知
extern NSString * const YZMenuWillAppearNotification;
// Menu已经显示的通知
extern NSString * const YZMenuDidAppearNotification;
// Menu将要隐藏的通知
extern NSString * const YZMenuWillDisappearNotification;
// Menu已经隐藏的通知
extern NSString * const YZMenuDidDisappearNotification;


typedef void(^YZMenuSelectedItem)(NSInteger index, YZMenuItem *item);

typedef enum {
    YZMenuBackgrounColorEffectSolid      = 0, //!<背景显示效果.纯色
    YZMenuBackgrounColorEffectGradient   = 1, //!<背景显示效果.渐变叠加
} YZMenuBackgrounColorEffect;

@interface YZMenu : NSObject

+ (void)showMenuInView:(UIView *)view fromRect:(CGRect)rect menuItems:(NSArray *)menuItems selected:(YZMenuSelectedItem)selectedItem;

+ (void)dismissMenu;
+ (BOOL)isShow;

// 主题色
+ (UIColor *)tintColor;
+ (void)setTintColor:(UIColor *)tintColor;

// 圆角
+ (CGFloat)cornerRadius;
+ (void)setCornerRadius:(CGFloat)cornerRadius;

// 箭头尺寸
+ (CGFloat)arrowSize;
+ (void)setArrowSize:(CGFloat)arrowSize;

// 标题字体
+ (UIFont *)titleFont;
+ (void)setTitleFont:(UIFont *)titleFont;

// 背景效果
+ (YZMenuBackgrounColorEffect)backgrounColorEffect;
+ (void)setBackgrounColorEffect:(YZMenuBackgrounColorEffect)effect;

// 是否显示阴影
+ (BOOL)hasShadow;
+ (void)setHasShadow:(BOOL)flag;

// 选中颜色
+ (UIColor*)selectedColor;
+ (void)setSelectedColor:(UIColor*)selectedColor;

// 分割线颜色
+ (UIColor*)separatorColor;
+ (void)setSeparatorColor:(UIColor*)separatorColor;

/// 菜单元素垂直方向上的边距值
+ (CGFloat)menuItemMarginY;
+ (void)setMenuItemMarginY:(CGFloat)menuItemMarginY;

@end
