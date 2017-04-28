/************************************************************
 Class    : QuestionViewController.m
 Describe : 常见问题界面
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-03-21
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "QuestionViewController.h"

@interface QuestionViewController ()

@end

@implementation QuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    BaseScrollView *scrollView = [[BaseScrollView alloc] init];
    
    UILabel *questionLabel = [[UILabel alloc] init];
    questionLabel.numberOfLines = 0;
    questionLabel.textColor = [UIColor grayColor];
    //questionLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0f];
    //questionLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    NSString *str = @"<p style='font-size:13px;color:#434343;'><b>问：登录时提示账号或密码错误？</b><br/>"
    "答：检查核对账户，密码8位字母（大小写）和数字。<br/><br/>"
    "<b>问：如何删除信息列表中的信息？</b><br/>"
    "答：在列表页中向左滑动或者长按都会显示删除按钮，然后进行删除。<br/><br/>"
    "<b>问：如何进行密码重置？</b><br/>"
    "答：密码重置时，税务人员输入登录用户名。点击“重置”后，系统通过短信发送验证码到手机（手机号码与核心征管中记录的一致），验证通过后，进入密码重置页面。输入新密码即可。</p>";
    
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithData:[str dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    questionLabel.attributedText = attrStr;
    
    CGSize questionSize = [[BaseHandleUtil shareInstance] sizeWithString:str font:[UIFont systemFontOfSize:17.0f] maxSize:CGSizeMake(WIDTH_SCREEN - 20, MAXFLOAT)];
    questionLabel.frame = CGRectMake(10, 0, questionSize.width, questionSize.height);
    [scrollView addSubview:questionLabel];
    
    [self.view addSubview:scrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
