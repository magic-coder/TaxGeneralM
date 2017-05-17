/************************************************************
 Class    : AppTopView.m
 Describe : 应用界面顶部头视图
 Company  : Prient
 Author   : Yanzheng
 Date     : 2016-12-29
 Version  : 1.0
 Declare  : Copyright © 2016 Yanzheng. All rights reserved.
 ************************************************************/

#import "AppTopView.h"
#import "SettingUtil.h"

@implementation AppTopView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = DEFAULT_BLUE_COLOR;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH"];
        int hour = [[formatter stringFromDate:[NSDate date]] intValue];
        
        NSString *imageName = @"app_top_bg_3";  // 傍晚
        
        if(hour >= 6 && hour < 10){
            imageName = @"app_top_bg_0";    // 早晨
        }
        if(hour >= 10 && hour < 16){
            imageName = @"app_top_bg_1";    // 中午
        }
        if(hour >= 16 && hour < 20){
            imageName = @"app_top_bg_2";    // 下午
        }
        
        
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:imageName scaleToSize:frame.size]];
        self.userInteractionEnabled = YES;
        self.multipleTouchEnabled = YES;
        //控制子视图不能超出父视图的范围
        self.clipsToBounds = YES;
        
        // 读取系统设置文件内容(更新提醒)
        NSDictionary *settingDict = [[SettingUtil shareInstance] loadSettingData];
        BOOL forecastOn = [[settingDict objectForKey:@"forecast"] boolValue];
        if(forecastOn){
            CBAutoScrollLabel *autoScrollLabel = [[CBAutoScrollLabel alloc] initWithFrame:CGRectMake(10, HEIGHT_STATUS+5, WIDTH_SCREEN-100, 30)];
            //autoScrollLabel.text = @"";
            autoScrollLabel.textColor = [UIColor whiteColor];
            autoScrollLabel.labelSpacing = 35; // 开始和结束标签之间的距离
            autoScrollLabel.pauseInterval = 1.0; // 等待多少秒后开始滚动
            autoScrollLabel.scrollSpeed = 30; // 每秒像素
            autoScrollLabel.textAlignment = NSTextAlignmentLeft; // 不使用自动滚动时的中心文本
            autoScrollLabel.fadeLength = 12.f; // length of the left and right edge fade, 0 to disable
            autoScrollLabel.font = [UIFont systemFontOfSize:15.0f];
            [self addSubview:autoScrollLabel];// 顶部天气预报提醒
            
            NSString *url = @"http://apis.baidu.com/tianyiweather/basicforecast/weatherapi?area=101110101";
            [[YZNetworkingManager shareInstance] requestMethod:GET url:url parameters:nil success:^(NSDictionary *responseDic) {
                DLog(@"%@", responseDic);
                
                NSString *pmVal = [[[[responseDic objectForKey:@"air"] objectForKey:@"101110101"] objectForKey:@"2001006"] objectForKey:@"001"];
                NSString *currentTemperature = [[[[responseDic objectForKey:@"observe"] objectForKey:@"101110101"] objectForKey:@"1001002"] objectForKey:@"002"];  // 当前温度
                NSString *currentHumidity = [[[[responseDic objectForKey:@"observe"] objectForKey:@"101110101"] objectForKey:@"1001002"] objectForKey:@"005"];  // 当前湿度
                NSString *currentRainfall = [[[[responseDic objectForKey:@"observe"] objectForKey:@"101110101"] objectForKey:@"1001002"] objectForKey:@"006"];  // 当前降水量
                NSString *currentWind = [[[[responseDic objectForKey:@"observe"] objectForKey:@"101110101"] objectForKey:@"1001002"] objectForKey:@"003"];  // 当前风力
                
                NSDictionary *indexDict = [[[[responseDic objectForKey:@"index"] objectForKey:@"24h"] objectForKey:@"101110101"] objectForKey:@"1001004"][0];// 指数
                
                NSString *indexStr = [NSString stringWithFormat:@"%@：%@，%@：%@，%@：%@，%@：%@，%@：%@，%@：%@，%@：%@", [[indexDict objectForKey:@"001"] objectForKey:@"001001"], [[indexDict objectForKey:@"001"] objectForKey:@"001002"], [[indexDict objectForKey:@"002"] objectForKey:@"002001"], [[indexDict objectForKey:@"002"] objectForKey:@"002002"], [[indexDict objectForKey:@"004"] objectForKey:@"004001"], [[indexDict objectForKey:@"004"] objectForKey:@"004002"], [[indexDict objectForKey:@"005"] objectForKey:@"005001"], [[indexDict objectForKey:@"005"] objectForKey:@"005002"], [[indexDict objectForKey:@"007"] objectForKey:@"007001"], [[indexDict objectForKey:@"007"] objectForKey:@"007002"], [[indexDict objectForKey:@"009"] objectForKey:@"009001"], [[indexDict objectForKey:@"009"] objectForKey:@"009002"], [[indexDict objectForKey:@"010"] objectForKey:@"010001"], [[indexDict objectForKey:@"010"] objectForKey:@"010002"]];
                
                NSString *str = [NSString stringWithFormat:@"西安市当前气温：%@℃，PM2.5：%d，湿度：%@%%，降水量：%@mm，风力：%@级，%@", currentTemperature, [pmVal intValue], currentHumidity, currentRainfall, currentWind, indexStr];
                
                autoScrollLabel.text = str;
                
            } failure:^(NSString *error) {
                RLog(@"%@", error);
                UILabel *titleLabel = [[UILabel alloc] init];
                titleLabel.frame = CGRectMake(WIDTH_SCREEN/2-50, HEIGHT_STATUS+5, 100, 30);
                titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
                titleLabel.textAlignment = NSTextAlignmentCenter;
                titleLabel.text = @"应用";
                titleLabel.textColor = [UIColor whiteColor];
                [self addSubview:titleLabel];// 顶部标题
            }];
            
            // 添加搜索按钮
            UIButton *btn_search = [UIButton buttonWithType:UIButtonTypeCustom];
            btn_search.frame = CGRectMake(WIDTH_SCREEN-85, HEIGHT_STATUS, 46, 46);
            [btn_search setImage:[UIImage imageNamed:@"baritem_app_search"] forState:UIControlStateNormal];
            [btn_search setImage:[UIImage imageNamed:@"baritem_app_searchHL"] forState:UIControlStateHighlighted];
            btn_search.tag = 1;
            [btn_search addTarget:self action:@selector(appBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn_search];   // 搜索按钮
            
        }else{
            
            // 添加搜索框
            UITextField *searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, HEIGHT_STATUS + 8, WIDTH_SCREEN - 15 - 60, 26)];
            searchTextField.layer.cornerRadius = 5;
            searchTextField.layer.borderWidth = .5;
            searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
            searchTextField.layer.borderColor = DEFAULT_BACKGROUND_COLOR.CGColor;
            searchTextField.font = [UIFont systemFontOfSize:14.0f];
            searchTextField.backgroundColor = DEFAULT_BACKGROUND_COLOR;
            //searchTextField.placeholder = @"应用搜索";
            //searchTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"应用搜索" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
            searchTextField.alpha = 0.3f;
            [self addSubview:searchTextField];
            
            UIImageView *imgSearch = [[UIImageView alloc] initWithFrame:CGRectMake(searchTextField.originX+4, searchTextField.originY+1, 24, 24)];
            imgSearch.image = [UIImage imageNamed:@"app_common_searchHL"];
            [self addSubview:imgSearch];
            
            UILabel *searchLabel = [[UILabel alloc] initWithFrame:CGRectMake(searchTextField.originX+34, searchTextField.originY, 100, 26)];
            searchLabel.textColor = [UIColor whiteColor];
            searchLabel.font = [UIFont systemFontOfSize:14.0f];
            searchLabel.text = @"应用搜索";
            [self addSubview:searchLabel];
            
            UIButton *btn_search_frame = [UIButton buttonWithType:UIButtonTypeCustom];
            btn_search_frame.frame = searchTextField.frame;
            btn_search_frame.tag = 1;
            [btn_search_frame addTarget:self action:@selector(appBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn_search_frame];   // 搜索按钮
            
        }
        
        UIButton *btn_edit = [UIButton buttonWithType:UIButtonTypeCustom];
        btn_edit.frame = CGRectMake(WIDTH_SCREEN-46, HEIGHT_STATUS, 46, 46);
        [btn_edit setImage:[UIImage imageNamed:@"baritem_app_edit"] forState:UIControlStateNormal];
        [btn_edit setImage:[UIImage imageNamed:@"baritem_app_editHL"] forState:UIControlStateHighlighted];
        btn_edit.tag = 0;
        
        CGFloat btnW = (WIDTH_SCREEN - 50)/4;
        
        UIButton *btn_1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn_1.frame = CGRectMake(10, 70, btnW, 80);
        [btn_1 setImage:[UIImage imageNamed:@"app_common_notification"] forState:UIControlStateNormal];
        [btn_1 setImage:[UIImage imageNamed:@"app_common_notificationHL"] forState:UIControlStateHighlighted];
        [btn_1 setTitle:@"通知公告" forState:UIControlStateNormal];
        [btn_1.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [btn_1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn_1 setTitleColor:DEFAULT_LIGHT_BLUE_COLOR forState:UIControlStateHighlighted];
        btn_1.imageEdgeInsets = UIEdgeInsetsMake(- (btn_1.frame.size.height - btn_1.titleLabel.frame.size.height- btn_1.titleLabel.frame.origin.y),(WIDTH_SCREEN - 50)/4/2 - btn_1.imageView.size.width/2, 0, 0);
        btn_1.titleEdgeInsets = UIEdgeInsetsMake(btn_1.frame.size.height-btn_1.imageView.frame.size.height-btn_1.imageView.frame.origin.y+10, -btn_1.imageView.frame.size.width*0.9f, 0, 0);
        
        UIButton *btn_2 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn_2.frame = CGRectMake(10 + btnW + 10, 70, btnW, 80);
        [btn_2 setImage:[UIImage imageNamed:@"app_common_contacts"] forState:UIControlStateNormal];
        [btn_2 setImage:[UIImage imageNamed:@"app_common_contactsHL"] forState:UIControlStateHighlighted];
        [btn_2 setTitle:@"通讯录" forState:UIControlStateNormal];
        [btn_2.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [btn_2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn_2 setTitleColor:DEFAULT_LIGHT_BLUE_COLOR forState:UIControlStateHighlighted];
        btn_2.imageEdgeInsets = UIEdgeInsetsMake(- (btn_2.frame.size.height - btn_2.titleLabel.frame.size.height- btn_2.titleLabel.frame.origin.y),(WIDTH_SCREEN - 50)/4/2 - btn_2.imageView.size.width/2, 0, 0);
        btn_2.titleEdgeInsets = UIEdgeInsetsMake(btn_2.frame.size.height-btn_2.imageView.frame.size.height-btn_2.imageView.frame.origin.y+10, -btn_2.imageView.frame.size.width*0.9f, 0, 0);
        
        UIButton *btn_3 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn_3.frame = CGRectMake(10 + btnW + 10 + btnW + 10, 70, btnW, 80);
        [btn_3 setImage:[UIImage imageNamed:@"app_common_map"] forState:UIControlStateNormal];
        [btn_3 setImage:[UIImage imageNamed:@"app_common_mapHL"] forState:UIControlStateHighlighted];
        [btn_3 setTitle:@"办税地图" forState:UIControlStateNormal];
        [btn_3.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [btn_3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn_3 setTitleColor:DEFAULT_LIGHT_BLUE_COLOR forState:UIControlStateHighlighted];
        btn_3.imageEdgeInsets = UIEdgeInsetsMake(- (btn_3.frame.size.height - btn_3.titleLabel.frame.size.height- btn_3.titleLabel.frame.origin.y),(WIDTH_SCREEN - 50)/4/2 - btn_3.imageView.size.width/2, 0, 0);
        btn_3.titleEdgeInsets = UIEdgeInsetsMake(btn_3.frame.size.height-btn_3.imageView.frame.size.height-btn_3.imageView.frame.origin.y+10, -btn_3.imageView.frame.size.width*0.9f, 0, 0);
        
        
        UIButton *btn_4 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn_4.frame = CGRectMake(10 + btnW + 10 + btnW + 10 + btnW + 10, 70, btnW, 80);
        [btn_4 setImage:[UIImage imageNamed:@"app_common_question"] forState:UIControlStateNormal];
        [btn_4 setImage:[UIImage imageNamed:@"app_common_questionHL"] forState:UIControlStateHighlighted];
        [btn_4 setTitle:@"常见问题" forState:UIControlStateNormal];
        [btn_4.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [btn_4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn_4 setTitleColor:DEFAULT_LIGHT_BLUE_COLOR forState:UIControlStateHighlighted];
        btn_4.imageEdgeInsets = UIEdgeInsetsMake(- (btn_4.frame.size.height - btn_4.titleLabel.frame.size.height- btn_4.titleLabel.frame.origin.y),(WIDTH_SCREEN - 50)/4/2 - btn_4.imageView.size.width/2, 0, 0);
        btn_4.titleEdgeInsets = UIEdgeInsetsMake(btn_4.frame.size.height-btn_4.imageView.frame.size.height-btn_4.imageView.frame.origin.y+10, -btn_4.imageView.frame.size.width*0.9f, 0, 0);
        
        
        // 注册按钮点击事件
        [btn_edit addTarget:self action:@selector(appBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn_1 addTarget:self action:@selector(appBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn_2 addTarget:self action:@selector(appBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn_3 addTarget:self action:@selector(appBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn_4 addTarget:self action:@selector(appBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:btn_edit];     // 右侧编辑按钮
        [self addSubview:btn_1];
        [self addSubview:btn_2];
        [self addSubview:btn_3];
        [self addSubview:btn_4];
        
    }
    return self;
}

- (void)appBtnOnClick:(UIButton *)sender{
    // 如果协议响应了appTopViewBtnClick方法
    if([_delegate respondsToSelector:@selector(appTopViewBtnClick:)]){
        [_delegate appTopViewBtnClick:sender]; // 通知执行协议方法
    }
}

@end
