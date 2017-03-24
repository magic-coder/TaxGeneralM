//
//  AccountViewController.m
//  TaxGeneralM
//
//  Created by Apple on 2017/2/6.
//  Copyright © 2017年 Yanzheng. All rights reserved.
//

#import "AccountViewController.h"
#import "MineUtil.h"

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
        [YZActionSheet showActionSheetWithTitle:@"退出登录后下次使用时需重新登录，您确定要退出吗？" cancelButtonTitle:@"取消" destructiveButtonTitle:@"退出" otherButtonTitles:nil handler:^(YZActionSheet *actionSheet, NSInteger index) {
            if(-1 == index){
                [YZProgressHUD showHUDView:self.view Mode:LOCKMODE Text:@"注销中..."];
                
                [AccountUtil accountLogout];
                
                [YZProgressHUD hiddenHUDForView:self.view];
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
