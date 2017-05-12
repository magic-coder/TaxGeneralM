/************************************************************
 Class    : MessageListViewCell.m
 Describe : 消息列表界面自定义cell
 Company  : Prient
 Author   : Yanzheng
 Date     : 2016-08-15
 Version  : 1.0
 Declare  : Copyright © 2016 Yanzheng. All rights reserved.
 ************************************************************/

#import "MessageListViewCell.h"

@interface MessageListViewCell()

@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIView *bottomLine;

@property (nonatomic, assign) float leftFreeSpace;

@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIImageView *redMarkView;
@property (nonatomic, strong) UILabel *redMark;

@end

@implementation MessageListViewCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _topLineStyle = CellLineStyleNone;
        _bottomLineStyle = CellLineStyleDefault;
        
        [self addSubview:self.avatarView];
        [self addSubview:self.nameLabel];
        [self addSubview:self.dateLabel];
        [self addSubview:self.messageLabel];
        [self addSubview:self.redMarkView];
    }
    return self;
}

- (void) layoutSubviews{
    [super layoutSubviews];
    
    [self.topLine setOriginY:0];
    [self.bottomLine setOriginY:self.frameHeight - _bottomLine.frameHeight];
    [self setBottomLineStyle:_bottomLineStyle];
    [self setTopLineStyle:_topLineStyle];
    
    //self.leftFreeSpace = self.frameHeight * 0.18;
    self.leftFreeSpace = 12;
    
    float imageWidth = self.frameHeight * 0.72;
    float space = self.leftFreeSpace;
    [_avatarView setFrame:CGRectMake(space, space, imageWidth, imageWidth)];
    
    float redMarkX = space + imageWidth;
    float redMarkY = space;
    float redMarkW = 24;
    float redMarkH = 24;
    [_redMarkView setFrame:CGRectMake(redMarkX - 12, redMarkY - 12, redMarkW, redMarkH)];
    
    float labelX = space * 2 + imageWidth;
    float labelY = self.frameHeight * 0.135;
    float labelHeight = self.frameHeight * 0.4;
    float labelWidth = self.frameWidth - labelX - space * 1.5;
    
    float dateWidth = 120;
    float dateHeight = labelHeight * 0.75;
    float dateX = self.frameWidth - space - dateWidth;
    [_dateLabel setFrame:CGRectMake(dateX, labelY * 0.7, dateWidth, dateHeight)];
    
    float usernameLabelWidth = self.frameWidth - labelX - dateWidth - space;
    [_nameLabel setFrame:CGRectMake(labelX, labelY, usernameLabelWidth, labelHeight)];
    
    labelY = self.frameHeight * 0.91 - labelHeight;
    [_messageLabel setFrame:CGRectMake(labelX, labelY, labelWidth, labelHeight)];
}

- (void) setMessageListModel:(MessageListModel *)messageListModel{
    _messageListModel = messageListModel;
    
    [_avatarView setImage:[UIImage imageNamed:_messageListModel.avatar]];
    [_nameLabel setText:_messageListModel.name];
    [_dateLabel setText:_messageListModel.date];
    [_messageLabel setText:_messageListModel.message];
    
    if([_messageListModel.unReadCount intValue] > 0){
        _redMarkView.hidden = NO;
        [_redMark setText:_messageListModel.unReadCount];
    }else{
        _redMarkView.hidden = YES;
    }
    
    [self layoutSubviews];
}

#pragma mark - Common Getter and Setter
- (UIView *) topLine{
    if (_topLine == nil) {
        _topLine = [[UIView alloc] init];
        [_topLine setFrameHeight:0.5f];
        [_topLine setBackgroundColor:[UIColor grayColor]];
        [_topLine setAlpha:0.4];
        [self.contentView addSubview:_topLine];
    }
    return _topLine;
}

- (UIView *) bottomLine{
    if (_bottomLine == nil) {
        _bottomLine = [[UIView alloc] init];
        [_bottomLine setFrameHeight:0.5f];
        [_bottomLine setBackgroundColor:[UIColor grayColor]];
        [_bottomLine setAlpha:0.4];
        [self.contentView addSubview:_bottomLine];
    }
    return _bottomLine;
}

- (void) setTopLineStyle:(CellLineStyle)style{
    _topLineStyle = style;
    if (style == CellLineStyleDefault) {
        [self.topLine setOriginX:_leftFreeSpace];
        [self.topLine setFrameWidth:self.frameWidth - _leftFreeSpace];
        [self.topLine setHidden:NO];
    }else if (style == CellLineStyleFill) {
        [self.topLine setOriginX:0];
        [self.topLine setFrameWidth:self.frameWidth];
        [self.topLine setHidden:NO];
    }else if (style == CellLineStyleNone) {
        [self.topLine setHidden:YES];
    }
}

- (void) setBottomLineStyle:(CellLineStyle)style{
    _bottomLineStyle = style;
    if (style == CellLineStyleDefault) {
        [self.bottomLine setOriginX:_leftFreeSpace];
        [self.bottomLine setFrameWidth:self.frameWidth - _leftFreeSpace];
        [self.bottomLine setHidden:NO];
    }else if (style == CellLineStyleFill) {
        [self.bottomLine setOriginX:0];
        [self.bottomLine setFrameWidth:self.frameWidth];
        [self.bottomLine setHidden:NO];
    }else if (style == CellLineStyleNone) {
        [self.bottomLine setHidden:YES];
    }
}

#pragma mark - Getter
- (UIImageView *) avatarView{
    if (_avatarView == nil) {
        _avatarView = [[UIImageView alloc] init];
        [_avatarView.layer setMasksToBounds:YES];
        [_avatarView.layer setCornerRadius:5.0f];
    }
    return _avatarView;
}

- (UILabel *) nameLabel{
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        [_nameLabel setFont:[UIFont systemFontOfSize:16]];
    }
    return _nameLabel;
}

- (UILabel *) dateLabel{
    if (_dateLabel == nil) {
        _dateLabel = [[UILabel alloc] init];
        [_dateLabel setAlpha:0.8];
        [_dateLabel setFont:[UIFont systemFontOfSize:12]];
        [_dateLabel setTextAlignment:NSTextAlignmentRight];
        [_dateLabel setTextColor:[UIColor grayColor]];
    }
    return _dateLabel;
}

- (UILabel *) messageLabel{
    if (_messageLabel == nil) {
        _messageLabel = [[UILabel alloc] init];
        [_messageLabel setTextColor:[UIColor grayColor]];
        [_messageLabel setFont:[UIFont systemFontOfSize:14]];
    }
    return _messageLabel;
}

-(UIImageView *)redMarkView{
    if(_redMarkView == nil){
        _redMarkView = [[UIImageView alloc] init];
        [_redMarkView setImage:[UIImage imageNamed:@"msg_red_mark"]];
        _redMarkView.layer.masksToBounds = YES;
        _redMarkView.layer.cornerRadius = 12.0f;
        [_redMarkView addSubview:self.redMark];
    }
    return _redMarkView;
}

- (UILabel *)redMark{
    if(_redMark == nil){
        _redMark = [[UILabel alloc] init];
        [_redMark setFrame:CGRectMake(0, 0, 24, 24)];
        [_redMark setTextColor:[UIColor whiteColor]];
        [_redMark setFont:[UIFont boldSystemFontOfSize:12]];
        [_redMark setTextAlignment:NSTextAlignmentCenter];
        _redMark.layer.masksToBounds = YES;
        _redMark.layer.cornerRadius = 12.0f;
    }
    return _redMark;
}

@end
