/************************************************************
 Class    : BaseTextField.m
 Describe : 基本整行输入框
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-02-08
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "BaseTextField.h"

@implementation BaseTextField

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        // 左侧间隙
        UILabel *paddingView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 25)];
        paddingView.text = @" ";
        paddingView.textColor = [UIColor darkGrayColor];
        paddingView.backgroundColor = [UIColor clearColor];
        
        self.leftView = paddingView;
        self.leftViewMode = UITextFieldViewModeAlways;
        
        self.backgroundColor = [UIColor whiteColor];
        self.font = [UIFont systemFontOfSize:15.0f];
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 0.5;
        // 输入说明提示
        // self.placeholder = @"请输入文本信息";
        // 是否隐藏输入字符
        // self.secureTextEntry = YES;
        // 是否显示清空按钮
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        
    }
    return self;
}

@end
