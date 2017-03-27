/************************************************************
 Class    : MapListViewCell.h
 Describe : 自定义地图机构列表Cell
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-02-20
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import <UIKit/UIKit.h>
#import "MapListModel.h"

@interface MapListViewCell : UITableViewCell

@property (nonatomic, strong) MapListModel *model;

@end
