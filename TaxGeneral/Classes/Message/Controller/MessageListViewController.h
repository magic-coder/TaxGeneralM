//
//  MessageListViewController.h
//  TaxGeneral
//
//  Created by Apple on 16/8/15.
//  Copyright © 2016年 Yanzheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageListViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *data;      // 消息列表数据

- (void)autoLoadData;   // 自动请求刷新
@end
