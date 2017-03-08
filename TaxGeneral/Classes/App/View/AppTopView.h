//
//  AppTopView.h
//  TaxGeneral
//
//  Created by Apple on 2016/12/29.
//  Copyright © 2016年 Yanzheng. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol AppTopViewDelegate <NSObject>

- (void)appTopViewBtnClick:(UIButton *)sender;

@end

@interface AppTopView : UIView

@property (nonatomic, weak) id<AppTopViewDelegate> delegate;

@end
