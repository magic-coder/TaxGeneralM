//
//  MineUtil.m
//  TaxGeneralM
//
//  Created by Apple on 2017/2/6.
//  Copyright © 2017年 Yanzheng. All rights reserved.
//

#import "MineUtil.h"
#import "SettingUtil.h"

@implementation MineUtil

+ (NSMutableArray *)getMineItems{
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
    
    return items;
}

+ (NSMutableArray *)getAccountItems{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    BaseTableModelItem *userID = [BaseTableModelItem createWithTitle:@"姓名" subTitle:@"倪辰曦"];
    userID.accessoryType = UITableViewCellAccessoryNone;
    BaseTableModelGroup *group1 = [[BaseTableModelGroup alloc] initWithHeaderTitle:nil footerTitle:nil settingItems:userID, nil];
    [items addObject:group1];

    BaseTableModelItem *name = [BaseTableModelItem createWithTitle:@"账号" subTitle:@"ncx0628"];
    name.accessoryType = UITableViewCellAccessoryNone;
    BaseTableModelItem *phoneNum = [BaseTableModelItem createWithTitle:@"手机号" subTitle:@"15691959168"];
    phoneNum.accessoryType = UITableViewCellAccessoryNone;
    //BaseTableModelItem *barCode = [BaseTableModelItem createWithImageName:nil title:@"我的二维码" subTitle:nil rightImageName:@"mine_barcode"];
    //barCode.accessoryType = UITableViewCellAccessoryNone;
    BaseTableModelItem *organ = [BaseTableModelItem createWithTitle:@"所属部门" subTitle:@"西安市地方税务局"];
    organ.accessoryType = UITableViewCellAccessoryNone;
    BaseTableModelGroup *group2 = [[BaseTableModelGroup alloc] initWithHeaderTitle:nil footerTitle:nil settingItems:name, phoneNum, organ, nil];
    [items addObject:group2];
    
    BaseTableModelItem *lastTime = [BaseTableModelItem createWithTitle:@"上次登录时间" subTitle:@"2017-02-06 16:36"];
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

+ (NSMutableArray *)getSafeItems{
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
    
    NSDictionary *settingDict = [[SettingUtil alloc] loadSettingData];
    BOOL touchIDOn = [[settingDict objectForKey:@"touchID"] boolValue];
    
    BaseTableModelItem *item3 = [BaseTableModelItem createWithTitle:@"指纹解锁"];
    item3.type = BaseTableModelItemTypeSwitch;
    item3.tag = 423;
    item3.isOn = touchIDOn;
    BaseTableModelGroup *group2 = [[BaseTableModelGroup alloc] initWithHeaderTitle:nil footerTitle:@"若要开启指纹解锁功能，请先在“设置”-“Touch ID 与密码”中添加指纹。" settingItems:item3, nil];
    [items addObject:group2];
    
    return items;
}

+(NSMutableArray *)getGestureItems{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    BaseTableModelItem *item1= [BaseTableModelItem createWithTitle:@"删除手势密码"];
    item1.alignment = BaseTableModelItemAlignmentMiddle;
    BaseTableModelGroup *group1 = [[BaseTableModelGroup alloc] initWithHeaderTitle:nil footerTitle:nil settingItems:item1, nil];
    [items addObject:group1];
    
    return items;
}

+ (NSMutableArray *)getScheduleItems{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    BaseTableModelItem *item1 = [BaseTableModelItem createWithTitle:@"日程提醒管理"];
    BaseTableModelItem *item2= [BaseTableModelItem createWithTitle:@"办税日历"];
    BaseTableModelGroup *group1 = [[BaseTableModelGroup alloc] initWithHeaderTitle:nil footerTitle:nil settingItems:item1, item2, nil];
    [items addObject:group1];
    
    return items;
}

+ (NSMutableArray *)getServiceItems{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    BaseTableModelItem *item1 = [BaseTableModelItem createWithTitle:@"客服电话" subTitle:@"400-896-9699"];
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

+ (NSMutableArray *)getQuestionItems{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    BaseTableModelGroup *group1 = [[BaseTableModelGroup alloc] initWithHeaderTitle:@"问：登录时提示账号或密码错误？" footerTitle:@"答：检查核对账户，密码8位字母（大小写）和数字。" settingItems: nil];
    [items addObject:group1];
    
    BaseTableModelGroup *group2 = [[BaseTableModelGroup alloc] initWithHeaderTitle:@"问：如何删除信息列表中的信息？" footerTitle:@"答：在列表页中向左滑动或者长按都会显示删除按钮，然后进行删除。" settingItems: nil];
    [items addObject:group2];
    
    BaseTableModelGroup *group3 = [[BaseTableModelGroup alloc] initWithHeaderTitle:@"问：如何进行密码重置？" footerTitle:@"答：密码重置时，税务人员输入登录用户名。点击“重置”后，系统通过短信发送验证码到手机（手机号码与核心征管中记录的一致），验证通过后，进入密码重置页面。输入新密码即可。" settingItems: nil];
    [items addObject:group3];
    
    return items;
}

+ (NSMutableArray *)getSettingItems{
    
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
    NSDictionary *settingDict = [[SettingUtil alloc] loadSettingData];
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
