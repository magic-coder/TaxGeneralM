/************************************************************
 Class    : MainTabBarController.m
 Describe : 主界面TabBar添加各个视图
 Company  : Prient
 Author   : Yanzheng
 Date     : 2016-07-28
 Version  : 1.0
 Declare  : Copyright © 2016 Yanzheng. All rights reserved.
 ************************************************************/

#import "MainTabBarController.h"
#import "MainNavigationController.h"

#define CLASSNAME       @"className"
#define TITLE           @"title"
#define IMAGE           @"image"
#define SELECTEDIMAGE   @"selectedImage"

@interface MainTabBarController () <UITabBarControllerDelegate>

//最近一次选择的Index
@property (nonatomic, readonly) NSUInteger lastSelectedIndex;

@end

@implementation MainTabBarController

+ (MainTabBarController *)shareInstance{
    static MainTabBarController *mainTabBarController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mainTabBarController = [[MainTabBarController alloc] init];
    });
    return mainTabBarController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    DLog(@"进入初始化mainTabBar");
    
    self.delegate = self;
    
    NSArray *itemArray = @[
                           @{
                               //CLASSNAME        :   @"HomeViewController",
                               //CLASSNAME        :   @"NewsViewController",
                               CLASSNAME        :   @"NewsListViewController",
                               TITLE            :   @"税闻",
                               IMAGE            :   @"tabbar_news",
                               SELECTEDIMAGE    :   @"tabbar_newsHL"
                               },
                           @{
                               //CLASSNAME        :   @"TestViewController",
                               CLASSNAME        :   @"AppViewController",
                               TITLE            :   @"应用",
                               IMAGE            :   @"tabbar_app",
                               SELECTEDIMAGE    :   @"tabbar_appHL"
                               },
                           @{
                               CLASSNAME        :   @"MessageListViewController",
                               TITLE            :   @"消息",
                               IMAGE            :   @"tabbar_msg",
                               SELECTEDIMAGE    :   @"tabbar_msgHL"
                               },
                           @{
                               CLASSNAME        :   @"MineViewController",
                               TITLE            :   @"我",
                               IMAGE            :   @"tabbar_account",
                               SELECTEDIMAGE    :   @"tabbar_accountHL"
                               }
                           ];
    
    [itemArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        /*
        if([obj[CLASSNAME] isEqualToString:@"NewsViewController"]){
            WMPageController *pageController = [self defaultWMPageController];
            pageController.title = obj[TITLE];
            pageController.preloadPolicy = WMPageControllerPreloadPolicyNeighbour;
            mainNav = [[MainNavigationController alloc] initWithRootViewController:pageController];
        }else{
            UIViewController *vc = [NSClassFromString(obj[CLASSNAME]) new];
            vc.title = obj[TITLE];
            mainNav = [[MainNavigationController alloc] initWithRootViewController:vc];
        }
        */
        
        UIViewController *vc = [NSClassFromString(obj[CLASSNAME]) new];
        vc.title = obj[TITLE];
        MainNavigationController *mainNav = [[MainNavigationController alloc] initWithRootViewController:vc];
        
        UITabBarItem *item = mainNav.tabBarItem;
        item.title = obj[TITLE];
        item.image = [UIImage imageNamed:obj[IMAGE]];
        item.selectedImage = [[UIImage imageNamed:obj[SELECTEDIMAGE]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName : DEFAULT_BLUE_COLOR} forState:UIControlStateSelected];
        [self addChildViewController:mainNav];
    }];
}
/*
-(WMPageController *) defaultWMPageController{
    NSMutableArray *classes = [[NSMutableArray alloc] init];
    [classes addObject:[NewsViewController class]];
    [classes addObject:[NewsViewController class]];
    [classes addObject:[NewsViewController class]];
    [classes addObject:[NewsViewController class]];
    [classes addObject:[NewsViewController class]];
    
    
    NSMutableArray *titles = [[NSMutableArray alloc] init];
    [titles addObject:@"推荐"];
    [titles addObject:@"热门"];
    [titles addObject:@"国税"];
    [titles addObject:@"地税"];
    [titles addObject:@"其他"];
    
    WMPageController *pageVC = [[WMPageController alloc] initWithViewControllerClasses:classes andTheirTitles:titles];
    pageVC.titleSizeNormal = 16.0f;
    pageVC.titleSizeSelected = 18.0f;
    pageVC.menuViewStyle = WMMenuViewStyleLine;
    pageVC.menuItemWidth = 85;
    pageVC.titleColorSelected = DEFAULT_BLUE_COLOR;
    pageVC.postNotification = YES;
    pageVC.bounces = YES;
    return pageVC;
}
*/

-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    UIViewController *selectedVC = tabBarController.selectedViewController;
    if([selectedVC isEqual:viewController] && tabBarController.selectedIndex == 0){
        DLog(@"税闻列表刷新...");
        // 如果协议响应了autoRefreshData方法
        if([_customDelegate respondsToSelector:@selector(autoRefreshData)]){
            [_customDelegate autoRefreshData]; // 通知执行协议方法
        }
        return NO;
    }
    return YES;
}

-(void)setSelectedIndex:(NSUInteger)selectedIndex{
    [super setSelectedIndex:selectedIndex];
    
    //判断是否相等,不同才设置
    if (self.selectedIndex != selectedIndex) {
        //设置最近一次
        _lastSelectedIndex = self.selectedIndex;
        DLog(@"Yan-[first] -> OLD:%ld, NEW:%ld", self.lastSelectedIndex, selectedIndex);
        if(self.lastSelectedIndex == 0 || self.lastSelectedIndex == 3){
            [Variable shareInstance].lastSelectedIds = self.lastSelectedIndex;
        }
    }
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    //获得选中的item
    NSUInteger tabIndex = [tabBar.items indexOfObject:item];
    if (tabIndex != self.selectedIndex) {
        //设置最近一次变更
        _lastSelectedIndex = self.selectedIndex;
        DLog(@"Yan-[second] -> OLD:%ld, NEW:%ld", self.lastSelectedIndex, tabIndex);
        if(self.lastSelectedIndex == 0 || self.lastSelectedIndex == 3){
            [Variable shareInstance].lastSelectedIds = self.lastSelectedIndex;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
