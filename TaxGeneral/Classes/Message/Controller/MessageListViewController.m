/************************************************************
 Class    : MessageListViewController.m
 Describe : 消息列表界面
 Company  : Prient
 Author   : Yanzheng
 Date     : 2016-08-15
 Version  : 1.0
 Declare  : Copyright © 2016 Yanzheng. All rights reserved.
 ************************************************************/

#import "MessageListViewController.h"
#import "MessageListViewCell.h"
#import "MessageListUtil.h"
#import "MJRefresh.h"

#import "ChatViewController.h"
#import "MessageDetailViewController.h"

/*
#pragma mark - 3DTouch需实现代理方法
@interface MessageListViewController ()<UIViewControllerPreviewingDelegate>
*/
@interface MessageListViewController ()

@property (nonatomic, strong) NSMutableArray *data;             // 消息列表数据
@property (nonatomic, strong) UIImageView *topLogoImageView;    // 顶部回弹logo视图
@property (nonatomic, assign) int pageNo;                       // 页码值

@end

@implementation MessageListViewController

static NSString * const reuseIdentifier = @"messageListCell";
static int const pageSize = 100;

- (void)viewDidLoad {
    [super viewDidLoad];
    _data = [[NSMutableArray alloc] init];
    
    [self.view setBackgroundColor:DEFAULT_BACKGROUND_COLOR];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    
    [self.tableView registerClass:[MessageListViewCell class] forCellReuseIdentifier:reuseIdentifier];
    [self.tableView setSeparatorStyle: UITableViewCellSeparatorStyleNone];
    
    self.title = @"消息";
    
    // 判断是否登录，若没登录则返回登录页面
    if([self isLogin]){
        [self autoLoadData];
    }else{
        [self goToLogin];
    }
}

#pragma mark - 视图即将显示时调用
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //BOOL isRefresh = [Variable shareInstance].msgRefresh;
    
    // 判断是否登录，若没登录则返回登录页面
    if([self isLogin]){
        // 先判断角标
        UITabBarItem * item = [self.tabBarController.tabBar.items objectAtIndex:2];
        
        if([item.badgeValue intValue] != [Variable shareInstance].unReadCount || ![self.navigationItem.title isEqualToString:@"消息"]){
            [self autoLoadData];
            //[Variable shareInstance].msgRefresh = NO;
            //item.badgeValue = nil;
        }else{
            NSDictionary *dataDict = [[MessageListUtil shareInstance] loadMsgDataWithFile];
            if(dataDict != nil){
                [self handleDataDict:dataDict];// 数据处理
            }else{
                [self autoLoadData];
            }
        }
        [self.tableView reloadData];
    }else{
        [self goToLogin];
    }
}

#pragma mark - 视图已经显示方法
#pragma mark 用于下拉展示顶部logo视图
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    UIView *superView = self.tableView.subviews.firstObject;// tableView中使用
    //UIView *superView = self.collectionView.superview.subviews.firstObject;// collectionView中使用
    [superView insertSubview:self.topLogoImageView atIndex:0];
    
    [self.topLogoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.centerX.mas_equalTo(_topLogoImageView.superview);
        // 必须设置底部约束
        make.bottom.mas_equalTo(_topLogoImageView.superview).offset(-20);
    }];
}

#pragma mark - Table view data source数据源方法
#pragma mark 返回组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _data.count;
}

#pragma mark 返回每组条数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = [_data objectAtIndex:section];
    return array.count;
}

#pragma mark 返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    NSArray *array = [_data objectAtIndex:indexPath.section];
    [cell setMessageListModel:[array objectAtIndex:indexPath.row]];
    indexPath.row == 0 ? [cell setTopLineStyle:CellLineStyleFill] : [cell setTopLineStyle:CellLineStyleNone];
    indexPath.row == array.count - 1 ? [cell setBottomLineStyle:CellLineStyleFill] : [cell setBottomLineStyle:CellLineStyleDefault];
    /*
    if(self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable){
        // 给cell注册3DTouch的peek（预览）和pop功能
        [self registerForPreviewingWithDelegate:self sourceView:cell];
    }
     */
    return cell;
}

