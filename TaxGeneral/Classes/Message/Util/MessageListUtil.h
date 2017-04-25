/************************************************************
 Class    : MessageListUtil.h
 Describe : 消息列表工具类
 Company  : Prient
 Author   : Yanzheng
 Date     : 2016-08-16
 Version  : 1.0
 Declare  : Copyright © 2016 Yanzheng. All rights reserved.
 ************************************************************/

#import <Foundation/Foundation.h>
#import "MessageListModel.h"

@interface MessageListUtil : NSObject

- (NSDictionary *)loadMsgDataWithFile;

- (int)getMsgUnReadCountSuccess:(void(^)(int unReadCount))success;

- (void)loadMsgDataWithPageNo:(int)pageNo pageSize:(int)pageSize dataBlock:(void(^)(NSDictionary *dataDict))dataBlock failed:(void(^)(NSString *error))failed;

- (void)deleteMsgWithSourceCode:(NSString *)sourceCode pushOrgCode:(NSString *)pushOrgCode success:(void(^)())success failed:(void(^)(NSString *error))failed;

@end
