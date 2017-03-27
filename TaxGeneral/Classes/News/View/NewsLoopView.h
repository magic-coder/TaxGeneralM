/************************************************************
 Class    : NewsLoopView.h
 Describe : 税闻顶部焦点自动轮播视图
 Company  : Prient
 Author   : Yanzheng
 Date     : 2016-12-02
 Version  : 1.0
 Declare  : Copyright © 2016 Yanzheng. All rights reserved.
 ************************************************************/

#import <UIKit/UIKit.h>
@class NewsLoopView;

// 设置loopView点击的代理方法
@protocol NewsLoopViewDelegate <NSObject>

@optional
- (void)loopViewDidSelectedImage:(NewsLoopView *)loopView index:(int)index;

@end

@interface NewsLoopView : UIView

@property (nonatomic, weak) id<NewsLoopViewDelegate> delegate;
@property (nonatomic, assign) BOOL autoPlay;
@property (nonatomic, assign) NSTimeInterval timeInterval;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray *urls;

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles images:(NSArray *)images urls:(NSArray *)urls autoPlay:(BOOL)isAuto delay:(NSTimeInterval)timeInterval;

@end
