//
//  CategoriesViewController.m
//  EbayCategoryDemo
//
//  Created by zhaowei on 2016/12/13.
//  Copyright © 2016年 share. All rights reserved.
//

#import "CategoriesViewController.h"
#import "CategoryModel.h"
#import "CategoryViewController.h"

@interface CategoriesViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
@property (nonatomic, weak) UICollectionView *collectionView;
@end

@implementation CategoriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
}

- (void)initView {
    //添加约束，进行自动布局
    __weak typeof(self.view) ws = self.view;
    ws.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor whiteColor];
    //隐藏滚动条
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.alwaysBounceVertical = YES;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"categories"];
    collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [ws addSubview:collectionView];
    
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ws.mas_top);
        make.leading.mas_equalTo(ws.mas_leading);
        make.trailing.mas_equalTo(ws.mas_trailing);
        make.bottom.mas_equalTo(ws.mas_bottom);
    }];
    
    self.collectionView = collectionView;
}

#pragma mark  设置CollectionView的组数

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"categories" forIndexPath:indexPath];
    cell.backgroundColor = YSCOLOR_RANDOM;
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemWidth = (SCREEN_WIDTH - 100)/3.0;
    if (SCREEN_WIDTH == 375) {
        NSInteger row =  indexPath.row % 3;
        switch (row) {
            case 0:
                itemWidth = (NSInteger)itemWidth + 0.0;
                break;
            case 1:
                itemWidth = (NSInteger)itemWidth + 1.0;
                break;
            case 2:
                itemWidth = (NSInteger)itemWidth + 1.0;
                break;
            default:
                break;
        }
    }
    return CGSizeMake(itemWidth, 116);
}

#pragma mark  定义每个UICollectionView的横向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

#pragma mark  定义每个UICollectionView的纵向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CategoryModel *rootModel = [CategoryModel new];
    rootModel.name = [NSString stringWithFormat:@"NAME-%ld",indexPath.item];
    rootModel.isOwner = YES;
    CategoryViewController *controller = [CategoryViewController new];
    controller.categoryModel = rootModel;
    [self.navigationController pushViewController:controller animated:YES];
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
