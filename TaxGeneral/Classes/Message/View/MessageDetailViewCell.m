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

//@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UIImageView *baseView;

@property (nonatomic, assign) float baseSpace;

@property (nonatomic, strong) UIView *firstLine;            // 第一条分割线
@property (nonatomic, strong) UIView *secondLine;           // 第二条分割线

@property (nonatomic, strong) UILabel *titleLabel;          // 标题
@property (nonatomic, strong) UIImageView *userImg;         // 推送人图标
@property (nonatomic, strong) UILabel *pushUserLabel;       // 推送人
@property (nonatomic, strong) UILabel *userLabel;           // 人名
@property (nonatomic, strong) UIImageView *pushDateImg;     // 推送时间图标
@property (nonatomic, strong) UILabel *pushDateLabel;       // 推送时间
@property (nonatomic, strong) UILabel *dateLabel;           // 时间
@property (nonatomic, strong) UIImageView *abstractImg;     // 摘要图标
@property (nonatomic, strong) UILabel *abstractLabel;       // 摘要
@property (nonatomic, strong) UILabel *contentLabel;        // 内容
@property (nonatomic, strong) UIImageView *linkImg;         // 链接图标
@property (nonatomic, strong) UILabel *detailLabel;         // 详细

@property (nonatomic, strong) UIImageView *arrowImageView;  // 底部右侧箭头

@end

@implementation MessageDetailViewCell

#pragma mark - 初始化加载
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;    // cell点击变色效果
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self addGestureRecognizer: [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)]];// 添加长按手势方法（长按显示菜单）
        [self.contentView addSubview:self.baseView];
    }
    return self;
}

#pragma mark - 长按手势方法
- (void)longPressAction:(UILongPressGestureRecognizer *)longPressGesture{
    if (longPressGesture.state == UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        UIMenuItem *calendarItem = [[UIMenuItem alloc] initWithTitle:@"加入提醒" action:@selector(calendarItemClicked:)];
        UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyItemClicked:)];
        UIMenuItem *deleteItem = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteItemClicked:)];
        [menu setMenuItems:[NSArray arrayWithObjects:calendarItem, copyItem, deleteItem, nil]];
        [menu setTargetRect:self.bounds inView:self];
        [menu setMenuVisible:YES animated:YES];
        
        _baseView.image = [UIImage imageNamed:@"msg_detail_bgHL" scaleToSize:_baseView.size];
    }else{
        _baseView.image = [UIImage imageNamed:@"msg_detail_bg" scaleToSize:_baseView.size];
    }
}

#pragma mark 长按处理Action事件
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if(action==@selector(calendarItemClicked:) || action ==@selector(copyItemClicked:) || action==@selector(deleteItemClicked:)){
        return YES;
    }
    return [super canPerformAction:action withSender:sender];
}
#pragma mark 成为第一响应者方法
- (BOOL)canBecomeFirstResponder{
    return YES;
}

#pragma mark 菜单meun对应的方法实现
- (void)calendarItemClicked:(id)sender{
    // 如果协议响应了msgDetailViewCellMenuClicked:type::方法
    if([_delegate respondsToSelector:@selector(msgDetailViewCellMenuClicked:type:)]){
        [_delegate msgDetailViewCellMenuClicked:self type:MsgDetailViewCellMenuTypeCalendar];
    }
}
- (void)copyItemClicked:(id)sender{
    // 如果协议响应了msgDetailViewCellMenuClicked:type::方法
    if([_delegate respondsToSelector:@selector(msgDetailViewCellMenuClicked:type:)]){
        [_delegate msgDetailViewCellMenuClicked:self type:MsgDetailViewCellMenuTypeCopy];
    }
}
- (void)deleteItemClicked:(id)sender{
    // 如果协议响应了msgDetailViewCellMenuClicked:type::方法
    if([_delegate respondsToSelector:@selector(msgDetailViewCellMenuClicked:type:)]){
        [_delegate msgDetailViewCellMenuClicked:self type:MsgDetailViewCellMenuTypeDelete];
    }
}

