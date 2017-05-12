/************************************************************
 Class    : AccountHeaderView.m
 Describe : 我的界面账户头->头视图
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-05-09
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "AccountHeaderView.h"
#import "SettingUtil.h"

@interface AccountHeaderView()

@end

@implementation AccountHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        
        self.backgroundColor = DEFAULT_BACKGROUND_COLOR;

        _imageView = [[UIImageView alloc] initWithFrame:frame];
        //_imageView.image = [UIImage imageNamed:@"common_navigation_bg"];
        _imageView.image = [UIImage imageNamed:@"mine_account_bg"];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imageView];
        
        _nightBtn = [[UIButton alloc] init];
        NSMutableDictionary *settingDict = [[SettingUtil shareInstance] loadSettingData];
        if([[settingDict objectForKey:@"night"] boolValue]){
            [_nightBtn setBackgroundImage:[UIImage imageNamed:@"mine_account_sun"] forState:UIControlStateNormal];
            [_nightBtn setBackgroundImage:[UIImage imageNamed:@"mine_account_sunHL"] forState:UIControlStateHighlighted];
        }else{
            [_nightBtn setBackgroundImage:[UIImage imageNamed:@"mine_account_moon"] forState:UIControlStateNormal];
            [_nightBtn setBackgroundImage:[UIImage imageNamed:@"mine_account_moonHL"] forState:UIControlStateHighlighted];
        }
        [_nightBtn addTarget:self action:@selector(nightAction:) forControlEvents:UIControlEventTouchUpInside];
        _nightBtn.frame = CGRectMake(WIDTH_SCREEN-35, 30, 20, 20);
        [self addSubview:_nightBtn];
        
        _accountBtn = [[UIButton alloc] init];
        [_accountBtn addTarget:self action:@selector(accountInfoAction:) forControlEvents:UIControlEventTouchUpInside];
        _accountBtn.frame = CGRectMake(WIDTH_SCREEN/2-35, 40, 70, 70);
        [self addSubview:_accountBtn];
        
        _nameLabel = [self labelWithFrame:CGRectMake(0, CGRectGetMaxY(_accountBtn.frame)+10, WIDTH_SCREEN, 20)];
        [self addSubview:_nameLabel];
        
        _bigNameLabel = [self labelWithFrame:CGRectMake(130, _accountBtn.originY+10, WIDTH_SCREEN-130, 30)];
        _bigNameLabel.font = [UIFont boldSystemFontOfSize:26.0f];
        _bigNameLabel.alpha = 0;
        [self addSubview:_bigNameLabel];
        
        _orgNameLabel = [self labelWithFrame:CGRectMake(130, CGRectGetMaxY(_bigNameLabel.frame), WIDTH_SCREEN-130, 20)];
        _orgNameLabel.font = [UIFont systemFontOfSize:14.0f];
        _orgNameLabel.alpha = 0;
        [self addSubview:_orgNameLabel];

    }
    return self;
}

#pragma mark - 创建基本通用样式的Label
- (UILabel *)labelWithFrame:(CGRect)frame{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.numberOfLines = 0;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:16.0f];
    //label.font = [UIFont fontWithName:@"Helvetica" size:13.0f];
    //字体自适应
    label.adjustsFontSizeToFitWidth = YES;
    
    return label;
}

// 点击方法
- (void)nightAction:(UIButton *)sender{
    NSMutableDictionary *settingDict = [[SettingUtil shareInstance] loadSettingData];
    if(![[settingDict objectForKey:@"night"] boolValue]){
        [Variable shareInstance].brightness = [UIScreen mainScreen].brightness; // 获取当前屏幕亮度
        [sender setBackgroundImage:[UIImage imageNamed:@"mine_account_sun"] forState:UIControlStateNormal];
        [sender setBackgroundImage:[UIImage imageNamed:@"mine_account_sunHL"] forState:UIControlStateHighlighted];
        [[UIScreen mainScreen] setBrightness:0];
        [settingDict setObject:[NSNumber numberWithBool:YES] forKey:@"night"];
    }else{
        [sender setBackgroundImage:[UIImage imageNamed:@"mine_account_moon"] forState:UIControlStateNormal];
        [sender setBackgroundImage:[UIImage imageNamed:@"mine_account_moonHL"] forState:UIControlStateHighlighted];
        [[UIScreen mainScreen] setBrightness:[Variable shareInstance].brightness];
        [settingDict setObject:[NSNumber numberWithBool:NO] forKey:@"night"];
    }
    [[SettingUtil shareInstance] writeSettingData:settingDict];
}

- (void)accountInfoAction:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(accountHeaderViewDidSelectedInfo)]) {
        [self.delegate accountHeaderViewDidSelectedInfo];
    }
}

// 重写Setter 方法
- (void)setNameText:(NSString *)nameText{
    _nameLabel.text = nameText;
    _bigNameLabel.text = nameText;
    if([nameText isEqualToString:@"未登录"]){
        _orgNameLabel.text = @"登录后，即可解锁更多功能！";
        
        [_accountBtn setBackgroundImage:[UIImage imageNamed:@"mine_account_header_grey"] forState:UIControlStateNormal];
        [_accountBtn setBackgroundImage:[UIImage imageNamed:@"mine_account_header_grey"] forState:UIControlStateHighlighted];
    }else{
        _orgNameLabel.text = [[[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_SUCCESS] objectForKey:@"orgName"];
        
        [_accountBtn setBackgroundImage:[UIImage imageNamed:@"mine_account_header_color"] forState:UIControlStateNormal];
        [_accountBtn setBackgroundImage:[UIImage imageNamed:@"mine_account_header_color"] forState:UIControlStateHighlighted];
    }
}

@end
