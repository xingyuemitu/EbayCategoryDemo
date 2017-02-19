//
//  CategoryViewModel.h
//  EbayCategoryDemo
//
//  Created by zhaowei on 2016/12/13.
//  Copyright © 2016年 share. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryViewModel : NSObject<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,weak) UIViewController *controller;
- (void)requestNetwork:(id)parmaters completion:(void (^)(id))completion failure:(void (^)(id))failure;
@end
