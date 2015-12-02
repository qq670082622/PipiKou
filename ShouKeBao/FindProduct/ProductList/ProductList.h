//
//  ProductList.h
//  ShouKeBao
//
//  Created by David on 15/3/17.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProduceDetailViewController.h"
#import "SKViewController.h"
typedef enum{
    FromKeyWord,
    FromSearch
}ProductListFrom;

@interface ProductList : SKViewController//<passValue>


@property (nonatomic,copy) NSString *pushedSearchK;
//@property (nonatomic,copy) NSString *productTitle;
@property(nonatomic,strong) NSMutableArray *pushedArr;
@property(nonatomic,assign) BOOL isFromSearch;
@property (nonatomic, assign)ProductListFrom productListFrom;
@end
