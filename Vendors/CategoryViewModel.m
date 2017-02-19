//
//  CategoryViewModel.m
//  EbayCategoryDemo
//
//  Created by zhaowei on 2016/12/13.
//  Copyright © 2016年 share. All rights reserved.
//

#import "CategoryViewModel.h"
#import "CategoryCell.h"
#import "CategoryModel.h"
#import "CategoryApi.h"

typedef enum {
    TableViewRowInsert,
    TableViewRowDelete
}TableViewRowAction;

@interface CategoryViewModel ()
@property (atomic, assign) NSInteger selectedCategorySection;
@property (nonatomic, strong) NSMutableArray *displayedChildren;
@end

@implementation CategoryViewModel

- (void)requestNetwork:(id)parmaters completion:(void (^)(id))completion failure:(void (^)(id))failure {
    _selectedCategorySection = 1;
    CategoryModel *rootModel = [CategoryModel new];
    rootModel.name = @"All Categories";
    rootModel.isOwner = YES;
    rootModel.children = @[parmaters];
    
    self.displayedChildren = [NSMutableArray array];
    [self.displayedChildren addObject:rootModel];
    [self.displayedChildren addObject:parmaters];
    
    //下面做请求处理
    [self requestCategoryNetwork:parmaters completion:completion failure:failure];
    [self requestCategoryNetwork:parmaters completion:^(id obj) {
        [self.displayedChildren addObjectsFromArray:obj];
    } failure:^(id obj) {
        
    }];
}

- (void)requestCategoryNetwork:(id)parmaters completion:(void (^)(id))completion failure:(void (^)(id))failure {
    //下面做请求处理
//    CategoryApi *api = [CategoryApi new];
    CategoryModel *parmaterModel = (CategoryModel *)parmaters;
    
    NSMutableArray *array = [NSMutableArray array];
    //1到10的随机数
    int x = arc4random() % 10 + 1;
    for (int i = 1; i <= x; i ++) {
        CategoryModel *randomModel = [CategoryModel new];
        randomModel.name = [NSString stringWithFormat:@"%@--%d",parmaterModel.name,i];
        randomModel.isOwner = arc4random() % 2;
        [array addObject:randomModel];
    }
    
    parmaterModel.children = array;
    if (completion) {
        completion(array);
    }
}

#pragma mark - UITableView Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.displayedChildren.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CategoryCell *cell = [CategoryCell categoryCellWithTableView:tableView andIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setCell:cell content:self.displayedChildren[indexPath.row] indexRow:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CategoryModel *categoryModel = self.displayedChildren[indexPath.row];
    
    if (categoryModel.isOwner) {
        if (categoryModel.children != nil && categoryModel.children.count > 0) {
            [self setArraysWithTableView:tableView selectedModel:categoryModel selectedIndex:indexPath.row dataArray:categoryModel.children];
        } else {
            //这里应该发请求
            [self requestCategoryNetwork:categoryModel completion:^(NSArray *array) {
                [self setArraysWithTableView:tableView selectedModel:categoryModel selectedIndex:indexPath.row dataArray:array];
            } failure:^(id obj) {
                
            }];
        }
    } else {
        NSLog(@"没有下级分类的情况下，跳转到该分类所对应的商品列表页面");
    }
}

#pragma mark - Private Methods

- (CategoryCell *)setCell:(CategoryCell *)cell content:(CategoryModel *)categoryModel indexRow:(NSInteger)indexRow {
    cell.categoryModel = categoryModel;
    
    if (indexRow < _selectedCategorySection) {
        cell.textLabel.textColor = [UIColor grayColor];
        cell.leadingView.hidden = NO;
        cell.leadingView.image = [UIImage imageNamed:@"arrow_back"];
    } else if (indexRow == _selectedCategorySection) {
        cell.textLabel.textColor = [UIColor whiteColor];
        [cell.trailingBtn setTitle:@"See All" forState:UIControlStateNormal];
        cell.seeAllBlock = ^{
            //这里进行页面跳转，查看分类商品
            NSLog(@"这里进行页面跳转，查看分类商品====%@",categoryModel.name);
        };
    } else if (indexRow > _selectedCategorySection) {
        if (!categoryModel.isOwner) {
            [cell.trailingBtn setImage:nil forState:UIControlStateNormal];
        } else {
            [cell.trailingBtn setImage:[UIImage imageNamed:@"xl_button"] forState:UIControlStateNormal];
        }
    }
    
    return cell;
}
#pragma mark - Animation Methods

