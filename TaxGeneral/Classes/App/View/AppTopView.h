/************************************************************
 Class    : AppTopView.h
 Describe : 应用界面顶部头视图
 Company  : Prient
 Author   : Yanzheng
 Date     : 2016-12-29
 Version  : 1.0
 Declare  : Copyright © 2016 Yanzheng. All rights reserved.
 ************************************************************/

#import <UIKit/UIKit.h>


@protocol AppTopViewDelegate <NSObject>

- (void)appTopViewBtnClick:(UIButton *)sender;

@end

@interface AppTopView : UIView

@property (nonatomic, weak) id<AppTopViewDelegate> delegate;

@end
