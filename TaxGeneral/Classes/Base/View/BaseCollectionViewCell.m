/************************************************************
 Class    : BaseCollectionViewCell.m
 Describe : 基础的网格的cell对象
 Company  : Prient
 Author   : Yanzheng
 Date     : 2016-12-30
 Version  : 1.0
 Declare  : Copyright © 2016 Yanzheng. All rights reserved.
 ************************************************************/

#import "BaseCollectionViewCell.h"

@interface BaseCollectionViewCell()

@property (nonatomic, strong) UIView *topLine;              // 顶部边线
@property (nonatomic, strong) UIView *leftLine;             // 左侧边线
@property (nonatomic, strong) UIView *rightLine;            // 右侧边线
@property (nonatomic, strong) UIView *bottomLine;           // 底部边线
@property (nonatomic, strong) UIImageView *newsImageView;    // 新角标

@property (nonatomic, strong) UIImageView *imageView;       // 图片视图
@property (nonatomic, strong) UIButton *editBtn;            // 右上角编辑按钮

@end

@implementation BaseCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self loadInit];
    }
    return self;
}

#pragma mark - 初始化方法
- (void)loadInit{
    self.backgroundColor = [UIColor whiteColor];
    
    _topLine = [[UIView alloc] init];
    [self.contentView addSubview:_topLine];
     
    _leftLine = [[UIView alloc] init];
    [self.contentView addSubview:_leftLine];
    
    _rightLine = [[UIView alloc] init];
    [self.contentView addSubview:_rightLine];
    
    _bottomLine = [[UIView alloc] init];
    [self.contentView addSubview:_bottomLine];
    
    _imageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_imageView];
    
    _titleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_titleLabel];
    
    _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_editBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_editBtn];
    
    // 新角标
    _newsImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_newsImageView];
}

#pragma mark - 设置布局样式
- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    if(_cellStyle == CollectionCellStyleNone){
        // 右侧边线样式
        [_rightLine setFrame:CGRectMake(self.frameWidth-0.5f, 0, 0.5f, self.frameHeight-0.5f)];
        [_rightLine setBackgroundColor:DEFAULT_LINE_GRAY_COLOR];
        
        // 底部边线样式
        [_bottomLine setFrame:CGRectMake(0.5f, self.frameHeight-0.5f, self.frameWidth-0.5f, 0.5f)];
        [_bottomLine setBackgroundColor:DEFAULT_LINE_GRAY_COLOR];
        
        // 新角标
        [_newsImageView setFrame:CGRectMake(self.frameWidth-30, 0, 30, 30)];
    }
    
    if(_cellStyle == CollectionCellStyleEdit){
        // 顶部边线样式
        [_topLine setFrame:CGRectMake(5, 5, self.frameWidth-0.5f-10, 0.5f)];
        [_topLine setBackgroundColor:DEFAULT_LINE_GRAY_COLOR];
        
        // 左侧边线样式
        [_leftLine setFrame:CGRectMake(5, 0.5f+5, 0.5f, self.frameHeight-0.5f-10)];
        [_leftLine setBackgroundColor:DEFAULT_LINE_GRAY_COLOR];
        
        // 右侧边线样式
        [_rightLine setFrame:CGRectMake(self.frameWidth-0.5f-5, 5, 0.5f, self.frameHeight-0.5f-10)];
        [_rightLine setBackgroundColor:DEFAULT_LINE_GRAY_COLOR];
        
        // 底部边线样式
        [_bottomLine setFrame:CGRectMake(0.5f+5, self.frameHeight-0.5f-5, self.frameWidth-0.5f-10, 0.5f)];
        [_bottomLine setBackgroundColor:DEFAULT_LINE_GRAY_COLOR];
        
        [_editBtn setFrame:CGRectMake(self.frameWidth - 35, 5, 30, 30)];
        [_editBtn setImageEdgeInsets:UIEdgeInsetsMake(8, 8, 8, 8)];// 设置按钮图片大小
        if(self.editBtnStyle == CollectionCellEditBtnStyleAdd){
            [_editBtn setImage:[UIImage imageNamed:@"app_edit_add"] forState:UIControlStateNormal];
            [_editBtn setTag:0];
        }
        if(self.editBtnStyle == CollectionCellEditBtnStyleDel){
            [_editBtn setImage:[UIImage imageNamed:@"app_edit_del"] forState:UIControlStateNormal];
            [_editBtn setTag:1];
        }
        if(self.editBtnStyle == CollectionCellEditBtnStyleSel){
            [_editBtn setImage:[UIImage imageNamed:@"app_edit_sel"] forState:UIControlStateNormal];
            [_editBtn setTag:2];
        }
        
        // 新角标
        [_newsImageView setFrame:CGRectMake(5, 5, 28, 28)];
        
    }
    
    // 如果image存在，进行设置图片的样式
    if(self.item.webImg || self.item.localImg){
        [_imageView setFrame:CGRectMake(self.frameWidth*0.5f-self.frameHeight*0.3f*0.5f, self.frameHeight*0.5f-self.frameHeight*0.3f*0.7f, self.frameHeight*0.3f, self.frameHeight*0.3f)];
        [_imageView setContentMode:UIViewContentModeScaleToFill];
    }
    
    // 如果title存在，进行设置标签的样式
    if(self.item.title){
        [_titleLabel setFrame:CGRectMake(0, self.frameHeight*0.7f, self.frameWidth-0.5f, 20)];
        [_titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setTextColor:[UIColor lightGrayColor]];
    }
    
}

#pragma mark - 编辑按钮点击方法
- (void)editBtnClick:(UIButton *)sender{
    // 如果协议响应了baseCollectionViewCellEditBtnClick:方法
    if([_delegate respondsToSelector:@selector(baseCollectionViewCellEditBtnClick:)]){
        [_delegate baseCollectionViewCellEditBtnClick:sender]; // 通知执行协议方法
    }
}

#pragma mark - 重写item的Setter方法
- (void)setItem:(BaseCollectionModelItem *)item{
    _item = item;
    // 从远程URL获取图片(默认本地图标)
    [_imageView sd_setImageWithURL:[NSURL URLWithString:item.webImg] placeholderImage:[UIImage imageNamed:item.localImg] options:SDWebImageAllowInvalidSSLCertificates completed:nil];
    _titleLabel.text = self.item.title;
    
    // 添加新角标
    if(item.isNewApp){
        if(_cellStyle == CollectionCellStyleNone){
            [_newsImageView setImage:[UIImage imageNamed:@"app_common_new_mark_right"]];
        }
        if(_cellStyle == CollectionCellStyleEdit){
            [_newsImageView setImage:[UIImage imageNamed:@"app_common_new_mark_left"]];
        }
    }else{
        [_newsImageView setImage:[UIImage imageNamed:@"none"]];
    }
    
    [self layoutSubviews];
}

@end
