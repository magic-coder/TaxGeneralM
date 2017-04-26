/************************************************************
 Class    : MineUtil.m
 Describe : 我的界面工具类，加载各子模块内容
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-02-06
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "MineUtil.h"
#import "SettingUtil.h"

@implementation MineUtil

+ (instancetype)shareInstance{
    static MineUtil *mineUtil = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mineUtil = [[MineUtil alloc] init];
    });
    return mineUtil;
}

- (NSMutableArray *)getMineItems{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    BaseTableModelItem *mineInfo = [BaseTableModelItem createWithImageName:@"mine_account" title:@"账户管理"];
    BaseTableModelGroup *group1 = [[BaseTableModelGroup alloc] initWithHeaderTitle:nil footerTitle:nil settingItems:mineInfo, nil];
    [items addObject:group1];
    
    BaseTableModelItem *safe = [BaseTableModelItem createWithImageName:@"mine_safe" title:@"安全中心"];
    BaseTableModelItem *schedule = [BaseTableModelItem createWithImageName:@"mine_schedule" title:@"我的日程"];
    BaseTableModelItem *service = [BaseTableModelItem createWithImageName:@"mine_service" title:@"我的客服"];
    
    BaseTableModelGroup *group2 = [[BaseTableModelGroup alloc] initWithHeaderTitle:nil footerTitle:nil settingItems:safe, schedule, service, nil];
    [items addObject:group2];
    
    BaseTableModelItem *setting = [BaseTableModelItem createWithImageName:@"mine_setting" title:@"设置"];
    
    BaseTableModelGroup *group3 = [[BaseTableModelGroup alloc] initWithHeaderTitle:nil footerTitle:nil settingItems:setting, nil];
    [items addObject:group3];
    
    BaseTableModelItem *about = [BaseTableModelItem createWithImageName:@"mine_about" title:@"关于"];
    BaseTableModelGroup *group4 = [[BaseTableModelGroup alloc] initWithHeaderTitle:nil footerTitle:nil settingItems:about, nil];
    [items addObject:group4];
    
    BOOL isTest = [[[NSUserDefaults standardUserDefaults] objectForKey:@"isTest"] boolValue];
    if(isTest){
        BaseTableModelItem *test = [BaseTableModelItem createWithImageName:@"mine_test" title:@"测试"];
        BaseTableModelGroup *group5 = [[BaseTableModelGroup alloc] initWithHeaderTitle:nil footerTitle:nil settingItems:test, nil];
        [items addObject:group5];
    }
    
    return items;
}

- (NSMutableArray *)getAccountItems{
    
    NSDictionary *userDict = [[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_SUCCESS];
    
    NSMutableArray *items = [[NSMutableArray alloc] init];
    BaseTableModelItem *userID = [BaseTableModelItem createWithTitle:@"姓名" subTitle:[userDict objectForKey:@"userName"]];
    userID.accessoryType = UITableViewCellAccessoryNone;
    BaseTableModelGroup *group1 = [[BaseTableModelGroup alloc] initWithHeaderTitle:nil footerTitle:nil settingItems:userID, nil];
    [items addObject:group1];

    BaseTableModelItem *name = [BaseTableModelItem createWithTitle:@"账号" subTitle:[userDict objectForKey:@"userCode"]];
    name.accessoryType = UITableViewCellAccessoryNone;
    BaseTableModelItem *phoneNum = [BaseTableModelItem createWithTitle:@"手机号" subTitle:@"15691959168"];
    phoneNum.accessoryType = UITableViewCellAccessoryNone;
    //BaseTableModelItem *barCode = [BaseTableModelItem createWithImageName:nil title:@"我的二维码" subTitle:nil rightImageName:@"mine_barcode"];
    //barCode.accessoryType = UITableViewCellAccessoryNone;
    BaseTableModelItem *organ = [BaseTableModelItem createWithTitle:@"所属部门" subTitle:[userDict objectForKey:@"orgName"]];
    organ.accessoryType = UITableViewCellAccessoryNone;
    BaseTableModelGroup *group2 = [[BaseTableModelGroup alloc] initWithHeaderTitle:nil footerTitle:nil settingItems:name, phoneNum, organ, nil];
    [items addObject:group2];
    
    
    BaseTableModelItem *lastTime = [BaseTableModelItem createWithTitle:@"上次登录时间" subTitle:[userDict objectForKey:@"loginDate"]];
    lastTime.accessoryType = UITableViewCellAccessoryNone;
    BaseTableModelGroup *group3 = [[BaseTableModelGroup alloc] initWithHeaderTitle:nil footerTitle:nil settingItems:lastTime, nil];
    [items addObject:group3];
    
    BaseTableModelItem *exit = [BaseTableModelItem createWithTitle:@"退出登录"];
    exit.alignment = BaseTableModelItemAlignmentMiddle;
    exit.titleColor = DEFAULT_RED_COLOR;
    
    BaseTableModelGroup *group4 = [[BaseTableModelGroup alloc] initWithHeaderTitle:nil footerTitle:nil settingItems:exit, nil];
    [items addObject:group4];
    
    return items;
}

- (NSMutableArray *)getSafeItems{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    BaseTableModelItem *item1 = [BaseTableModelItem createWithTitle:@"密码修改"];
    NSString *gesturePwd = [[NSUserDefaults standardUserDefaults] objectForKey:@"gesturespassword"];
    BaseTableModelItem *item2 = nil;
    if(gesturePwd.length > 0){
        item2 = [BaseTableModelItem createWithTitle:@"手势密码" subTitle:@"已开启"];
    }else{
        item2 = [BaseTableModelItem createWithTitle:@"手势密码" subTitle:@"未开启"];
    }
    
    BaseTableModelGroup *group1 = [[BaseTableModelGroup alloc] initWithHeaderTitle:nil footerTitle:nil settingItems:item1, item2, nil];
    [items addObject:group1];
    
    NSDictionary *settingDict = [[SettingUtil shareInstance] loadSettingData];
    BOOL touchIDOn = [[settingDict objectForKey:@"touchID"] boolValue];
    
    BaseTableModelItem *item3 = [BaseTableModelItem createWithTitle:@"指纹解锁"];
    item3.type = BaseTableModelItemTypeSwitch;
    item3.tag = 423;
    item3.isOn = touchIDOn;
    BaseTableModelGroup *group2 = [[BaseTableModelGroup alloc] initWithHeaderTitle:nil footerTitle:@"若要开启指纹解锁功能，请先在“设置”-“Touch ID 与密码”中添加指纹。" settingItems:item3, nil];
    [items addObject:group2];
    
    return items;
}

- (NSMutableArray *)getGestureItems{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    BaseTableModelItem *item1= [BaseTableModelItem createWithTitle:@"删除手势密码"];
    item1.alignment = BaseTableModelItemAlignmentMiddle;
    BaseTableModelGroup *group1 = [[BaseTableModelGroup alloc] initWithHeaderTitle:nil footerTitle:nil settingItems:item1, nil];
    [items addObject:group1];
    
    return items;
}

- (NSMutableArray *)getScheduleItems{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    BaseTableModelItem *item1 = [BaseTableModelItem createWithTitle:@"日程提醒管理"];
    BaseTableModelItem *item2= [BaseTableModelItem createWithTitle:@"办税日历"];
    BaseTableModelGroup *group1 = [[BaseTableModelGroup alloc] initWithHeaderTitle:nil footerTitle:nil settingItems:item1, item2, nil];
    [items addObject:group1];
    
    return items;
}

- (NSMutableArray *)getServiceItems{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    BaseTableModelItem *item1 = [BaseTableModelItem createWithTitle:@"客服电话" subTitle:@"12366"];
    item1.accessoryType = UITableViewCellAccessoryNone;
    BaseTableModelItem *item2 = [BaseTableModelItem createWithTitle:@"客服邮箱" subTitle:@"yanzheng@prient.com"];
    item2.accessoryType = UITableViewCellAccessoryNone;
    BaseTableModelGroup *group1 = [[BaseTableModelGroup alloc] initWithHeaderTitle:nil footerTitle:nil settingItems:item1, item2, nil];
    [items addObject:group1];
    
    BaseTableModelItem *item3= [BaseTableModelItem createWithTitle:@"常见问题"];
    BaseTableModelGroup *group2 = [[BaseTableModelGroup alloc] initWithHeaderTitle:nil footerTitle:nil settingItems:item3, nil];
    [items addObject:group2];
    
    return items;
}

- (NSMutableArray *)getSettingItems{
    
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    // 判断用户是否打开消息通知
    NSString *subTitle;
    UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
    if (UIUserNotificationTypeNone != setting.types) {
        subTitle = @"已开启";
    }else{
        subTitle = @"已关闭";
    }
    
    BaseTableModelItem *recNoti = [BaseTableModelItem createWithTitle:@"接收新消息通知" subTitle:subTitle];
    recNoti.accessoryType = UITableViewCellAccessoryNone;
    BaseTableModelGroup *group1 = [[BaseTableModelGroup alloc] initWithHeaderTitle:nil footerTitle:@"如果你要关闭或开启“互联网+税务”的新消息通知，请在iPhone的“设置”-“通知”功能中，找到应用程序“互联网+税务”更改。" settingItems:recNoti, nil];
    [items addObject:group1];
    
    // 获取声音、震动值
    NSDictionary *settingDict = [[SettingUtil shareInstance] loadSettingData];
    BOOL voiceOn = [[settingDict objectForKey:@"voice"] boolValue];
    BOOL shakeOn = [[settingDict objectForKey:@"shake"] boolValue];
    
    BaseTableModelItem *voice = [BaseTableModelItem createWithTitle:@"声音"];
    voice.type = BaseTableModelItemTypeSwitch;
    voice.tag = 452;
    voice.isOn = voiceOn;
    BaseTableModelItem *shake = [BaseTableModelItem createWithTitle:@"震动"];
    shake.type = BaseTableModelItemTypeSwitch;
    shake.tag = 453;
    shake.isOn = shakeOn;
    BaseTableModelGroup *group2 = [[BaseTableModelGroup alloc] initWithHeaderTitle:nil footerTitle:@"当“互联网+税务”在运行时，你可以设置是否需要声音或者振动。" settingItems:voice, shake, nil];
    [items addObject:group2];
    
    float tempSize = [[SDImageCache sharedImageCache] getSize]/1024;
    NSString *cacheSize = tempSize >= 1024 ? [NSString stringWithFormat:@"%.1fMB",tempSize/1024] : [NSString stringWithFormat:@"%.1fKB",tempSize];
    BaseTableModelItem *clear = [BaseTableModelItem createWithTitle:@"清理缓存" subTitle:cacheSize];
    clear.accessoryType = UITableViewCellAccessoryNone;
    BaseTableModelGroup *group3 = [[BaseTableModelGroup alloc] initWithHeaderTitle:nil footerTitle:nil settingItems: clear, nil];
    [items addObject:group3];
    
    return items;
}

@end
