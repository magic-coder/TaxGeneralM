/************************************************************
 Class    : NewsTableViewCell.m
 Describe : 自定义税文列表cell（三种样式：文本、单图、多图）
 Company  : Prient
 Author   : Yanzheng
 Date     : 2016-12-02
 Version  : 1.0
 Declare  : Copyright © 2016 Yanzheng. All rights reserved.
 ************************************************************/

#import "NewsTableViewCell.h"
#import "NewsModel.h"

#define TITLE_FONT [UIFont systemFontOfSize:18.0f]
#define DESCRIBE_FONT [UIFont systemFontOfSize:12.0f]
#define PLACEHOLDER_IMAGE [UIImage imageNamed:@"common_news_placeholder"]

@interface NewsTableViewCell()

@property (nonatomic, assign) float baseSpace;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *fewImageView;

@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *centerImageView;
@property (nonatomic, strong) UIImageView *rightImageView;

@property (nonatomic, strong) UILabel *describeLabel;

@property (nonatomic, strong) UIView *bottomLine;

@end

@implementation NewsTableViewCell

#pragma mark - 初始化方法
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.fewImageView];
        [self.contentView addSubview:self.leftImageView];
        [self.contentView addSubview:self.centerImageView];
        [self.contentView addSubview:self.rightImageView];
        [self.contentView addSubview:self.describeLabel];
        [self.contentView addSubview:self.bottomLine];
    }
    
    return self;
}

#pragma mark 布局加载
- (void)layoutSubviews{
    [super layoutSubviews];
    
    _baseSpace = 10;
    float imageWidth = (self.frameWidth - _baseSpace * 3)/3;
    
    // 文本样式
    if(_newsModel.style == NewsModelStyleText){
        float titleLabelX = _baseSpace;
        float titleLabelY = _baseSpace;
        CGSize titleSize = [self sizeWithString:_newsModel.title font:TITLE_FONT maxSize:CGSizeMake(self.frameWidth - (_baseSpace * 2), MAXFLOAT)];
        float titleLabelW = titleSize.width;
        float titleLabelH = titleSize.height;
        [_titleLabel setFrame:CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH)];
        
        float describeLabelX = _baseSpace;
        float describeLabelY = _baseSpace + titleLabelH + _baseSpace;
        float describeLabelW = titleLabelW;
        float describeLabelH = 10.0;
        _describeLabel.backgroundColor = [UIColor redColor];
        [_describeLabel setFrame:CGRectMake(describeLabelX, describeLabelY, describeLabelW, describeLabelH)];
        
        // 计算cell高度
        _newsModel.cellHeight = _baseSpace + titleLabelH + _baseSpace + describeLabelH + _baseSpace;
        
    }
    
    // 单图样式
    if(_newsModel.style == NewsModelStyleFewImage){
        float fewImageViewW = imageWidth;
        float fewImageViewH = 75;
        float fewImageViewX = self.frameWidth - _baseSpace - fewImageViewW;
        float fewImageViewY = _baseSpace;
        [_fewImageView setFrame:CGRectMake(fewImageViewX, fewImageViewY, fewImageViewW, fewImageViewH)];
        
        float titleLabelX = _baseSpace;
        float titleLabelY = _baseSpace;
        CGSize titleSize = [self sizeWithString:_newsModel.title font:TITLE_FONT maxSize:CGSizeMake(self.frameWidth - (_baseSpace * 3) - fewImageViewW, MAXFLOAT)];
        float titleLabelW = titleSize.width;
        float titleLabelH = titleSize.height;
        [_titleLabel setFrame:CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH)];
        
        float describeLabelX = _baseSpace;
        float describeLabelY = 0;
        if(titleLabelH + _baseSpace + 8.0 <= 75){
            describeLabelY = _baseSpace + 75 - 8.0;
        }else{
            describeLabelY = _baseSpace + titleLabelH + _baseSpace;
        }
        
        float describeLabelW = titleLabelW;
        float describeLabelH = 10.0;
        [_describeLabel setFrame:CGRectMake(describeLabelX, describeLabelY, describeLabelW, describeLabelH)];
        
        // 计算cell高度
        if((titleLabelH + _baseSpace + describeLabelH) > 75){
            _newsModel.cellHeight = _baseSpace + titleLabelH + _baseSpace + describeLabelH + _baseSpace;
        }else{
            _newsModel.cellHeight = _baseSpace + 75 + _baseSpace;
        }
        
    }
    
    // 多图样式
    if(_newsModel.style == NewsModelStyleMoreImage){
        
        float titleLabelX = _baseSpace;
        float titleLabelY = _baseSpace;
        CGSize titleSize = [self sizeWithString:_newsModel.title font:TITLE_FONT maxSize:CGSizeMake(self.frameWidth - (_baseSpace * 2), MAXFLOAT)];
        float titleLabelW = titleSize.width;
        float titleLabelH = titleSize.height;
        [_titleLabel setFrame:CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH)];
        
        float leftImageViewX = _baseSpace;
        float leftImageViewY = _baseSpace + titleLabelH + _baseSpace;
        float leftImageViewW = imageWidth;
        float leftImageViewH = 75;
        [_leftImageView setFrame:CGRectMake(leftImageViewX, leftImageViewY, leftImageViewW, leftImageViewH)];
        
        float centerImageViewX = _baseSpace + imageWidth + 5;
        float centerImageViewY = _baseSpace + titleLabelH + _baseSpace;
        float centerImageViewW = imageWidth;
        float centerImageViewH = 75;
        [_centerImageView setFrame:CGRectMake(centerImageViewX, centerImageViewY, centerImageViewW, centerImageViewH)];
        
        float rightImageViewX = _baseSpace + imageWidth + 5 + imageWidth + 5;
        float rightImageViewY = _baseSpace + titleLabelH + _baseSpace;
        float rightImageViewW = imageWidth;
        float rightImageViewH = 75;
        [_rightImageView setFrame:CGRectMake(rightImageViewX, rightImageViewY, rightImageViewW, rightImageViewH)];
        
        float describeLabelX = _baseSpace;
        float describeLabelY = _baseSpace + titleLabelH + _baseSpace + 75 + _baseSpace;
        float describeLabelW = titleLabelW;
        float describeLabelH = 10.0;
        [_describeLabel setFrame:CGRectMake(describeLabelX, describeLabelY, describeLabelW, describeLabelH)];
        
        // 计算cell高度
        _newsModel.cellHeight = _baseSpace + titleLabelH + _baseSpace + 75 + _baseSpace + describeLabelH + _baseSpace;
    }
    
    // 设置每个cell底部线条
    float bottomLineX = _baseSpace;
    float bottomLineY = _newsModel.cellHeight - 0.5f;
    float bottomLineW = self.frameWidth - (_baseSpace * 2);
    float bottomLineH = 0.5f;
    [_bottomLine setFrame:CGRectMake(bottomLineX, bottomLineY, bottomLineW, bottomLineH)];
    
}

