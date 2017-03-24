//
//  ServiceViewController.m
//  TaxGeneralM
//
//  Created by Apple on 2017/2/6.
//  Copyright © 2017年 Yanzheng. All rights reserved.
//

#import "ServiceViewController.h"
#import "MineUtil.h"

#import "QuestionViewController.h"

@interface ServiceViewController ()

@end

@implementation ServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.data = [MineUtil getServiceItems];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BaseTableModelGroup *group = [self.data objectAtIndex:indexPath.section];
    BaseTableModelItem *item = [group itemAtIndex:indexPath.row];
    
    UIViewController *viewController = nil;
    if([item.title isEqualToString:@"客服电话"]){
        NSString *str = [NSString stringWithFormat:@"tel://%@", item.subTitle];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
    if([item.title isEqualToString:@"客服邮箱"]){
        NSString *str = [NSString stringWithFormat:@"mailto://%@", item.subTitle];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
    if([item.title isEqualToString:@"常见问题"]){
        QuestionViewController *questionViewController = [[QuestionViewController alloc] init];
        viewController = questionViewController;
    }
    
    if(nil != viewController){
        viewController.title = item.title;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
