/************************************************************
 Class    : NewsViewController.m
 Describe : 税闻列表界面
 Company  : Prient
 Author   : Yanzheng
 Date     : 2016-12-01
 Version  : 1.0
 Declare  : Copyright © 2016 Yanzheng. All rights reserved.
 ************************************************************/

#import "NewsListViewController.h"
#import "NewsTableViewCell.h"
#import "NewsLoopView.h"
#import "NewsModel.h"
#import "NewsUtil.h"
#import "MJRefresh.h"

#import "MainTabBarController.h"

@interface NewsListViewController () <MainTabBarControllerDelegate, NewsLoopViewDelegate>

@property (nonatomic, strong) NewsLoopView *loopView;
@property (nonatomic, strong) NSMutableArray *data;     // 数据列表
@property (nonatomic, strong) NSMutableArray *tempData; // 临时数据列表
@property (nonatomic, assign) int pageNo;               // 页码值
@property (nonatomic, assign) int totalPage;            // 最大页
@property (nonatomic, assign) int refreshCount;         // 刷新条数
@property (nonatomic, strong) NewsUtil *newsUtil;

@end

@implementation NewsListViewController

static NSString * const reuseIdentifier = @"newsTableViewCell";
static int const pageSize = 10;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _pageNo = 1;
    _newsUtil = [[NewsUtil alloc] init];
    
    MainTabBarController *mainTabBarController = (MainTabBarController *)self.tabBarController;
    mainTabBarController.customDelegate = self;
    
    self.tableView.rowHeight = 80;
    
    self.view.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    self.tableView.backgroundColor = [UIColor whiteColor];
    //self.tableView.showsVerticalScrollIndicator = NO;// 隐藏纵向滚动条
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;// 自定义cell样式
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];// 去除底部多余分割线
    
    // 设置下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    // 获取数据
    NSMutableDictionary *dataDict = [_newsUtil loadData];
    if(dataDict != nil){
        [self handleDataDict:dataDict];// sandBox存在则进行处理加工数据
    }else{
        [self.tableView.mj_header beginRefreshing];// 进行查询数据
    }
}

