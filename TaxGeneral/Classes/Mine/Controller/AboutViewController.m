/************************************************************
 Class    : AboutViewController.m
 Describe : 关于界面
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-03-17
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "AboutViewController.h"
#import "AboutHeaderView.h"
#import "AboutFooterView.h"

@interface AboutViewController ()

@property (nonatomic, strong) NSArray *data;     // 数据列表

@property (nonatomic, strong) AboutHeaderView *headerView;  // 顶部视图
@property (nonatomic, strong) AboutFooterView *footerView;  // 底部视图

@end

@implementation AboutViewController

static NSString * const reuseIdentifier = @"aboutTableViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _data = @[@"功能介绍", @"检测更新", @"去评分"];
    
    [self.view setBackgroundColor:DEFAULT_BACKGROUND_COLOR];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    self.tableView.showsVerticalScrollIndicator = NO;// 隐藏纵向滚动条
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    
    _headerView = [[AboutHeaderView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, 150)];
    self.tableView.tableHeaderView = _headerView;
    
    _footerView = [[AboutFooterView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN-HEIGHT_STATUS-HEIGHT_NAVBAR-150-43*3-20)];
    self.tableView.tableFooterView = _footerView;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;   // 右侧小箭头
    cell.textLabel.font = [UIFont systemFontOfSize:15.5f];
    cell.textLabel.text = _data[indexPath.row];
    
    return cell;
}

#pragma mark 返回行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 43.0f;
}

#pragma mark - cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 点击后将颜色变回来
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.row == 1){
        [YZProgressHUD showHUDView:SELF_VIEW Mode:SHOWMODE Text:@"当前版本已是最新版本"];
    }
    
}

@end
