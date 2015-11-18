//
//  CustomDynamicModel.m
//  ShouKeBao
//
//  Created by 冯坤 on 15/11/17.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "CustomDynamicModel.h"
#import "ProductModal.h"
@implementation CustomDynamicModel
+(CustomDynamicModel*)modelWithDic:(NSDictionary *)dic{
    CustomDynamicModel * model = [[CustomDynamicModel alloc]init];
    [model setValuesForKeysWithDictionary:dic];
    return model;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"Productdetail"]) {
        self.ProductdetailModel = [[ProductModal alloc]init];
        [self.ProductdetailModel setValuesForKeysWithDictionary:value];
    }
}
@end
