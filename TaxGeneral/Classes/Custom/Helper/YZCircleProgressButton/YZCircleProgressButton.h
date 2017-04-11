/************************************************************
 Class    : YZCircleProgressButton.h
 Describe : 自定义倒计时动态按钮
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-04-10
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import <UIKit/UIKit.h>

typedef void(^YZCircleProgressBlock)(void);

@interface YZCircleProgressButton : UIButton

//set track color
@property (nonatomic,strong)UIColor    *trackColor;

//set progress color
@property (nonatomic,strong)UIColor    *progressColor;

//set track background color
@property (nonatomic,strong)UIColor    *fillColor;

//set progress line width
@property (nonatomic,assign)CGFloat    lineWidth;

//set progress duration
@property (nonatomic,assign)CGFloat    animationDuration;

/**
 *  set complete callback
 *
 *  @param lineWidth line width
 *  @param block     block
 *  @param duration  time
 */
- (void)startAnimationDuration:(CGFloat)duration withBlock:(YZCircleProgressBlock)block;

@end
