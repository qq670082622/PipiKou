//
//  batchModel.h
//  ShouKeBao
//
//  Created by 吴铭 on 15/3/31.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface batchModel : NSObject
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *recordID;
@property(nonatomic,copy)NSString *tel;
@property(nonatomic,copy)NSString *email;

-(id)init;

@end
