/************************************************************
 Class    : ChatViewController.m
 Describe : 对话框（聊天）界面
 Company  : Prient
 Author   : Yanzheng
 Date     : 2016-08-16
 Version  : 1.0
 Declare  : Copyright © 2016 Yanzheng. All rights reserved.
 ************************************************************/

#import "ChatViewController.h"

@interface ChatViewController ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _imageView = [[UIImageView alloc] init];
    _imageView.image = [UIImage imageNamed:@"chat.png"];
    _imageView.frame = FRAME_SCREEN;
    [self.view addSubview:_imageView];
    
}

#pragma mark 3DTouch预览时底部快捷选项
-(NSArray<id<UIPreviewActionItem>> *)previewActionItems{
    UIPreviewAction *previewAction_1 =[UIPreviewAction actionWithTitle:@"已读" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        DLog(@"点击了已读按钮");
    }];
    
    UIPreviewAction *previewAction_2 =[UIPreviewAction actionWithTitle:@"删除" style:UIPreviewActionStyleDestructive handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        DLog(@"删除");
    }];
    
    NSArray *actions = @[previewAction_1, previewAction_2];
    
    return actions;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
