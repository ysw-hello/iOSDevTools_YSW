//
//  ATRelatedMenuView.m
//  testDemo
//
//  Created by 闫士伟 on 2017/9/5.
//  Copyright © 2017年 闫士伟. All rights reserved.
//

#import "ATRelatedMenuView.h"

static NSString *const leftCellID = @"ATRelatedMenuLeftTableViewCell";
static NSString *const rightCellID = @"ATRelatedMenuRightTableViewCell";

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface ATRelatedMenuLeftTableViewCell : UITableViewCell

/**
 label
 */
@property (nonatomic, strong) UILabel *titleLabel;

-(void)updateWithData:(NSString *)dataStr;

@end

@implementation ATRelatedMenuLeftTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:_titleLabel];
        //layout
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
        }];

    }
    return self;
}

-(void)updateWithData:(NSString *)dataStr {
    _titleLabel.text = dataStr;
    
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface ATRelatedMenuRightTableViewCell : UITableViewCell

/**
 label
 */
@property (nonatomic, strong) UILabel *detailTitleLabel;

/**
 imageView
 */
@property (nonatomic, strong) UIImageView *rightIcon;

-(void)updateWithData:(NSString *)dataStr;

@end

@implementation ATRelatedMenuRightTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.rightIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        _rightIcon.image = [UIImage imageNamed:@"home_allCycle_Focus"];
        _rightIcon.hidden = YES;
        [self addSubview:_rightIcon];
        //layout
        [_rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(self.mas_right).offset(-15);
            make.width.equalTo(@15);
            make.height.equalTo(@15);
        }];
        
        self.detailTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:_detailTitleLabel];
        //layout
        [_detailTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(self.mas_left).offset(15);
        }];


    }
    return self;
}

-(void)updateWithData:(NSString *)dataStr {

    _detailTitleLabel.text = dataStr;

}

@end


////////////////////////////////////////////////////////////////////////////////////////////////////

@interface ATRelatedMenuView () <UITableViewDelegate,UITableViewDataSource>

/**
 rightTableView: frontIndexPath
 */
@property (nonatomic, strong) NSIndexPath *frontIndexPath;

/**
 leftTableView
 */
@property (nonatomic, strong) UITableView *leftTableView;

/**
 rightTableView
 */
@property (nonatomic, strong) UITableView *rightTableView;


@end

@implementation ATRelatedMenuView

#pragma mark - public methods
-(void)reloadData {
    [self.leftTableView reloadData];
    [self.rightTableView reloadData];
}

#pragma mark - system methods

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        UIView *coverView = [[UIView alloc] initWithFrame:self.frame];
        coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        [coverView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coverViewClick)]];
        [self addSubview:coverView];
        
        [self.leftTableView registerClass:[ATRelatedMenuLeftTableViewCell class] forCellReuseIdentifier:leftCellID];
        [self.rightTableView registerClass:[ATRelatedMenuRightTableViewCell class] forCellReuseIdentifier:rightCellID];

    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    if (self.frontIndexPath) {
        [self.rightTableView selectRowAtIndexPath:self.frontIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }

}

#pragma mark - private method
-(void)coverViewClick {
    [self removeFromSuperview];
}

#pragma mark - lazy load
-(UITableView *)leftTableView {
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width * 1/3, 44 * 8)];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _leftTableView.tableFooterView = [UIView new];
        _leftTableView.bounces = NO;
        [self addSubview:_leftTableView];
    }
    return _leftTableView;
}

-(UITableView *)rightTableView {
    if (!_rightTableView) {
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.leftTableView.frame.size.width, 0, self.frame.size.width * 2/3, self.leftTableView.frame.size.height)];
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _rightTableView.tableFooterView = [UIView new];
        [self addSubview:_rightTableView];
    }
    return _rightTableView;
}

#pragma mark - UITableViewDataSource && UITableViewDelegate 

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.leftTableView) {
        return self.leftArray.count;
    }else {
        NSString *currentKey = [self.leftArray objectAtIndex:self.currentIndex];
        return [[[self.dataArr objectAtIndex:self.currentIndex] objectForKey:currentKey] count];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.leftTableView) {
        ATRelatedMenuLeftTableViewCell *leftCell = [tableView dequeueReusableCellWithIdentifier:leftCellID forIndexPath:indexPath];
        if (self.currentIndex == indexPath.row) {
            leftCell.backgroundColor = [UIColor whiteColor];
            leftCell.titleLabel.textColor = [UIColor blueColor];
        }else{
            leftCell.backgroundColor = [UIColor lightGrayColor];
            leftCell.titleLabel.textColor = [UIColor blackColor];
        }
        [leftCell updateWithData:[self.leftArray objectAtIndex:indexPath.row]];
        return leftCell;
    } else {
        ATRelatedMenuRightTableViewCell *rightCell = [tableView dequeueReusableCellWithIdentifier:rightCellID];
        NSString *currentkey = [self.leftArray objectAtIndex:self.currentIndex];
        [rightCell updateWithData:[[[self.dataArr objectAtIndex:self.currentIndex] objectForKey:currentkey] objectAtIndex:indexPath.row]];
        if (self.currentIndexPath.row == indexPath.row && self.currentIndexPath && self.flag == self.currentIndex) {
            rightCell.rightIcon.hidden = NO;
        } else {
            rightCell.rightIcon.hidden = YES;
        }
        return rightCell;
    }
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.leftTableView) {
        self.currentIndex = indexPath.row;
        [self reloadData];
    } else {
        if (self.currentIndexPath == indexPath && self.flag == self.currentIndex) {
            [self removeFromSuperview];
            return;
        }
        self.flag = self.currentIndex;
        self.currentIndexPath = indexPath;
        self.frontIndexPath = self.currentIndexPath;
        [tableView reloadData];
        
        if (self.classTimeHandler) {
            self.classTimeHandler(self.currentIndex, indexPath);
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self removeFromSuperview];
        });
    }
}

@end
