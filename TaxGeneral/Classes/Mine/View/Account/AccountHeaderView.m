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

@interface AccountHeaderView()

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
        
        _accountBtn = [[UIButton alloc] init];
        [_accountBtn setBackgroundImage:[UIImage imageNamed:@"finger_headIcon"] forState:UIControlStateNormal];
        [_accountBtn setBackgroundImage:[UIImage imageNamed:@"finger_headIcon"] forState:UIControlStateHighlighted];
        [_accountBtn addTarget:self action:@selector(accountInfoAction:) forControlEvents:UIControlEventTouchDown];
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
- (void)accountInfoAction:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(accountHeaderViewDidSelectedInfo)]) {
        [self.delegate accountHeaderViewDidSelectedInfo];
    }
}

// 重写Setter 方法
- (void)setNameText:(NSString *)nameText{
    _nameText = nameText;
    _nameLabel.text = _nameText;
}

@end
