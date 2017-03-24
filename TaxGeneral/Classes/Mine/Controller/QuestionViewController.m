//
//  QuestionViewController.m
//  TaxGeneralM
//
//  Created by Apple on 2017/3/21.
//  Copyright © 2017年 Yanzheng. All rights reserved.
//

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
    
    CGSize questionSize = [self sizeWithString:str font:[UIFont systemFontOfSize:17.0f] maxSize:CGSizeMake(WIDTH_SCREEN - 20, MAXFLOAT)];
    questionLabel.frame = CGRectMake(10, 10, questionSize.width, questionSize.height);
    [scrollView addSubview:questionLabel];
    
    [self.view addSubview:scrollView];
}

/**
 *  计算文本的宽高
 *
 *  @param str     需要计算的文本
 *  @param font    文本显示的字体
 *  @param maxSize 文本显示的范围
 *
 *  @return 文本占用的真实宽高
 */
- (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *dict = @{NSFontAttributeName : font};
    // 如果将来计算的文字的范围超出了指定的范围,返回的就是指定的范围
    // 如果将来计算的文字的范围小于指定的范围, 返回的就是真实的范围
    CGSize size = [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
