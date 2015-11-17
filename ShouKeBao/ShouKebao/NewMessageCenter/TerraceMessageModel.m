//
//  TerraceMessageModel.m
//  ShouKeBao
//
//  Created by 冯坤 on 15/11/17.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "TerraceMessageModel.h"

@implementation TerraceMessageModel


+(TerraceMessageModel *)modelWithDic:(NSDictionary *)dic{
    TerraceMessageModel * model = [[TerraceMessageModel alloc]init];
    [model setValuesForKeysWithDictionary:dic];
    return model;
}
@end
