//
//  personIdModel.m
//  ShouKeBao
//
//  Created by 吴铭 on 15/6/15.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "personIdModel.h"
#import "NSDate+Category.h"
#import "NSMutableDictionary+QD.h"
@implementation personIdModel
+(instancetype)modelWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

-(instancetype)initWithDict:(NSDictionary *)dic
{
    if (self = [super init]) {
        
      NSMutableDictionary *dict = [NSMutableDictionary cleanNullResult:dic];
        
        self.UserName = dict[@"UserName"];
        self.Address = dict[@"Address"];
        self.BirthDay = dict[@"BirthDay"];
        self.CardNum = dict[@"CardNum"];
        self.Nationality = dict[@"Nationality"];//民族
        self.Sex = dict[@"Sex"];
       // self.createTime = dict[@"CreateTime"];
        self.Country = dict[@"Country"];//国家
        NSLog(@"%@", dict);
        self.PassportNum = dict[@"PassportNum"];
        self.ValidStartDate = dict[@"ValidStartDate"];
        self.ValidAddress = dict[@"ValidAddress"];
        self.ValidEndDate = dict[@"ValidEndDate"];
        self.ModifyDate = dict[@"ModifyDate"];
        self.PicUrl = dict[@"PicUrl"];
        self.MinPicUrl = dict[@"MinPicUrl"];
        self.RecordId = dict[@"RecordId"];
        self.RecordType = dict[@"RecordType"];
        // NSString *timeStr = dict[@"createTime"];
   //   NSDate *date = [NSDate dateWithTimeIntervalInMilliSecondSince1970:[timeStr doubleValue]];
     //   self.createTime =  [date formattedTime];    
        
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{

}
@end
