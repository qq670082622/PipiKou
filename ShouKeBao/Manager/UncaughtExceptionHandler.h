//
//  UncaughtExceptionHandler.h
//  ShouKeBao
//
//  Created by 冯坤 on 15/6/23.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UncaughtExceptionHandler : NSObject
{
        
    BOOL dismissed;
        
}
void InstallUncaughtExceptionHandler();
@end
