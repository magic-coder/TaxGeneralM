/************************************************************
 Class    : YZMenu.m
 Describe : 自定义按钮气泡弹出气泡菜单效果
 Company  : Prient
 Author   : Yanzheng
 Date     : 2017-02-27
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "YZMenu.h"
#import <QuartzCore/QuartzCore.h>

NSString * const YZMenuWillAppearNotification = @"YZMenuWillAppearNotification";
NSString * const YZMenuDidAppearNotification = @"YZMenuDidAppearNotification";
NSString * const YZMenuWillDisappearNotification = @"YZMenuWillDisappearNotification";
NSString * const YZMenuDidDisappearNotification = @"YZMenuDidDisappearNotification";

#define kArrowSize      10.0f   //!< 箭头尺寸
#define kCornerRadius   6.0f    //!< 圆角
#define kTintColor  [UIColor colorWithRed:81.0f/255.0f green:81.0f/255.0f blue:81.0f/255.0f alpha:1.0f]  // 主题颜色
#define kSelectedColor [UIColor colorWithRed:112.0f/255.0f green:112.0f/255.0f blue:112.0f/255.0f alpha:1.0f]
#define kTitleFont  [UIFont systemFontOfSize:16.0]

#define kSeparatorInsetLeft     0
#define kSeparatorInsetRight    0
#define kSeparatorHeight        0.5
#define kSeparatorColor [UIColor colorWithRed:138.0f/255.0f green:138.0f/255.0f blue:138.0f/255.0f alpha:1.0f]
#define kMenuViewInsetTop       0
#define kMenuViewInsetBottom    0

const CGFloat kMenuItemMarginY = 12.f;


/// 背景色
static UIColor  *gTintColor;
/// 箭头尺寸
static CGFloat  gArrowSize = kArrowSize;
/// 圆角
CGFloat         gCornerRadius = kCornerRadius;
/// 字体
static UIFont   *gTitleFont;
/// 背景色效果
static YZMenuBackgrounColorEffect   gBackgroundColorEffect = YZMenuBackgrounColorEffectSolid;
/// 是否显示阴影
static BOOL     gHasShadow = NO;
/// 选中颜色（默认蓝色）
static UIColor  *gSelectedColor;
/// 分割线颜色
static UIColor  *gSeparatorColor;
/// 菜单原始的垂直边距值
static CGFloat  gMenuItemMarginY = kMenuItemMarginY;

//@property (nonatomic) UIEdgeInsets separatorInset NS_AVAILABLE_IOS(7_0) UI_APPEARANCE_SELECTOR; // allows customization of the frame of cell separators

typedef enum {
    
    YZMenuViewArrowDirectionNone,
    YZMenuViewArrowDirectionUp,
    YZMenuViewArrowDirectionDown,
    YZMenuViewArrowDirectionLeft,
    YZMenuViewArrowDirectionRight,
    
} YZMenuViewArrowDirection;


@interface YZMenuView : UIView

/**
 *  @method
 *  @brief 隐藏Menu
 *
 *  @param animated 是否有动画
 */
- (void)dismissMenu:(BOOL)animated;

@end


@interface YZMenuOverlay : UIView

@end

@interface YZMenu ()

+ (instancetype)sharedMenu;

/// 视图当前是否显示
@property(nonatomic, assign) BOOL isShow;

/// 重置属性
+ (void)reset;

@end

#pragma mark - YZMenuOverlay

@implementation YZMenuOverlay

#pragma mark System Methods
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        
        UITapGestureRecognizer *gestureRecognizer;
        gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [self addGestureRecognizer:gestureRecognizer];
    }
    return self;
}

- (void)singleTap:(UITapGestureRecognizer *)recognizer {
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[YZMenuView class]] && [view respondsToSelector:@selector(dismissMenu:)]) {
            [view performSelector:@selector(dismissMenu:) withObject:@(YES)];
        }
    }
}
@end



