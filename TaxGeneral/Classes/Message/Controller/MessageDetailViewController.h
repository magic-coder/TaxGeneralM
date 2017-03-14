//
//  MessageDetailViewController.h
//  TaxGeneralM
//
//  Created by Apple on 2017/2/15.
//  Copyright © 2017年 Yanzheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageDetailViewController : UITableViewController

@property (nonatomic, assign) int totalPage;            // 最大页
@property (nonatomic, strong) NSString *sourceCode;     // 来源代码
@property (nonatomic, strong) NSString *pushUserCode;   // 推送人代码

@end
