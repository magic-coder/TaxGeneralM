/************************************************************
 Class    : SettingViewController.m
 Describe : 设置界面
 Company  : Prient
 Author   : Yanzheng
 Date     : 2016-08-05
 Version  : 1.0
 Declare  : Copyright © 2016 Yanzheng. All rights reserved.
 ************************************************************/

#import "SettingViewController.h"
#import "MineUtil.h"
#import "SettingUtil.h"

@interface SettingViewController () <BaseTableViewControllerDelegate>

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    
    self.data = [MineUtil getSettingItems];
    
    // 增加监听（监听程序从后台切入前台）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appHasGoneInForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

#pragma mark - 视图即将销毁方法
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    // 移除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 进入前台方法
- (void)appHasGoneInForeground:(NSNotificationCenter *)defaultCenter{
    self.data = [MineUtil getSettingItems];
    [self.tableView reloadData];
}

#pragma mark - 点击cell方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BaseTableModelGroup *group = [self.data objectAtIndex:indexPath.section];
    BaseTableModelItem *item = [group itemAtIndex:indexPath.row];
    
    if([item.title isEqualToString:@"清理缓存"]){
        [YZActionSheet showActionSheetWithTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"确定"] handler:^(YZActionSheet *actionSheet, NSInteger index) {
            if(index == 1){
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
                    
                    // Switch to determinate mode
                    dispatch_async(dispatch_get_main_queue(), ^{
                        hud.mode = MBProgressHUDModeDeterminate;
                        hud.labelText = @"正在清理...";
                    });
                    float progress = 0.0f;
                    while (progress < 1.0f) {
                        progress += 0.01f;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            hud.progress = progress;
                        });
                        usleep(30000);
                    }
                    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                        
                        [[BaseSandBoxUtil alloc] removeFileName:@"newsData.plist"];
                        
                        UIImage *image = [UIImage imageNamed:@"common_mark_success"];
                        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                        hud.customView = imageView;
                        hud.mode = MBProgressHUDModeCustomView;
                        hud.labelText = @"清理完成！";
                        // 重新加载数据
                        self.data = [MineUtil getSettingItems];
                        [self.tableView reloadData];
                    }];
                    [[SDImageCache sharedImageCache] clearMemory];
                    sleep(1);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [hud hide:YES];
                    });
                });
            }
        }];
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - <BaseTableViewControllerDelegate>代理方法
- (void)baseTableViewControllerSwitchChanged:(UISwitch *)sender{
    NSNumber *open = [NSNumber numberWithBool:YES];
    NSNumber *close = [NSNumber numberWithBool:NO];
    
    NSMutableDictionary *settingDict = [[SettingUtil alloc] loadSettingData];
    
    NSInteger tag = sender.tag;
    if([sender isOn]){
        // 声音
        if(tag == 452){
            [settingDict setObject:open forKey:@"voice"];
        }
        // 震动
        if(tag == 453){
            [settingDict setObject:open forKey:@"shake"];
        }
    }else{
        // 声音
        if(tag == 452){
            [settingDict setObject:close forKey:@"voice"];
        }
        // 震动
        if(tag == 453){
            [settingDict setObject:close forKey:@"shake"];
        }
    }
    
    DLog(@"settingDict = %@", settingDict);
    
    // 写入本地SandBox设置文件中
    BOOL res = [[SettingUtil alloc] writeSettingData:settingDict];
    if(!res){
        [YZProgressHUD showHUDView:NAV_VIEW Mode:SHOWMODE Text:@"设置异常！"];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
