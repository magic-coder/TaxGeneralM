//
//  MessageDetailUtil.m
//  TaxGeneralM
//
//  Created by Apple on 2017/2/15.
//  Copyright © 2017年 Yanzheng. All rights reserved.
//

#import "MessageDetailUtil.h"
#import "MessageDetailModel.h"

@implementation MessageDetailUtil

+(NSMutableArray *)getDetailData{
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    
    MessageDetailModel *item1 = [MessageDetailModel createWithTitle:@"工作安排、西安@2017 -> Since 2016" date:@"2017-02-15 10:38" content:@"有的正文比较简单，只讲明为什么发布或批转这一文件，有哪些原则要求，主要的具体内容应看所附文件。有的正文写多几句，借题发挥，补充强调有关要求，或作出指示，布置相应的工作。也就是要遵照执行、贯彻落实的具体内容在附件里，而不是在批转的通知中。批转通知只是一个载体。" url:@"https://www.baidu.com"];
    
    MessageDetailModel *item2 = [MessageDetailModel createWithTitle:@"没有详情的消息不可点击跳转,不信你点点试试" date:@"2017-02-16 16:12" content:@"会议通知是上级对下级、组织对成员或平行单位之间部署工作、传达事情或召开会议等所使用的应用文。是我国党政军各级机关乃至企事业单位、群众团体经常使用的公文文种，是应用写作中常见的一种文体。" url:nil];
    
    MessageDetailModel *item3 = [MessageDetailModel createWithTitle:@"第六届西安市地方税务局全局表彰大会" date:@"2017-02-17 09:32" content:@"会议通知    各科室、处属各单位 ：   为贯彻落实上级会议精神，总结回顾2016年工作，安排部署2017年工作，经研究，决定召开管理处工作会议暨职工迎春联欢会，现将有关事项通知如下;  一、会议时间   2017年2月20日（星期二）上午8；30 —12；00  二、会议地点  管理处四楼会议室  三、会议议程   1、通报全省高速公路运营管理大检查情况   2、宣读省交通厅、厅高管局、省高管中心先进集体 暨先进个人表彰决定  3、成小原处长做管理处工作报告  4、职工迎春联欢会" url:@"https://www.apple.com"];
    
    [mutableArray addObject:item1];
    [mutableArray addObject:item2];
    [mutableArray addObject:item3];
    
    return mutableArray;
}

@end
