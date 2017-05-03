/************************************************************
 Class    : BaseCollectionReusableView.m
 Describe : 基础网格视图的组顶部视图，提供分组描述说明
 Company  : Prient
 Author   : Yanzheng
 Date     : 2016-12-31
 Version  : 1.0
 Declare  : Copyright © 2016 Yanzheng. All rights reserved.
 ************************************************************/

#import "BaseCollectionReusableView.h"

@interface BaseCollectionReusableView()

@property (nonatomic, strong) UIView *leftView;         // 左侧标记视图

@property (nonatomic, strong) UIView *topLine;          // 顶部边线
@property (nonatomic, strong) UIView *bottomLine;       // 底部边线

@property (nonatomic, strong) UILabel *titleLabel;      // 标签

@property (nonatomic, assign) int rdNum;                // 随机标志

@end

@implementation BaseCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self loadInit];
    }
    return self;
}

#pragma mark - 初始化方法
- (void)loadInit{
    
    self.rdNum = [[BaseHandleUtil shareInstance] getRandomNumber:0 to:1];   // 获取随机数
    
    self.backgroundColor = [UIColor whiteColor];
    
    _leftView = [[UIView alloc] init];
    [self addSubview:_leftView];
    
    _topLine = [[UIView alloc] init];
    [self addSubview:_topLine];
    
    _bottomLine = [[UIView alloc] init];
    [self addSubview:_bottomLine];
     
    _titleLabel = [[UILabel alloc] init];
    [self addSubview:_titleLabel];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if(self.style == ReusableViewStyleNone){
        
        if(self.isTop){
            // 顶部边线样式
            [_topLine setFrame:CGRectMake(3, 0, self.frameWidth-3, 0.5f)];
            [_topLine setBackgroundColor:DEFAULT_LINE_GRAY_COLOR];
        }
        
        // 左侧标记红线
        [_leftView setFrame:CGRectMake(0, 0, 4.0f, self.frameHeight-0.5f)];
        if(self.rdNum == 0){
            [_leftView setBackgroundColor:[UIColor redColor]];
        }else{
            [_leftView setBackgroundColor:[UIColor orangeColor]];
        }
        [_leftView setAlpha:0.7f];
        
        // 底部边线样式
        [_bottomLine setFrame:CGRectMake(3, self.frameHeight-0.5f, self.frameWidth-3, 0.5f)];
        [_bottomLine setBackgroundColor:DEFAULT_LINE_GRAY_COLOR];
    }
    
    if(self.style == ReusableViewStyleEdit){
        _topLine.hidden = YES;
        _leftView.hidden = YES;
        _bottomLine.hidden = YES;
    }
    
    // 如果标题存在，进行设置标签样式
    if(self.text){
        if(self.style == ReusableViewStyleNone){
            [_titleLabel setTextColor:[UIColor grayColor]];
        }
        
        if(self.style == ReusableViewStyleEdit){
            [_titleLabel setTextColor:[UIColor blackColor]];
        }
        
        [_titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [_titleLabel setNumberOfLines:0];   // 设置为自动换行
        [_titleLabel setText:_text];
        
        // float x = self.frameWidth * 0.035;
        float w = self.frameWidth * 0.89;
        CGSize size = [self.titleLabel sizeThatFits:CGSizeMake(w, MAXFLOAT)];   // 根据text计算大小
        [_titleLabel setFrame:CGRectMake(16, self.frameHeight/2-size.height/2, w, size.height)];
        // 居中布局
        //[_titleLabel setFrame:CGRectMake(self.frameWidth/2-size.width/2, self.frameHeight/2-size.height/2, w, size.height)];
    }
}

#pragma mark - 重写text的Setter方法
- (void)setText:(NSString *)text{
    _text = text;
    [self layoutSubviews];
}

#pragma mark - 重写isTop的Setter方法
- (void)setIsTop:(BOOL)isTop{
    _isTop = isTop;
    [self layoutSubviews];
}

@end