#pragma mark 通过Setter方法为模型赋值
- (void)setNewsModel:(NewsModel *)newsModel{
    _newsModel = newsModel;
    
    [_titleLabel setText:_newsModel.title];
    if(_newsModel.style == NewsModelStyleFewImage){
        NSString *fewImageName = [_newsModel.images objectAtIndex:0];
        // 从远程url获取https图片
        // [_fewImageView sd_setImageWithURL:[NSURL URLWithString:fewImageName] placeholderImage:PLACEHOLDER_IMAGE options:SDWebImageAllowInvalidSSLCertificates completed:nil];
        [_fewImageView sd_setImageWithURL:[NSURL URLWithString:fewImageName] placeholderImage:PLACEHOLDER_IMAGE options:SDWebImageAllowInvalidSSLCertificates completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            // 在回调block中进行图片裁剪处理（去除一圈白边）
            CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(20, 20, image.size.width-40, image.size.height-40));
            _fewImageView.image =[UIImage imageWithCGImage:imageRef];
        }];
        
        _fewImageView.hidden = NO;
        _leftImageView.hidden = YES;
        _centerImageView.hidden = YES;
        _rightImageView.hidden = YES;
    }else if(_newsModel.style == NewsModelStyleMoreImage){
        NSString *leftImageName = [_newsModel.images objectAtIndex:0];
        NSString *centerImageName = [_newsModel.images objectAtIndex:1];
        NSString *rightImageName = [_newsModel.images objectAtIndex:2];
        // 从远程url获取https图片
        /*
        [_leftImageView sd_setImageWithURL:[NSURL URLWithString:leftImageName] placeholderImage:PLACEHOLDER_IMAGE options:SDWebImageAllowInvalidSSLCertificates completed:nil];
        [_centerImageView sd_setImageWithURL:[NSURL URLWithString:centerImageName] placeholderImage:PLACEHOLDER_IMAGE options:SDWebImageAllowInvalidSSLCertificates completed:nil];
        [_rightImageView sd_setImageWithURL:[NSURL URLWithString:rightImageName] placeholderImage:PLACEHOLDER_IMAGE options:SDWebImageAllowInvalidSSLCertificates completed:nil];
        */
        [_leftImageView sd_setImageWithURL:[NSURL URLWithString:leftImageName] placeholderImage:PLACEHOLDER_IMAGE options:SDWebImageAllowInvalidSSLCertificates completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            // 在回调block中进行图片裁剪处理（去除一圈白边）
            CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(20, 20, image.size.width-40, image.size.height-40));
            _leftImageView.image =[UIImage imageWithCGImage:imageRef];
        }];
        [_centerImageView sd_setImageWithURL:[NSURL URLWithString:centerImageName] placeholderImage:PLACEHOLDER_IMAGE options:SDWebImageAllowInvalidSSLCertificates completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            // 在回调block中进行图片裁剪处理（去除一圈白边）
            CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(20, 20, image.size.width-40, image.size.height-40));
            _centerImageView.image =[UIImage imageWithCGImage:imageRef];
        }];
        [_rightImageView sd_setImageWithURL:[NSURL URLWithString:rightImageName] placeholderImage:PLACEHOLDER_IMAGE options:SDWebImageAllowInvalidSSLCertificates completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            // 在回调block中进行图片裁剪处理（去除一圈白边）
            CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(20, 20, image.size.width-40, image.size.height-40));
            _rightImageView.image =[UIImage imageWithCGImage:imageRef];
        }];
        
        _fewImageView.hidden = YES;
        _leftImageView.hidden = NO;
        _centerImageView.hidden = NO;
        _rightImageView.hidden = NO;
    }else{
        _fewImageView.hidden = YES;
        _leftImageView.hidden = YES;
        _centerImageView.hidden = YES;
        _rightImageView.hidden = YES;
    }
    // 设置底部显示为来源+时间
    [_describeLabel setText:[NSString stringWithFormat:@"%@  %@",_newsModel.source, _newsModel.datetime]];
    [_describeLabel setText:_newsModel.datetime];
    
    [self layoutSubviews];
}