#pragma mark - 设置model的值并添加组件
- (void)setMessageDetailModel:(MessageDetailModel *)messageDetailModel{
    _messageDetailModel = messageDetailModel;
    
    [_titleLabel setText:_messageDetailModel.title];
    [_userLabel setText:_messageDetailModel.user];
    [_dateLabel setText:_messageDetailModel.date];
    [_contentLabel setText:_messageDetailModel.content];
    
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
    CGSize titleSize = [[BaseHandleUtil shareInstance] sizeWithString:_messageDetailModel.title font:TITLE_FONT maxSize:CGSizeMake(frameWidth, MAXFLOAT)];
    float titleLabelW = titleSize.width;
    float titleLabelH = titleSize.height;
    [_titleLabel setFrame:CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH)];
    
    // 第一条分割线
    float firstLineX = _baseSpace;
    float firstLineY = titleLabelY + titleLabelH + _baseSpace;
    float firstLineW = frameWidth;
    float firstLineH = 0.5f;
    [_firstLine setFrame:CGRectMake(firstLineX, firstLineY, firstLineW, firstLineH)];
    
    // 推送人员
    float pushUserLabelX = _baseSpace + 17;
    float pushUserLabelY = firstLineY + firstLineH + _baseSpace;
    float pushUserLabelW = 72.0f;
    float pushUserLabelH = 17.0f;
    [_pushUserLabel setFrame:CGRectMake(pushUserLabelX, pushUserLabelY, pushUserLabelW, pushUserLabelH)];
    
    // 人名
    float userLabelX = _baseSpace + 17 + pushUserLabelW;
    float userLabelY = pushUserLabelY;
    float userLabelW = frameWidth - pushUserLabelW - _baseSpace * 2;
    float userLabelH = 17.0f;
    [_userLabel setFrame:CGRectMake(userLabelX, userLabelY, userLabelW, userLabelH)];
    
    // 推送时间
    float pushDateLabelX = _baseSpace + 17;
    float pushDateLabelY = userLabelY + userLabelH + _baseSpace;
    float pushDateLabelW = 72.0f;
    float pushDateLabelH = 17.0f;
    if([_messageDetailModel.user isEqualToString:@"系统推送"]){
        _userImg.hidden = YES;
        _pushUserLabel.hidden = YES;
        _userLabel.hidden = YES;
        
        pushDateLabelY = firstLineY + firstLineH + _baseSpace;
    }else{
        _userImg.hidden = NO;
        _pushUserLabel.hidden = NO;
        _userLabel.hidden = NO;
        
        // 用户图标
        float userImgX = _baseSpace;
        float userImgY = pushUserLabelY+2;
        float userImgW = 13.0f;
        float userImgH = 13.0f;
        [_userImg setFrame:CGRectMake(userImgX, userImgY, userImgW, userImgH)];
    }
    [_pushDateLabel setFrame:CGRectMake(pushDateLabelX, pushDateLabelY, pushDateLabelW, pushDateLabelH)];
    
    // 推送时间图标
    float pushDateImgX = _baseSpace;
    float pushDateImgY = pushDateLabelY+2;
    float pushDateImgW = 13.0f;
    float pushDateImgH = 13.0f;
    [_pushDateImg setFrame:CGRectMake(pushDateImgX, pushDateImgY, pushDateImgW, pushDateImgH)];
    
    // 时间
    float dateLabelX = _baseSpace + 17 + pushDateLabelW;
    float dateLabelY = pushDateLabelY;
    float dateLabelW = frameWidth - pushDateLabelW - _baseSpace * 2;
    float dateLabelH = 17.0f;
    [_dateLabel setFrame:CGRectMake(dateLabelX, dateLabelY, dateLabelW, dateLabelH)];
    
    // 摘要
    float abstractLabelX = _baseSpace + 17;
    float abstractLabelY = dateLabelY + dateLabelH + _baseSpace;
    float abstractLabelW = 72.0f;
    float abstractLabelH = 17.0f;
    [_abstractLabel setFrame:CGRectMake(abstractLabelX, abstractLabelY, abstractLabelW, abstractLabelH)];
    
    // 摘要图标
    float abstractImgX = _baseSpace;
    float abstractImgY = abstractLabelY+2;
    float abstractImgW = 13.0f;
    float abstractImgH = 13.0f;
    [_abstractImg setFrame:CGRectMake(abstractImgX, abstractImgY, abstractImgW, abstractImgH)];
    
    // 摘要内容
    float contentLabelX = _baseSpace + 17 + abstractLabelW;
    float contentLabelY = abstractLabelY;
    CGSize contentSize = [[BaseHandleUtil shareInstance] sizeWithString:_messageDetailModel.content font:CONTENT_FONT maxSize:CGSizeMake(frameWidth - abstractLabelW, MAXFLOAT)];
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
        float detailLabelX = _baseSpace + 17;
        float detailLabelY = secondLineY + secondLineH + _baseSpace;
        float detailLabelW = frameWidth;
        float detailLabelH = 17.0f;
        [_detailLabel setFrame:CGRectMake(detailLabelX, detailLabelY, detailLabelW, detailLabelH)];
        
        // 链接图标
        _linkImg.hidden = NO;
        float linkImgX = _baseSpace;
        float linkImgY = detailLabelY+2;
        float linkImgW = 13.0f;
        float linkImgH = 13.0f;
        [_linkImg setFrame:CGRectMake(linkImgX, linkImgY, linkImgW, linkImgH)];
        
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
        _linkImg.hidden = YES;
        _arrowImageView.hidden = YES;
        
        self.selected = UITableViewCellSelectionStyleNone; // 点击不变色
        
        // 计算cell高度
        cellHeight = contentLabelY + contentLabelH + _baseSpace;
    }
    
    _messageDetailModel.cellHeight = cellHeight;
    
    // 设置基本视图的frame
    _baseView.frame = CGRectMake(15, 0, WIDTH_SCREEN-30, cellHeight);
    [_baseView setImage:[UIImage imageNamed:@"msg_detail_bg" scaleToSize:_baseView.size]];
    
    // 点击效果
    /*
    UIView *backView = [[UIView alloc] initWithFrame:_baseView.frame];
    self.selectedBackgroundView = backView;
    [backView.layer setCornerRadius:5.0f];
    */
    //self.selectedBackgroundView.backgroundColor = [UIColor redColor];
    
}

