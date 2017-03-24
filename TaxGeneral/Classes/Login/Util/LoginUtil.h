//
//  LoginUtil.h
//  TaxGeneralM
//
//  Created by Apple on 2017/3/21.
//  Copyright © 2017年 Yanzheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginUtil : NSObject

+ (void)loginWithAppDict:(NSMutableDictionary *)dict success:(void (^)())success failed:(void (^)(NSString *error))failed;

+ (void)loginWithTokenSuccess:(void (^)())success failed:(void (^)(NSString *error))failed;

@end
