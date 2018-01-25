//
//  YSWBannerView.m
//  testDemo
//
//  Created by 闫士伟 on 2017/8/16.
//  Copyright © 2017年 闫士伟. All rights reserved.
//

#import "YSWBannerView.h"
#import "UIViewAdditions.h"


static NSString *const cellReuseID = @"cellReuseID";



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface YSWBannerCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;


-(void)updateCellWithImageInfo:(id)imageInfo defaultImage:(UIImage *)defaultImage;

@end

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation YSWBannerCell

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:self.imageView];
    }
    return self;
}

-(void)updateCellWithImageInfo:(id)imageInfo defaultImage:(UIImage *)defaultImage {
    //容错处理
    if (!imageInfo || ([imageInfo isKindOfClass:[NSString class]] && [imageInfo isEqualToString:@""])) {
        if (!defaultImage) return;
        
        self.imageView.image = defaultImage;
        return;
    }
    
    //四种类型分解
    if ([imageInfo isKindOfClass:[UIImage class]]) {
        self.imageView.image = imageInfo;
    } else if ([imageInfo isKindOfClass:[NSURL class]]) {
        [self.imageView sd_setImageWithURL:imageInfo placeholderImage:defaultImage];
    } else if ([imageInfo isKindOfClass:[NSString class]]) {
        if ([(NSString *)imageInfo containsString:@"://"]) {
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageInfo] placeholderImage:defaultImage];
            return;
        }
        self.imageView.image = [UIImage imageNamed:imageInfo];
    }
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////





@interface YSWBannerView ()<UICollectionViewDelegate,UICollectionViewDataSource>

/**
 collectionView
 */
@property (nonatomic, strong) UICollectionView *collectionView;

/**
 collectionViewFlowLayout
 */
@property (nonatomic, strong) UICollectionViewFlowLayout *collectionViewFlowLayout;

/**
 pageControl
 */
@property (nonatomic, strong) UIPageControl *pageControl;

/**
 dataArr
 */
@property (nonatomic, strong) NSMutableArray *dataArr;

/**
 timer
 */
@property (nonatomic, strong) NSTimer *timer;

/**
 currentPage
 */
@property (nonatomic, assign) NSInteger currentPage;



@end


@implementation YSWBannerView

#pragma mark - public method

+(YSWBannerView *)YSWBannerViewWithFrame:(CGRect)frame imageSourceArray:(NSArray *)imageSource pageIndicatorTintColor:(UIColor *)pageIndicatorTintColor currentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor defaultImage:(UIImage *)defaultImage autoScroll:(BOOL)autoScroll autoScrollDelay:(CGFloat)autoScrollDelay tapHandler:(ImageItemTapHandler)tapHandler {
    
    YSWBannerView *bannerView = [[YSWBannerView alloc] initWithFrame:frame];
    
    bannerView.backgroundColor = [UIColor clearColor];
    bannerView.frame = frame;
    bannerView.autoScroll = autoScroll;
    bannerView.autoScrollDelay = autoScrollDelay;
    bannerView.imageSourceArray = imageSource;
    bannerView.pageIndicatorTintColor = pageIndicatorTintColor;
    bannerView.currentPageIndicatorTintColor = currentPageIndicatorTintColor;
    bannerView.defaultImage = defaultImage;
    bannerView.tapHandler = tapHandler;
    
    return bannerView;
}


#pragma maark - system method

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.autoScrollDelay = 5.f;//默认滚动的时间间隔为5s
        [self.collectionView registerClass:[YSWBannerCell class] forCellWithReuseIdentifier:cellReuseID];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    self.pageControl.numberOfPages = self.imageSourceArray.count;
}

#pragma mark - private methods