#pragma mark - <UITableViewDelegate>代理方法
#pragma mark 每行是否可以进行编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
    if(indexPath.section == 0){
        return NO;
    }
    */
    return YES;
}

#pragma mark 编辑显示的标题
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

#pragma mark 点击删除按钮执行的操作
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        MessageListViewCell *cell = (MessageListViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        NSString *sourceCode = cell.messageListModel.sourceCode;
        NSString *pushOrgCode = cell.messageListModel.pushOrgCode;
        if(pushOrgCode == nil){
            pushOrgCode = @"";
        }
        [YZProgressHUD showHUDView:SELF_VIEW Mode:LOCKMODE Text:@"删除中..."];
        [[MessageListUtil shareInstance] deleteMsgWithSourceCode:sourceCode pushOrgCode:pushOrgCode success:^{
            [YZProgressHUD hiddenHUDForView:SELF_VIEW];
            // 删除成功，重新加载数据
            [[MessageListUtil shareInstance] loadMsgDataWithPageNo:_pageNo pageSize:pageSize dataBlock:^(NSDictionary *dataDict) {
            } failed:^(NSString *error) {
            }];
            // 移除本行
            [[_data objectAtIndex:indexPath.section] removeObjectAtIndex:indexPath.row];
            [tableView reloadData];
            // 设置角标
            [[BaseHandleUtil shareInstance] setBadge:[Variable shareInstance].unReadCount - [cell.messageListModel.unReadCount intValue]];
            
        } failed:^(NSString *error) {
            [YZProgressHUD hiddenHUDForView:SELF_VIEW];
            [YZProgressHUD showHUDView:SELF_VIEW Mode:SHOWMODE Text:error];
        }];
        
    }
}

#pragma mark 返回行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 63;
}

#pragma mark 返回头视图高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}

#pragma mark 点击行触发点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    /*
    ChatViewController *chatViewController = [[ChatViewController alloc] init];
    [self.navigationController pushViewController:chatViewController animated:YES];
     */
    
    MessageDetailViewController *messageDetailVC = [[MessageDetailViewController alloc] init];
    [self.navigationController pushViewController:messageDetailVC animated:YES];
    
    // 获取当前点击的cell
    MessageListViewCell *cell = (MessageListViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    if([cell.messageListModel.unReadCount intValue] > 0){
        NSDictionary *dataDict = [[MessageListUtil shareInstance] loadMsgDataWithFile];
        
        NSArray *results = [dataDict objectForKey:@"results"];
        NSMutableArray *mutableResults = [[NSMutableArray alloc] init];
        
        for(NSDictionary *dict in results){
            NSString *sourceCode = [dict objectForKey:@"sourcecode"];
            NSString *pushOrgCode = [dict objectForKey:@"swjgdm"];
            if(pushOrgCode == nil){
                pushOrgCode = @"";
            }
            if(cell.messageListModel.pushOrgCode == nil){
                cell.messageListModel.pushOrgCode = @"";
            }
            
            if([sourceCode isEqualToString:cell.messageListModel.sourceCode] && [pushOrgCode isEqualToString:cell.messageListModel.pushOrgCode]){
                NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:dict];
                [mutableDict setObject:@"0" forKey:@"unreadcount"];
                [mutableResults addObject:mutableDict];
            }else{
                [mutableResults addObject:dict];
            }
            
        }
        
        NSDictionary *resDict = [NSDictionary dictionaryWithObjectsAndKeys: mutableResults, @"results", nil];
        // 写入本地缓存（SandBox）
        [[BaseSandBoxUtil shareInstance] writeData:resDict fileName:@"msgData.plist"];
    }
    
    messageDetailVC.title = cell.messageListModel.name; // 设置详细视图标题
    
    messageDetailVC.sourceCode = cell.messageListModel.sourceCode;
    messageDetailVC.pushOrgCode = cell.messageListModel.pushOrgCode;
    
}

