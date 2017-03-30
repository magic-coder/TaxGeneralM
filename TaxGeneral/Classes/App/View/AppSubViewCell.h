/************************************************************
 Class    : AppSubViewCell.h
 Describe : 第二级菜单列表自定义cell样式
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-03-29
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import <UIKit/UIKit.h>
#import "AppSubModel.h"

typedef NS_ENUM(NSInteger, AppSubViewCellLineStyle) {
    AppSubViewCellLineStyleDefault,
    AppSubViewCellLineStyleFill,
    AppSubViewCellLineStyleNone,
};

@interface AppSubViewCell : UITableViewCell

@property (nonatomic, assign) AppSubViewCellLineStyle bottomLineStyle;
@property (nonatomic, assign) AppSubViewCellLineStyle topLineStyle;

@property (nonatomic, strong) AppSubModel *model;

@end