#pragma mark - YZMenuView
@implementation YZMenuView {
    YZMenuViewArrowDirection _arrowDirection;
    CGFloat _arrowPosition;
    UIView *_contentView;
    NSArray *_menuItems;
    YZMenuSelectedItem _selectedItem;
}

#pragma mark System Methods
- (id)init {
    self = [super initWithFrame:CGRectZero];
    if(self) {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = YES;
        self.alpha = 0;
        
        if ([YZMenu hasShadow]) {
            self.layer.shadowOpacity = 0.5;
            self.layer.shadowColor = [YZMenu tintColor].CGColor;
            self.layer.shadowOffset = CGSizeMake(2, 2);
            self.layer.shadowRadius = 2;
        }
    }
    return self;
}


- (void)setupFrameInView:(UIView *)view fromRect:(CGRect)fromRect {
    const CGSize contentSize = _contentView.frame.size;
    
    const CGFloat outerWidth = view.bounds.size.width;
    const CGFloat outerHeight = view.bounds.size.height;
    
    const CGFloat rectX0 = fromRect.origin.x;
    const CGFloat rectX1 = fromRect.origin.x + fromRect.size.width;
    const CGFloat rectXM = fromRect.origin.x + fromRect.size.width * 0.5f;
    const CGFloat rectY0 = fromRect.origin.y;
    const CGFloat rectY1 = fromRect.origin.y + fromRect.size.height;
    const CGFloat rectYM = fromRect.origin.y + fromRect.size.height * 0.5f;;
    
    const CGFloat widthPlusArrow = contentSize.width + [YZMenu arrowSize];
    const CGFloat heightPlusArrow = contentSize.height + [YZMenu arrowSize];
    const CGFloat widthHalf = contentSize.width * 0.5f;
    const CGFloat heightHalf = contentSize.height * 0.5f;
    
    const CGFloat kMargin = 5.f;
    
    if (heightPlusArrow < (outerHeight - rectY1)) {
        
        _arrowDirection = YZMenuViewArrowDirectionUp;
        CGPoint point = (CGPoint){
            rectXM - widthHalf,
            rectY1
        };
        
        if (point.x < kMargin)
            point.x = kMargin;
        
        if ((point.x + contentSize.width + kMargin) > outerWidth)
            point.x = outerWidth - contentSize.width - kMargin;
        
        _arrowPosition = rectXM - point.x;
        _contentView.frame = (CGRect){0, [YZMenu arrowSize], contentSize};
        
        self.frame = (CGRect) {
            
            point,
            contentSize.width,
            contentSize.height + [YZMenu arrowSize]
        };
        
    } else if (heightPlusArrow < rectY0) {
        
        _arrowDirection = YZMenuViewArrowDirectionDown;
        CGPoint point = (CGPoint){
            rectXM - widthHalf,
            rectY0 - heightPlusArrow
        };
        
        if (point.x < kMargin)
            point.x = kMargin;
        
        if ((point.x + contentSize.width + kMargin) > outerWidth)
            point.x = outerWidth - contentSize.width - kMargin;
        
        _arrowPosition = rectXM - point.x;
        _contentView.frame = (CGRect){CGPointZero, contentSize};
        
        self.frame = (CGRect) {
            
            point,
            contentSize.width,
            contentSize.height + [YZMenu arrowSize]
        };
        
    } else if (widthPlusArrow < (outerWidth - rectX1)) {
        
        _arrowDirection = YZMenuViewArrowDirectionLeft;
        CGPoint point = (CGPoint){
            rectX1,
            rectYM - heightHalf
        };
        
        if (point.y < kMargin)
            point.y = kMargin;
        
        if ((point.y + contentSize.height + kMargin) > outerHeight)
            point.y = outerHeight - contentSize.height - kMargin;
        
        _arrowPosition = rectYM - point.y;
        _contentView.frame = (CGRect){[YZMenu arrowSize], 0, contentSize};
        
        self.frame = (CGRect) {
            
            point,
            contentSize.width + [YZMenu arrowSize],
            contentSize.height
        };
        
    } else if (widthPlusArrow < rectX0) {
        
        _arrowDirection = YZMenuViewArrowDirectionRight;
        CGPoint point = (CGPoint){
            rectX0 - widthPlusArrow,
            rectYM - heightHalf
        };
        
        if (point.y < kMargin)
            point.y = kMargin;
        
        if ((point.y + contentSize.height + 5) > outerHeight)
            point.y = outerHeight - contentSize.height - kMargin;
        
        _arrowPosition = rectYM - point.y;
        _contentView.frame = (CGRect){CGPointZero, contentSize};
        
        self.frame = (CGRect) {
            
            point,
            contentSize.width  + [YZMenu arrowSize],
            contentSize.height
        };
        
    } else {
        
        _arrowDirection = YZMenuViewArrowDirectionNone;
        
        self.frame = (CGRect) {
            
            (outerWidth - contentSize.width)   * 0.5f,
            (outerHeight - contentSize.height) * 0.5f,
            contentSize,
        };
    }
}

