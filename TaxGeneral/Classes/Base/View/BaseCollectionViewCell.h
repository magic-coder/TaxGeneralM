/************************************************************
 Class    : BaseCollectionViewCell.h
 Describe : 基础的网格的cell对象
 Company  : Prient
 Author   : Yanzheng
 Date     : 2016-12-30
 Version  : 1.0
 Declare  : Copyright © 2016 Yanzheng. All rights reserved.
 ************************************************************/

#import <UIKit/UIKit.h>
#import "BaseCollectionModel.h"

// 自定义cell的样式
typedef NS_ENUM(NSInteger, CollectionCellStyle) {
    CollectionCellStyleNone,    // 默认展示样式只有右侧跟底部线条
    CollectionCellStyleEdit     // 编辑样式（四边线条，显示+、-号）
};

// 自定义编辑按钮样式
typedef NS_ENUM(NSInteger, CollectionCellEditBtnStyle) {
    CollectionCellEditBtnStyleAdd,  // 编辑按钮为添加
    CollectionCellEditBtnStyleDel,  // 编辑按钮为删除
    CollectionCellEditBtnStyleSel   // 编辑按钮为已选择
};

@protocol BaseCollectionViewCellDelegate <NSObject>

-(void)baseCollectionViewCellEditBtnClick:(UIButton *)sender;

@end

@interface BaseCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *titleLabel;      // 标签（外部需要使用，所以定义在头文件中）
@property (nonatomic, assign) CollectionCellStyle cellStyle;    // 设置cell的样式
@property (nonatomic, assign) CollectionCellEditBtnStyle editBtnStyle;  // 编辑按钮样式

@property (nonatomic, strong) BaseCollectionModelItem *item;

@property (nonatomic, weak) id<BaseCollectionViewCellDelegate> delegate;

@end
