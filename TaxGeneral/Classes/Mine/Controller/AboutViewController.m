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
    
    if(indexPath.row == 0){
        NSString *urlStr = [NSString stringWithFormat:@"%@taxnews/public/introductionIOS.htm", SERVER_URL];
        YZWebViewController *introduceVC = [[YZWebViewController alloc] initWithURL:urlStr];
        introduceVC.title = @"功能介绍";
        [self.navigationController pushViewController:introduceVC animated:YES];
    }
    if(indexPath.row == 1){
        NSString *urlStr = @"https://itunes.apple.com/cn/lookup?id=1230863080";
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager POST:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSArray *results = [responseObject objectForKey:@"results"];
            if(results.count > 0){
                
                // 服务器版本号
                NSString *version = [[results objectAtIndex:0] objectForKey:@"version"];
                NSArray *serverVers = [version componentsSeparatedByString:@"."];
                // 应用程序介绍网址（用户升级跳转URL）
                //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/1230863080"]];
                NSString *trackViewUrl = [[results objectAtIndex:0] objectForKey:@"trackViewUrl"];
                
                // 当前版本号（本地）
                NSString *currentVersion = [Variable shareInstance].appVersion;
                NSArray *currentVers = [currentVersion componentsSeparatedByString:@"."];
                
                if ([serverVers[0] intValue] > [currentVers[0] intValue] || [serverVers[1] intValue] > [currentVers[1] intValue] || [serverVers[2] intValue] > [currentVers[2] intValue]) {
                    
                    [YZAlertView showAlertWith:self title:@"版本更新" message:[NSString stringWithFormat:@"发现新版本(%@)，是否更新",version] callbackBlock:^(NSInteger btnIndex) {
                        if (btnIndex == 1) {
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:trackViewUrl]];
                        }
                    } cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"更新", nil];
                }else{
                    [YZProgressHUD showHUDView:SELF_VIEW Mode:SHOWMODE Text:@"当前版本已是最新版本"];
                }
            }else{
                [YZProgressHUD showHUDView:SELF_VIEW Mode:SHOWMODE Text:@"当前版本已是最新版本"];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [YZProgressHUD showHUDView:SELF_VIEW Mode:SHOWMODE Text:@"版本检测失败，请稍后再试！"];
        }];
    }
    if(indexPath.row == 2){
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1230863080&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"]];
    }
}

@end
