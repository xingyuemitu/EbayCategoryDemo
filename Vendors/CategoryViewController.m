//
//  CategoryViewController.m
//  EbayCategoryDemo
//
//  Created by zhaowei on 2016/12/13.
//  Copyright © 2016年 share. All rights reserved.
//

#import "CategoryViewController.h"
#import "CategoryViewModel.h"
#import "CategoryModel.h"

@interface CategoryViewController ()
@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) CategoryViewModel *viewModel;
@end

@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    [self.viewModel requestNetwork:self.categoryModel completion:^(id obj) {
        [self.tableView reloadData];
    } failure:^(id obj) {
        
    }];
}

- (void)initView {
    __weak typeof(self.view) ws = self.view;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate = self.viewModel;
    tableView.dataSource = self.viewModel;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 45;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ws.mas_top);
        make.leading.mas_equalTo(ws.mas_leading);
        make.trailing.mas_equalTo(ws.mas_trailing);
        make.bottom.mas_equalTo(ws.mas_bottom);
    }];
    self.tableView = tableView;
}

-(CategoryViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[CategoryViewModel alloc] init];
        _viewModel.controller = self;
    }
    return _viewModel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
