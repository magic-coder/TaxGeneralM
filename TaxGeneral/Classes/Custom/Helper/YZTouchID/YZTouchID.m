/************************************************************
 Class    : YZTouchID.m
 Describe : 自定义指纹识别类
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-02-27
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "YZTouchID.h"

@implementation YZTouchID
+ (instancetype)sharedInstance {
    static YZTouchID *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[YZTouchID alloc] init];
    });
    return instance;
}

-(void)td_showTouchIDWithDescribe:(NSString *)desc BlockState:(StateBlock)block{
    
    if (NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_8_0) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            RLog(@"系统版本不支持TouchID (必须高于iOS 8.0才能使用)");
            block(YZTouchIDStateVersionNotSupport,nil);
        });
        
        return;
    }
    
    LAContext *context = [[LAContext alloc]init];
    
    // Yan -> 三次指纹错误不做提示
    context.localizedFallbackTitle = @"";
    
    NSError *error = nil;
    
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:desc == nil ? @"通过Home键验证已有指纹":desc reply:^(BOOL success, NSError * _Nullable error) {
            
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    DLog(@"TouchID 验证成功");
                    block(YZTouchIDStateSuccess,error);
                });
            }else if(error){
                
                switch (error.code) {
                    case LAErrorAuthenticationFailed:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            DLog(@"TouchID 验证失败");
                            block(YZTouchIDStateFail,error);
                        });
                        break;
                    }
                    case LAErrorUserCancel:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            DLog(@"TouchID 被用户手动取消");
                            block(YZTouchIDStateUserCancel,error);
                        });
                    }
                        break;
                    case LAErrorUserFallback:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            DLog(@"用户不使用TouchID,选择手动输入密码");
                            block(YZTouchIDStateInputPassword,error);
                        });
                    }
                        break;
                    case LAErrorSystemCancel:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            DLog(@"TouchID 被系统取消 (如遇到来电,锁屏,按了Home键等)");
                            block(YZTouchIDStateSystemCancel,error);
                        });
                    }
                        break;
                    case LAErrorPasscodeNotSet:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            DLog(@"TouchID 无法启动,因为用户没有设置密码");
                            block(YZTouchIDStatePasswordNotSet,error);
                        });
                    }
                        break;
                    case LAErrorTouchIDNotEnrolled:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            DLog(@"TouchID 无法启动,因为用户没有设置TouchID");
                            block(YZTouchIDStateTouchIDNotSet,error);
                        });
                    }
                        break;
                    case LAErrorTouchIDNotAvailable:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            DLog(@"TouchID 无效");
                            block(YZTouchIDStateTouchIDNotAvailable,error);
                        });
                    }
                        break;
                    case LAErrorTouchIDLockout:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            DLog(@"TouchID 被锁定(连续多次验证TouchID失败,系统需要用户手动输入密码)");
                            block(YZTouchIDStateTouchIDLockout,error);
                        });
                    }
                        break;
                    case LAErrorAppCancel:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            DLog(@"当前软件被挂起并取消了授权 (如App进入了后台等)");
                            block(YZTouchIDStateAppCancel,error);
                        });
                    }
                        break;
                    case LAErrorInvalidContext:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            DLog(@"当前软件被挂起并取消了授权 (LAContext对象无效)");
                            block(YZTouchIDStateInvalidContext,error);
                        });
                    }
                        break;
                    default:
                        break;
                }
            }
        }];
        
    }else{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            DLog(@"当前设备不支持TouchID");
            block(YZTouchIDStateNotSupport,error);
        });
        
    }
    
}
@end
