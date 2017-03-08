//
//  MessageListViewCell.h
//  TaxGeneral
//
//  Created by Apple on 16/8/15.
//  Copyright © 2016年 Yanzheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageListModel.h"

typedef NS_ENUM(NSInteger, CellLineStyle) {
    CellLineStyleDefault,
    CellLineStyleFill,
    CellLineStyleNone,
};

@interface MessageListViewCell : UITableViewCell

@property (nonatomic, assign) CellLineStyle bottomLineStyle;
@property (nonatomic, assign) CellLineStyle topLineStyle;

@property (nonatomic, strong) MessageListModel *messageListModel;

@end
