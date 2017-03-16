//
//  AppViewController.m
//  TaxGeneral
//
//  Created by Apple on 2017/01/17.
//  Copyright © 2017年 Yanzheng. All rights reserved.
//

#import "AppViewController.h"
#import "BaseCollectionViewCell.h"
#import "LoginViewController.h"
#import "AppTopView.h"
#import "AppUtil.h"

#import "MessageDetailViewController.h"
#import "MapListViewController.h"
#import "MapViewController.h"
#import "QuestionViewController.h"
#import "TestWebViewController.h"

#import "AppEditViewController.h"

#import "BaseCollectionUtil.h"

@interface AppViewController () <UINavigationControllerDelegate, AppTopViewDelegate>

@property (nonatomic, assign) BOOL adjustStatus;// 调整状态
@property (nonatomic, strong) AppUtil *appUtil;

@end

@implementation AppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _appUtil = [[AppUtil alloc] init];
    
    // 设置导航控制器的代理为self
    self.navigationController.delegate = self;
    
    self.view.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    self.collectionView.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    
    self.collectionStyle = CollectionStyleNone;
    
    AppTopView *topView = [[AppTopView alloc] initWithFrame:CGRectMake(0.f, 0.f, WIDTH_SCREEN, 160.f)];
    topView.delegate = self;
    [self.view addSubview:topView];
    
    self.collectionView.frame = CGRectMake(0.f, 160.f-HEIGHT_STATUS, WIDTH_SCREEN, HEIGHT_SCREEN+HEIGHT_STATUS-160.f);
}

#pragma mark - 视图即将显示方法
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _adjustStatus = NO;// 初始化调整状态值
    
    if([self isLogin]){
        self.data = [_appUtil loadDataWithType:AppItemsTypeNone];
        if(self.data != nil){
            [self.collectionView reloadData];
        }else{
            [YZProgressHUD showHUDView:self.navigationController.view Mode:LOCKMODE Text:@"加载中..."];
            [_appUtil initDataWithType:AppItemsTypeNone dataBlock:^(NSMutableArray *dataArray) {
                [YZProgressHUD hiddenHUDForView:self.navigationController.view];
                self.data = dataArray;
                [self.collectionView reloadData];
            } failed:^(NSString *error) {
                [YZProgressHUD hiddenHUDForView:self.navigationController.view];
                [YZProgressHUD showHUDView:self.navigationController.view Mode:SHOWMODE Text:error];
            }];
        }
    }else{
        [self goToLogin];
    }
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
    NSString *url = SERVER_URL;
    
    if([cell.item.title isEqualToString:@"办税地图"]){
        viewController = [[MapListViewController alloc] init];
    }else{
        url = cell.item.url;
    }
    
    if(viewController != nil || url != nil){
        if(viewController == nil){
            viewController = [[BaseWebViewController alloc] initWithURL:url];
        }
        
        viewController.title = cell.titleLabel.text; // 设置标题
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

#pragma mark - <AppTopViewDelegate> 顶部视图中应用点击事件代理方法
- (void)appTopViewBtnClick:(UIButton *)sender{
    
    UIViewController *viewController= nil;
    
    if(sender.titleLabel.text == nil){// 进入应用管理器
        viewController = [[AppEditViewController alloc] init];
    }
    if([sender.titleLabel.text isEqualToString:@"通知公告"]){
        viewController = [[BaseWebViewController alloc] initWithURL:[NSString stringWithFormat:@"%@public/notice/index", SERVER_URL]];
    }
    if([sender.titleLabel.text isEqualToString:@"通讯录"]){
        viewController = [[BaseWebViewController alloc] initWithURL:[NSString stringWithFormat:@"%@litter/initLitter", SERVER_URL]];
    }
    if([sender.titleLabel.text isEqualToString:@"办税地图"]){
        viewController = [[MapListViewController alloc] init];
    }
    if([sender.titleLabel.text isEqualToString:@"常见问题"]){
        viewController = [[QuestionViewController alloc] init];
    }
    
    if(viewController != nil){
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
    BaseCollectionModelGroup *otherGroup = [self.data objectAtIndex:1];
    BaseCollectionModelGroup *allGroup = [[_appUtil loadDataWithType:AppItemsTypeEdit] objectAtIndex:1];
    
    NSMutableArray *mineData = [[NSMutableArray alloc] init];
    NSMutableArray *otherData = [[NSMutableArray alloc] init];
    NSMutableArray *allData = [[NSMutableArray alloc] init];
    
    // 我的应用数据
    int mine_ids = 1;
    for(BaseCollectionModelItem *mineItem in mineGroup.items){
        NSDictionary *mineDict = [NSDictionary dictionaryWithObjectsAndKeys: mineItem.no, @"appno", mineItem.title, @"appname", mineItem.webImg, @"appimage", mineItem.url, @"appurl", [NSString stringWithFormat:@"%d", mine_ids], @"userappsort", nil];
        [mineData addObject:mineDict];
        mine_ids++;
    }
    // 其他应用数据
    int other_ids = 1;
    for(BaseCollectionModelItem *otherItem in otherGroup.items){
        NSDictionary *otherDict = [NSDictionary dictionaryWithObjectsAndKeys: otherItem.no, @"appno", otherItem.title, @"appname", otherItem.webImg, @"appimage", otherItem.url, @"appurl", [NSString stringWithFormat:@"%d", other_ids], @"userappsort", nil];
        [otherData addObject:otherDict];
        other_ids++;
    }
    // 全部应用
    for(BaseCollectionModelItem *allItem in allGroup.items){
        NSDictionary *allDict = [NSDictionary dictionaryWithObjectsAndKeys: allItem.no, @"appno", allItem.title, @"appname", allItem.webImg, @"appimage", allItem.url, @"appurl", nil];
        [allData addObject:allDict];
    }
    
    DLog(@"mineData = %ld",mineData.count);
    DLog(@"otherData = %ld",otherData.count);
    DLog(@"allData = %ld",allData.count);
    
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:mineData, @"mineData", otherData, @"otherData", allData, @"allData", nil];
    
    [_appUtil writeNewAppData:dataDict];
}

#pragma mark - 判断是否登录，及跳转登录
#pragma mark 判断是否登录了
-(BOOL)isLogin{
    NSDictionary *userDict = [[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_SUCCESS];
    if(nil != userDict){
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
    BOOL isShowPage = [viewController isKindOfClass:[self class]] || [viewController isKindOfClass:[MapViewController class]];
    
    [self.navigationController setNavigationBarHidden:isShowPage animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
