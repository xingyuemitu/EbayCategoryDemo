//
//  CategoryModel.m
//  EbayCategoryDemo
//
//  Created by zhaowei on 2016/12/13.
//  Copyright © 2016年 share. All rights reserved.
//

#import "CategoryModel.h"

@implementation CategoryModel
+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
             @"cid"             :@"id",
             @"url"             :@"url",
             @"name"            :@"name",
             @"textColor"       :@"text_color",
             @"borderColor"     :@"border_color",
             @"isOwner"         :@"isOwner",
             @"children"        :@"children"
             };
}

// 如果实现了该方法，则处理过程中不会处理该列表外的属性。
+ (NSArray *)modelPropertyWhitelist {
    return @[
             @"cid",
             @"url",
             @"name",
             @"textColor",
             @"borderColor",
             @"isOwner",
             @"children"
             ];
}
@end
