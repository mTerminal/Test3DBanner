//
//  HMCycleScrollView.h
//  HMCycleScrollView
//
//  Created by aahazz on 16/3/17.
//  Copyright © 2016年 侯猛. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HMCycleScrollView;

@protocol  HMCycleScrollViewDelegate <NSObject>

/**
 *  代理回调点击
 *
 *  @param index           点击第几张图片
 */
- (void)cycleScrollView:(HMCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index;

@end

@interface HMCycleScrollView : UIView <UIScrollViewDelegate>

@property (nonatomic, assign) NSInteger                   totalItemsCount;


@property (nonatomic, strong) NSTimer                     *timer;

@property (nonatomic, strong) UIPageControl               *pageControl;

@property (nonatomic, strong) UIScrollView                *scrollView;

@property (nonatomic, assign) CGFloat                     width;

@property (nonatomic, assign) CGFloat                     intervalWidth;
/**
 *  图片链接数组
 */
@property (nonatomic, strong) NSArray                     *imagesURLStrings;

@property (nonatomic, weak  ) id                     <    HMCycleScrollViewDelegate    > delegate;

/**
 *  创建轮播图调用方法
 *
 *  @param frame    轮播图创建尺寸
 *  @param delegate 传入代理
 *
 */
+ (instancetype)createScrollViewWithFrame:(CGRect)frame delegate:(id<HMCycleScrollViewDelegate>)delegate;
@end
