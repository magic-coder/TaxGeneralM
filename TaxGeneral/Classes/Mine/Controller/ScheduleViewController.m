//
//  ScheduleViewController.m
//  TaxGeneralM
//
//  Created by Apple on 2017/2/7.
//  Copyright © 2017年 Yanzheng. All rights reserved.
//

#import "ScheduleViewController.h"
#import "MineUtil.h"

#import "TaxCalendarViewController.h"

@interface ScheduleViewController ()

@end

@implementation ScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.data = [MineUtil getScheduleItems];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BaseTableModelGroup *group = [self.data objectAtIndex:indexPath.section];
    BaseTableModelItem *item = [group itemAtIndex:indexPath.row];
    
    UIViewController *viewController = nil;
    if ([item.title isEqualToString:@"日程提醒管理"]) {
        [YZAlertView showAlertWith:self title:nil message:@"“互联网+税务”想要打开“日历”" callbackBlock:^(NSInteger btnIndex) {
            if(btnIndex == 1){
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"calshow:"]];
            }
        } cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"打开", nil];
    }
    if ([item.title isEqualToString:@"办税日历"]) {
        TaxCalendarViewController *taxCalendarVC = [[TaxCalendarViewController alloc] init];
        viewController = taxCalendarVC;
    }
    if(nil != viewController){
        viewController.title = item.title;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
