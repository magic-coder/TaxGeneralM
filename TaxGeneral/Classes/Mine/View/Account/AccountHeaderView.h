/************************************************************
 Class    : AccountHeaderView.h
 Describe : 我的界面账户头->头视图
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-05-09
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import <UIKit/UIKit.h>

// 设置accountHeaderView点击的代理方法
@protocol AccountHeaderViewDelegate <NSObject>

@optional
- (void)accountHeaderViewDidSelectedInfo;

@end

@interface AccountHeaderView : UIView

@property (nonatomic, strong) UIImageView *imageView;   // 背景图
@property (nonatomic, strong) NSString *nameText;

@property (nonatomic, weak) id<AccountHeaderViewDelegate> delegate;

@end
