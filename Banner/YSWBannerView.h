//
//  YSWBannerView.h
//  testDemo
//
//  Created by 闫士伟 on 2017/8/16.
//  Copyright © 2017年 闫士伟. All rights reserved.
//

/**
 Example:
 
 NSArray *imageSourceArr = [NSArray arrayWithObjects:
                                                    @"http://cimg.taohuaan.net/upload/201211/09/161159Wq7P8.jpg",
                                                    @"cat",
                                                    [UIImage imageNamed:@"dog2"],
                                                    [NSURL URLWithString:@"http://img396.ph.126.net/haglwzMp-3ndAh35LOn8Pg==/3073425270704988165.jpg"],
                                                    @"",
                                                    nil];
 
 YSWBannerView *bannerView = [YSWBannerView YSWBannerViewWithFrame:CGRectMake(0, 120, kScreenWidth, 300) imageSourceArray:nil pageIndicatorTintColor:[UIColor lightGrayColor] currentPageIndicatorTintColor:[UIColor cyanColor] defaultImage:[UIImage imageNamed:@"happy"] autoScroll:YES autoScrollDelay:1.f tapHandler:^(NSInteger index) {
        NSLog(@"点击了%ld",index);
 }];
 
 bannerView.imageSourceArray = imageSourceArr;
 [self.view addSubview:bannerView];
 
 */



#import <UIKit/UIKit.h>

typedef void(^ImageItemTapHandler)(NSInteger index);

@interface YSWBannerView : UIView

/**
 是否自动滚动
 */
@property (nonatomic, assign) BOOL autoScroll;

/**
 滚动间隔 default 5s
 */
@property (nonatomic, assign) CGFloat autoScrollDelay;

/**
 图片资源 数组 (支持 UIImage 及 imagePath：NSURL/NSString)
 */
@property (nonatomic, strong) NSArray *imageSourceArray;

/**
 占位图DefaultImage
 */
@property (nonatomic, strong) UIImage *defaultImage;

/**
 pageControl 未选中默认颜色 default lightGrayColor
 */
@property (nonatomic, strong) UIColor *pageIndicatorTintColor;

/**
 pageControl 选择当前页颜色 default redColor
 */
@property (nonatomic, strong) UIColor *currentPageIndicatorTintColor;



/**
 图片item点击 回调handler
 */
@property (nonatomic, copy) ImageItemTapHandler tapHandler;


/**
 返回定制YSWBannerView

 @param frame bannerViewFrame
 @param imageSource 图片数组
 @param pageIndicatorTintColor 默认的pageControl颜色
 @param currentPageIndicatorTintColor 选中的pageControl颜色
 @param defaultImage 占位图
 @param autoScroll 是否自动滚动
 @param tapHandler 点击图片Item的回调Handler
 @return YSWBannerView
 */
+(YSWBannerView *)YSWBannerViewWithFrame:(CGRect)frame
                        imageSourceArray:(NSArray *)imageSource
                  pageIndicatorTintColor:(UIColor *)pageIndicatorTintColor
           currentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor
                            defaultImage:(UIImage *)defaultImage
                              autoScroll:(BOOL)autoScroll
                         autoScrollDelay:(CGFloat)autoScrollDelay
                              tapHandler:(ImageItemTapHandler)tapHandler;




@end
