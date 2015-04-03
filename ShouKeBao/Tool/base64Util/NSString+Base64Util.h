//
//  NSString+Base64Util.h
//  piaodaren
//
//  Created by David on 15/2/9.
//  Copyright (c) 2015年 novaloncn.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Base64Util)
- (NSString*)decryptUseDESWithkey:(NSString*)key;
- (NSString *)encryptUseDESWithkey:(NSString *)key;

@end
