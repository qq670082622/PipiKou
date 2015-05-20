//
//  SubstationParttern.m
//  ShouKeBao
//
//  Created by 吴铭 on 15/5/19.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "SubstationParttern.h"

@implementation SubstationParttern
@synthesize stationName;
+(id)sharedStationName
{
    static SubstationParttern *shareStationName = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once (&onceToken,^{
        
        shareStationName = [[self alloc]init];
    });
    
    return shareStationName;
    
}


-(id)init
{
    if (self = [super init])
    {
          NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
        stationName = [accountDefaults objectForKey:@"SubstationName"];
       
    }
    return self;
}

@end
