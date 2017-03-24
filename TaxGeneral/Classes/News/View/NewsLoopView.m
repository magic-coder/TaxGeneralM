/************************************************************
 Class    : NewsLoopView.m
 Describe : 顶部焦点自动轮播视图
 Company  : Prient
 Author   : Yanzheng
 Date     : 2016-12-02
 Version  : 1.0
 Declare  : Copyright © 2016 Yanzheng. All rights reserved.
 ************************************************************/

#import "NewsLoopView.h"
#define PAGE_H 20

@interface NewsLoopView() <UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *currentImages;
@property (nonatomic, assign) int currentPage;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIPageControl *pageControl;
@property (nonatomic, weak) UIScrollView *scrollView;

@end

@implementation NewsLoopView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles images:(NSArray *)images urls:(NSArray *)urls autoPlay:(BOOL)isAuto delay:(NSTimeInterval)timeInterval{
    if (self = [super initWithFrame:frame]) {
        _autoPlay = isAuto;
        _timeInterval = timeInterval;
        _titles = titles;
        _images = images;
        _urls = urls;
        _currentPage = 0;
        
        [self addScrollView];
        [self addPageControl];
        if (self.autoPlay == YES) {
            [self toPlay];
        }
    }
    return self;
}

#pragma mark - Public Methods
- (void)addPageControl {
    CGFloat height = self.frame.size.height;
    CGFloat width = self.frame.size.width;
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, height-PAGE_H, width, PAGE_H)];
    bgView.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.2];
    
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, width, PAGE_H)];
    pageControl.numberOfPages = self.images.count; // 小圆点的个数
    pageControl.currentPage = 0;    // 初始化页面值
    pageControl.userInteractionEnabled = NO;
    
    // 根据原点数量重新计算原点位置，(居右)
    CGSize pointSize = [pageControl sizeForNumberOfPages:self.images.count];
    CGFloat page_x = -(pageControl.bounds.size.width - pointSize.width - 20) / 2 ;
    [pageControl setBounds:CGRectMake(page_x, pageControl.bounds.origin.y, pageControl.bounds.size.width, pageControl.bounds.size.height)];
    _pageControl = pageControl;
    [bgView addSubview:self.pageControl];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, width - pointSize.width - 40, PAGE_H)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];// 字体加粗
    titleLabel.text = _titles[0];// 默认展示第一个标题
    _titleLabel = titleLabel;
    [bgView addSubview:self.titleLabel];
    
    [self addSubview:bgView];
}

#pragma mark - Private Methods
#pragma mark 自动播放（轮播）
- (void)toPlay {
    [self performSelector:@selector(autoPlayToNextPage) withObject:nil afterDelay:_timeInterval];
}

#pragma mark 自动播放下一个页面
- (void)autoPlayToNextPage {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoPlayToNextPage) object:nil];
    [self.scrollView setContentOffset:CGPointMake(self.frame.size.width * 2, 0) animated:YES];
    [self performSelector:@selector(autoPlayToNextPage) withObject:nil afterDelay:_timeInterval];
}

#pragma mark 初始化currentImages
- (NSMutableArray *)currentImages {
    if (_currentImages == nil) {
        _currentImages = [[NSMutableArray alloc] init];
    }
    [_currentImages removeAllObjects];
    NSInteger count = 3;
    int i = (int)(_currentPage + count - 1)%count;
    [_currentImages addObject:self.images[i]];
    [_currentImages addObject:self.images[_currentPage]];
    i = (int)(_currentPage + 1)%count;
    [_currentImages addObject:self.images[i]];
    return _currentImages;
}

#pragma mark 添加滚动视图
- (void)addScrollView {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    for (int i = 0; i < 3; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * width, 0, width, height)];
        // 获取本地图片
        // imageView.image = [UIImage imageNamed:self.currentImages[i]];
        
        // 从远程URL获取图片
        //[imageView sd_setImageWithURL:[NSURL URLWithString:self.currentImages[i]] placeholderImage:[UIImage imageNamed:@"common_news_placeholder"] options:SDWebImageAllowInvalidSSLCertificates completed:nil];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.currentImages[i]] placeholderImage:[UIImage imageNamed:@"common_news_placeholder"] options:SDWebImageAllowInvalidSSLCertificates completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            // 在回调block中进行图片裁剪处理（去除一圈白边）
            CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(20, 20, image.size.width-40, image.size.height-40));
            imageView.image =[UIImage imageWithCGImage:imageRef];
        }];
        
        [scrollView addSubview:imageView];
    }
    scrollView.scrollsToTop = NO;
    scrollView.contentSize = CGSizeMake(width * 3, height);
    scrollView.contentOffset = CGPointMake(width, 0);
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.delegate = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapped:)];
    [scrollView addGestureRecognizer:tap];
    
    [self addSubview:scrollView];
    _scrollView = scrollView;
}

#pragma mark 刷新图片
- (void)refreshImages {
    NSArray *subViews = self.scrollView.subviews;
    for (int i = 0; i < subViews.count; i++) {
        UIImageView *imageView = (UIImageView *)subViews[i];
        // 获取本地图片
        // imageView.image = [UIImage imageNamed:self.currentImages[i]];
        
        // 从远程URL获取图片
        //[imageView sd_setImageWithURL:[NSURL URLWithString:self.currentImages[i]] placeholderImage:[UIImage imageNamed:@"common_news_placeholder"] options:SDWebImageAllowInvalidSSLCertificates completed:nil];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.currentImages[i]] placeholderImage:[UIImage imageNamed:@"common_news_placeholder"] options:SDWebImageAllowInvalidSSLCertificates completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            // 在回调block中进行图片裁剪处理（去除一圈白边）
            CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(20, 20, image.size.width-40, image.size.height-40));
            imageView.image =[UIImage imageWithCGImage:imageRef];
        }];
    }
    
    [self.scrollView setContentOffset:CGPointMake(self.frame.size.width, 0)];
}

#pragma mark - delegate
- (void)singleTapped:(UITapGestureRecognizer *)recognizer {
    if ([self.delegate respondsToSelector:@selector(loopViewDidSelectedImage:index:)]) {
        [self.delegate loopViewDidSelectedImage:self index:_currentPage];
    }
}

#pragma mark 视图滚动方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat x = scrollView.contentOffset.x;
    CGFloat width = self.frame.size.width;
    if (x >= 2 * width) {
        _currentPage = (++_currentPage) % self.images.count;
        self.pageControl.currentPage = _currentPage;
        [self refreshImages];
    }
    if (x <= 0) {
        _currentPage = (int)(_currentPage + self.images.count - 1)%self.images.count;
        self.pageControl.currentPage = _currentPage;
        [self refreshImages];
    }
    // 滑动变换标题
    _titleLabel.text = [_titles objectAtIndex:_currentPage];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [scrollView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:YES];
}

@end
