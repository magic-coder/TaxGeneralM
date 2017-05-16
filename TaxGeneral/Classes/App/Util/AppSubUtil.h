/************************************************************
 Class    : AppSubUtil.h
 Describe : 应用程序子界面
 Company  : Prient
 Author   : Yanzheng
 Date     : 2016-03-30
 Version  : 1.0
 Declare  : Copyright © 2016 Yanzheng. All rights reserved.
 ************************************************************/

#import <Foundation/Foundation.h>

@interface AppSubUtil : NSObject

+ (instancetype)shareInstance;

- (NSMutableArray *)loadSubDataWithPno:(NSString *)pno level:(NSString *)level;

- (NSMutableArray *)loadSearchData;

@end
