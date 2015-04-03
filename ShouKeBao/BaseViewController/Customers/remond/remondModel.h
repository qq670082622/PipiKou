//
//  remondModel.h
//  ShouKeBao
//
//  Created by 吴铭 on 15/3/31.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface remondModel : NSObject
@property (nonatomic,copy) NSString *Content;
@property (nonatomic,copy) NSString *RemindTime;
@property (nonatomic,copy) NSString *ID;
+ (instancetype)modalWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
