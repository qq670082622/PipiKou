//
//  Orders.h
//  ShouKeBao
//
//  Created by David on 15/3/12.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKViewController.h"

@interface Orders : SKViewController
{
    UIBarButtonItem *_barItem;
    UIBarButtonItem *_barItem2;
}
@property (nonatomic,strong) NSMutableArray *invoiceArr;//存放 选中开发票 cell
-(void)ChangeFrame;
@end
