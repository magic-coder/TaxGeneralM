/************************************************************
 Class    : AppViewController.m
 Describe : 应用列表界面
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-01-17
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "AppViewController.h"
#import "BaseCollectionViewCell.h"
#import "AppTopView.h"
#import "AppUtil.h"

#import "MessageDetailViewController.h"
#import "MapListViewController.h"
#import "MapViewController.h"
#import "QuestionViewController.h"
#import "TestWebViewController.h"

#import "AppSubViewController.h"
#import "AppEditViewController.h"
#import "AppSearchViewController.h"

@interface AppViewController () <UINavigationControllerDelegate, AppTopViewDelegate>

@property (nonatomic, strong) AppTopView *topView;
@property (nonatomic, strong) UIImageView *topLogoImageView;    // 顶部回弹logo视图
@property (nonatomic, assign) BOOL adjustStatus;                // 调整状态

@property (nonatomic, assign) double lastTimestamp;             // 上次时间戳
@property (nonatomic, assign) double currentTimestamp;          // 当前时间戳

@end

@implementation AppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 设置导航控制器的代理为self
    self.navigationController.delegate = self;
    
    self.view.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    self.collectionView.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    
    self.collectionStyle = CollectionStyleNone;
    
    _topView = [[AppTopView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, 160)];
    _topView.delegate = self;
    [self.view addSubview:_topView];
    
    self.collectionView.frame = CGRectMake(0.f, 160.f-HEIGHT_STATUS, WIDTH_SCREEN, HEIGHT_SCREEN+HEIGHT_STATUS-160.f);
    
}

#pragma mark - 视图即将显示方法
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _adjustStatus = NO;// 初始化调整状态值
    
    if([self isLogin]){
        self.data = [[AppUtil shareInstance] loadDataWithType:AppItemsTypeNone];
        if(self.data != nil){
            [self.collectionView reloadData];
        }else{
            [YZProgressHUD showHUDView:SELF_VIEW Mode:LOCKMODE Text:@"加载中..."];
            [[AppUtil shareInstance] initDataWithType:AppItemsTypeNone dataBlock:^(NSMutableArray *dataArray) {
                [YZProgressHUD hiddenHUDForView:SELF_VIEW];
                self.data = dataArray;
                [self.collectionView reloadData];
            } failed:^(NSString *error) {
                [YZProgressHUD hiddenHUDForView:SELF_VIEW];
                [YZProgressHUD showHUDView:SELF_VIEW Mode:SHOWMODE Text:error];
            }];
        }
    }else{
        [self goToLogin];
    }
}

#pragma mark - 视图已经显示
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //UIView *superView = self.tableView.subviews.firstObject;// tableView中使用
    UIView *superView = self.collectionView.superview.subviews.firstObject;// collectionView中使用
    [superView insertSubview:self.topLogoImageView atIndex:0];
    
    [self.topLogoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(180, 60));
        make.centerX.mas_equalTo(_topLogoImageView.superview);
        // 必须设置底部约束
        make.bottom.mas_equalTo(_topLogoImageView.superview).offset(-20);
    }];
}

#pragma mark - 视图即将销毁方法
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 是否有调整，若有调整则进行保存
    if(_adjustStatus){
        [self writeNewData];
    }
}

#pragma mark - <UICollectionDelegate>点击代理方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    /*
    BaseCordovaViewController *cordovaVC = [[BaseCordovaViewController alloc] init];
    NSString *cordovaPage = nil;
    cordovaVC.pagePath = cordovaPage;
    cordovaVC.currentTitle = cell.titleLabel.text;
    [self.navigationController pushViewController:cordovaVC animated:YES];
    */
    
    BaseCollectionViewCell *cell = (BaseCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    UIViewController *viewController = nil;
    
    if([cell.item.title isEqualToString:@"办税地图"]){
        viewController = [[MapListViewController alloc] init];
        
        viewController.title = cell.titleLabel.text; // 设置标题
        [self.navigationController pushViewController:viewController animated:YES];
    }else{
        NSString *url = cell.item.url;
        if(url == nil || url.length <= 0){
            int level = [cell.item.level intValue]+1;
            viewController = [[AppSubViewController alloc] initWithPno:cell.item.no level:[NSString stringWithFormat:@"%d", level]];
        }else{
            viewController = [[BaseWebViewController alloc] initWithURL:url];
        }
        
        viewController.title = cell.titleLabel.text; // 设置标题
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

#pragma mark - <AppTopViewDelegate> 顶部视图中应用点击事件代理方法
- (void)appTopViewBtnClick:(UIButton *)sender{
    
    UIViewController *viewController= nil;
    NSString *url = nil;
    
    if(sender.titleLabel.text == nil){
        if(sender.tag == 0){    // 进入应用管理器
            viewController = [[AppEditViewController alloc] init];
        }
        if(sender.tag == 1){    // 进入应用搜索
            [self.navigationController pushViewController:[[AppSearchViewController alloc] init] animated:NO];
        }
    }
    if([sender.titleLabel.text isEqualToString:@"通知公告"]){
        //url = [NSString stringWithFormat:@"%@public/notice/index", SERVER_URL];
        url = [NSString stringWithFormat:@"%@public/notice/10/1", SERVER_URL];
    }
    if([sender.titleLabel.text isEqualToString:@"通讯录"]){
        url = [NSString stringWithFormat:@"%@litter/initLitter", SERVER_URL];
    }
    if([sender.titleLabel.text isEqualToString:@"办税地图"]){
        viewController = [[MapListViewController alloc] init];
    }
    if([sender.titleLabel.text isEqualToString:@"常见问题"]){
        viewController = [[QuestionViewController alloc] init];
    }
    
    if(viewController != nil || url != nil){
        if(viewController == nil){
            viewController = [[BaseWebViewController alloc] initWithURL:url];
        }
        
        viewController.title = sender.titleLabel.text;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
}

#pragma mark - 长按移动方法
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(nonnull NSIndexPath *)sourceIndexPath toIndexPath:(nonnull NSIndexPath *)destinationIndexPath{
    
    BaseCollectionModelGroup *moveGroup = [self.data objectAtIndex:sourceIndexPath.section];
    BaseCollectionModelItem *item = [moveGroup itemAtIndex:sourceIndexPath.item];
    [moveGroup.items removeObjectAtIndex:sourceIndexPath.item];
    
    BaseCollectionModelGroup *insertGroup = [self.data objectAtIndex:destinationIndexPath.section];
    [insertGroup.items insertObject:item atIndex:destinationIndexPath.item];
    [self.collectionView reloadData];
    
    _adjustStatus = YES;// 调整后将调整状态设置为YES
}

#pragma mark - 将调整好的数据写入到本地文件
- (void)writeNewData{
    
    // 点击保存将数据写入SandBox覆盖以前数据
    BaseCollectionModelGroup *mineGroup = [self.data objectAtIndex:0];
    BaseCollectionModelGroup *otherGroup = nil;
    if(self.data.count > 1){
        otherGroup = [self.data objectAtIndex:1];
    }else{
        otherGroup = [[BaseCollectionModelGroup alloc] init];
        otherGroup.items = [[NSMutableArray alloc] init];
    }
    BaseCollectionModelGroup *allGroup = [[[AppUtil shareInstance] loadDataWithType:AppItemsTypeEdit] objectAtIndex:1];
    
    NSMutableArray *mineData = [[NSMutableArray alloc] init];
    NSMutableArray *otherData = [[NSMutableArray alloc] init];
    NSMutableArray *allData = [[NSMutableArray alloc] init];
    
    // 我的应用数据
    int mine_ids = 1;
    for(BaseCollectionModelItem *mineItem in mineGroup.items){
        NSDictionary *mineDict = [NSDictionary dictionaryWithObjectsAndKeys: mineItem.no, @"appno", mineItem.title, @"appname", mineItem.webImg, @"appimage", mineItem.url, @"appurl", [NSString stringWithFormat:@"%d", mine_ids], @"userappsort", @"1", @"apptype", mineItem.isNewApp ? @"Y" : @"N", @"isnewapp", nil];
        [mineData addObject:mineDict];
        mine_ids++;
    }
    // 其他应用数据
    int other_ids = 1;
    for(BaseCollectionModelItem *otherItem in otherGroup.items){
        NSDictionary *otherDict = [NSDictionary dictionaryWithObjectsAndKeys: otherItem.no, @"appno", otherItem.title, @"appname", otherItem.webImg, @"appimage", otherItem.url, @"appurl", [NSString stringWithFormat:@"%d", other_ids], @"userappsort", @"2", @"apptype", otherItem.isNewApp ? @"Y" : @"N", @"isnewapp", nil];
        [otherData addObject:otherDict];
        other_ids++;
    }
    // 全部应用
    for(BaseCollectionModelItem *allItem in allGroup.items){
        NSDictionary *allDict = [NSDictionary dictionaryWithObjectsAndKeys: allItem.no, @"appno", allItem.title, @"appname", allItem.webImg, @"appimage", allItem.url, @"appurl", allItem.isNewApp ? @"Y" : @"N", @"isnewapp", nil];
        [allData addObject:allDict];
    }
    
    DLog(@"mineData = %ld",mineData.count);
    DLog(@"otherData = %ld",otherData.count);
    DLog(@"allData = %ld",allData.count);
    
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:mineData, @"mineData", otherData, @"otherData", allData, @"allData", nil];
    
    [[AppUtil shareInstance] writeNewAppData:dataDict];
}

#pragma mark - 判断是否登录，及跳转登录
#pragma mark 判断是否登录了
-(BOOL)isLogin{
    
    // 计算上次刷新与当前时间戳
    NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970];
    _currentTimestamp = floor(timestamp);
    
    NSDictionary *userDict = [[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_SUCCESS];
    if(nil != userDict){
        if(_currentTimestamp - _lastTimestamp > 60.0f){ // 时间戳大于一分钟进行处理
            [[LoginUtil shareInstance] loginWithTokenSuccess:^{
                _lastTimestamp = _currentTimestamp;
            } failed:^(NSString *error) {
                _lastTimestamp = _currentTimestamp;
                [YZAlertView showAlertWith:self title:@"登录失效" message:@"您当前登录信息已失效，请重新登录！" callbackBlock:^(NSInteger btnIndex) {
                    // 注销方法
                    [YZProgressHUD showHUDView:SELF_VIEW Mode:LOCKMODE Text:@"注销中..."];
                    [[AccountUtil shareInstance] accountLogout:^{
                        DLog(@"用户注销成功");
                        [YZProgressHUD hiddenHUDForView:SELF_VIEW];
                        
                        LoginViewController *loginVC = [[LoginViewController alloc] init];
                        loginVC.isLogin = YES;
                        
                        // 水波纹动画效果
                        CATransition *animation = [CATransition animation];
                        animation.duration = 1.0f;
                        animation.timingFunction = UIViewAnimationCurveEaseInOut;
                        animation.type = @"rippleEffect";
                        //animation.type = kCATransitionMoveIn;
                        animation.subtype = kCATransitionFromTop;
                        [self.view.window.layer addAnimation:animation forKey:nil];
                        
                        [self presentViewController:loginVC animated:YES completion:nil];
                    } failed:^(NSString *error) {
                        DLog(@"用户注销失败，error=%@", error);
                        [YZProgressHUD hiddenHUDForView:SELF_VIEW];
                        [YZProgressHUD showHUDView:SELF_VIEW Mode:SHOWMODE Text:error];
                    }];
                } cancelButtonTitle:@"重新登录" destructiveButtonTitle:nil otherButtonTitles: nil];
            }];
        }
        return YES;
    }else{
        return NO;
    }
}

#pragma mark 跳转登录页面
-(void)goToLogin{
    
    CATransition *animation = [CATransition animation];
    animation.duration = 1.0f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"rippleEffect";
    //animation.type = kCATransitionMoveIn;
    animation.subtype = kCATransitionFromTop;
    [self.navigationController.tabBarController.view.window.layer addAnimation:animation forKey:nil];
    
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    loginVC.isLogin = YES;
    [self presentViewController:loginVC animated:YES completion:nil];
}

#pragma mark - <UINavigationControllerDelegate>代理方法（隐藏导航栏）
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    // 判断要显示的控制器是否是自己
    BOOL isShowPage = [viewController isKindOfClass:[self class]] || [viewController isKindOfClass:[MapViewController class]] || [viewController isKindOfClass:[AppSearchViewController class]];
    
    [self.navigationController setNavigationBarHidden:isShowPage animated:YES];
}

#pragma mark - 懒加载方法
#pragma mark 顶部logo视图
- (UIImageView *)topLogoImageView {
    if (!_topLogoImageView) {
        _topLogoImageView = [[UIImageView alloc] init];
        _topLogoImageView.image = [UIImage imageNamed:@"app_common_top_logo"];
        _topLogoImageView.contentMode = UIViewContentModeScaleAspectFit;
        _topLogoImageView.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    }
    return _topLogoImageView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
