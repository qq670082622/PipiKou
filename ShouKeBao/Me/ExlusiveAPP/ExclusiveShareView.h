//
//  ExclusiveShareView.h
//  ShouKeBao
//
//  Created by 张正梅 on 15/11/17.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExclusiveShareView : NSObject

+(void)shareWithContent:(id)publishContent backgroundShareView:(id) backgroundShareView naVC:(id)naVC andUrl:(NSString *)url;


@end
