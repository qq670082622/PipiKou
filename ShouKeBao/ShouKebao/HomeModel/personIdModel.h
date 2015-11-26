//
//  personIdModel.h
//  ShouKeBao
//
//  Created by 吴铭 on 15/6/15.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
@interface personIdModel : BaseModel

@property (nonatomic,copy) NSString *UserName;

@property (nonatomic,copy) NSString *Address;

@property (nonatomic,copy) NSString *BirthDay;

@property (nonatomic,copy) NSString *CardNum;

@property (nonatomic,copy) NSString *Nationality;//民族

@property (nonatomic,copy) NSString *Sex;

@property (nonatomic,copy) NSString *RecordType;

@property(nonatomic,copy) NSString *Country;//国家

@property(nonatomic,copy) NSString *PassportNum;//护照号

@property(nonatomic,copy) NSString *ValidStartDate;

@property(nonatomic,copy) NSString *ValidAddress;

@property(nonatomic,copy) NSString *ValidEndDate;

@property (nonatomic,copy) NSString *PicUrl;
@property (nonatomic,copy) NSString *MinPicUrl;

@property (nonatomic,copy) NSString *ModifyDate;//修改日期



@property (nonatomic,copy) NSString *RecordId;//纪录ID
+(instancetype)modelWithDict:(NSDictionary *)dict;
-(instancetype)initWithDict:(NSDictionary *)dict;
@end
