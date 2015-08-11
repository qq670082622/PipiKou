//
//  rightModal2.h
//  ShouKeBao
//
//  Created by David on 15/3/17.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
@interface rightModal2 : BaseModel  
@property(nonatomic,copy) NSString  *title;
@property (nonatomic,copy) NSString *Name;
//@property (nonatomic,copy) NSString *SearchKey;
@property (nonatomic, strong)NSMutableArray * subNameArray;
@property (nonatomic, strong)NSMutableArray * searchKeyArray;
+ (instancetype)modalWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
