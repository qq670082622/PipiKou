//
//  WriteFileManager.h
//  hishow
//
//  Created by Chard on 15/3/14.
//  Copyright (c) 2015年 haixun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WriteFileManager : NSObject

// plist存储
+ (NSArray *)saveFileWithArray:(NSArray *)array Name:(NSString *)name;

+ (NSArray *)readFielWithName:(NSString *)name;

// 模型存储
+ (NSArray *)saveData:(NSArray *)array name:(NSString *)name;

+ (NSArray *)readData:(NSString *)name;

+ (NSMutableArray *)WMsaveData:(NSMutableArray *)array name:(NSString *)name;

+ (NSMutableArray *)WMreadData:(NSString *)name;

// 保存图片
+ (BOOL)saveImageToCacheDir:(NSString *)directoryPath image:(UIImage *)image imageName:(NSString *)imageName imageType:(NSString *)imageType;

// 读取图片
+ (NSData *)loadImageData:(NSString *)directoryPath imageName:(NSString *)imageName;

@end
