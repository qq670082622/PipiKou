//
//  personIdModel.h
//  ShouKeBao
//
//  Created by 吴铭 on 15/6/15.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface personIdModel : NSObject

@property (nonatomic,copy) NSString *UserName;
@property (nonatomic,copy) NSString *Address;
@property (nonatomic,copy) NSString *BirthDay;
@property (nonatomic,copy) NSString *CardNum;
@property (nonatomic,copy) NSString *National;
@property (nonatomic,copy) NSString *Nation;
@property (nonatomic,copy) NSString *Sex;
@property (nonatomic,copy) NSString *createTime;
@property (nonatomic,copy) NSString *type;
@property(nonatomic,copy) NSString *Nationality;
@property(nonatomic,copy) NSString *PassportNum;
@property(nonatomic,copy) NSString *ValidStartDate;
@property(nonatomic,copy) NSString *ValidAddress;
@property(nonatomic,copy) NSString *ValidEndDate;


+(instancetype)modelWithDict:(NSDictionary *)dict;
-(instancetype)initWithDict:(NSDictionary *)dict;
@end
