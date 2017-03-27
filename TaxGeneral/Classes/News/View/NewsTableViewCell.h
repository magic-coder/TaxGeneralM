/************************************************************
 Class    : NewsTableViewCell.h
 Describe : 自定义税文列表cell（三种样式：文本、单图、多图）
 Company  : Prient
 Author   : Yanzheng
 Date     : 2016-12-02
 Version  : 1.0
 Declare  : Copyright © 2016 Yanzheng. All rights reserved.
 ************************************************************/

#import <UIKit/UIKit.h>
@class NewsModel;

@interface NewsTableViewCell : UITableViewCell

@property (nonatomic, strong) NewsModel *newsModel;

@end
