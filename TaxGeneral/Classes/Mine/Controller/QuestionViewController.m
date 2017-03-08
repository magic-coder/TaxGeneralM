//
//  QuestionViewController.m
//  TaxGeneralM
//
//  Created by Apple on 2017/2/7.
//  Copyright © 2017年 Yanzheng. All rights reserved.
//

#import "QuestionViewController.h"
#import "MineUtil.h"

@interface QuestionViewController ()

@end

@implementation QuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.data = [MineUtil getQuestionItems];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
