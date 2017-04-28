/************************************************************
 Class    : AccountViewController.m
 Describe : 账户管理界面
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-02-06
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "AccountViewController.h"
#import "MineUtil.h"

@interface AccountViewController ()

@end

@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.data = [[MineUtil shareInstance] getAccountItems];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    BaseTableModelGroup *group = [self.data objectAtIndex:indexPath.section];
    BaseTableModelItem *item = [group itemAtIndex:indexPath.row];
    
    if([item.title isEqualToString:@"退出登录"]){
        [YZActionSheet showActionSheetWithTitle:@"退出登录后下次使用时需重新登录，您确定要退出吗？" cancelButtonTitle:@"取消" destructiveButtonTitle:@"退出" otherButtonTitles:nil handler:^(YZActionSheet *actionSheet, NSInteger index) {
            if(-1 == index){
                [YZProgressHUD showHUDView:SELF_VIEW Mode:LOCKMODE Text:@"注销中..."];
                [[AccountUtil shareInstance] accountLogout:^{
                    DLog(@"用户注销成功");
                    [YZProgressHUD hiddenHUDForView:SELF_VIEW];
                   
                    [self.navigationController popViewControllerAnimated:YES];
                    
                } failed:^(NSString *error) {
                    DLog(@"用户注销失败，error=%@", error);
                    [YZProgressHUD hiddenHUDForView:SELF_VIEW];
                    [YZProgressHUD showHUDView:SELF_VIEW Mode:SHOWMODE Text:error];
                }];
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
