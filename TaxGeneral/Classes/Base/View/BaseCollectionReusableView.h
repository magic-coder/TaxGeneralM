/************************************************************
 Class    : BaseCollectionReusableView.h
 Describe : 基础网格视图的组顶部视图，提供分组描述说明
 Company  : Prient
 Author   : Yanzheng
 Date     : 2016-12-31
 Version  : 1.0
 Declare  : Copyright © 2016 Yanzheng. All rights reserved.
 ************************************************************/

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ReusableViewStyle) {
    ReusableViewStyleNone,  // 基本展示模式
    ReusableViewStyleEdit   // 编辑模式
};

@interface BaseCollectionReusableView : UICollectionReusableView

@property (nonatomic, assign) BOOL isTop;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) ReusableViewStyle style;

@end
