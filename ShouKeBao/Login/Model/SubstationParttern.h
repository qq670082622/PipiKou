//
//  SubstationParttern.h
//  ShouKeBao
//
//  Created by 吴铭 on 15/5/19.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubstationParttern : NSObject
{
    
    NSString *stationName;
    
}
@property (strong,nonatomic)NSString *stationName;
+(id)sharedStationName;

@end
