//
//  jsMethod.h
//  piaodaren
//
//  Created by David on 15/2/11.
//  Copyright (c) 2015年 novaloncn.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface jsMethod : UIWebView
+(NSString *)getUidFormJS:(NSString *)methodName andwebView:(UIWebView *)webView;
+(void)postToJs:(NSString *)data;
@end
