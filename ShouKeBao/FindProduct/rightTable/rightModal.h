//
//  rightModal.h
//  ShouKeBao
//
//  Created by David on 15/3/17.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
@interface rightModal : BaseModel   
@property (copy, nonatomic) NSString  *rightIcon;
@property (copy, nonatomic) NSString  *rightDescrip;
@property (strong, nonatomic) NSNumber  *rightPrice;
@property (copy,nonatomic) NSMutableString *productUrl;
@property (strong,nonatomic) NSDictionary *ShareInfo;
+ (instancetype)modalWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