- (void)setArraysWithTableView:(UITableView *)tableView selectedModel:(CategoryModel *)selectedModel selectedIndex:(NSInteger)index dataArray:(NSArray *)array{
    if (index == 0) {
        NSLog(@"这里是root分类，按逻辑进行相应操作");
    } else if(index == _selectedCategorySection){
        NSLog(@"点击了当前选中的分类，不做任何操作");
    } else {
        [tableView beginUpdates];
        //如果选择当前被选中的直接返回
        if (_selectedCategorySection == index) {
            [tableView endUpdates];
            return;
        } else {
            NSMutableArray *indexPathInsert = [[NSMutableArray alloc] init];
            NSInteger currentIndex = -1;
            NSRange range;
            currentIndex = _selectedCategorySection;
            if (index < _selectedCategorySection)
            {
                range = NSMakeRange(index, self.displayedChildren.count - index);
                _selectedCategorySection = index;
            } else {
                range = NSMakeRange(_selectedCategorySection + 1, self.displayedChildren.count - _selectedCategorySection - 1);
                [indexPathInsert addObject:[self buildIndexPath:_selectedCategorySection]];
                _selectedCategorySection += 1;
            }
            
            [self tableview:tableView baseIndexPath:[self buildIndexPath:currentIndex] fromIndexPath:[self buildIndexPath:range.location] animation:UITableViewRowAnimationNone toIndexPath:[self buildIndexPath:range.location + range.length - 1] animation:UITableViewRowAnimationNone tableViewAction:TableViewRowDelete];
            
            [self.displayedChildren removeObjectsInRange:range];
            [self.displayedChildren addObject:selectedModel];
            
            if (array && array.count > 0) {
                [indexPathInsert addObjectsFromArray:[self indexPathArray:self.displayedChildren.count end:self.displayedChildren.count + array.count -1]];
                selectedModel.children = array;
                [self.displayedChildren addObjectsFromArray:array];
            }
            [tableView insertRowsAtIndexPaths:indexPathInsert withRowAnimation:UITableViewRowAnimationFade];
            //                CategoryModel *cate = ((CategoryModel *)[self.displayedChildren objectAtIndex:[self buildIndexPath:_selectedCategorySection]]);
            //                [self setCell:(CategoryCell *)[self.tableView cellForRowAtIndexPath:[self getIndexPath:currentIndex]] content:cate indexRow:_selectedCategorySection];
            [self setCell:(CategoryCell *)[tableView cellForRowAtIndexPath:[self buildIndexPath:currentIndex]] content:self.displayedChildren[_selectedCategorySection] indexRow:_selectedCategorySection];
        }
        [tableView endUpdates];
    }
    
}

//工具方法
- (void)tableView:(UITableView *)tableView based:(NSInteger)base from:(UITableViewRowAnimation)from to:(UITableViewRowAnimation)to action:(TableViewRowAction)action {
    [self tableview:tableView baseIndexPath:[self buildIndexPath:base] fromIndexPath:[self buildIndexPath:0] animation:from toIndexPath:[self buildIndexPath:(self.displayedChildren.count - 1)] animation:to tableViewAction:action];
}

- (void)tableview:(UITableView *)tableView baseIndexPath:(NSIndexPath *)baseIndexPath fromIndexPath:(NSIndexPath *)fromIndexPath animation:(UITableViewRowAnimation)baseTofromAnimation toIndexPath:(NSIndexPath *)toIndexPath animation:(UITableViewRowAnimation)baseTotoAnimation tableViewAction:(TableViewRowAction)action {
    NSMutableArray *array = [[NSMutableArray alloc]init];
    array = [self indexPathArray:fromIndexPath.row end:baseIndexPath.row - 1];
    [self tableView:tableView action:action indexPathArray:array animation:baseTofromAnimation];
    array = [self indexPathArray:baseIndexPath.row + 1 end:toIndexPath.row];
    [self tableView:tableView action:action indexPathArray:array animation:baseTotoAnimation];
}

- (void)tableView:(UITableView *)tableView action:(TableViewRowAction)action indexPathArray:(NSArray *)indexPathArray animation:(UITableViewRowAnimation)animation {
    if (TableViewRowInsert == action )
    {
        [tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:animation];
    }
    else if (TableViewRowDelete == action)
    {
        [tableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:animation];
    }
}
//构建多个NSIndexPath
- (NSMutableArray *)indexPathArray:(NSInteger)begin end:(NSInteger)end {
    NSMutableArray *indexPathArray = [[NSMutableArray alloc]init];
    for (NSInteger i = begin; i <= end; i++) {
        [indexPathArray addObject:[self buildIndexPath:i]];
    }
    return indexPathArray;
}
//构建NSIndexPath
- (NSIndexPath *)buildIndexPath:(NSInteger)row {
    return [NSIndexPath indexPathForRow:row inSection:0];
}
@end
