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
@property (nonatomic, strong) UIButton *nightBtn;       // 夜间模式按钮
@property (nonatomic, strong) UIButton *accountBtn;     // 用户头像按钮
@property (nonatomic, strong) UILabel *levelLabel;      // 用户等级
@property (nonatomic, strong) UILabel *nameLabel;       // 用户名称
@property (nonatomic, strong) UILabel *bigNameLabel;    // 用户名称放大
@property (nonatomic, strong) UILabel *orgNameLabel;    // 机构名称

@property (nonatomic, strong) NSString *nameText;

@property (nonatomic, weak) id<AccountHeaderViewDelegate> delegate;

@end
