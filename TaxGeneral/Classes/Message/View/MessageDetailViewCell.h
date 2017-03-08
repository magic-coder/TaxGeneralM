/************************************************************
 Class    : MessageDetailViewCell.h
 Describe : 自定义消息推送列表展示，封装消息框
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-02-15
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import <UIKit/UIKit.h>
#import "MessageDetailModel.h"

@interface MessageDetailViewCell : UITableViewCell

@property (nonatomic, strong) MessageDetailModel *messageDetailModel;

@end