- (void)showMenuInView:(UIView *)view fromRect:(CGRect)rect menuItems:(NSArray *)menuItems selected:(YZMenuSelectedItem)selectedItem {
    _menuItems = menuItems;
    _selectedItem = selectedItem;
    _contentView = [self mkContentView];
    [self addSubview:_contentView];
    
    [self setupFrameInView:view fromRect:rect];
    
    YZMenuOverlay *overlay = [[YZMenuOverlay alloc] initWithFrame:view.bounds];
    [overlay addSubview:self];
    [view addSubview:overlay];
    
    _contentView.hidden = YES;
    const CGRect toFrame = self.frame;
    self.frame = (CGRect){self.arrowPoint, 1, 1};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:YZMenuWillAppearNotification object:nil];
    
    [UIView animateWithDuration:0.2 animations:^(void) {
        
        self.alpha = 1.0f;
        self.frame = toFrame;
        
    } completion:^(BOOL completed) {
        _contentView.hidden = NO;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:YZMenuDidAppearNotification object:nil];
    }];
}

- (void)dismissMenu:(BOOL)animated {
    if (self.superview) {
        [[NSNotificationCenter defaultCenter] postNotificationName:YZMenuWillDisappearNotification object:nil];
        
        __weak typeof(self) weakSelf = self;
        void (^removeView)(void) = ^(void) {
            if ([weakSelf.superview isKindOfClass:[YZMenuOverlay class]])
                [weakSelf.superview removeFromSuperview];
            [weakSelf removeFromSuperview];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:YZMenuDidDisappearNotification object:nil];
        };
        
        if (animated) {
            _contentView.hidden = YES;
            const CGRect toFrame = (CGRect){self.arrowPoint, 1, 1};
            [UIView animateWithDuration:0.2 animations:^(void) {
                self.alpha = 0;
                self.frame = toFrame;
            } completion:^(BOOL finished) {
                removeView();
            }];
        }
        else {
            removeView();
        }
    }
    [YZMenu sharedMenu].isShow = NO;
}

- (void)performAction:(id)sender {
    [self dismissMenu:YES];
    UIButton *button = (UIButton *)sender;
    YZMenuItem *menuItem = _menuItems[button.tag];
    [menuItem performAction];
    if (_selectedItem) {
        _selectedItem(button.tag, menuItem);
    }
}

