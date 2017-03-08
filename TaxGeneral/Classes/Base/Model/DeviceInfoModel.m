//
//  DeviceInfoModel.m
//  TaxGeneral
//
//  Created by Apple on 2016/12/30.
//  Copyright © 2016年 Yanzheng. All rights reserved.
//

#import "DeviceInfoModel.h"
#import <sys/utsname.h>

@implementation DeviceInfoModel

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.deviceIdentifier forKey:@"deviceIdentifier"];
    [aCoder encodeObject:self.deviceName forKey:@"deviceName"];
    [aCoder encodeObject:self.deviceModel forKey:@"deviceModel"];
    [aCoder encodeObject:self.systemName forKey:@"systemName"];
    [aCoder encodeObject:self.systemVersion forKey:@"systemVersion"];
    [aCoder encodeInteger:self.deviceInch forKey:@"deviceInch"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super init]){
        self.deviceIdentifier = [aDecoder decodeObjectForKey:@"deviceIdentifier"];
        self.deviceName = [aDecoder decodeObjectForKey:@"deviceName"];
        self.deviceModel = [aDecoder decodeObjectForKey:@"deviceModel"];
        self.systemName = [aDecoder decodeObjectForKey:@"systemName"];
        self.systemVersion = [aDecoder decodeObjectForKey:@"systemVersion"];
        self.deviceInch = [aDecoder decodeIntegerForKey:@"deviceInch"];
    }
    return self;
}


- (instancetype)getDeviceInfoModel{
    NSString *deviceIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSString *deviceName = [[UIDevice currentDevice] name];
    NSString *deviceModel = [self deviceVersion];//方法在下面
    NSString *systemName = [[UIDevice currentDevice] systemName];
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    
    DeviceScreenInch deviceInch = [UIDevice deviceScreenInch];
    
    DLog(@"Yan -> 唯一标示 : %@", deviceIdentifier);
    DLog(@"Yan -> 设备名称 : %@", deviceName);
    DLog(@"Yan -> 手机型号 : %@", deviceModel);
    DLog(@"Yan -> 系统名称 : %@", systemName);
    DLog(@"Yan -> 手机序系统版本 : %@", systemVersion);
    DLog(@"Yan -> 屏幕尺寸 : %ld", (long)deviceInch);
    
    DeviceInfoModel *model = [[DeviceInfoModel alloc] init];
    model.deviceIdentifier = deviceIdentifier;
    model.deviceName = deviceName;
    model.deviceModel = deviceModel;
    model.systemName = systemName;
    model.systemVersion = systemVersion;
    model.deviceInch = deviceInch;
    
    return model;
}

#pragma mark 获取设备型号
- (NSString *)deviceVersion {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPod1,1"]) return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"]) return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"]) return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"]) return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"]) return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPad1,1"]) return @"iPad 1G";
    if ([platform isEqualToString:@"iPad2,1"]) return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,2"]) return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"]) return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,4"]) return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,5"]) return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad2,6"]) return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad2,7"]) return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad3,1"]) return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,2"]) return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,3"]) return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"]) return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,5"]) return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,6"]) return @"iPad 4";
    if ([platform isEqualToString:@"iPad4,1"]) return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,2"]) return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,3"]) return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,4"]) return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,5"]) return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,6"]) return @"iPad Mini 2G";
    if ([platform isEqualToString:@"i386"]) return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"]) return @"iPhone Simulator";
    return platform;
}

@end
