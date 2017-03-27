/************************************************************
 Class    : MapListViewCell.m
 Describe : 自定义地图机构列表Cell
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-02-20
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "MapListViewCell.h"

@interface MapListViewCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *logoImageView;

@end

@implementation MapListViewCell

#pragma mark - 初始化cell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        [self addSubview:self.logoImageView];
        [self addSubview:self.nameLabel];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if(_model.isExpand){
        switch (_model.level) {
            case 0:
                self.logoImageView.frame = CGRectMake(10.0f, 15.0f, 20.0f, 20.0f);
                self.logoImageView.image = [UIImage imageNamed:@"map_group"];
                self.nameLabel.frame = CGRectMake(40.0f, 5.0f, WIDTH_SCREEN-50, 40.0f);
                break;
            case 1:
                self.logoImageView.frame = CGRectMake(40.0f, 15.0f, 20.0f, 20.0f);
                self.logoImageView.image = [UIImage imageNamed:@"map_station"];
                self.nameLabel.frame = CGRectMake(70.0f, 5.0f, WIDTH_SCREEN-80, 40.0f);
                break;
            case 2:
                self.logoImageView.frame = CGRectMake(70.0f, 15.0f, 20.0f, 20.0f);
                self.logoImageView.image = [UIImage imageNamed:@"map_institute"];
                self.nameLabel.frame = CGRectMake(100.0f, 5.0f, WIDTH_SCREEN-110, 40.0f);
                break;
            default:
                break;
        }
    }
    
}

#pragma mark - 重写Setter、Getter方法
- (void)setModel:(MapListModel *)model{
    _model = model;
    
    if(model.name){
        self.nameLabel.text = model.name;
    }
    
    [self layoutSubviews];
}

-(UIImageView *)logoImageView{
    if(_logoImageView == nil){
        _logoImageView = [[UIImageView alloc] init];
    }
    return _logoImageView;
}

- (UILabel *)nameLabel{
    if(_nameLabel == nil){
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.numberOfLines = 0;
        _nameLabel.font = [UIFont systemFontOfSize:15.0f];
    }
    return _nameLabel;
}

@end
