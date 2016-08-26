//
//  HMCycleScrollView.m
//  HMCycleScrollView
//
//  Created by aahazz on 16/3/17.
//  Copyright © 2016年 侯猛. All rights reserved.
//


#import "HMCycleScrollView.h"
#import "UIImageView+WebCache.h"
#import "UIScrollView+_DScrollView.h"

@implementation HMCycleScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _width = [UIScreen mainScreen].bounds.size.width;
        _intervalWidth = 50;
    }
    return self;
}

+ (instancetype)createScrollViewWithFrame:(CGRect)frame delegate:(id<HMCycleScrollViewDelegate>)delegate
{
    HMCycleScrollView *cycleScrollView = [[HMCycleScrollView alloc] initWithFrame:frame];
    cycleScrollView.delegate = delegate;
    [cycleScrollView initialize];
    return cycleScrollView;
}

- (void)initialize
{
    
}

- (void)setImagesURLStrings:(NSArray *)imagesURLStrings
{
    
    
    [_timer invalidate];
    _timer = nil;
    for (id temp in self.subviews) {
        [temp removeFromSuperview];
    }
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(_intervalWidth / 2, 0, _width - _intervalWidth, self.bounds.size.height)];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(_width / 2 - 5, self.bounds.size.height - 20, 10, 10)];
    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(automaticCycle) userInfo:nil repeats:YES];
    
    _pageControl.userInteractionEnabled = NO;
    _scrollView.delegate = self;
    _scrollView.clipsToBounds = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    
    [self addSubview:_scrollView];
    
    
    _imagesURLStrings = imagesURLStrings;
    _totalItemsCount = imagesURLStrings.count * 100;
    for (NSInteger i = 0; i < _totalItemsCount; i ++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake((_width - _intervalWidth) * i, 0, _width - _intervalWidth, self.bounds.size.height)];
        view.backgroundColor = [UIColor clearColor];
        [_scrollView addSubview:view];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGuest:)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _width - _intervalWidth, self.bounds.size.height)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imagesURLStrings[i % _imagesURLStrings.count]] placeholderImage:[UIImage imageNamed:@"bannerPlaceholderImage"]];
        imageView.layer.masksToBounds = YES;
        imageView.userInteractionEnabled = YES;
        imageView.layer.cornerRadius = 5;
        imageView.tag = i;
        imageView.contentMode = UIViewContentModeScaleToFill;
        [imageView addGestureRecognizer:tapGesture];
        [view addSubview:imageView];
    }
    if (_imagesURLStrings.count == 1) {
        _pageControl.hidden = YES;
    }
    _pageControl.numberOfPages = imagesURLStrings.count;
    [self addSubview:_pageControl];
    _scrollView.contentSize = CGSizeMake((_width - _intervalWidth) * _totalItemsCount, 0);
    _scrollView.contentOffset = CGPointMake((_width - _intervalWidth) * (_totalItemsCount / 2), 0);
    _pageControl.currentPage = 0;
    [_scrollView make3Dscrollview];
    
}

#pragma mark 手势点击触发代理方法
- (void)tapGuest:(UITapGestureRecognizer *)recognizer
{
    if (_imagesURLStrings == nil || _imagesURLStrings.count == 0) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:didSelectItemAtIndex:)]) {
        [self.delegate cycleScrollView:self didSelectItemAtIndex:recognizer.view.tag % _imagesURLStrings.count];
    }
}

#pragma mark scrollview delegate 
// 减速停止时改变page
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    if (_imagesURLStrings == nil || _imagesURLStrings.count == 0) {
        return;
    }
    NSInteger x = (scrollView.contentOffset.x / (_width - _intervalWidth));
    NSInteger num = x % _imagesURLStrings.count;
    _pageControl.currentPage = num;
    if (x == _imagesURLStrings.count + 1) {
        [_scrollView setContentOffset:CGPointMake((_width - _intervalWidth) * (_totalItemsCount / 2), 0) animated:NO];
    }
    
    if (x == _totalItemsCount - _imagesURLStrings.count) {
        [_scrollView setContentOffset:CGPointMake((_width - _intervalWidth) * (_totalItemsCount / 2), 0) animated:NO];
    }
    
}

// 开始拖拽视图
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (_imagesURLStrings == nil || _imagesURLStrings.count == 0) {
        return;
    }
    [_timer invalidate];
    _timer = nil;
}
// 完成拖拽
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_imagesURLStrings == nil || _imagesURLStrings.count == 0) {
        return;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(automaticCycle) userInfo:nil repeats:YES];
}

// 滚动动画结束时执行
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (_imagesURLStrings == nil || _imagesURLStrings.count == 0) {
        return;
    }
    NSInteger x = (scrollView.contentOffset.x / (_width - _intervalWidth));
    NSInteger num = x % _imagesURLStrings.count;
    _pageControl.currentPage = num;
    if (x == _imagesURLStrings.count + 1) {
        [_scrollView setContentOffset:CGPointMake((_width - _intervalWidth) * (_totalItemsCount / 2), 0) animated:NO];
    }
    
    if (x == _totalItemsCount - _imagesURLStrings.count) {
        [_scrollView setContentOffset:CGPointMake((_width - _intervalWidth) * (_totalItemsCount / 2), 0) animated:NO];
    }
}

#pragma mark 计时器
- (void)automaticCycle
{
    if (_imagesURLStrings == nil || _imagesURLStrings.count == 0) {
        return;
    }
    NSInteger x = (_scrollView.contentOffset.x / (_width - _intervalWidth));
    CGFloat offSetX = (x + 1) * (_width - _intervalWidth);
    CGPoint offset = CGPointMake(offSetX, 0);
    [_scrollView setContentOffset:offset animated:YES];
}



@end
