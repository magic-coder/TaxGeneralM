//
//  AboutFooterView.m
//  TaxGeneralM
//
//  Created by Apple on 2017/3/17.
//  Copyright © 2017年 Yanzheng. All rights reserved.
//

#import "AboutFooterView.h"

@implementation AboutFooterView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = DEFAULT_BACKGROUND_COLOR;
        
        UILabel *taxLabel = [self labelWithFrame:CGRectMake(0, frame.size.height-80, WIDTH_SCREEN, 20)];
        taxLabel.text = @"西安市地方税务局";
        [self addSubview:taxLabel];
        
        UILabel *techLabel = [self labelWithFrame:CGRectMake((WIDTH_SCREEN-240)/2+5, frame.size.height-60, 60, 20)];
        techLabel.text = @"技术支持：";
        [self addSubview:techLabel];
        
        UIButton *techBtn = [self buttonWithFrame:CGRectMake((WIDTH_SCREEN-240)/2+60, frame.size.height-60, 180, 20) title:@"蓬天信息系统（北京）有限公司"];
        [techBtn addTarget:self action:@selector(onClickTechBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:techBtn];
        
        UILabel *statementLabel = [self labelWithFrame:CGRectMake(0, frame.size.height-25, WIDTH_SCREEN, 20)];
        statementLabel.text = @"Copyright © 2000-2017 Prient. All rights reserved.";
        [self addSubview:statementLabel];
        
    }
    return self;
}

- (void)onClickTechBtn:(UIButton *)sender{
    NSString *urlString = @"http://www.prient.com";
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", urlString]];
    [[UIApplication sharedApplication] openURL:url];
}

#pragma mark - 创建基本通用样式的Label
- (UILabel *)labelWithFrame:(CGRect)frame{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.numberOfLines = 0;
    label.textColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentCenter;
    //label.font = [UIFont fontWithName:@"Helvetica" size:13.0f];
    label.font = [UIFont systemFontOfSize:12.0f];
    //字体自适应
    label.adjustsFontSizeToFitWidth = YES;
    
    return label;
}

#pragma mark - 创建基本通用样式的Button
- (UIButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setBackgroundColor:DEFAULT_BACKGROUND_COLOR];
    [button setTitleColor:DEFAULT_BLUE_COLOR forState:UIControlStateNormal];
    [button setTitleColor:DEFAULT_LIGHT_BLUE_COLOR forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    
    return button;
}

@end
