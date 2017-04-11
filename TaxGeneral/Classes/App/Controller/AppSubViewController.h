/************************************************************
 Class    : AppSubViewController.h
 Describe : 应用第二级菜单列表
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-03-29
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import <UIKit/UIKit.h>

@interface AppSubViewController : UITableViewController

- (instancetype)initWithPno:(NSString *)pno level:(NSString *)level;

@end
