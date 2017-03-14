//
//  AccountUtil.h
//  TaxGeneralM
//
//  Created by Apple on 2017/3/9.
//  Copyright © 2017年 Yanzheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountUtil : NSObject

- (void)accountLogout:(void(^)())success failed:(void(^)(NSString *error))failed;

@end
