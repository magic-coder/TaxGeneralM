/************************************************************
 Class    : MessageListViewController.h
 Describe : 消息列表界面
 Company  : Prient
 Author   : Yanzheng
 Date     : 2016-08-15
 Version  : 1.0
 Declare  : Copyright © 2016 Yanzheng. All rights reserved.
 ************************************************************/

#import <UIKit/UIKit.h>

@interface MessageListViewController : UITableViewController

- (void)autoLoadData;   // 自动请求刷新

@end
