//
//  ATRelatedMenuView.h
//  testDemo
//
//  Created by 闫士伟 on 2017/9/5.
//  Copyright © 2017年 闫士伟. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ATSelectedClassTimeHandler)(NSInteger currentIndex, NSIndexPath *indexPath);

@interface ATRelatedMenuView : UIView

/**
 左边TableView数据源
 */
@property (nonatomic, strong) NSArray *leftArray;

/**
 右边TableView数据源
 */
@property (nonatomic, strong) NSArray *dataArr;

/**
 rightTableView: 区分复用flag
 */
@property (nonatomic, assign) NSInteger flag;

/**
 leftTableView: current index
 */
@property (nonatomic, assign) NSInteger currentIndex;

/**
 rightTableView: currentIndexPath
 */
@property (nonatomic, strong) NSIndexPath *currentIndexPath;

/**
 日期点击 回调handler
 */
@property (nonatomic, copy) ATSelectedClassTimeHandler classTimeHandler;


/**
 刷新整体数据源
 */
-(void)reloadData;

@end

/**  Example :使用示例
 
 ATRelatedMenuView *relatedMenuView = [[ATRelatedMenuView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64)];
 relatedMenuView.dataArr = @[
 @{@"全部日期":@[@"全部",@"7:00-10:00",@"10:00-13:00",@"13:00-16:00",@"16:00-19:00",@"19:00-21:00",@"21:00-24:00"]},
 @{@"每周一":@[@"全部",@"7:00-10:00",@"10:00-13:00",@"13:00-16:00",@"16:00-19:00",@"19:00-21:00"]},
 @{@"每周二":@[@"全部",@"7:00-10:00",@"10:00-13:00",@"13:00-16:00",@"16:00-19:00"]},
 @{@"每周三":@[@"全部",@"7:00-10:00",@"10:00-13:00",@"13:00-16:00"]},
 @{@"每周四":@[@"全部",@"10:00-13:00",@"13:00-16:00",@"16:00-19:00",@"19:00-21:00",@"21:00-24:00"]},
 @{@"每周五":@[@"全部",@"13:00-16:00",@"16:00-19:00",@"19:00-21:00",@"21:00-24:00"]},
 @{@"每周六":@[@"全部",@"16:00-19:00",@"19:00-21:00",@"21:00-24:00"]},
 @{@"每周日":@[@"全部",@"10:00-13:00",@"13:00-16:00",@"16:00-19:00"]},
 ];
 relatedMenuView.leftArray = @[@"全部日期",@"每周一",@"每周二",@"每周三",@"每周四",@"每周五",@"每周六",@"每周日"];
 relatedMenuView.currentIndex = self.currentIndex;
 relatedMenuView.currentIndexPath = self.currentIndexPath;
 relatedMenuView.flag = self.currentIndex;
 
 @weakify(relatedMenuView);
 __weak typeof(self) weakSelf = self;
 relatedMenuView.classTimeHandler = ^(NSInteger currentIndex, NSIndexPath *indexPath) {
 @strongify(relatedMenuView);
 weakSelf.currentIndex = currentIndex;
 weakSelf.currentIndexPath = indexPath;
 
 NSString *timeDate = [relatedMenuView.leftArray objectAtIndex:currentIndex];
 NSString *timePeriod = [[[relatedMenuView.dataArr objectAtIndex:currentIndex] objectForKey:timeDate] objectAtIndex:indexPath.row];
 NSString *buttonTilte = (currentIndex == 0 && indexPath.row == 0) ? @"上课时间" : [timeDate stringByAppendingString:timePeriod];
 [classTimeButton setTitle:buttonTilte forState:UIControlStateNormal];
 
 };
 [relatedMenuView reloadData];
 [self.view addSubview:relatedMenuView];
 */
