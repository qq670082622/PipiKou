//
//  MessageCenterModel.h
//  ShouKeBao
//
//  Created by 冯坤 on 15/11/17.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "BaseModel.h"

@interface MessageCenterModel : BaseModel
@property (nonatomic, strong)NSString * messageTitle;
@property (nonatomic, strong)NSString * dateStr;
@property (nonatomic, strong)NSString * messageCount;
@end
