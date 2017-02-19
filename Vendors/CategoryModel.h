//
//  CategoryModel.h
//  EbayCategoryDemo
//
//  Created by zhaowei on 2016/12/13.
//  Copyright © 2016年 share. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryModel : NSObject
@property(assign, nonatomic) NSInteger *cid;
@property(strong, nonatomic) NSString* borderColor;
@property(strong, nonatomic) NSString* textColor;
@property(strong, nonatomic) NSString* url;
@property(strong, nonatomic) NSString* name;
@property(assign, nonatomic) BOOL isOwner;
@property(strong, nonatomic) NSArray *children;
@end
