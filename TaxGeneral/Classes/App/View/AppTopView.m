/************************************************************
 Class    : AppTopView.m
 Describe : 应用界面顶部头视图
 Company  : Prient
 Author   : Yanzheng
 Date     : 2016-12-29
 Version  : 1.0
 Declare  : Copyright © 2016 Yanzheng. All rights reserved.
 ************************************************************/

#import "AppTopView.h"

@implementation AppTopView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = DEFAULT_BLUE_COLOR;
        NSString *imageName = [NSString stringWithFormat:@"app_top_bg_%d", [BaseHandleUtil getRandomNumber:0 to:2]];
        if(![imageName isEqualToString:@"app_top_bg_0"]){
            self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:imageName scaleToSize:frame.size]];
        }
        self.userInteractionEnabled = YES;
        self.multipleTouchEnabled = YES;
        //控制子视图不能超出父视图的范围
        self.clipsToBounds = YES;
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.frame = CGRectMake(WIDTH_SCREEN/2-50, HEIGHT_STATUS+5, 100, 30);
        titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"应用";
        titleLabel.textColor = [UIColor whiteColor];
        
        UIButton *btn_edit = [UIButton buttonWithType:UIButtonTypeCustom];
        btn_edit.frame = CGRectMake(WIDTH_SCREEN-46, HEIGHT_STATUS, 46, 46);
        [btn_edit setImage:[UIImage imageNamed:@"baritem_app_edit"] forState:UIControlStateNormal];
        [btn_edit setImage:[UIImage imageNamed:@"baritem_app_editHL"] forState:UIControlStateHighlighted];
        
        CGFloat btnW = (WIDTH_SCREEN - 50)/4;
        
        UIButton *btn_1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn_1.frame = CGRectMake(10, 70, btnW, 80);
        [btn_1 setImage:[UIImage imageNamed:@"app_common_notification"] forState:UIControlStateNormal];
        [btn_1 setImage:[UIImage imageNamed:@"app_common_notificationHL"] forState:UIControlStateHighlighted];
        [btn_1 setTitle:@"通知公告" forState:UIControlStateNormal];
        [btn_1.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [btn_1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn_1 setTitleColor:DEFAULT_LIGHT_BLUE_COLOR forState:UIControlStateHighlighted];
        btn_1.imageEdgeInsets = UIEdgeInsetsMake(- (btn_1.frame.size.height - btn_1.titleLabel.frame.size.height- btn_1.titleLabel.frame.origin.y),(WIDTH_SCREEN - 50)/4/2 - btn_1.imageView.size.width/2, 0, 0);
        btn_1.titleEdgeInsets = UIEdgeInsetsMake(btn_1.frame.size.height-btn_1.imageView.frame.size.height-btn_1.imageView.frame.origin.y+10, -btn_1.imageView.frame.size.width*0.9f, 0, 0);
        
        UIButton *btn_2 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn_2.frame = CGRectMake(10 + btnW + 10, 70, btnW, 80);
        [btn_2 setImage:[UIImage imageNamed:@"app_common_contacts"] forState:UIControlStateNormal];
        [btn_2 setImage:[UIImage imageNamed:@"app_common_contactsHL"] forState:UIControlStateHighlighted];
        [btn_2 setTitle:@"通讯录" forState:UIControlStateNormal];
        [btn_2.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [btn_2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn_2 setTitleColor:DEFAULT_LIGHT_BLUE_COLOR forState:UIControlStateHighlighted];
        btn_2.imageEdgeInsets = UIEdgeInsetsMake(- (btn_2.frame.size.height - btn_2.titleLabel.frame.size.height- btn_2.titleLabel.frame.origin.y),(WIDTH_SCREEN - 50)/4/2 - btn_2.imageView.size.width/2, 0, 0);
        btn_2.titleEdgeInsets = UIEdgeInsetsMake(btn_2.frame.size.height-btn_2.imageView.frame.size.height-btn_2.imageView.frame.origin.y+10, -btn_2.imageView.frame.size.width*0.9f, 0, 0);
        
        UIButton *btn_3 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn_3.frame = CGRectMake(10 + btnW + 10 + btnW + 10, 70, btnW, 80);
        [btn_3 setImage:[UIImage imageNamed:@"app_common_map"] forState:UIControlStateNormal];
        [btn_3 setImage:[UIImage imageNamed:@"app_common_mapHL"] forState:UIControlStateHighlighted];
        [btn_3 setTitle:@"办税地图" forState:UIControlStateNormal];
        [btn_3.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [btn_3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn_3 setTitleColor:DEFAULT_LIGHT_BLUE_COLOR forState:UIControlStateHighlighted];
        btn_3.imageEdgeInsets = UIEdgeInsetsMake(- (btn_3.frame.size.height - btn_3.titleLabel.frame.size.height- btn_3.titleLabel.frame.origin.y),(WIDTH_SCREEN - 50)/4/2 - btn_3.imageView.size.width/2, 0, 0);
        btn_3.titleEdgeInsets = UIEdgeInsetsMake(btn_3.frame.size.height-btn_3.imageView.frame.size.height-btn_3.imageView.frame.origin.y+10, -btn_3.imageView.frame.size.width*0.9f, 0, 0);
        
        
        UIButton *btn_4 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn_4.frame = CGRectMake(10 + btnW + 10 + btnW + 10 + btnW + 10, 70, btnW, 80);
        [btn_4 setImage:[UIImage imageNamed:@"app_common_question"] forState:UIControlStateNormal];
        [btn_4 setImage:[UIImage imageNamed:@"app_common_questionHL"] forState:UIControlStateHighlighted];
        [btn_4 setTitle:@"常见问题" forState:UIControlStateNormal];
        [btn_4.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [btn_4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn_4 setTitleColor:DEFAULT_LIGHT_BLUE_COLOR forState:UIControlStateHighlighted];
        btn_4.imageEdgeInsets = UIEdgeInsetsMake(- (btn_4.frame.size.height - btn_4.titleLabel.frame.size.height- btn_4.titleLabel.frame.origin.y),(WIDTH_SCREEN - 50)/4/2 - btn_4.imageView.size.width/2, 0, 0);
        btn_4.titleEdgeInsets = UIEdgeInsetsMake(btn_4.frame.size.height-btn_4.imageView.frame.size.height-btn_4.imageView.frame.origin.y+10, -btn_4.imageView.frame.size.width*0.9f, 0, 0);
        
        
        // 注册按钮点击事件
        [btn_edit addTarget:self action:@selector(appBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn_1 addTarget:self action:@selector(appBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn_2 addTarget:self action:@selector(appBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn_3 addTarget:self action:@selector(appBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn_4 addTarget:self action:@selector(appBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:titleLabel];// 顶部标题
        [self addSubview:btn_edit];// 右侧编辑按钮
        [self addSubview:btn_1];
        [self addSubview:btn_2];
        [self addSubview:btn_3];
        [self addSubview:btn_4];
        
    }
    return self;
}

- (void)appBtnOnClick:(UIButton *)sender{
    // 如果协议响应了appTopViewBtnClick方法
    if([_delegate respondsToSelector:@selector(appTopViewBtnClick:)]){
        [_delegate appTopViewBtnClick:sender]; // 通知执行协议方法
    }
}

@end
