/************************************************************
 Class    : YZProgressHUD.h
 Describe : 自己封装的加载提示悬浮框提供静态简单的调用方法
 Company  : Prient
 Author   : Yanzheng
 Date     : 2016-07-25
 Version  : 1.0
 Declare  : Copyright © 2016 Yanzheng. All rights reserved.
 ************************************************************/

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

// 显示方式
typedef NS_ENUM (NSInteger, YZProgressHUDMode) {
    LOCKMODE = 0, // 锁定方式不自动消失
    SHOWMODE = 1  // 提示方式自动消失
};

@interface YZProgressHUD : NSObject

/**
 * @breif 显示提示框
 * @param view在哪个视图上显示
 * @param mode自定义了2种显示方式：LOCKMODE锁定显示需要手工调用删除，SHOWMODE提示显示自动会消失
 * @param text需要显示的文本
 */
+(void)showHUDView:(UIView *)view Mode:(YZProgressHUDMode)mode Text:(NSString *)text;

/**
 * @breif 隐藏悬浮框
 * @param view被显示的视图
 */
+(void)hiddenHUDForView:(UIView *)view;

@end