- (UIView *)mkContentView {
    for (UIView *v in self.subviews) {
        [v removeFromSuperview];
    }
    
    if (!_menuItems.count)
        return nil;
    
    const CGFloat kMinMenuItemHeight = 32.f;
    const CGFloat kMinMenuItemWidth = 32.f;
    const CGFloat kMarginX = 10.f;
    
    UIFont *titleFont = [YZMenu titleFont];
    
    CGFloat maxImageWidth = 0;
    CGFloat maxItemHeight = 0;
    CGFloat maxItemWidth = 0;
    
    for (YZMenuItem *menuItem in _menuItems) {
        const CGSize imageSize = menuItem.image.size;
        if (imageSize.width > maxImageWidth)
            maxImageWidth = imageSize.width;
    }
    
    if (maxImageWidth) {
        maxImageWidth += kMarginX;
    }
    
    for (YZMenuItem *menuItem in _menuItems) {
        
        const CGSize titleSize = [menuItem.title sizeWithAttributes:@{NSFontAttributeName:menuItem.titleFont?menuItem.titleFont:titleFont}];
        //const CGSize titleSize = [menuItem.title sizeWithFont:titleFont];
        const CGSize imageSize = menuItem.image.size;
        
        const CGFloat itemHeight = MAX(titleSize.height, imageSize.height) + [YZMenu menuItemMarginY] * 2;
        const CGFloat itemWidth = ((!menuItem.enabled && !menuItem.image) ? titleSize.width : maxImageWidth + titleSize.width) + kMarginX * 4;
        
        if (itemHeight > maxItemHeight)
            maxItemHeight = itemHeight;
        
        if (itemWidth > maxItemWidth)
            maxItemWidth = itemWidth;
    }
    
    maxItemWidth  = MAX(maxItemWidth, kMinMenuItemWidth);
    maxItemHeight = MAX(maxItemHeight, kMinMenuItemHeight);
    
    const CGFloat titleX = kMarginX * 2 + maxImageWidth;
    const CGFloat titleWidth = maxItemWidth - titleX - kMarginX * 2;
    
    UIImage *selectedImage = [YZMenuView selectedImage:(CGSize){maxItemWidth, maxItemHeight}];
    
    UIImage *gradientLine = [YZMenuView gradientLineWithColor:[YZMenu separatorColor]];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectZero];
    contentView.autoresizingMask = UIViewAutoresizingNone;
    contentView.backgroundColor = [UIColor clearColor];
    contentView.opaque = NO;
    contentView.layer.cornerRadius = gCornerRadius;
    [contentView setClipsToBounds:YES];
    
    CGFloat itemY = kMenuViewInsetTop;
    NSUInteger itemNum = 0;
    
    for (YZMenuItem *menuItem in _menuItems) {
        
        const CGRect itemFrame = (CGRect){0, itemY, maxItemWidth, maxItemHeight};
        
        UIView *itemView = [[UIView alloc] initWithFrame:itemFrame];
        itemView.autoresizingMask = UIViewAutoresizingNone;
        itemView.backgroundColor = [UIColor clearColor];
        itemView.opaque = NO;
        
        [contentView addSubview:itemView];
        
        if (menuItem.enabled) {
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = itemNum;
            button.frame = CGRectMake(0, 0, itemView.frame.size.width, itemView.frame.size.height);
            button.enabled = menuItem.enabled;
            button.backgroundColor = [UIColor clearColor];
            button.opaque = NO;
            button.autoresizingMask = UIViewAutoresizingNone;
            
            [button addTarget:self
                       action:@selector(performAction:)
             forControlEvents:UIControlEventTouchUpInside];
            [button setBackgroundImage:selectedImage forState:UIControlStateHighlighted];
            
            [itemView addSubview:button];
        }
        
        if (menuItem.title.length) {
            
            CGRect titleFrame;
            
            if (!menuItem.enabled && !menuItem.image) {
                
                titleFrame = (CGRect){
                    kMarginX * 2,
                    [YZMenu menuItemMarginY],
                    maxItemWidth - kMarginX * 4,
                    maxItemHeight - [YZMenu menuItemMarginY] * 2
                };
                
            } else {
                
                titleFrame = (CGRect){
                    titleX,
                    [YZMenu menuItemMarginY],
                    titleWidth,
                    maxItemHeight - [YZMenu menuItemMarginY] * 2
                };
            }
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleFrame];
            titleLabel.text = menuItem.title;
            titleLabel.font = menuItem.titleFont ? menuItem.titleFont : titleFont;
            titleLabel.textAlignment = menuItem.alignment;
            titleLabel.textColor = menuItem.foreColor ? menuItem.foreColor : [UIColor whiteColor];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.autoresizingMask = UIViewAutoresizingNone;
            [itemView addSubview:titleLabel];
        }
        
        if (menuItem.image) {
            
            const CGRect imageFrame = {kMarginX * 2, [YZMenu menuItemMarginY], maxImageWidth, maxItemHeight - [YZMenu menuItemMarginY] * 2};
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageFrame];
            imageView.image = menuItem.image;
            imageView.clipsToBounds = YES;
            imageView.contentMode = UIViewContentModeCenter;
            imageView.autoresizingMask = UIViewAutoresizingNone;
            [itemView addSubview:imageView];
        }
        
        if (itemNum < _menuItems.count - 1) {
            
            UIImageView *gradientView = [[UIImageView alloc] initWithImage:gradientLine];
            gradientView.frame = (CGRect){kSeparatorInsetLeft, maxItemHeight, maxItemWidth - kSeparatorInsetLeft - kSeparatorInsetRight, kSeparatorHeight};
            gradientView.contentMode = UIViewContentModeScaleToFill;
            [itemView addSubview:gradientView];
            
            itemY += gradientView.frame.size.height;
            
            [itemView bringSubviewToFront:gradientView];
        }
        
        itemY += maxItemHeight;
        ++itemNum;
    }
    
    contentView.frame = (CGRect){0, 0, maxItemWidth, itemY + kMenuViewInsetBottom};
    
    return contentView;
}

