/************************************************************
 Class    : AppSubViewController.m
 Describe : 应用第二级菜单列表
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-03-29
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "AppSubViewController.h"
#import "AppSubViewCell.h"
#import "AppSubUtil.h"

@interface AppSubViewController ()

@property (nonatomic, strong) NSMutableArray *data;

@end

@implementation AppSubViewController

static NSString * const reuseIdentifier = @"appSubCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _data = [[NSMutableArray alloc] init];
    
    self.view.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    self.tableView.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    
    [self.tableView registerClass:[AppSubViewCell class] forCellReuseIdentifier:reuseIdentifier];
    [self.tableView setSeparatorStyle: UITableViewCellSeparatorStyleNone];
    
    _data = [AppSubUtil getAppSubData];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AppSubViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    [cell setModel:[_data objectAtIndex:indexPath.row]];
    indexPath.row == 0 ? [cell setTopLineStyle:AppSubViewCellLineStyleFill] : [cell setTopLineStyle:AppSubViewCellLineStyleNone];
    indexPath.row == _data.count - 1 ? [cell setBottomLineStyle:AppSubViewCellLineStyleFill] : [cell setBottomLineStyle:AppSubViewCellLineStyleDefault];
    return cell;
}
#pragma mark 返回行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 63.0f;
}

#pragma mark 点击行触发点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    // 获取当前点击的cell
    AppSubViewCell *cell = (AppSubViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    DLog(@"Yan -> 点击了cell : %@", cell.model.title);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
