//
//  CategoryCell.h
//  EbayCategoryDemo
//
//  Created by zhaowei on 2016/12/13.
//  Copyright © 2016年 share. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CategoryModel;
@interface CategoryCell : UITableViewCell
@property (nonatomic,strong) CategoryModel *categoryModel;
//左侧箭头
@property (nonatomic,weak) UIImageView *leadingView;
//标题
@property (nonatomic,weak) UILabel *titleLabel;
//右侧箭头及See All
@property (nonatomic,weak) UIButton *trailingBtn;

@property (nonatomic,copy ) void (^seeAllBlock)();

+ (CategoryCell *)categoryCellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath;
@end
