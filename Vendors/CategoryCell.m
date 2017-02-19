//
//  CategoryCell.m
//  EbayCategoryDemo
//
//  Created by zhaowei on 2016/12/13.
//  Copyright © 2016年 share. All rights reserved.
//

#import "CategoryCell.h"
#import "CategoryModel.h"

@interface CategoryCell ()

@end

@implementation CategoryCell

+ (CategoryCell *)categoryCellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath {
    //注册cell
    [tableView registerClass:[CategoryCell class] forCellReuseIdentifier:@"categoryCell"];
    return [tableView dequeueReusableCellWithIdentifier:@"categoryCell" forIndexPath:indexPath];
}

- (void)prepareForReuse {
    self.leadingView.hidden = YES;
    self.leadingView.image = nil;
    self.titleLabel.text = nil;
    [self.trailingBtn setTitle:@"" forState:UIControlStateNormal];
    [self.trailingBtn setImage:nil forState:UIControlStateNormal];
    self.seeAllBlock = nil;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //左侧箭头
        UIImageView *leadingView = [UIImageView new];
        [self.contentView addSubview:leadingView];
        [leadingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top).offset(20);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-20);
            make.leading.mas_equalTo(self.contentView.mas_leading).offset(20);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        self.leadingView = leadingView;
        //标题
        UILabel *titleLabel = [UILabel new];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(leadingView.mas_trailing).offset(30);
            make.centerY.mas_equalTo(leadingView.mas_centerY);
        }];
        self.titleLabel = titleLabel;
        //右侧箭头及See All
        UIButton *trailingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [trailingBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        trailingBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [trailingBtn addTarget:self action:@selector(trailingTouch:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:trailingBtn];
        [trailingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-20);
            make.centerY.mas_equalTo(leadingView.mas_centerY);
        }];
        self.trailingBtn = trailingBtn;
        
    }
    return self;
}

- (void)trailingTouch:(id)sender {
    if (self.seeAllBlock) {
        self.seeAllBlock();
    }
}

- (void)setCategoryModel:(CategoryModel *)categoryModel {
    _categoryModel = categoryModel;
    self.titleLabel.text = categoryModel.name;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
