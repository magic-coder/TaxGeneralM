/************************************************************
 Class    : MessageDetailViewController.h
 Describe : 消息内容展示信息界面
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-02-15
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import <UIKit/UIKit.h>

@interface MessageDetailViewController : UITableViewController

@property (nonatomic, strong) NSString *sourceCode;     // 来源代码
@property (nonatomic, strong) NSString *pushOrgCode;   // 推送机构代码

@end
