/************************************************************
 Class    : MessageDetailUtil.h
 Describe : 消息内容明细工具类
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-02-15
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import <Foundation/Foundation.h>

@interface MessageDetailUtil : NSObject

- (void)loadMsgDataWithParam:(NSDictionary *)param dataBlock:(void (^)(NSDictionary *dataDict))dataBlock failed:(void (^)(NSString *error))failed;

- (void)deleteMsgWithUUID:(NSString *)uuid success:(void (^)())success failed:(void (^)(NSString *error))failed;

@end
