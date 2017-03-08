/************************************************************
 Class    : YZWebProgressView.h
 Describe : This is YZWebProgressView
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-01-16
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import <UIKit/UIKit.h>

@interface YZWebProgressView : UIView
@property (assign , nonatomic)float springVelocity;
@property (assign , nonatomic)float springSpeed;
@property (strong , nonatomic)NSProgress *progress; // change Progress  
@property (assign , nonatomic)float duration;
@property (strong , nonatomic)UIColor *color;
@end