#pragma mark - Common Getter and Setter
-(UIImageView *)baseView{
    if(_baseView == nil){
        _baseView = [[UIImageView alloc] init];
        _baseView.layer.masksToBounds = YES;
        [_baseView.layer setCornerRadius:5.0f];
        
        [_baseView addSubview:self.titleLabel];
        [_baseView addSubview:self.userImg];
        [_baseView addSubview:self.pushUserLabel];
        [_baseView addSubview:self.userLabel];
        [_baseView addSubview:self.pushDateImg];
        [_baseView addSubview:self.pushDateLabel];
        [_baseView addSubview:self.dateLabel];
        [_baseView addSubview:self.firstLine];
        [_baseView addSubview:self.abstractImg];
        [_baseView addSubview:self.abstractLabel];
        [_baseView addSubview:self.contentLabel];
        [_baseView addSubview:self.secondLine];
        [_baseView addSubview:self.linkImg];
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

- (UIImageView *)userImg{
    if(_userImg == nil){
        _userImg = [[UIImageView alloc] init];
        _userImg.hidden = YES;
        [_userImg setImage:[UIImage imageNamed:@"msg_user"]];
    }
    return _userImg;
}

- (UILabel *)pushUserLabel{
    if(_pushUserLabel == nil){
        _pushUserLabel = [[UILabel alloc] init];
        _pushUserLabel.text = @"推送人员：";
        [_pushUserLabel setFont:CONTENT_FONT];
        [_pushUserLabel setTextAlignment:NSTextAlignmentLeft];
        [_pushUserLabel setTextColor:[UIColor blackColor]];
    }
    return _pushUserLabel;
}

- (UILabel *)userLabel{
    if(_userLabel == nil){
        _userLabel = [[UILabel alloc] init];
        [_userLabel setFont:CONTENT_FONT];
        [_userLabel setAlpha:0.8f];
        [_userLabel setTextAlignment:NSTextAlignmentLeft];
        [_userLabel setTextColor:[UIColor grayColor]];
    }
    return _userLabel;
}

- (UIImageView *)pushDateImg{
    if(_pushDateImg == nil){
        _pushDateImg = [[UIImageView alloc] init];
        [_pushDateImg setImage:[UIImage imageNamed:@"msg_date"]];
    }
    return _pushDateImg;
}

- (UILabel *)pushDateLabel{
    if(_pushDateLabel == nil){
        _pushDateLabel = [[UILabel alloc] init];
        _pushDateLabel.text = @"推送时间：";
        [_pushDateLabel setFont:CONTENT_FONT];
        [_pushDateLabel setTextAlignment:NSTextAlignmentLeft];
        [_pushDateLabel setTextColor:[UIColor blackColor]];
    }
    return _pushDateLabel;
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

- (UIImageView *)abstractImg{
    if(_abstractImg == nil){
        _abstractImg = [[UIImageView alloc] init];
        [_abstractImg setImage:[UIImage imageNamed:@"msg_abstract"]];
    }
    return _abstractImg;
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

- (UIImageView *)linkImg{
    if(_linkImg == nil){
        _linkImg = [[UIImageView alloc] init];
        _linkImg.hidden = YES;
        [_linkImg setImage:[UIImage imageNamed:@"msg_link"]];
    }
    return _linkImg;
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

@end