/*
#pragma mark - 3D Touch 代理方法
#pragma mark 视图peek(预览)
-(UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location{
    // 获取按压的cell所在行，[previewingContext sourceView]就是按压的那个视图
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(MessageListViewCell *)[previewingContext sourceView]];
    MessageListViewCell *cell = (MessageListViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    // 设定预览界面
    ChatViewController *chatViewController = [[ChatViewController alloc] init];
    chatViewController.preferredContentSize = CGSizeMake(0.0f,600.f);
    chatViewController.title = cell.messageListModel.name;  // 设置标题
    // 调整不被虚化的范围，按压的那个cell不被虚化（轻轻按压时周边会被虚化，再少用力展示预览，再加力跳页至设定界面）
    //CGRect rect = CGRectMake(0, 0, self.view.frame.size.width,40);
    //previewingContext.sourceRect = rect;
    
    return chatViewController;  // 返回预览界面
}

#pragma mark 视图pop用力按压进入
-(void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit{
    [self showViewController:viewControllerToCommit sender:self];
}
*/

#pragma mark - 加载数据
-(void)autoLoadData{
    
    // 计算上次刷新与当前时间戳
    //NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970];
    //_currentTimestamp = floor(timestamp);
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(WIDTH_SCREEN/2-80, HEIGHT_NAVBAR/2-20, 160, 40)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, 80, 30)];
    titleLabel.text = @"收取中...";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    loading.center = CGPointMake(-8, 15);
    [loading startAnimating];
    
    [titleView addSubview:titleLabel];
    [titleLabel addSubview:loading];
    
    self.navigationItem.titleView = titleView;
    _pageNo = 1;
    [[MessageListUtil shareInstance] loadMsgDataWithPageNo:_pageNo pageSize:pageSize dataBlock:^(NSDictionary *dataDict) {
        [self handleDataDict:dataDict];// 数据处理
        
        self.navigationItem.titleView = nil;
        self.navigationItem.title = @"消息";
        [self.tableView reloadData];
    } failed:^(NSString *error) {
        if([error isEqualToString:@"510"]){
            self.navigationItem.titleView = nil;
            self.navigationItem.title = @"未登录";
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
        }else{
            self.navigationItem.titleView = nil;
            self.navigationItem.title = @"未连接";
            [YZProgressHUD showHUDView:SELF_VIEW Mode:SHOWMODE Text:error];
        }
    }];
}

#pragma mark - 处理数据
-(void)handleDataDict:(NSDictionary *)dict{
    _data = [[NSMutableArray alloc] init];
    
    NSArray *results = [dict objectForKey:@"results"];
    NSMutableArray *sysData = [[NSMutableArray alloc] init];
    NSMutableArray *userData = [[NSMutableArray alloc] init];
    int badge = 0;
    for(NSDictionary *dict in results){
        MessageListModel *model = [MessageListModel createWithDict:dict];
        if(![model.sourceCode isEqualToString:@"01"]){
            [sysData addObject:model];
        }else{
            [userData addObject:model];
        }
        
        badge += [model.unReadCount intValue];
    }
    [Variable shareInstance].unReadCount = badge;
    [[BaseHandleUtil shareInstance] setBadge:badge];// 设置提醒角标
    
    [_data addObject:sysData];
    [_data addObject:userData];
    
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

#pragma mark - 懒加载方法
#pragma mark 顶部logo视图
- (UIImageView *)topLogoImageView {
    if (!_topLogoImageView) {
        _topLogoImageView = [[UIImageView alloc] init];
        _topLogoImageView.image = [UIImage imageNamed:@"msg_top_logo"];
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
