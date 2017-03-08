//
//  MessageListUtil.m
//  TaxGeneral
//
//  Created by Apple on 16/8/16.
//  Copyright © 2016年 Yanzheng. All rights reserved.
//

#import "MessageListUtil.h"

@implementation MessageListUtil

+ (NSMutableArray *)getMessageList{
    NSMutableArray *list = [[NSMutableArray alloc] init];
    NSMutableArray *sysList = [[NSMutableArray alloc] init];
    NSMutableArray *userList = [[NSMutableArray alloc] init];
    
    // 此处目前读取plist资源文件，后期从数据库中获取
    NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"msgData" ofType:@"plist"];
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] initWithContentsOfFile:dataPath];
    NSMutableArray *sysData = [dataDict objectForKey:@"sysData"];
    NSMutableArray *userData = [dataDict objectForKey:@"userData"];
    
    for(NSDictionary *dict in sysData){
        //MessageListModel *model = [MessageListModel createWithDict:dict];
        MessageListModel *model = [MessageListModel mj_objectWithKeyValues:dict];
        [sysList addObject:model];
    }
    for(NSDictionary *dict in userData){
        //MessageListModel *model = [MessageListModel createWithDict:dict];
        MessageListModel *model = [MessageListModel mj_objectWithKeyValues:dict];
        [userList addObject:model];
    }

    /*
    //MessageListModel *model1 = [MessageListModel createWithAvatar:@"msg_add" name:@"添加好友" message:@"暂无新消息" date:@""];
     
     
    MessageListModel *model1 = [MessageListModel createWithAvatar:@"msg_notification" name:@"通知公告" message:@"12366纳税服务平台，今日系统服务全面升级..." date:@"08:00"];
    MessageListModel *model2 = [MessageListModel createWithAvatar:@"msg_information" name:@"工作消息" message:@"西安市地方税务局会议通知，与2017-02-10日在市局4楼大会议室召开全体会议" date:@"17:02"];
    
    MessageListModel *model3 = [MessageListModel createWithAvatar:@"msg_heard" name:@"市局领导" message:@"互联网+税务时代app即将上线，摆好姿势，准备迎接..." date:@"16:50"];
    MessageListModel *model4 = [MessageListModel createWithAvatar:@"msg_heard" name:@"信息处" message:@"新版app有三个版本，管理端、客户端、自然人端" date:@"13:27"];
    MessageListModel *model5 = [MessageListModel createWithAvatar:@"msg_heard" name:@"征管科" message:@"全新UI、全新体验、一触即发😘" date:@"10:12"];
    MessageListModel *model6 = [MessageListModel createWithAvatar:@"msg_heard" name:@"评估科" message:@"界面风格美到没朋友，很好用、很互联网+" date:@"09:36"];
    
    [sysList addObject:model1];
    [sysList addObject:model2];
    
    [userList addObject:model3];
    [userList addObject:model4];
    [userList addObject:model5];
    [userList addObject:model6];
    */
    
    [list addObject:sysList];
    [list addObject:userList];
    
    return list;
}

@end
