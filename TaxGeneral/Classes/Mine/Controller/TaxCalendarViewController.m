//
//  TaxCalendarViewController.m
//  TaxGeneralM
//
//  Created by Apple on 2017/2/7.
//  Copyright © 2017年 Yanzheng. All rights reserved.
//

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
