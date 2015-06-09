//
//  newModel.h
//  ShouKeBao
//
//  Created by 吴铭 on 15/6/4.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface newModel : NSObject
@property (nonatomic,copy)NSString *Text;
@property (nonatomic,copy)NSString *Value;

+ (instancetype)modalWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