- (CGPoint)arrowPoint {
    CGPoint point;
    
    if (_arrowDirection == YZMenuViewArrowDirectionUp) {
        
        point = (CGPoint){ CGRectGetMinX(self.frame) + _arrowPosition, CGRectGetMinY(self.frame) };
        
    } else if (_arrowDirection == YZMenuViewArrowDirectionDown) {
        
        point = (CGPoint){ CGRectGetMinX(self.frame) + _arrowPosition, CGRectGetMaxY(self.frame) };
        
    } else if (_arrowDirection == YZMenuViewArrowDirectionLeft) {
        
        point = (CGPoint){ CGRectGetMinX(self.frame), CGRectGetMinY(self.frame) + _arrowPosition  };
        
    } else if (_arrowDirection == YZMenuViewArrowDirectionRight) {
        
        point = (CGPoint){ CGRectGetMaxX(self.frame), CGRectGetMinY(self.frame) + _arrowPosition  };
        
    } else {
        
        point = self.center;
    }
    
    return point;
}
/**
 *  渐变颜色的图片
 */
+ (UIImage *)selectedImage:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[YZMenu selectedColor] CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)gradientLineWithColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return theImage;
    
}

/*
 + (UIImage *)gradientLine:(CGSize)size {
 const CGFloat locations[5] = {0,0.2,0.5,0.8,1};
 const CGFloat R = 0.44f, G = 0.44f, B = 0.44f;
 const CGFloat components[20] = {
 R,G,B,0.1,
 R,G,B,0.4,
 R,G,B,0.7,
 R,G,B,0.4,
 R,G,B,0.1
 };
 
 return [self gradientImageWithSize:size locations:locations components:components count:5];
 }
 
 + (UIImage *)gradientImageWithSize:(CGSize) size locations:(const CGFloat []) locations components:(const CGFloat []) components count:(NSUInteger)count {
 UIGraphicsBeginImageContextWithOptions(size, NO, 0);
 CGContextRef context = UIGraphicsGetCurrentContext();
 
 CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
 CGGradientRef colorGradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, 2);
 CGColorSpaceRelease(colorSpace);
 CGContextDrawLinearGradient(context, colorGradient, (CGPoint){0, 0}, (CGPoint){size.width, 0}, 0);
 CGGradientRelease(colorGradient);
 
 UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
 UIGraphicsEndImageContext();
 return image;
 }
 */

