//
//  ShareView.h
//  ShouKeBao
//
//  Created by 张正梅 on 15/9/28.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareView : NSObject

//+(void)shareWithContent:(id)publishContent Flag:(BOOL)flag;
+(void)shareWithContent:(id)publishContent andUrl:(NSString *)url;
+ (void)cancleBtnClick;


@end
