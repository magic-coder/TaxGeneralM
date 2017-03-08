/************************************************************
 Class    : YZProgressHUD.m
 Describe : 自己封装的加载提示悬浮框提供静态简单的调用方法
 Company  : Prient
 Author   : Yanzheng
 Date     : 2016-07-25
 Version  : 1.0
 Declare  : Copyright © 2016 Yanzheng. All rights reserved.
 ************************************************************/

#import "YZProgressHUD.h"

@implementation YZProgressHUD

+(void)showHUDView:(UIView *)view Mode:(YZProgressHUDMode)mode Text:(NSString *)text{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = NSLocalizedString(text, nil);
    
    // 隐藏时从父控件中删除
    hud.removeFromSuperViewOnHide = YES;
    // 是否需要背景锁定效果（蒙版效果）
    // hud.dimBackground = YES;
    
    switch (mode) {
        case LOCKMODE:
            //hh.dimBackground = YES;
            hud.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.1f];
            break;
        case SHOWMODE:
            hud.mode = MBProgressHUDModeText;
            [hud hide:YES afterDelay:3.f];
            break;
        default:
            break;
    }
}

+(void)hiddenHUDForView:(UIView *)view{
    [MBProgressHUD hideHUDForView:view animated:YES];
}

@end
