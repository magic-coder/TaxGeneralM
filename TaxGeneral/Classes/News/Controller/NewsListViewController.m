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

#import "MessageListUtil.h"
#import "TouchIDViewController.h"
#import "WUGesturesUnlockViewController.h"

#import "SettingUtil.h"

@interface NewsListViewController () <MainTabBarControllerDelegate, NewsLoopViewDelegate, NSURLConnectionDataDelegate>

@property (nonatomic, strong) MainTabBarController *mainTabBarController;
@property (nonatomic, strong) NewsLoopView *loopView;
@property (nonatomic, strong) UILabel *hintLabel;       // 刷新顶部提示浮动标
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
    
    [self initializeHandle];
    
    _pageNo = 1;
    _newsUtil = [NewsUtil shareInstance];
    
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
    if(_totalPage <= 0){
        return;
    }
    
    NSDictionary *loopDict = [dataDict objectForKey:@"loopResult"];
    NSArray *titles = [loopDict objectForKey:@"titles"];
    NSArray *images = [loopDict objectForKey:@"images"];
    NSArray *urls = [loopDict objectForKey:@"urls"];
    if(_loopView == nil){
        _loopView = [[NewsLoopView alloc] initWithFrame:CGRectMake(0, 0, self.view.frameWidth, self.view.frameWidth/1.8) titles:titles images:images urls:urls autoPlay:YES delay:10.0];
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
    [self.hintLabel removeFromSuperview];
    //self.tableView.userInteractionEnabled = NO;// 不允许点击
    [_newsUtil initDataWithPageSize:pageSize dataBlock:^(NSDictionary *dataDict) {
        
        //self.tableView.userInteractionEnabled = YES;// 允许点击
        
        _refreshCount = pageSize;
        _tempData = [NSMutableArray arrayWithArray:_data];
        _data = [[NSMutableArray alloc] init];
        
        _pageNo = 1;
        _totalPage = [[dataDict objectForKey:@"totalPage"] intValue];
        if(_totalPage <= 0){
            // 结束刷新
            [self.tableView.mj_header endRefreshing];
            return;
        }
        
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
        
        if([[[BaseHandleUtil shareInstance] getCurrentVC] isKindOfClass:self.class]){
            [self showNewStatusesCount:_refreshCount];
        }
        
        [self.tableView reloadData];
        
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
        
        // 设置上拉加载
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        
        [self.tableView.mj_footer resetNoMoreData];
        
    } failed:^(NSString *error) {
        self.tableView.userInteractionEnabled = YES;// 允许点击
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
        
        [YZProgressHUD showHUDView:SELF_VIEW Mode:SHOWMODE Text:error];
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
        [YZProgressHUD showHUDView:SELF_VIEW Mode:SHOWMODE Text:error];
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
    
    YZWebViewController *webVC = [[YZWebViewController alloc] initWithURL:cell.newsModel.url];
    webVC.title = @"税闻详情";
    [self.navigationController pushViewController:webVC animated:YES];
    
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
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - 顶部loop的点击代理方法
- (void)loopViewDidSelectedImage:(NewsLoopView *)loopView index:(int)index{
    DLog(@"Yan -> 点击了第%d个loop视图，其中标题为：%@", index, [loopView.urls objectAtIndex:index]);
    YZWebViewController *webVC = [[YZWebViewController alloc] initWithURL:[loopView.urls objectAtIndex:index]];
    webVC.title = @"税闻详情";
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark - 展示更新条数（浮动提示层）
- (void)showNewStatusesCount:(int)count{
    
    [self.hintLabel removeFromSuperview];
    
    // 1.创建一个UILabel
    //UILabel *label = [[UILabel alloc] init];
    
    // 2.显示文字
    if (count) {
        self.hintLabel.text = [NSString stringWithFormat:@"更新了%d条税闻", count];
    } else {
        self.hintLabel.text = @"没有最新的税闻";
    }
    
    // 3.设置背景
    self.hintLabel.backgroundColor = WBColor(242.0, 162.0, 46.0, 1.0f);
    self.hintLabel.textAlignment = NSTextAlignmentCenter;
    self.hintLabel.textColor = [UIColor whiteColor];
    self.hintLabel.font = [UIFont systemFontOfSize:14.0f];
    
    // 4.设置frame
    self.hintLabel.frame = CGRectMake(0, HEIGHT_STATUS+HEIGHT_NAVBAR-30, WIDTH_SCREEN, 30);
    
    // 5.添加到导航控制器的view
    //    [self.navigationController.view addSubview:label];
    [self.navigationController.view insertSubview:self.hintLabel belowSubview:self.navigationController.navigationBar];
    
    // 6.动画
    CGFloat duration = 0.75;
    self.hintLabel.alpha = 0.0;
    [UIView animateWithDuration:duration animations:^{
        // 往下移动一个label的高度
        self.hintLabel.transform = CGAffineTransformMakeTranslation(0, 30);
        self.hintLabel.alpha = 1.0;
    } completion:^(BOOL finished) { // 向下移动完毕
        // 延迟delay秒后，再执行动画
        CGFloat delay = 1.0;
        [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
            // 恢复到原来的位置
            self.hintLabel.transform = CGAffineTransformIdentity;
            self.hintLabel.alpha = 0.0;
        } completion:^(BOOL finished) {
            // 删除控件
            [self.hintLabel removeFromSuperview];
        }];
    }];
}

- (UILabel *)hintLabel{
    if(_hintLabel == nil){
        _hintLabel = [[UILabel alloc] init];
    }
    return _hintLabel;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.hintLabel removeFromSuperview];
    self.hintLabel = nil;
}

#pragma mark - 初始化处理
- (void)initializeHandle{
    // 设置代理方法
    _mainTabBarController = (MainTabBarController *)self.tabBarController;
    _mainTabBarController.customDelegate = self;
    
    // 校验用户是否开启了指纹、手势密码，并进行相应跳转
    // 获取单例模式中的用户信息自动登录
    NSDictionary *userDict = [[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_SUCCESS];
    if(nil != userDict){
        // 获取首次加载标志
        NSString *isLoad = [[NSUserDefaults standardUserDefaults] stringForKey:LOAD_FINISH];
        if(isLoad){
            NSDictionary *settingDict = [[SettingUtil shareInstance] loadSettingData];
            if([[settingDict objectForKey:@"touchID"] boolValue]){  // 指纹解锁
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:LOAD_FINISH];// 删除首次加载信息
                TouchIDViewController *touchIDVC = [[TouchIDViewController alloc] init];
                [_mainTabBarController presentViewController:touchIDVC animated:NO completion:nil];
            }else{
                NSString *gesturePwd = [[NSUserDefaults standardUserDefaults] objectForKey:GESTURES_PASSWORD];
                if(gesturePwd.length > 0){  // 手势验证解锁
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:LOAD_FINISH];// 删除首次加载信息
                    WUGesturesUnlockViewController *gesturesUnlockVC = [[WUGesturesUnlockViewController alloc] initWithUnlockType:WUUnlockTypeLoginPwd];
                    [_mainTabBarController presentViewController:gesturesUnlockVC animated:NO completion:nil];
                }
            }
        }
    }
    
    // 效验应用版本是否可更新
    NSString *urlStr = @"https://itunes.apple.com//lookup?id=1230863080";
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:req delegate:self];
}

#pragma mark - <NSURLConnectionDataDelegate>代理方法
- (void)connection:(NSURLConnection *)connection didReceiveData:(nonnull NSData *)data{
    NSError *error; //解析
    NSDictionary *appInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    NSArray *results = [appInfo objectForKey:@"results"];
    if(results.count > 0){
        // 最新版本号
        NSString *version = [[results objectAtIndex:0] objectForKey:@"version"];
        // 应用程序介绍网址（用户升级跳转URL）
        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/1230863080"]];
        NSString *trackViewUrl = [[results objectAtIndex:0] objectForKey:@"trackViewUrl"];
        
        // 当前版本号
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
        
        if (![version isEqualToString:currentVersion]) {
            [YZAlertView showAlertWith:self title:@"版本更新" message:[NSString stringWithFormat:@"发现新版本(%@),是否升级",version] callbackBlock:^(NSInteger btnIndex) {
                if (btnIndex == 1) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:trackViewUrl]];
                }
            } cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"升级", nil];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
