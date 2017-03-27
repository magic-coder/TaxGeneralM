/************************************************************
 Class    : MapViewController.h
 Describe : 地图界面（包含：定位、目标、线路规划、导航）
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-02-21
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import <UIKit/UIKit.h>
#import "MapListModel.h"

@interface MapViewController : UIViewController

@property(nonatomic, strong) MapListModel *model;

@end
