/************************************************************
 Class    : AppSearchViewController.m
 Describe : 应用搜索界面
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-05-16
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "AppSearchViewController.h"
#import "BaseTableView.h"
#import "AppSubViewController.h"
#import "AppSubViewCell.h"
#import "AppSubUtil.h"

@interface AppSearchViewController () <UITableViewDelegate, UITableViewDataSource, BaseTableViewDelegate>

@property (nonatomic, strong) BaseTableView *tableView;
@property (nonatomic, strong) NSMutableArray *data;

@property (nonatomic, strong) UITextField *searchTextField;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) NSMutableArray *results;   // 数据筛选结果

@end

@implementation AppSearchViewController

static NSString * const reuseIdentifier = @"appSubCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _tableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, HEIGHT_STATUS + HEIGHT_NAVBAR, WIDTH_SCREEN, HEIGHT_SCREEN - HEIGHT_NAVBAR - HEIGHT_STATUS) style:UITableViewStylePlain];
    _tableView.touchDelegate = self;
    _tableView.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[AppSubViewCell class] forCellReuseIdentifier:reuseIdentifier];
    [_tableView setSeparatorStyle: UITableViewCellSeparatorStyleNone];
    
    _searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 28, WIDTH_SCREEN - 15 - 60, 28)];
    _searchTextField.layer.cornerRadius = 5;
    _searchTextField.layer.borderWidth = .5;
    _searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _searchTextField.layer.borderColor = DEFAULT_LINE_GRAY_COLOR.CGColor;
    _searchTextField.font = [UIFont systemFontOfSize:15.0f];
    _searchTextField.placeholder = @"请输入应用名称";
    _searchTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetHeight(_searchTextField.frame), CGRectGetHeight(_searchTextField.frame))];
    _searchTextField.leftViewMode = UITextFieldViewModeAlways;
    UIImageView *imgSearch = [[UIImageView alloc] initWithFrame:CGRectMake(3, 3, 22, 22)];
    imgSearch.image = [UIImage imageNamed:@"app_common_search"];
    [_searchTextField.leftView addSubview:imgSearch];
    [_searchTextField addTarget:self action:@selector(searchApp:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_searchTextField];
    
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _cancelBtn.frame = CGRectMake(15 + (WIDTH_SCREEN - 15 - 60), 28, 60, 28);
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn addTarget:self action:@selector(cancelSearch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancelBtn];
    
    [_searchTextField becomeFirstResponder];    // 搜索输入框获取焦点
    
    _data = [[NSMutableArray alloc] init];
    _data = [[AppSubUtil shareInstance] loadSearchData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // 设置顶部状态栏字体为黑色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    // 设置顶部状态栏字体为白色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AppSubViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    AppSubModel *model = [_results objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell setModel:model];
    indexPath.row == 0 ? [cell setTopLineStyle:AppSubViewCellLineStyleFill] : [cell setTopLineStyle:AppSubViewCellLineStyleNone];
    indexPath.row == _results.count - 1 ? [cell setBottomLineStyle:AppSubViewCellLineStyleFill] : [cell setBottomLineStyle:AppSubViewCellLineStyleDefault];
    
    // 关键词高亮
    NSString *searchStr = [[_searchTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] uppercaseString];
    if(searchStr){
        NSRange range;
        NSArray *keyWordsArray = [model.keyWords componentsSeparatedByString:@" "];
        for(NSString *keyWords in keyWordsArray){
            range = [keyWords rangeOfString:searchStr];
            if(range.length > 0){
                NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:model.title];
                //NSRange range = [model.title rangeOfString:_searchTextField.text];
                [attr addAttribute:NSForegroundColorAttributeName value:DEFAULT_BLUE_COLOR range:range];
                cell.titleLabel.attributedText = attr;
                break;
            }
        }
    }
    
    return cell;
}

#pragma mark 返回行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 63.0f;
}

#pragma mark 点击行触发点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
    // 获取当前点击的cell
    AppSubViewCell *cell = (AppSubViewCell *)[_tableView cellForRowAtIndexPath:indexPath];
    
    DLog(@"%@%@", cell.model.pno,cell.model.no);
    
    UIViewController *viewController = nil;
    
    NSString *url = cell.model.url;
    if(url == nil || url.length <= 0){
        int level = [cell.model.level intValue]+1;
        viewController = [[AppSubViewController alloc] initWithPno:cell.model.no level:[NSString stringWithFormat:@"%d", level]];
    }else{
        viewController = [[BaseWebViewController alloc] initWithURL:url];
    }
    
    viewController.title = cell.model.title; // 设置标题
    [self.navigationController pushViewController:viewController animated:YES];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark - <BaseTableViewDelegate> Touch代理方法
- (void)tableView:(UITableView *)tableView touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

// 查询方法
- (void)searchApp:(UITextField *)textField{
    NSString *searchString = [[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] uppercaseString];
    //NSPredicate 谓词
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF.keyWords CONTAINS [cd] %@", searchString];
    if (_results != nil) {
        [_results removeAllObjects];
    }
    
    //过滤数据
    _results = [NSMutableArray arrayWithArray:[_data filteredArrayUsingPredicate:preicate]];
    //刷新表格
    [_tableView reloadData];
}

// 取消方法
- (void)cancelSearch:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