- (void)drawRect:(CGRect)rect {
    [self drawBackground:self.bounds inContext:UIGraphicsGetCurrentContext()];
    // 绘制完成后,初始静态变量值
    // 防止下次调用控件时沿用上一次设置的属性
    [YZMenu reset];
}

- (void)drawBackground:(CGRect)frame inContext:(CGContextRef) context {
    CGFloat R0 = 0.0, G0 = 0.0, B0 = 0.0;
    CGFloat R1 = 0.0, G1 = 0.0, B1 = 0.0;
    
    UIColor *tintColor = [YZMenu tintColor];
    if (tintColor) {
        CGFloat a;
        [tintColor getRed:&R0 green:&G0 blue:&B0 alpha:&a];
        [tintColor getRed:&R1 green:&G1 blue:&B1 alpha:&a];
    }
    
    if ([YZMenu backgrounColorEffect] == YZMenuBackgrounColorEffectGradient) {
        R1-=0.2;
        G1-=0.2;
        B1-=0.2;
    }
    
    CGFloat X0 = frame.origin.x;
    CGFloat X1 = frame.origin.x + frame.size.width;
    CGFloat Y0 = frame.origin.y;
    CGFloat Y1 = frame.origin.y + frame.size.height;
    
    // render arrow
    
    UIBezierPath *arrowPath = [UIBezierPath bezierPath];
    
    // fix the issue with gap of arrow's base if on the edge
    const CGFloat kEmbedFix = 3.f;
    
    if (_arrowDirection == YZMenuViewArrowDirectionUp) {
        
        const CGFloat arrowXM = _arrowPosition;
        const CGFloat arrowX0 = arrowXM - [YZMenu arrowSize];
        const CGFloat arrowX1 = arrowXM + [YZMenu arrowSize];
        const CGFloat arrowY0 = Y0;
        const CGFloat arrowY1 = Y0 + [YZMenu arrowSize] + kEmbedFix;
        
        [arrowPath moveToPoint:    (CGPoint){arrowXM, arrowY0}];
        [arrowPath addLineToPoint: (CGPoint){arrowX1, arrowY1}];
        [arrowPath addLineToPoint: (CGPoint){arrowX0, arrowY1}];
        [arrowPath addLineToPoint: (CGPoint){arrowXM, arrowY0}];
        
        [[UIColor colorWithRed:R0 green:G0 blue:B0 alpha:1] set];
        
        Y0 += [YZMenu arrowSize];
        
    } else if (_arrowDirection == YZMenuViewArrowDirectionDown) {
        
        const CGFloat arrowXM = _arrowPosition;
        const CGFloat arrowX0 = arrowXM - [YZMenu arrowSize];
        const CGFloat arrowX1 = arrowXM + [YZMenu arrowSize];
        const CGFloat arrowY0 = Y1 - [YZMenu arrowSize] - kEmbedFix;
        const CGFloat arrowY1 = Y1;
        
        [arrowPath moveToPoint:    (CGPoint){arrowXM, arrowY1}];
        [arrowPath addLineToPoint: (CGPoint){arrowX1, arrowY0}];
        [arrowPath addLineToPoint: (CGPoint){arrowX0, arrowY0}];
        [arrowPath addLineToPoint: (CGPoint){arrowXM, arrowY1}];
        
        [[UIColor colorWithRed:R1 green:G1 blue:B1 alpha:1] set];
        
        Y1 -= [YZMenu arrowSize];
        
    } else if (_arrowDirection == YZMenuViewArrowDirectionLeft) {
        
        const CGFloat arrowYM = _arrowPosition;
        const CGFloat arrowX0 = X0;
        const CGFloat arrowX1 = X0 + [YZMenu arrowSize] + kEmbedFix;
        const CGFloat arrowY0 = arrowYM - [YZMenu arrowSize];;
        const CGFloat arrowY1 = arrowYM + [YZMenu arrowSize];
        
        [arrowPath moveToPoint:    (CGPoint){arrowX0, arrowYM}];
        [arrowPath addLineToPoint: (CGPoint){arrowX1, arrowY0}];
        [arrowPath addLineToPoint: (CGPoint){arrowX1, arrowY1}];
        [arrowPath addLineToPoint: (CGPoint){arrowX0, arrowYM}];
        
        [[UIColor colorWithRed:R0 green:G0 blue:B0 alpha:1] set];
        
        X0 += [YZMenu arrowSize];
        
    } else if (_arrowDirection == YZMenuViewArrowDirectionRight) {
        
        const CGFloat arrowYM = _arrowPosition;
        const CGFloat arrowX0 = X1;
        const CGFloat arrowX1 = X1 - [YZMenu arrowSize] - kEmbedFix;
        const CGFloat arrowY0 = arrowYM - [YZMenu arrowSize];;
        const CGFloat arrowY1 = arrowYM + [YZMenu arrowSize];
        
        [arrowPath moveToPoint:    (CGPoint){arrowX0, arrowYM}];
        [arrowPath addLineToPoint: (CGPoint){arrowX1, arrowY0}];
        [arrowPath addLineToPoint: (CGPoint){arrowX1, arrowY1}];
        [arrowPath addLineToPoint: (CGPoint){arrowX0, arrowYM}];
        
        [[UIColor colorWithRed:R1 green:G1 blue:B1 alpha:1] set];
        
        X1 -= [YZMenu arrowSize];
    }
    
    [arrowPath fill];
    
    // render body
    const CGRect bodyFrame = {X0, Y0, X1 - X0, Y1 - Y0};
    
    UIBezierPath *borderPath = [UIBezierPath bezierPathWithRoundedRect:bodyFrame
                                                          cornerRadius:[YZMenu cornerRadius]];
    
    const CGFloat locations[] = {0, 1};
    const CGFloat components[] = {
        R0, G0, B0, 1,
        R1, G1, B1, 1,
    };
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace,
                                                                 components,
                                                                 locations,
                                                                 sizeof(locations)/sizeof(locations[0]));
    CGColorSpaceRelease(colorSpace);
    
    
    [borderPath addClip];
    
    CGPoint start, end;
    
    if (_arrowDirection == YZMenuViewArrowDirectionLeft ||
        _arrowDirection == YZMenuViewArrowDirectionRight) {
        
        start = (CGPoint){X0, Y0};
        end = (CGPoint){X1, Y0};
        
    } else {
        
        start = (CGPoint){X0, Y0};
        end = (CGPoint){X0, Y1};
    }
    
    CGContextDrawLinearGradient(context, gradient, start, end, 0);
    
    CGGradientRelease(gradient);
}

