/************************************************************
 Class    : MessageDetailViewCell.m
 Describe : 自定义消息推送列表展示，封装消息框
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-02-15
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "MessageDetailViewCell.h"

#define TITLE_FONT [UIFont systemFontOfSize:17.0f]
#define CONTENT_FONT [UIFont systemFontOfSize:14.0f]

@interface MessageDetailViewCell()

@property (nonatomic, strong) UIView *baseView;

@property (nonatomic, assign) float baseSpace;

@property (nonatomic, strong) UIView *firstLine;            // 第一条分割线
@property (nonatomic, strong) UIView *secondLine;           // 第二条分割线

@property (nonatomic, strong) UILabel *titleLabel;          // 标题
@property (nonatomic, strong) UILabel *dateLabel;           // 时间
@property (nonatomic, strong) UILabel *abstractLabel;       // 摘要
@property (nonatomic, strong) UILabel *contentLabel;        // 内容
@property (nonatomic, strong) UILabel *detailLabel;         // 详细

@property (nonatomic, strong) UIImageView *arrowImageView;  // 底部右侧箭头

@end

@implementation MessageDetailViewCell

#pragma mark - 初始化加载
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.baseView];
    }
    return self;
}

#pragma mark - 设置model的值并添加组件
- (void)setMessageDetailModel:(MessageDetailModel *)messageDetailModel{
    _messageDetailModel = messageDetailModel;
    
    [_titleLabel setText:_messageDetailModel.title];
    [_contentLabel setText:_messageDetailModel.content];
    [_dateLabel setText:_messageDetailModel.date];
    
    [self layoutSubviews];
}

#pragma mark - 布局加载
- (void)layoutSubviews{
    [super layoutSubviews];
    
    // 通用间隙
    _baseSpace = 15.0f;
    // 通用宽度
    float frameWidth = self.frameWidth - (_baseSpace * 2) - 30.0f;
    
    // 标题
    float titleLabelX = _baseSpace;
    float titleLabelY = _baseSpace;
    CGSize titleSize = [self sizeWithString:_messageDetailModel.title font:TITLE_FONT maxSize:CGSizeMake(frameWidth, MAXFLOAT)];
    float titleLabelW = titleSize.width;
    float titleLabelH = titleSize.height;
    [_titleLabel setFrame:CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH)];
    
    // 时间
    float dateLabelX = _baseSpace;
    float dateLabelY = titleLabelY + titleLabelH + 5.0f;
    float dateLabelW = frameWidth;
    float dateLabelH = 13.0f;
    [_dateLabel setFrame:CGRectMake(dateLabelX, dateLabelY, dateLabelW, dateLabelH)];
    
    // 第一条分割线
    float firstLineX = _baseSpace;
    float firstLineY = dateLabelY + dateLabelH + _baseSpace;
    float firstLineW = frameWidth;
    float firstLineH = 0.5f;
    [_firstLine setFrame:CGRectMake(firstLineX, firstLineY, firstLineW, firstLineH)];
    
    // 摘要
    float abstractLabelX = _baseSpace;
    float abstractLabelY = firstLineY + firstLineH + _baseSpace;
    float abstractLabelW = 72.0f;
    float abstractLabelH = 16.0f;
    [_abstractLabel setFrame:CGRectMake(abstractLabelX, abstractLabelY, abstractLabelW, abstractLabelH)];
    
    // 内容
    float contentLabelX = _baseSpace + abstractLabelW;
    float contentLabelY = abstractLabelY;
    CGSize contentSize = [self sizeWithString:_messageDetailModel.content font:CONTENT_FONT maxSize:CGSizeMake(frameWidth - abstractLabelW, MAXFLOAT)];
    float contentLabelW = contentSize.width;
    float contentLabelH = contentSize.height;
    [_contentLabel setFrame:CGRectMake(contentLabelX, contentLabelY, contentLabelW, contentLabelH)];
    
    // cell高度
    CGFloat cellHeight;
    
    // 当有url时展示查看详情，否则不展示
    if(_messageDetailModel.url.length > 0){
        // 第二条分割线
        _secondLine.hidden = NO;
        float secondLineX = _baseSpace;
        float secondLineY = contentLabelY + contentLabelH + _baseSpace;
        float secondLineW = frameWidth;
        float secondLineH = 0.5f;
        [_secondLine setFrame:CGRectMake(secondLineX, secondLineY, secondLineW, secondLineH)];
        
        // 查看详情
        _detailLabel.hidden = NO;
        float detailLabelX = _baseSpace;
        float detailLabelY = secondLineY + secondLineH + _baseSpace;
        float detailLabelW = frameWidth;
        float detailLabelH = 16.0f;
        [_detailLabel setFrame:CGRectMake(detailLabelX, detailLabelY, detailLabelW, detailLabelH)];
        
        // 详情右侧箭头
        _arrowImageView.hidden = NO;
        float arrowImageViewX = frameWidth - 5.0f;
        float arrowImageViewY = detailLabelY - 8.0f;
        float arrowImageViewW = 30.0f;
        float arrowImageViewH = 30.0f;
        [_arrowImageView setFrame:CGRectMake(arrowImageViewX, arrowImageViewY, arrowImageViewW, arrowImageViewH)];
        
        // 计算cell高度
        cellHeight = detailLabelY + detailLabelH + _baseSpace;
    }else{
        _secondLine.hidden = YES;
        _detailLabel.hidden = YES;
        _arrowImageView.hidden = YES;
        
        self.selected = UITableViewCellSelectionStyleNone; // 点击不变色
        
        // 计算cell高度
        cellHeight = contentLabelY + contentLabelH + _baseSpace;
    }
    
    _messageDetailModel.cellHeight = cellHeight;
    
    // 设置基本视图的frame
    _baseView.frame = CGRectMake(15, 0, WIDTH_SCREEN-30, cellHeight);
    
    // 点击效果
    UIView *backView = [[UIView alloc] initWithFrame:_baseView.frame];
    self.selectedBackgroundView = backView;
    [backView.layer setCornerRadius:5.0f];
    self.selectedBackgroundView.backgroundColor = DEFAULT_SELECTED_GRAY_COLOR;
    
}

#pragma mark - Common Getter and Setter
- (UIView *)baseView{
    if(_baseView == nil){
        _baseView = [[UIView alloc] init];
        _baseView.backgroundColor = [UIColor whiteColor];
        [_baseView.layer setCornerRadius:5.0f];
        
        [_baseView addSubview:self.titleLabel];
        [_baseView addSubview:self.dateLabel];
        [_baseView addSubview:self.firstLine];
        [_baseView addSubview:self.abstractLabel];
        [_baseView addSubview:self.contentLabel];
        [_baseView addSubview:self.secondLine];
        [_baseView addSubview:self.detailLabel];
        [_baseView addSubview:self.arrowImageView];
    }
    
    return _baseView;
}

-(UIView *)firstLine{
    if(_firstLine == nil){
        _firstLine = [[UIView alloc] init];
        _firstLine.backgroundColor = DEFAULT_LINE_GRAY_COLOR;
    }
    return _firstLine;
}

-(UIView *)secondLine{
    if(_secondLine == nil){
        _secondLine = [[UIView alloc] init];
        _secondLine.hidden = YES;
        _secondLine.backgroundColor = DEFAULT_LINE_GRAY_COLOR;
    }
    return _secondLine;
}

- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 0;
        [_titleLabel setFont:TITLE_FONT];
        [_titleLabel setTextAlignment:NSTextAlignmentLeft];
        
    }
    return _titleLabel;
}

- (UILabel *)dateLabel{
    if(_dateLabel == nil){
        _dateLabel = [[UILabel alloc] init];
        [_dateLabel setFont:CONTENT_FONT];
        [_dateLabel setAlpha:0.8f];
        [_dateLabel setTextAlignment:NSTextAlignmentLeft];
        [_dateLabel setTextColor:[UIColor grayColor]];
    }
    return _dateLabel;
}

- (UILabel *)abstractLabel{
    if(_abstractLabel == nil){
        _abstractLabel = [[UILabel alloc] init];
        _abstractLabel.text = @"内容摘要：";
        [_abstractLabel setFont:CONTENT_FONT];
        [_abstractLabel setTextAlignment:NSTextAlignmentLeft];
        [_abstractLabel setTextColor:[UIColor blackColor]];
    }
    return _abstractLabel;
}

- (UILabel *)contentLabel{
    if(_contentLabel == nil){
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.numberOfLines = 0;
        [_contentLabel setFont:CONTENT_FONT];
        [_contentLabel setTextAlignment:NSTextAlignmentLeft];
        [_contentLabel setTextColor:[UIColor grayColor]];
    }
    return _contentLabel;
}

-(UILabel *)detailLabel{
    if(_detailLabel == nil){
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.hidden = YES;
        _detailLabel.text = @"查看详情";
        [_detailLabel setFont:CONTENT_FONT];
        [_detailLabel setTextAlignment:NSTextAlignmentLeft];
        [_detailLabel setTextColor:[UIColor blackColor]];
    }
    return _detailLabel;
}

-(UIImageView *)arrowImageView{
    if(_arrowImageView == nil){
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.hidden = YES;
        _arrowImageView.image = [UIImage imageNamed:@"msg_right_arrow"];
    }
    return _arrowImageView;
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
