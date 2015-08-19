//
//  ShaiXuanViewController.h
//  ShouKeBao
//
//  Created by 吴铭 on 15/8/17.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShaiXuanViewController : UIViewController
{
    UITableView *subTable;
    NSArray *dataArr;
    
}
@property(nonatomic,strong) NSMutableArray *pushedArr;
@property (strong,nonatomic) NSMutableArray *conditionArr;//post装载的条件数据
@end
