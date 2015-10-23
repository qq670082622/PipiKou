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
    UILabel *lowPlabel;
    UILabel *tallPlabel;
    UITextField *lowPrice;
    UITextField *tallPrice;
    UIButton *sixbutton;
}
@property(nonatomic,strong) NSMutableArray *pushedArr;
@property (strong,nonatomic) NSMutableArray *conditionArr;//post装载的条件数据
@property (copy,nonatomic) NSMutableString * MinPricecondition;
@property (copy,nonatomic) NSMutableString * MaxPricecondition;
@property(nonatomic) NSInteger primaryNum;//价格区间的预选值
@property(nonatomic) NSDictionary *siftHLDic;//滑轮的数据

-(void)putTextField;
@end
