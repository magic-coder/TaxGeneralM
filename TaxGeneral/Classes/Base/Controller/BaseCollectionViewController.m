/************************************************************
 Class    : BaseCollectionViewController.m
 Describe : 基础的网格视图控制器，提供Collection界面布局
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-01-06
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "BaseCollectionViewController.h"
#import "BaseCollectionViewCell.h"
#import "BaseCollectionReusableView.h"
#import "BaseCollectionModel.h"

#import "DeviceInfoModel.h"

@interface BaseCollectionViewController () <BaseCollectionViewCellDelegate, UIViewControllerPreviewingDelegate>

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@end

@implementation BaseCollectionViewController

static NSString * const reuseTopIdentifier = @"baseTopCell";
static NSString * const reuseBaseIdentifier = @"baseCell";
static NSString * const reusableView = @"reusableView";

- (instancetype)init{
    _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;// 确定是水平滚动，还是垂直滚动
    _flowLayout.minimumLineSpacing = 0;
    _flowLayout.minimumInteritemSpacing = 0;
    //_flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    return [super initWithCollectionViewLayout:_flowLayout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    //将背景色移至子类设置
    //self.view.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    //self.collectionView.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    
    self.collectionView.alwaysBounceVertical = NO;// 总是可垂直滑动
    self.collectionView.showsVerticalScrollIndicator = NO; // 隐藏垂直滚动条
    
    // Register cell classes
    [self.collectionView registerClass:[BaseCollectionViewCell class] forCellWithReuseIdentifier:reuseBaseIdentifier];
    [self.collectionView registerClass:[BaseCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reusableView];
}

#pragma mark - <UICollectionViewDataSource> 数据源方法
#pragma mark 返回有多少组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.data.count;
}

#pragma mark 返回每组多少条
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    BaseCollectionModelGroup *group = [self.data objectAtIndex:section];
    return group.itemsCount;
}

#pragma mark 返回每个cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // Configure the cell
    BaseCollectionModelGroup *group = [_data objectAtIndex:indexPath.section];
    BaseCollectionModelItem *item = [group itemAtIndex:indexPath.row];
    
    BaseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseBaseIdentifier forIndexPath:indexPath];
    
    if(self.collectionStyle == CollectionStyleNone){
        cell.cellStyle = CollectionCellStyleNone;
        /*
        if(self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable){
            // 给cell注册3DTouch的peek（预览）和pop功能
            [self registerForPreviewingWithDelegate:self sourceView:cell];
        }
         */
    }
    if(self.collectionStyle == CollectionStyleEdit){
        cell.cellStyle = CollectionCellStyleEdit;
        //第一组为我的应用
        if(indexPath.section == 0){
            cell.editBtnStyle = CollectionCellEditBtnStyleDel;
        }else{  // 剩下的为其他应用
            cell.editBtnStyle = CollectionCellEditBtnStyleAdd;
            BaseCollectionModelGroup *groupMine = [self.data objectAtIndex:0];
            BaseCollectionModelGroup *groupAll = [self.data objectAtIndex:1];
            // 循环判断“全部应用”中哪些为“我的应用”，设置编辑按钮样式
            [groupAll.items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                BaseCollectionModelItem *allItem = (BaseCollectionModelItem *)obj;
                for(BaseCollectionModelItem *mineObj in groupMine.items){
                    if([mineObj.title isEqualToString:allItem.title] && [mineObj.image isEqualToString:allItem.image] && indexPath.row == idx){
                        cell.editBtnStyle = CollectionCellEditBtnStyleSel;
                    }
                }
            }];
        }
    }
    
    cell.delegate = self;
    
    [cell setItem:item];
    
    return cell;
}

#pragma mark 设置cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSData *deviceInfoData = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceInfoData"];
    DeviceInfoModel *deviceInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:deviceInfoData];
    
    if(indexPath.section == 0){
        // 根据屏幕尺寸设置cell大小
        if(deviceInfoModel.deviceInch == DeviceScreenInch_3_5 || deviceInfoModel.deviceInch == DeviceScreenInch_4_0){
            return CGSizeMake(80.0f, 80.0f);
        }else if(deviceInfoModel.deviceInch == DeviceScreenInch_4_7){
            if((indexPath.row+1)%4 == 0 || (indexPath.row+1)%4 == 1){
                return CGSizeMake(94.0f, 94.0f);
            }else{
                return CGSizeMake(93.5f, 94.0f);
            }
        }else if(deviceInfoModel.deviceInch == DeviceScreenInch_5_5){
            return CGSizeMake(103.5f, 103.0f);
        }else{
            return CGSizeMake(WIDTH_SCREEN/4, WIDTH_SCREEN/4);
        }
    }else{
        if(deviceInfoModel.deviceInch == DeviceScreenInch_3_5 || deviceInfoModel.deviceInch == DeviceScreenInch_4_0){
            if((indexPath.row+1)%3 == 0 || (indexPath.row+1)%3 == 1){
                return CGSizeMake(107.0f, 107.0f);
            }else{
                return CGSizeMake(106.0f, 107.0f);
            }
        }else if(deviceInfoModel.deviceInch == DeviceScreenInch_4_7){
            return CGSizeMake(125.0f, 125.0f);
        }else if(deviceInfoModel.deviceInch == DeviceScreenInch_5_5){
            return CGSizeMake(138.0f, 138.0f);
        }else{
            return CGSizeMake(WIDTH_SCREEN/3, WIDTH_SCREEN/3);
        }
    }
}

