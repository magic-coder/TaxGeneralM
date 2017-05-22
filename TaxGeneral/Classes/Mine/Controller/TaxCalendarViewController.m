/************************************************************
 Class    : TaxCalendarViewController.h
 Describe : 税务日历界面
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-02-07
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "TaxCalendarViewController.h"

@interface TaxCalendarViewController ()

@end

@implementation TaxCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"tax_calendar.png"];
    imageView.frame = FRAME_SCREEN;
    [self.view addSubview:imageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
