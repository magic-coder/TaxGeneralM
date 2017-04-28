/************************************************************
 Class    : AppEditViewController.m
 Describe : 应用管理器界面
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-01-20
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "AppEditViewController.h"
#import "AppUtil.h"

#import "BaseCollectionViewCell.h"

@interface AppEditViewController () <BaseCollectionViewControllerDelegate>

@end

@implementation AppEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"应用管理器";
    
    //添加导航栏右侧按钮
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveAppData:)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    self.navigationItem.rightBarButtonItem.enabled = NO;// 初始化保存按钮不可点击
    
    self.collectionStyle = CollectionStyleEdit;
    self.data = [[AppUtil shareInstance] loadDataWithType:AppItemsTypeEdit];
    if(self.data == nil){
        [YZProgressHUD showHUDView:SELF_VIEW Mode:LOCKMODE Text:@"加载中..."];
        [[AppUtil shareInstance] initDataWithType:AppItemsTypeEdit dataBlock:^(NSMutableArray *dataArray) {
            [YZProgressHUD hiddenHUDForView:SELF_VIEW];
            self.data = dataArray;
            [self.collectionView reloadData];
        } failed:^(NSString *error) {
            [YZProgressHUD hiddenHUDForView:SELF_VIEW];
            [YZProgressHUD showHUDView:SELF_VIEW Mode:SHOWMODE Text:error];
        }];
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    self.delegate = self;
}

#pragma mark - 顶部UIBarButtonItem的保存方法
- (void)saveAppData:(UIBarButtonItem *)sender{
    // 点击保存将数据写入SandBox覆盖以前数据
    BaseCollectionModelGroup *mineGroup = [self.data objectAtIndex:0];
    BaseCollectionModelGroup *otherGroup = [self.data objectAtIndex:1];
    BaseCollectionModelGroup *allGroup = [self.data objectAtIndex:1];
    
    NSMutableArray *mineData = [[NSMutableArray alloc] init];
    NSMutableArray *otherData = [[NSMutableArray alloc] init];
    NSMutableArray *allData = [[NSMutableArray alloc] init];
    
    // 我的应用数据
    int ids = 1;
    for(BaseCollectionModelItem *mineItem in mineGroup.items){
        NSDictionary *mineDict = [NSDictionary dictionaryWithObjectsAndKeys: mineItem.no, @"appno", mineItem.title, @"appname", mineItem.webImg, @"appimage", mineItem.url, @"appurl", [NSString stringWithFormat:@"%d", ids], @"userappsort", nil];
        [mineData addObject:mineDict];
        ids++;
    }
    // 其他应用数据
    for(BaseCollectionModelItem *otherItem in otherGroup.items){
        NSInteger i = 0;
        for(BaseCollectionModelItem *mineItem in mineGroup.items){
            if([otherItem.no isEqualToString:mineItem.no]){
                i++;
            }
        }
        if(i == 0){
            NSDictionary *otherDict = [NSDictionary dictionaryWithObjectsAndKeys:otherItem.no, @"appno", otherItem.title, @"appname", otherItem.webImg, @"appimage", otherItem.url, @"appurl", nil];
            [otherData addObject:otherDict];
        }
    }
    
    // 全部应用数据
    for(BaseCollectionModelItem *allItem in allGroup.items){
        NSDictionary *allDict = [NSDictionary dictionaryWithObjectsAndKeys:allItem.no, @"appno", allItem.title, @"appname", allItem.webImg, @"appimage", allItem.url, @"appurl", nil];
        [allData addObject:allDict];
    }
    
    DLog(@"mineData = %ld",mineData.count);
    DLog(@"otherData = %ld",otherData.count);
    DLog(@"allData = %ld",allData.count);
    
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:mineData, @"mineData", otherData, @"otherData", allData, @"allData", nil];
    
    BOOL res = [[AppUtil shareInstance] writeNewAppData:dataDict];
    if(res){
        [YZProgressHUD showHUDView:SELF_VIEW Mode:SHOWMODE Text:@"保存成功!"];
    }else{
        [YZProgressHUD showHUDView:SELF_VIEW Mode:SHOWMODE Text:@"对不起，保存失败!"];
    }
}

#pragma mark - 编辑按钮点击代理方法
- (void)baseCollectionViewControllerEditBtnClick:(UIButton *)sender{
    UIView *v = [sender superview];//获取父类view
    BaseCollectionViewCell *cell = (BaseCollectionViewCell *)[v superview];//获取cell
    NSIndexPath *indexpath = [self.collectionView indexPathForCell:cell];//获取cell对应的indexpath;
    
    if(sender.tag == 0){    //添加方法
        //DLog(@"进入添加方法 -> senction = %ld, row = %ld",(long)indexpath.section,(long)indexpath.row);
        
        BaseCollectionModelGroup *mineGroup = [self.data objectAtIndex:0];
        BaseCollectionModelGroup *allGroup = [self.data objectAtIndex:1];
        BaseCollectionModelItem *addItem = [allGroup.items objectAtIndex:indexpath.row];
        [mineGroup.items addObject:addItem];
        [self.collectionView reloadData];
    }
    if(sender.tag == 1){    //移除方法
        //DLog(@"进入移除方法 -> senction = %ld, row = %ld",(long)indexpath.section,(long)indexpath.row);
        
        BaseCollectionModelGroup *mineGroup = [self.data objectAtIndex:0];
        BaseCollectionModelItem *delItem = [mineGroup.items objectAtIndex:indexpath.row];
        [mineGroup.items removeObject:delItem];
        [self.collectionView reloadData];
    }
    if(sender.tag == 2){    //已选方法
        //DLog(@"进入已选择方法 -> senction = %ld, row = %ld，不进行任何操作",(long)indexpath.section,(long)indexpath.row);
        return;
    }
    
    [self.collectionView reloadData];
    // 点击编辑按钮后设置保存按钮可点击
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
