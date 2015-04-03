//
//  CustomModel.h
//  ShouKeBao
//
//  Created by 吴铭 on 15/3/30.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomModel : NSObject
//@property (nonatomic,copy) NSString *userIcon;
@property (nonatomic,copy) NSString *Name;
@property (nonatomic,copy) NSString *Mobile;
@property (nonatomic,copy) NSString *OrderCount;
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *QQCode;
@property (nonatomic,copy) NSString *Remark;
@property (nonatomic,copy) NSString *WeiXinCode;
+ (instancetype)modalWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
