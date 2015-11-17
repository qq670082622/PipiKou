//
//  CustomerSection.h
//  ShouKeBao
//
//  Created by 张正梅 on 15/11/16.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomerSection : NSObject
@property (nonatomic, copy) NSString *letter;
@property (nonatomic, strong)NSMutableArray *newsBindingCustomArr;
@property (nonatomic, strong)NSMutableArray *hadBindingCustomArr;
@property (nonatomic, strong)NSMutableArray *otherCustomArr;


@end
