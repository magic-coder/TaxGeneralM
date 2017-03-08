/************************************************************
 Class    : BaseTableViewHeaderFooterView.h
 Describe : 基础的表格头部、底部视图
 Company  : Prient
 Author   : Yanzheng
 Date     : 2016-08-04
 Version  : 1.0
 Declare  : Copyright © 2016 Yanzheng. All rights reserved.
 ************************************************************/

#import <UIKit/UIKit.h>

@interface BaseTableViewHeaderFooterView : UITableViewHeaderFooterView

@property (nonatomic, strong) NSString *text;

+ (CGFloat) getHeightForText:(NSString *)text;

@end
