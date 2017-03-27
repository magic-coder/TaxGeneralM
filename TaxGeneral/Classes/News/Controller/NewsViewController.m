/************************************************************
 Class    : NewsViewController.m
 Describe : 税闻界面（包含顶部分类的总界面）[由于分类少，暂不用该界面]
 Company  : Prient
 Author   : Yanzheng
 Date     : 2016-12-01
 Version  : 1.0
 Declare  : Copyright © 2016 Yanzheng. All rights reserved.
 ************************************************************/

#import "NewsViewController.h"
#import "NewsListViewController.h"

@interface NewsViewController ()

@property (nonatomic, strong) NSArray *newsTypes;

@end

@implementation NewsViewController

- (instancetype)init{
    if(self = [super init]){
        self.titleSizeNormal = 16.0f;
        self.titleSizeSelected = 18.0f;
        self.menuViewStyle = WMMenuViewStyleLine;
        self.menuItemWidth = WIDTH_SCREEN / 3;
        self.titleColorSelected = DEFAULT_BLUE_COLOR;
        self.postNotification = YES;
        self.bounces = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSArray *)newsTypes{
    if(!_newsTypes){
        _newsTypes = @[@"推荐", @"热门", @"其他"];
    }
    return _newsTypes;
}

#pragma mark - Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.newsTypes.count;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    NewsListViewController *vc = [[NewsListViewController alloc] init];
    vc.type = index;
    return vc;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.newsTypes[index];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