-(void)startTimer{
    if (_timer) {
        return;
    }
    _timer  = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollDelay target:[YYWeakProxy proxyWithTarget:self] selector:@selector(autoScrollToNextPage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

-(void)stopTimer {
    if (!_timer) {
        return;
    }
    [_timer invalidate];
    _timer = nil;
}

-(void)autoScrollToNextPage {
    if (self.currentPage == self.imageSourceArray.count - 1) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        self.pageControl.currentPage = self.imageSourceArray.count - 1;

    }else if (self.currentPage < self.imageSourceArray.count -1) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentPage + 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        self.pageControl.currentPage = self.currentPage - 1;
    }
}

#pragma mark - setter/getter

-(void)setImageSourceArray:(NSArray *)imageSourceArray {
    if (imageSourceArray.count > 0) {
        _imageSourceArray = imageSourceArray;
        self.dataArr = [NSMutableArray array];
        [self.dataArr addObject:[imageSourceArray lastObject]];
        [self.dataArr addObjectsFromArray:self.imageSourceArray];
        [self.dataArr addObject:[imageSourceArray firstObject]];
    }
    
    if (imageSourceArray.count > 1 && self.autoScroll == YES) {
        [self startTimer];
    }
    
}

-(NSInteger)currentPage {
    return (NSInteger)(self.collectionView.contentOffset.x / self.width);
}

-(CGFloat)autoScrollDelay {
    if (_autoScrollDelay == 0) {
        _autoScrollDelay = 5.f;//默认滚动的时间间隔为5s
    }
    return _autoScrollDelay;
}

-(UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((self.width - 120)/2, self.height - 15, 120, 10)];
        _pageControl.currentPage = 0;
        _pageControl.numberOfPages = 1;
        _pageControl.hidesForSinglePage = YES;
        _pageControl.pageIndicatorTintColor = self.pageIndicatorTintColor;
        _pageControl.currentPageIndicatorTintColor = self.currentPageIndicatorTintColor;
        [self addSubview:_pageControl];
    }
    return _pageControl;
}

-(UIColor *)pageIndicatorTintColor {
    if (!_pageIndicatorTintColor) {
        _pageIndicatorTintColor = [UIColor lightGrayColor];
    }
    return _pageIndicatorTintColor;
}

-(UIColor *)currentPageIndicatorTintColor {
    if (!_currentPageIndicatorTintColor) {
        _currentPageIndicatorTintColor = [UIColor redColor];
    }
    return _currentPageIndicatorTintColor;
}

-(UIImage *)defaultImage {
    if (!_defaultImage) {
        _defaultImage = [UIImage new];
    }
    return _defaultImage;
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) collectionViewLayout:self.collectionViewFlowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.alwaysBounceHorizontal = YES;
        [self addSubview:_collectionView];
    }
    return _collectionView;
}

-(UICollectionViewFlowLayout *)collectionViewFlowLayout {
    if (!_collectionViewFlowLayout) {
        _collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;//水平方向滚动
        _collectionViewFlowLayout.minimumLineSpacing = 0.f;
        _collectionViewFlowLayout.itemSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
    }
    return _collectionViewFlowLayout;
}



#pragma mark - <UICollectionViewDelegate,UICollectionViewDataSource>

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArr.count > 3 ? self.dataArr.count : 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    YSWBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReuseID forIndexPath:indexPath];
    [cell updateCellWithImageInfo:self.dataArr[indexPath.row] defaultImage:self.defaultImage];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.tapHandler) {
        self.tapHandler(indexPath.item - 1);
    }
}

#pragma mark - <scrollViewDelegate>

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (_timer && _autoScroll) {
        [self stopTimer];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    if (offsetX == 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.dataArr.count - 2 inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }else if (offsetX == scrollView.bounds.size.width * (self.dataArr.count - 1)) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:1 inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    
    double numPage = offsetX / scrollView.bounds.size.width;
    if (numPage == 0) {
        self.pageControl.currentPage = self.pageControl.numberOfPages - 1;
    }else if (numPage == self.dataArr.count - 1){
        self.pageControl.currentPage = 0;
    }else{
        self.pageControl.currentPage = numPage - 1;
    }
    
    if (_autoScroll) {
        [self startTimer];
    }
}


@end