#pragma mark - 处理数据
- (void)handleDataDict:(NSMutableDictionary *)dataDict{
    _data = [[NSMutableArray alloc] init];
    
    _totalPage = [[dataDict objectForKey:@"totalPage"] intValue];
    
    NSDictionary *loopDict = [dataDict objectForKey:@"loopResult"];
    NSArray *titles = [loopDict objectForKey:@"titles"];
    NSArray *images = [loopDict objectForKey:@"images"];
    NSArray *urls = [loopDict objectForKey:@"urls"];
    if(_loopView == nil){
        _loopView = [[NewsLoopView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width/1.8) titles:titles images:images urls:urls autoPlay:YES delay:10.0];
    }else{
        _loopView.titles = titles;
        _loopView.images = images;
        _loopView.urls = urls;
    }
    _loopView.delegate = self;
    self.tableView.tableHeaderView = _loopView;
    
    NSArray *newsData = [dataDict objectForKey:@"newsResult"];
    for(NSDictionary *newsDict in newsData){
        NewsModel *model = [NewsModel createWithDict:newsDict];
        [_data addObject:model];
    }
    
    [self.tableView reloadData];
    
    // 设置上拉加载
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

#pragma mark - 下拉刷新数据
- (void)loadNewData{
    
    [_newsUtil initDataWithPageSize:pageSize dataBlock:^(NSDictionary *dataDict) {
        
        _refreshCount = pageSize;
        _tempData = [NSMutableArray arrayWithArray:_data];
        _data = [[NSMutableArray alloc] init];
        
        _pageNo = 1;
        _totalPage = [[dataDict objectForKey:@"totalPage"] intValue];
        
        NSDictionary *loopDict = [dataDict objectForKey:@"loopResult"];
        NSArray *titles = [loopDict objectForKey:@"titles"];
        NSArray *images = [loopDict objectForKey:@"images"];
        NSArray *urls = [loopDict objectForKey:@"urls"];
        if(_loopView == nil){
            _loopView = [[NewsLoopView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width/1.8) titles:titles images:images urls:urls autoPlay:YES delay:10.0];
        }else{
            _loopView.titles = titles;
            _loopView.images = images;
            _loopView.urls = urls;
        }
        _loopView.delegate = self;
        self.tableView.tableHeaderView = _loopView;
        
        NSArray *newsData = [dataDict objectForKey:@"newsResult"];
        for(NSDictionary *newsDict in newsData){
            NewsModel *model = [NewsModel createWithDict:newsDict];
            [_data addObject:model];
            
            for(NewsModel *nm in _tempData){
                if([nm.title isEqualToString:model.title]){
                    _refreshCount--;
                }
            }
        }
        
        [self showNewStatusesCount:_refreshCount];
        
        [self.tableView reloadData];
        
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
        
        // 设置上拉加载
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        
        [self.tableView.mj_footer resetNoMoreData];
    } failed:^(NSString *error) {
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
        
        [YZProgressHUD showHUDView:NAV_VIEW Mode:SHOWMODE Text:error];
    }];
}

#pragma mark - 上拉加载更多
- (void)loadMoreData{
    _pageNo++;
    
    [_newsUtil moreDataWithPageNo:+_pageNo pageSize:pageSize dataBlock:^(NSArray *dataArray) {
        for(NSDictionary *dataDict in dataArray){
            NewsModel *model = [NewsModel createWithDict:dataDict];
            [_data addObject:model];
            
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            
            if(_pageNo < _totalPage){
                // 结束刷新
                [self.tableView.mj_footer endRefreshing];
            }else{
                // 拿到当前的上拉刷新控件，变为没有更多数据的状态
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
    } failed:^(NSString *error) {
        _pageNo--;
        [self.tableView.mj_footer resetNoMoreData];
        [YZProgressHUD showHUDView:NAV_VIEW Mode:SHOWMODE Text:error];
    }];
}

#pragma mark - Table view data source
#pragma mark 数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 1.缓存中取
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    // 2.创建
    if (cell == nil) {
        cell = [[NewsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    // 3.设置数据
    cell.newsModel = [_data objectAtIndex:indexPath.row];
    // 4.返回cell
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 点击后将颜色变回来
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DLog(@"Yan -> 点击了第%ld个", indexPath.row);
    NewsTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    DLog(@"Yan -> 标题为：%@", cell.newsModel.title);
    
    BaseWebViewController *baseWebVC = [[BaseWebViewController alloc] initWithURL:cell.newsModel.url];
    baseWebVC.title = @"税闻详情";
    baseWebVC.useWKWebView = YES;
    [self.navigationController pushViewController:baseWebVC animated:YES];
    
}

// 设置cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsModel *model = [_data objectAtIndex:indexPath.row];
    if(model.cellHeight > 0){
        return model.cellHeight;
    }
    return 0;
}

#pragma mark - <MainTabBarControllerDelegate> 代理方法刷新数据
- (void)autoRefreshData{
    // 先清除角标
    UITabBarItem * item = [self.tabBarController.tabBar.items objectAtIndex:0];
    item.badgeValue = nil;
    
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - 顶部loop的点击代理方法
- (void)loopViewDidSelectedImage:(NewsLoopView *)loopView index:(int)index{
    DLog(@"Yan -> 点击了第%d个loop视图，其中标题为：%@", index, [loopView.urls objectAtIndex:index]);
    BaseWebViewController *baseWebVC = [[BaseWebViewController alloc] initWithURL:[loopView.urls objectAtIndex:index]];
    baseWebVC.title = @"税闻详情";
    [self.navigationController pushViewController:baseWebVC animated:YES];
}

#pragma mark - 展示更新条数（浮动提示层）
- (void)showNewStatusesCount:(int)count{
    
    // 1.创建一个UILabel
    UILabel *label = [[UILabel alloc] init];
    
    // 2.显示文字
    if (count) {
        label.text = [NSString stringWithFormat:@"更新了%d条税闻", count];
    } else {
        label.text = @"没有最新的税闻";
    }
    
    // 3.设置背景
    label.backgroundColor = WBColor(242.0, 162.0, 46.0, 1.0f);
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:14.0f];
    
    // 4.设置frame
    label.frame = CGRectMake(0, HEIGHT_STATUS+HEIGHT_NAVBAR-30, WIDTH_SCREEN, 30);
    
    // 5.添加到导航控制器的view
    //    [self.navigationController.view addSubview:label];
    [self.navigationController.view insertSubview:label belowSubview:self.navigationController.navigationBar];
    
    // 6.动画
    CGFloat duration = 0.75;
    label.alpha = 0.0;
    [UIView animateWithDuration:duration animations:^{
        // 往下移动一个label的高度
        label.transform = CGAffineTransformMakeTranslation(0, 30);
        label.alpha = 1.0;
    } completion:^(BOOL finished) { // 向下移动完毕
        // 延迟delay秒后，再执行动画
        CGFloat delay = 1.0;
        [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
            // 恢复到原来的位置
            label.transform = CGAffineTransformIdentity;
            label.alpha = 0.0;
        } completion:^(BOOL finished) {
            // 删除控件
            [label removeFromSuperview];
        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
