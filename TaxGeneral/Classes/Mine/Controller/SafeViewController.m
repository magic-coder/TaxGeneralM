/************************************************************
 Class    : SafeViewController.m
 Describe : 安全中心内容界面
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-02-06
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "SafeViewController.h"
#import "MineUtil.h"
#import "SettingUtil.h"

#import "YZTouchID.h"
#import "ModifyPwdViewController.h"
#import "GestureViewController.h"
#import "WUGesturesUnlockViewController.h"

@interface SafeViewController () <BaseTableViewControllerDelegate>

@end

@implementation SafeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.delegate = self;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.data = [[MineUtil shareInstance] getSafeItems];
    
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BaseTableModelGroup *group = [self.data objectAtIndex:indexPath.section];
    BaseTableModelItem *item = [group itemAtIndex:indexPath.row];
    
    UIViewController *viewController = nil;
    if([item.title isEqualToString:@"密码修改"]){
        ModifyPwdViewController *modifyPwdVC = [[ModifyPwdViewController alloc] init];
        viewController = modifyPwdVC;
    }
    
    if([item.title isEqualToString:@"手势密码"]){
        if([item.subTitle isEqualToString:@"未开启"]){
            WUGesturesUnlockViewController *gesturesUnlockVC = [[WUGesturesUnlockViewController alloc] initWithUnlockType:WUUnlockTypeCreatePwd];
            viewController = gesturesUnlockVC;
        }
        if([item.subTitle isEqualToString:@"已开启"]){
            WUGesturesUnlockViewController *gesturesUnlockVC = [[WUGesturesUnlockViewController alloc] initWithUnlockType:WUUnlockTypeValidatePwd];
            viewController = gesturesUnlockVC;
        }
    }
    
    if(nil != viewController){
        viewController.title = item.title;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - <BaseTableViewControllerDelegate>代理方法
- (void)baseTableViewControllerSwitchChanged:(UISwitch *)sender{
    NSInteger tag =  sender.tag;
    if(tag == 423){// 指纹识别
        [self touchVerification:sender];
    }
}

#pragma mark - 验证TouchID
- (void)touchVerification:(UISwitch *)sender {
    
    YZTouchID *touchID = [[YZTouchID alloc] init];
    
    [touchID td_showTouchIDWithDescribe:nil BlockState:^(YZTouchIDState state, NSError *error) {
        
        if (state == YZTouchIDStateNotSupport) {    //不支持TouchID
            
            [YZAlertView showAlertWith:self title:nil message:@"对不起，当前设备不支持指纹" callbackBlock:^(NSInteger btnIndex) {
            } cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles: nil];
            
            sender.on = !sender.isOn;
        } else if(state == YZTouchIDStateTouchIDLockout){ // 多次指纹错误被锁定
            
            [YZAlertView showAlertWith:self title:nil message:@"多次错误，指纹已被锁定，请到手机解锁界面输入密码！" callbackBlock:^(NSInteger btnIndex) {
            } cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil];
            
            sender.on = !sender.isOn;
            
        } else if (state == YZTouchIDStateSuccess) {    //TouchID验证成功
            sender.on = sender.isOn;
        }else{
            sender.on = !sender.isOn;
        }
        
        // ps:以上的状态处理并没有写完全!
        // 在使用中你需要根据回调的状态进行处理,需要处理什么就处理什么
        
        SettingUtil *settingUtil = [[SettingUtil shareInstance] init];
        NSMutableDictionary *settingDict = [settingUtil loadSettingData];
        [settingDict setValue:[NSNumber numberWithBool:sender.isOn] forKey:@"touchID"];
        BOOL res = [settingUtil writeSettingData:settingDict];
        if(!res){
            [YZProgressHUD showHUDView:SELF_VIEW Mode:SHOWMODE Text:@"设置异常！"];
        }
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
