//
//  HeaderSectionView.m
//  ShouKeBao
//
//  Created by 冯坤 on 15/8/10.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "HeaderSectionView.h"
#import "ProductList.h"
@implementation HeaderSectionView

- (IBAction)AllClick:(id)sender {
    ProductList * productList = [[ProductList alloc]init];
    productList.pushedSearchK = self.nameLab.text;
    productList.title = self.nameLab.text;
    [self.FindProductNav pushViewController:productList animated:YES];
}
@end
