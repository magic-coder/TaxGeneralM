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
@class MessageDetailViewCell;

typedef NS_ENUM(NSInteger, MsgDetailViewCellMenuType) {
    MsgDetailViewCellMenuTypeCalendar,    // 添加日历提醒
    MsgDetailViewCellMenuTypeCopy,      // 复制
    MsgDetailViewCellMenuTypeDelete     // 删除
};

@protocol MessageDetailViewCellDelegate <NSObject>

-(void)msgDetailViewCellMenuClicked:(MessageDetailViewCell *)cell type:(MsgDetailViewCellMenuType)type;

@end

@interface MessageDetailViewCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) MessageDetailModel *messageDetailModel;

@property (nonatomic, weak) id<MessageDetailViewCellDelegate> delegate;

@end
