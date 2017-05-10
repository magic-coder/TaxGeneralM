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

@property(nonatomic, strong) UIButton *nightBtn;
@property(nonatomic, strong) UIButton *accountBtn;
@property(nonatomic, strong) UILabel *nameLabel;

@end

@implementation AccountHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        
        self.backgroundColor = DEFAULT_BACKGROUND_COLOR;
        //self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"common_navigation_bg" scaleToSize:frame.size]];
        
        /*
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH_SCREEN/2-35, 40	, 70, 70)];
        imageView.image = [UIImage imageNamed:@"finger_headIcon"];
        imageView.layer.masksToBounds = YES;// 隐藏边界
        imageView.layer.cornerRadius = 12;// 将图层的边框设置为圆角
        [self addSubview:imageView];
        */
        
        _imageView = [[UIImageView alloc] initWithFrame:frame];
        _imageView.image = [UIImage imageNamed:@"common_navigation_bg"];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imageView];
        
        _nightBtn = [[UIButton alloc] init];
        NSMutableDictionary *settingDict = [[SettingUtil shareInstance] loadSettingData];
        if([[settingDict objectForKey:@"night"] boolValue]){
            [_nightBtn setBackgroundImage:[UIImage imageNamed:@"mine_account_moon"] forState:UIControlStateNormal];
            [_nightBtn setBackgroundImage:[UIImage imageNamed:@"mine_account_moonHL"] forState:UIControlStateHighlighted];
        }else{
            [_nightBtn setBackgroundImage:[UIImage imageNamed:@"mine_account_sun"] forState:UIControlStateNormal];
            [_nightBtn setBackgroundImage:[UIImage imageNamed:@"mine_account_sunHL"] forState:UIControlStateHighlighted];
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
    if([[settingDict objectForKey:@"night"] boolValue]){
        [sender setBackgroundImage:[UIImage imageNamed:@"mine_account_sun"] forState:UIControlStateNormal];
        [sender setBackgroundImage:[UIImage imageNamed:@"mine_account_sunHL"] forState:UIControlStateHighlighted];
        [[UIScreen mainScreen] setBrightness:0];
        [settingDict setObject:[NSNumber numberWithBool:NO] forKey:@"night"];
    }else{
        [sender setBackgroundImage:[UIImage imageNamed:@"mine_account_moon"] forState:UIControlStateNormal];
        [sender setBackgroundImage:[UIImage imageNamed:@"mine_account_moonHL"] forState:UIControlStateHighlighted];
        [[UIScreen mainScreen] setBrightness:[Variable shareInstance].brightness];
        [settingDict setObject:[NSNumber numberWithBool:YES] forKey:@"night"];
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
    if([nameText isEqualToString:@"未登录"]){
        [_accountBtn setBackgroundImage:[UIImage imageNamed:@"mine_account_header_grey"] forState:UIControlStateNormal];
        [_accountBtn setBackgroundImage:[UIImage imageNamed:@"mine_account_header_grey"] forState:UIControlStateHighlighted];
    }else{
        [_accountBtn setBackgroundImage:[UIImage imageNamed:@"mine_account_header_color"] forState:UIControlStateNormal];
        [_accountBtn setBackgroundImage:[UIImage imageNamed:@"mine_account_header_color"] forState:UIControlStateHighlighted];
    }
}

@end
