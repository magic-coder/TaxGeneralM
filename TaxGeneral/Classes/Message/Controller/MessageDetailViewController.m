//
//  MessageDetailViewController.m
//  TaxGeneralM
//
//  Created by Apple on 2017/2/15.
//  Copyright © 2017年 Yanzheng. All rights reserved.
//

#import "MessageDetailViewController.h"
#import "MessageDetailViewCell.h"
#import "MessageDetailUtil.h"
#import "YZRefreshHeader.h"

@interface MessageDetailViewController () <MessageDetailViewCellDelegate>

@property (nonatomic, strong) NSMutableArray *data;             // 消息数据内容列表
@property (nonatomic, assign) int pageNo;                       // 页码值
@property (nonatomic, strong) MessageDetailUtil *msgDetailUtil;

@end

@implementation MessageDetailViewController

static NSString * const reuseIdentifier = @"messageDetailCell";
static int const pageSize = 10;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [Variable shareInstance].msgRefresh = YES;
    
    _data = [[NSMutableArray alloc] init];
    _msgDetailUtil = [[MessageDetailUtil alloc] init];
    
    [self.view setBackgroundColor:DEFAULT_BACKGROUND_COLOR];
    [self.tableView setBackgroundColor:DEFAULT_BACKGROUND_COLOR];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    //self.tableView.showsVerticalScrollIndicator = NO;   // 去掉右侧滚动条
    
    [self.tableView registerClass:[MessageDetailViewCell class] forCellReuseIdentifier:reuseIdentifier];
    [self.tableView setSeparatorStyle: UITableViewCellSeparatorStyleNone];
    
    [self loadData];
    
    if(_totalPage > 1){
        // 设置下拉刷新
        self.tableView.mj_header = [YZRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    }
    
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
    
    if(type == MsgDetailViewCellMenuTypeCopy){
        UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard]; // 黏贴板
        NSString *pasteString = [NSString stringWithFormat:@"标题：%@\n时间：%@\n摘要：%@", model.title, model.date, model.content];
        if(model.url.length > 0){
            pasteString = [NSString stringWithFormat:@"%@\n链接：%@", pasteString, model.url];
        }
        [pasteBoard setString:pasteString];
        DLog(@"Yan -> 复制内容结果为：%@", pasteString);
    }
    if(type == MsgDetailViewCellMenuTypeDelete){
        [_data removeObjectAtIndex:cell.indexPath.row];
        [self.tableView reloadData];
    }
}

#pragma mark - 加载数据
- (void)loadData{
    // 从服务器获取最新数据
    _pageNo = _totalPage;
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:[NSNumber numberWithInt:_pageNo] forKey:@"pageNo"];
    [param setObject:[NSNumber numberWithInt:pageSize] forKey:@"pageSize"];
    [param setObject:_sourceCode forKey:@"sourcecode"];
    [param setObject:_pushUserCode forKey:@"pushusercode"];
    
    [_msgDetailUtil loadMsgDataWithParam:param dataBlock:^(NSDictionary *dataDict) {
        [self handleDataDict:dataDict];// 数据处理
        [self.tableView reloadData];
        [self reloadAfterMessage:NO];
    } failed:^(NSString *error) {
        [YZProgressHUD showHUDView:self.navigationController.view Mode:SHOWMODE Text:error];
    }];
}

#pragma mark - 加载更多方法
- (void)loadMoreData{
    _pageNo--;
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:[NSNumber numberWithInt:_pageNo] forKey:@"pageNo"];
    [param setObject:[NSNumber numberWithInt:pageSize] forKey:@"pageSize"];
    [param setObject:_sourceCode forKey:@"sourcecode"];
    [param setObject:_pushUserCode forKey:@"pushusercode"];
    
    [_msgDetailUtil loadMsgDataWithParam:param dataBlock:^(NSDictionary *dataDict) {
        // 加载结束
        [self.tableView.mj_header endRefreshing];
        if(_pageNo == 1){
            self.tableView.mj_header = nil;
        }
        
        NSArray *results = [dataDict objectForKey:@"results"];
        // 逆序小日期在前大日期在后
        for(int i = (int)results.count - 1; i >= 0 ; i-- ){
            MessageDetailModel *model = [MessageDetailModel createWithDict:results[i]];
            [_data insertObject:model atIndex:0];
        }
        [self.tableView reloadData];
    } failed:^(NSString *error) {
        _pageNo++;
        // 加载结束
        [self.tableView.mj_header endRefreshing];
        [YZProgressHUD showHUDView:self.navigationController.view Mode:SHOWMODE Text:error];
    }];
}

#pragma mark - 处理数据
-(void)handleDataDict:(NSDictionary *)dict{
    _data = [[NSMutableArray alloc] init];
    
    NSArray *results = [dict objectForKey:@"results"];
    
    for(NSDictionary *dict in results){
        MessageDetailModel *model = [MessageDetailModel createWithDict:dict];
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
