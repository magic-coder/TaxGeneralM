/************************************************************
 Class    : MessageDetailViewController.m
 Describe : 消息内容展示明细界面
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-02-15
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "MessageDetailViewController.h"
#import "MessageDetailViewCell.h"
#import "MessageListUtil.h"
#import "MessageDetailUtil.h"
#import "YZRefreshHeader.h"

@interface MessageDetailViewController () <MessageDetailViewCellDelegate>

@property (nonatomic, strong) NSMutableArray *data;             // 消息数据内容列表
@property (nonatomic, assign) int pageNo;                       // 页码值
@property (nonatomic, assign) int totalPage;            // 最大页

@end

@implementation MessageDetailViewController

static NSString * const reuseIdentifier = @"messageDetailCell";
static int const pageSize = 5;

- (void)viewDidLoad {
    [super viewDidLoad];
        
    _data = [[NSMutableArray alloc] init];
    
    [self.view setBackgroundColor:DEFAULT_BACKGROUND_COLOR];
    [self.tableView setBackgroundColor:DEFAULT_BACKGROUND_COLOR];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    //self.tableView.showsVerticalScrollIndicator = NO;   // 去掉右侧滚动条
    
    [self.tableView registerClass:[MessageDetailViewCell class] forCellReuseIdentifier:reuseIdentifier];
    [self.tableView setSeparatorStyle: UITableViewCellSeparatorStyleNone];
    
    [self loadData];
}

#pragma mark - Table view data source数据源方法
#pragma mark 返回组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _data.count;
}
#pragma mark 返回每组条数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
#pragma mark 返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    [cell setMessageDetailModel:[_data objectAtIndex:indexPath.section]];
    cell.indexPath = indexPath;
    cell.delegate = self;
    return cell;
}

#pragma mark 返回行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageDetailModel *model = [_data objectAtIndex:indexPath.section];
    return model.cellHeight;
}

#pragma mark 返回头视图高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 36.0f;
    }else{
        return 0.01f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 36.0f;
}

#pragma mark 点击行触发点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    // 获取当前点击的cell
    MessageDetailViewCell *cell = (MessageDetailViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    NSString *url = cell.messageDetailModel.url;
    
    if(url.length > 0){
        BaseWebViewController *webVC = [[BaseWebViewController alloc] initWithURL:url];
        webVC.title = @"内容详情";
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

#pragma mark - <MessageDetailViewCellDelegate>菜单代理点击方法
- (void)msgDetailViewCellMenuClicked:(MessageDetailViewCell *)cell type:(MsgDetailViewCellMenuType)type{
    
    MessageDetailModel *model = cell.messageDetailModel;
    
    if(type == MsgDetailViewCellMenuTypeCalendar){
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSString *currentDate = [[[BaseHandleUtil shareInstance] getCurrentDate] substringWithRange:NSMakeRange(0, 10)];

        NSDate *startDate = [formatter dateFromString:[NSString stringWithFormat:@"%@ 09:00:00", currentDate]];
        NSDate *endDate = [formatter dateFromString:[NSString stringWithFormat:@"%@ 18:00:00", currentDate]];
        NSString *notes = @"";
        if(model.url.length > 0){
             notes = [NSString stringWithFormat:@"详细内容请点击：%@", model.url];
        }
        
        NSString *alarmStr = [NSString stringWithFormat:@"%lf", 60.0f * -5.0f * 1];// 设置提醒时间为5分钟前
        
        [[BaseHandleUtil shareInstance] createEventCalendarTitle:model.title location:model.content startDate:startDate endDate:endDate notes:(NSString *)notes allDay:NO alarmArray:@[alarmStr] block:^(NSString *msg) {
            if([msg isEqualToString:@"success"]){
                [YZAlertView showAlertWith:self title:@"提醒添加成功！" message:@"是否打开\"日历\"查看、编辑提醒事件？" callbackBlock:^(NSInteger btnIndex) {
                    if(btnIndex == 1){
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"calshow:"]];
                    }
                } cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"打开", nil];
            }else{
                [YZProgressHUD showHUDView:SELF_VIEW Mode:SHOWMODE Text:msg];
            }
        }];
    }
    if(type == MsgDetailViewCellMenuTypeCopy){
        UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard]; // 黏贴板
        NSString *pasteString = [NSString stringWithFormat:@"标题：%@", model.title];
        if(![model.user isEqualToString:@"系统推送"]){
            pasteString = [NSString stringWithFormat:@"%@\n推送人：%@", pasteString, model.user];
        }
        pasteString = [NSString stringWithFormat:@"%@\n时间：%@\n摘要：%@", pasteString, model.date, model.content];
        if(model.url.length > 0){
            pasteString = [NSString stringWithFormat:@"%@\n链接：%@", pasteString, model.url];
        }
        [pasteBoard setString:pasteString];
        DLog(@"Yan -> 复制内容结果为：%@", pasteString);
    }
    if(type == MsgDetailViewCellMenuTypeDelete){
        
        [YZActionSheet showActionSheetWithTitle:@"是否删除该条消息？" cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil handler:^(YZActionSheet *actionSheet, NSInteger index) {
            if(index == -1){
                [YZProgressHUD showHUDView:SELF_VIEW Mode:LOCKMODE Text:@"删除中..."];
                [[MessageDetailUtil shareInstance] deleteMsgWithUUID:cell.messageDetailModel.uuid success:^{
                    // 删除成功，重新获取数据
                    [[MessageListUtil shareInstance] loadMsgDataWithPageNo:1 pageSize:100 dataBlock:^(NSDictionary *dataDict) {
                        [YZProgressHUD hiddenHUDForView:SELF_VIEW];
                        // 移除本行
                        [_data removeObjectAtIndex:cell.indexPath.section];
                        [self.tableView reloadData];
                    } failed:^(NSString *error) {
                        [YZProgressHUD hiddenHUDForView:SELF_VIEW];
                        [YZProgressHUD showHUDView:SELF_VIEW Mode:SHOWMODE Text:error];
                    }];
                } failed:^(NSString *error) {
                    [YZProgressHUD hiddenHUDForView:SELF_VIEW];
                    [YZProgressHUD showHUDView:SELF_VIEW Mode:SHOWMODE Text:error];
                }];
            }
        }];
    }
}

#pragma mark - 加载数据
- (void)loadData{
    // 从服务器获取最新数据
    _pageNo = 1;
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:[NSNumber numberWithInt:_pageNo] forKey:@"pageNo"];
    [param setObject:[NSNumber numberWithInt:pageSize] forKey:@"pageSize"];
    [param setObject:_sourceCode forKey:@"sourcecode"];
    if(_pushOrgCode == nil){
        _pushOrgCode = @"";
    }
    [param setObject:_pushOrgCode forKey:@"swjgdm"];
    
    [YZProgressHUD showHUDView:SELF_VIEW Mode:LOCKMODE Text:@"加载中..."];
    [[MessageDetailUtil shareInstance] loadMsgDataWithParam:param dataBlock:^(NSDictionary *dataDict) {
        [YZProgressHUD hiddenHUDForView:SELF_VIEW];
        [self handleDataDict:dataDict];// 数据处理
        [self.tableView reloadData];
        [self reloadAfterMessage:NO];
        if(_totalPage > 1){
            // 设置下拉刷新
            self.tableView.mj_header = [YZRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        }
    } failed:^(NSString *error) {
        [YZProgressHUD hiddenHUDForView:SELF_VIEW];
        if([error isEqualToString:@"510"]){
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
            [YZProgressHUD showHUDView:SELF_VIEW Mode:SHOWMODE Text:error];
        }
        
    }];
}

#pragma mark - 加载更多方法
- (void)loadMoreData{
    _pageNo++;
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:[NSNumber numberWithInt:_pageNo] forKey:@"pageNo"];
    [param setObject:[NSNumber numberWithInt:pageSize] forKey:@"pageSize"];
    [param setObject:_sourceCode forKey:@"sourcecode"];
    [param setObject:_pushOrgCode forKey:@"swjgdm"];
    
    [[MessageDetailUtil shareInstance] loadMsgDataWithParam:param dataBlock:^(NSDictionary *dataDict) {
        // 加载结束
        [self.tableView.mj_header endRefreshing];
        if(_pageNo == _totalPage){
            self.tableView.mj_header = nil;
        }
        
        NSArray *results = [dataDict objectForKey:@"results"];
        // 逆序小日期在前大日期在后
        for(NSDictionary *dict in results){
            MessageDetailModel *model = [MessageDetailModel createWithDict:dict];
            [_data insertObject:model atIndex:0];
        }
        [self.tableView reloadData];
    } failed:^(NSString *error) {
        _pageNo--;
        // 加载结束
        [self.tableView.mj_header endRefreshing];
        [YZProgressHUD showHUDView:SELF_VIEW Mode:SHOWMODE Text:error];
    }];
}

#pragma mark - 处理数据
-(void)handleDataDict:(NSDictionary *)dict{
    _data = [[NSMutableArray alloc] init];
    
    _totalPage = [[dict objectForKey:@"totalPage"] intValue];
    
    NSArray *results = [dict objectForKey:@"results"];
    // 逆序小日期在前大日期在后
    for(int i = (int)results.count -1; i >= 0; i--){
        MessageDetailModel *model = [MessageDetailModel createWithDict:results[i]];
        [_data addObject:model];
    }
}

#pragma mark - 视图滚动到最底部
- (void)reloadAfterMessage:(BOOL)show {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.data.count > 0) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:self.data.count - 1];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:show];
        }
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