#pragma mark 初始化各组件的Getter方法
- (UILabel *)titleLabel{
    if(_titleLabel == nil){
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFont:TITLE_FONT];
        _titleLabel.numberOfLines = 0;  // 标签显示不限制行数
    }
    return _titleLabel;
}

- (UIImageView *)fewImageView{
    if(_fewImageView == nil){
        _fewImageView = [[UIImageView alloc] init];
    }
    return _fewImageView;
}

- (UIImageView *)leftImageView{
    if(_leftImageView == nil){
        _leftImageView = [[UIImageView alloc] init];
    }
    return _leftImageView;
}

- (UIImageView *)centerImageView{
    if(_centerImageView == nil){
        _centerImageView = [[UIImageView alloc] init];
    }
    return _centerImageView;
}

- (UIImageView *)rightImageView{
    if(_rightImageView == nil){
        _rightImageView = [[UIImageView alloc] init];
    }
    return _rightImageView;
}

- (UILabel *)describeLabel{
    if(_describeLabel == nil){
        _describeLabel = [[UILabel alloc] init];
        [_describeLabel setTextColor:[UIColor lightGrayColor]];
        [_describeLabel setFont:DESCRIBE_FONT];
    }
    return _describeLabel;
}

- (UIView *)bottomLine{
    _bottomLine = [[UIView alloc] init];
    [_bottomLine setBackgroundColor:[UIColor lightGrayColor]];
    [_bottomLine setAlpha:0.4];
    [self.contentView addSubview:_bottomLine];
    return nil;
}

/**
 *  计算文本的宽高
 *
 *  @param str     需要计算的文本
 *  @param font    文本显示的字体
 *  @param maxSize 文本显示的范围
 *
 *  @return 文本占用的真实宽高
 */
- (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *dict = @{NSFontAttributeName : font};
    // 如果将来计算的文字的范围超出了指定的范围,返回的就是指定的范围
    // 如果将来计算的文字的范围小于指定的范围, 返回的就是真实的范围
    CGSize size = [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size;
}

@end
