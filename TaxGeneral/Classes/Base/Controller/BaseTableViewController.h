/************************************************************
 Class    : BaseTableViewController.h
 Describe : 基础的表格视图控制器，提供Table布局界面
 Company  : Prient
 Author   : Yanzheng
 Date     : 2016-12-30
 Version  : 1.0
 Declare  : Copyright © 2016 Yanzheng. All rights reserved.
 ************************************************************/

#import <UIKit/UIKit.h>

@protocol BaseTableViewControllerDelegate <NSObject>

@optional
- (void)baseTableViewControllerBtnClick:(UIButton *)sender;
- (void)baseTableViewControllerSwitchChanged:(UISwitch *)sender;

@end

@interface BaseTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *data;

@property (nonatomic, weak) id<BaseTableViewControllerDelegate> delegate;

@end
