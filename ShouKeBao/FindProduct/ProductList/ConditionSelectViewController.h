//
//  ConditionSelectViewController.h
//  ShouKeBao
//
//  Created by 吴铭 on 15/3/25.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKViewController.h"
@protocol passValue <NSObject>
-(void)passKey:(NSString *)key andValue:(NSString *)value andSelectIndexPath:(NSArray *)selectIndexPath andSelectValue:(NSString *)selectValue;
@end
@interface ConditionSelectViewController : SKViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *table;
@property(copy , nonatomic) NSString *conditionTitle;
@property (strong , nonatomic) NSMutableArray *dataArr1;
@property (strong , nonatomic) NSArray *superViewSelectIndexPath;//格式[1,1] (前面代表section，后面代表row)
@property (strong , nonatomic) NSDictionary *conditionDic;
@property (nonatomic,copy) NSString *selectConditionName;
@property (nonatomic,weak) id<passValue> delegate;
@end