@end


#pragma mark - YZMenu
/// MenuView
static YZMenu                      *gMenu;

@implementation YZMenu {
    YZMenuView *_menuView;
    BOOL         _observing;
}

#pragma mark System Methods

+ (instancetype)sharedMenu {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gMenu = [[YZMenu alloc] init];
    });
    return gMenu;
}

- (id)init {
    NSAssert(!gMenu, @"singleton object");
    self = [super init];
    if (self) {
        self.isShow = NO;
    }
    return self;
}

- (void) dealloc {
    if (_observing) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

#pragma mark Public Methods

+ (void)showMenuInView:(UIView *)view fromRect:(CGRect)rect menuItems:(NSArray *)menuItems selected:(YZMenuSelectedItem)selectedItem {
    [[self sharedMenu] showMenuInView:view fromRect:rect menuItems:menuItems selected:selectedItem];
}

+ (void)dismissMenu {
    [[self sharedMenu] dismissMenu];
}

+ (BOOL)isShow {
    return [[self sharedMenu] isShow];
}

+ (void)reset {
    gTintColor = nil;
    gTitleFont = nil;
    gArrowSize = kArrowSize;
    gCornerRadius = kCornerRadius;
    gBackgroundColorEffect = YZMenuBackgrounColorEffectSolid;
    gHasShadow = NO;
    gSelectedColor = kSelectedColor;
    gSeparatorColor = kSeparatorColor;
}

#pragma mark Private Methods

- (void)showMenuInView:(UIView *)view fromRect:(CGRect)rect menuItems:(NSArray *)menuItems selected:(YZMenuSelectedItem)selectedItem {
    NSParameterAssert(view);
    NSParameterAssert(menuItems.count);
    
    if (_menuView) {
        [_menuView dismissMenu:NO];
        _menuView = nil;
    }
    
    if (!_observing) {
        _observing = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationWillChange:) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
    }
    
    // 创建MenuView
    _menuView = [[YZMenuView alloc] init];
    [_menuView showMenuInView:view fromRect:rect menuItems:menuItems selected:selectedItem];
    self.isShow = YES;
}

