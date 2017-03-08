/************************************************************
 Class    : BaseCollectionViewController.h
 Describe : 基础的网格视图控制器，提供Collection界面布局
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-01-06
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import <UIKit/UIKit.h>

// 自定义collection的样式
typedef NS_ENUM(NSInteger, CollectionStyle) {
    CollectionStyleNone,    // 一般模式
    CollectionStyleEdit     // 编辑模式
};

@protocol BaseCollectionViewControllerDelegate <NSObject>

- (void)baseCollectionViewControllerEditBtnClick:(UIButton *)sender;

@end

@interface BaseCollectionViewController : UICollectionViewController

@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, assign) CollectionStyle collectionStyle;

@property (nonatomic, weak) id<BaseCollectionViewControllerDelegate> delegate;

@end
