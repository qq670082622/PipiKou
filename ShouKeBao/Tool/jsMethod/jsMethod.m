//
//  jsMethod.m
//  piaodaren
//
//  Created by David on 15/2/11.
//  Copyright (c) 2015年 novaloncn.com. All rights reserved.
//

#import "jsMethod.h"
#import "NSString+Base64Util.h"
#import "StrToDic.h"
@implementation jsMethod
+(NSString *)getUidFormJS:(NSString *)methodName andwebView:(UIWebView *)webView
{
    NSString *result = [webView  stringByEvaluatingJavaScriptFromString:methodName];//此一句话即可得到页面传来的值
    NSString *newStr = [result decryptUseDESWithkey:@"drkqsell"];
    NSDictionary *dic = [StrToDic dictionaryWithJsonString:newStr];
    return dic[@"result"][@"userid"];
}
+(void)postToJs:(NSString *)data
{

}

@end