- (void)dismissMenu {
    
    if (_menuView) {
        [_menuView dismissMenu:NO];
        _menuView = nil;
    }
    
    if (_observing) {
        _observing = NO;
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    
    self.isShow = NO;
}

#pragma mark Notification
- (void)orientationWillChange:(NSNotification *)notification {
    [self dismissMenu];
}

#pragma mark setter/getter
+ (UIColor *)tintColor {
    return gTintColor?gTintColor:kTintColor;
}

+ (void)setTintColor:(UIColor *)tintColor {
    if (tintColor != gTintColor) {
        gTintColor = tintColor;
    }
}

+ (CGFloat)cornerRadius {
    return gCornerRadius >0?gCornerRadius:kCornerRadius;
}

+ (void)setCornerRadius:(CGFloat)cornerRadius {
    if (cornerRadius > 0) {
        gCornerRadius = cornerRadius;
    }
}

+ (CGFloat)arrowSize {
    return gArrowSize > 0?gArrowSize:kArrowSize;
}

+ (void)setArrowSize:(CGFloat)arrowSize {
    if (arrowSize > 0) {
        gArrowSize = arrowSize;
    }
}

+ (UIFont *)titleFont {
    return gTitleFont?gTitleFont:kTitleFont;
}

+ (void)setTitleFont:(UIFont *)titleFont {
    if (titleFont != gTitleFont) {
        gTitleFont = titleFont;
    }
}

+ (YZMenuBackgrounColorEffect)backgrounColorEffect {
    return gBackgroundColorEffect;
}

+ (void)setBackgrounColorEffect:(YZMenuBackgrounColorEffect)effect {
    gBackgroundColorEffect = effect;
}

+ (BOOL)hasShadow {
    return gHasShadow;
}

+ (void)setHasShadow:(BOOL)flag {
    gHasShadow = flag;
}

+(UIColor *)selectedColor {
    return gSelectedColor?gSelectedColor:kSelectedColor;
}
+(void)setSelectedColor:(UIColor *)selectedColor {
    gSelectedColor = selectedColor;
}

+(UIColor *)separatorColor {
    return gSeparatorColor?gSeparatorColor:kSeparatorColor;
}
+(void)setSeparatorColor:(UIColor *)separatorColor {
    gSeparatorColor = separatorColor;
}


/// 菜单元素垂直方向上的边距值
+ (CGFloat)menuItemMarginY {
    return gMenuItemMarginY > 0?gMenuItemMarginY:kMenuItemMarginY;
}
+(void)setMenuItemMarginY:(CGFloat)menuItemMarginY {
    if (menuItemMarginY > 0) {
        gMenuItemMarginY = menuItemMarginY;
    }
}

@end
