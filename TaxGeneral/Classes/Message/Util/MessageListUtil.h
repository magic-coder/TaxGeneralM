//
//  MessageListUtil.h
//  TaxGeneral
//
//  Created by Apple on 16/8/16.
//  Copyright © 2016年 Yanzheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageListModel.h"

@interface MessageListUtil : NSObject

- (NSDictionary *)loadMsgDataWithFile;

- (void)loadMsgDataWithPageNo:(int)pageNo pageSize:(int)pageSize dataBlock:(void(^)(NSDictionary *dataDict))dataBlock failed:(void(^)(NSString *error))failed;

@end
