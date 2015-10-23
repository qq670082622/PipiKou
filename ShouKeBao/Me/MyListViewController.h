//
//  MyListViewController.h
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/1.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "SKTableViewController.h"

typedef enum : NSUInteger {
    collectionType,
    previewType,
    RelatedProductType
} ListType;

@interface MyListViewController : SKTableViewController

@property (nonatomic,assign) ListType listType;
@property (nonatomic, copy)NSString * productId;
@end