#pragma mark 设置每个 cell 的 margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - <UICollectionViewDelegate> 代理方法
#pragma mark 设置每组的顶部视图
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    BaseCollectionReusableView *reusable = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reusableView forIndexPath:indexPath];
    
    if([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        BaseCollectionModelGroup *group = [_data objectAtIndex:indexPath.section];
        reusable.text = group.groupTitle;
    }
    if(indexPath.section == 0){
        reusable.isTop = YES;
    }else{
        reusable.isTop = NO;
    }
    
    if(self.collectionStyle == CollectionStyleEdit){
        reusable.style = ReusableViewStyleEdit;
    }
    
    return reusable;
}

#pragma mark 设置顶部视图的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if(section == 0){
        
        if(self.collectionStyle == CollectionStyleNone){
            return (CGSize){WIDTH_SCREEN, 0};
        }
        
        if(self.collectionStyle == CollectionStyleEdit){
            return (CGSize){WIDTH_SCREEN, 32};
        }
        
        return (CGSize){WIDTH_SCREEN, 32};
    }
    return (CGSize){WIDTH_SCREEN, 32};
}

#pragma mark - <UICollectionDelegate>点击代理方法
/*
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(self.collectionStyle == CollectionStyleNone){
        BaseCollectionViewCell *cell = (BaseCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        if([cell.titleLabel.text isEqualToString:@"办税地图"]){
            MapDemoViewController *mapVC = [[MapDemoViewController alloc] init];
            mapVC.title = cell.titleLabel.text; // 设置标题
            [self.navigationController pushViewController:mapVC animated:YES];
        }else if([cell.titleLabel.text isEqualToString:@"一户式"]){
            BaseWebViewController *webVC = [[BaseWebViewController alloc] initWithURL:@"http://itunes.com"];
            [self.navigationController pushViewController:webVC animated:YES];
        }else if([cell.titleLabel.text isEqualToString:@"两学一做"]){
            TestWebViewController *testWebView = [[TestWebViewController alloc] initWithURL:@"http://www.apple.com"];
            testWebView.title = cell.titleLabel.text;
            [self.navigationController pushViewController:testWebView animated:YES];
        }else{
            BaseCordovaViewController *cordovaVC = [[BaseCordovaViewController alloc] init];
            NSString *cordovaPage = nil;
            cordovaVC.pagePath = cordovaPage;
            cordovaVC.currentTitle = cell.titleLabel.text;
            [self.navigationController pushViewController:cordovaVC animated:YES];
        }
    }
}
*/

#pragma mark - 代理编辑按钮点击方法
- (void)baseCollectionViewCellEditBtnClick:(UIButton *)sender{
    // 如果协议响应了baseCollectionViewControllerEditBtnClick:方法
    if([_delegate respondsToSelector:@selector(baseCollectionViewControllerEditBtnClick:)]){
        [_delegate baseCollectionViewControllerEditBtnClick:sender]; // 通知执行协议方法
    }
}

#pragma mark - 3D Touch <UIViewControllerPreviewingDelegate> 代理方法
#pragma mark 视图peek(预览)
/*
-(UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location{
    // 获取按压的cell所在行，[previewingContext sourceView]就是按压的那个视图
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:(BaseCollectionViewCell *)[previewingContext sourceView]];
    BaseCollectionViewCell *cell = (BaseCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    // 设定预览界面
    BaseCordovaViewController *cordovaVC = [[BaseCordovaViewController alloc] init];
    NSString *cordovaPage = nil;
    cordovaVC.pagePath = cordovaPage;
    cordovaVC.currentTitle = cell.titleLabel.text;// 设置标题
    cordovaVC.preferredContentSize = CGSizeMake(0.0f, 600.0f);
    // 调整不被虚化的范围，按压的那个cell不被虚化（轻轻按压时周边会被虚化，再少用力展示预览，再加力跳页至设定界面）
    //CGRect rect = CGRectMake(0, 0, self.view.frame.size.width,40);
    //previewingContext.sourceRect = rect;
    return cordovaVC;
}
*/
#pragma mark 视图pop用力按压进入
/*
-(void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit{
    [self showViewController:viewControllerToCommit sender:self];
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
