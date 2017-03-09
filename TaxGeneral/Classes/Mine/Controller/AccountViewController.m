//
//  AccountViewController.m
//  TaxGeneralM
//
//  Created by Apple on 2017/2/6.
//  Copyright © 2017年 Yanzheng. All rights reserved.
//

#import "AccountViewController.h"
#import "MineUtil.h"
#import "SettingUtil.h"

@interface AccountViewController ()

@end

@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.data = [MineUtil getAccountItems];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    BaseTableModelGroup *group = [self.data objectAtIndex:indexPath.section];
    BaseTableModelItem *item = [group itemAtIndex:indexPath.row];
    
    if([item.title isEqualToString:@"退出登录"]){
        /*
        [YZAlertView showActionSheetWith:self title:EmptyTitle message:@"退出登录后下次使用时需重新登录，您确定要退出吗？" callbackBlock:^(NSInteger btnIndex) {
            if(0 == btnIndex){
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"gesturespassword"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:LOGIN_SUCCESS];
                [[SettingUtil alloc] removeSettingData];
                [[SettingUtil alloc] initSettingData];
                
                [self.navigationController popViewControllerAnimated:YES];
            }
        } destructiveButtonTitle:@"退出" cancelButtonTitle:@"取消" otherButtonTitles: nil, nil];
         */
        [YZActionSheet showActionSheetWithTitle:@"退出登录后下次使用时需重新登录，您确定要退出吗？" cancelButtonTitle:@"取消" destructiveButtonTitle:@"退出" otherButtonTitles:nil handler:^(YZActionSheet *actionSheet, NSInteger index) {
            if(-1 == index){
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"gesturespassword"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:LOGIN_SUCCESS];
                [[SettingUtil alloc] removeSettingData];
                [[SettingUtil alloc] initSettingData];
                
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
