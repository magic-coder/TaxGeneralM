//
//  MessageDetailUtil.h
//  TaxGeneralM
//
//  Created by Apple on 2017/2/15.
//  Copyright © 2017年 Yanzheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageDetailUtil : NSObject

- (void)loadMsgDataWithParam:(NSDictionary *)param dataBlock:(void (^)(NSDictionary *dataDict))dataBlock failed:(void (^)(NSString *error))failed;

@end
