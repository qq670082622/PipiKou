//
//  personIdModel.m
//  ShouKeBao
//
//  Created by 吴铭 on 15/6/15.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "personIdModel.h"
#import "NSDate+Category.h"
@implementation personIdModel
+(instancetype)modelWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        
//        @property (nonatomic,copy) NSString *UserName;
//        @property (nonatomic,copy) NSString *Address;
//        @property (nonatomic,copy) NSString *BirthDay;
//        @property (nonatomic,copy) NSString *CardNum;
//        @property (nonatomic,copy) NSString *National;
//        @property (nonatomic,copy) NSString *Nation;
//        @property (nonatomic,copy) NSString *Sex;
//        @property (nonatomic,copy) NSString *createTime;
//        @property (nonatomic,copy) NSString *type;
//        @property(nonatomic,copy) NSString *Nationality;
//        @property(nonatomic,copy) NSString *PassportNum;
//        @property(nonatomic,copy) NSString *ValidStartDate;
//        @property(nonatomic,copy) NSString *ValidAddress;
//        @property(nonatomic,copy) NSString *ValidEndDate;
//        [self setValuesForKeysWithDictionary:dict];
        self.UserName = dict[@"UserName"];
        self.Address = dict[@"Address"];
        self.BirthDay = dict[@"BirthDay"];
        self.CardNum = dict[@"CardNum"];
        self.National = dict[@"National"];
        self.Nation = dict[@"Nation"];
        self.Sex = dict[@"Sex"];
       // self.createTime = dict[@"CreateTime"];
        self.type = dict[@"type"];
        self.Nationality = dict[@"Nationality"];
        self.PassportNum = dict[@"PassportNum"];
        self.ValidStartDate = dict[@"ValidStartDate"];
        self.ValidAddress = dict[@"ValidAddress"];
        self.ValidEndDate = dict[@"ValidEndDate"];
       
        NSString *timeStr = dict[@"createTime"];
      NSDate *date = [NSDate dateWithTimeIntervalInMilliSecondSince1970:[timeStr doubleValue]];
        self.createTime =  [date formattedTime];
    }
    return self;
}
@end
