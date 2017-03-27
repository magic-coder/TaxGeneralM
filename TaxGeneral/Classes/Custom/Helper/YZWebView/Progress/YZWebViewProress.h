/************************************************************
 Class    : YZWebViewProress.h
 Describe : 自定义脉冲样式加载进度条
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-01-16
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import <UIKit/UIKit.h>

@protocol YZWebViewProgressDelegate;

@interface YZWebViewProress : NSObject<UIWebViewDelegate>

@property (nonatomic, readonly) NSProgress *currentProgress; // 0.0...1.0

@property (nonatomic, weak) id<YZWebViewProgressDelegate> progressDelegate;

@property (nonatomic, weak) id<UIWebViewDelegate> webViewProxyDelegate;

@end

@protocol YZWebViewProgressDelegate <NSObject>

@optional

- (void)updateProgress:(NSProgress *)progress webViewProgress:(YZWebViewProress *)webViewProgress;

@end
