//
//  ShaiXuanCell.h
//  ShouKeBao
//
//  Created by 吴铭 on 15/8/17.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShaiXuanCell : UITableViewCell
{
    UILabel *NameLabel;
    UILabel *CityLabel;
}
//接收cell前面的字符串
@property(nonatomic,copy)NSString *str;
//接受cell后面的传值
@property(nonatomic,copy)NSString *contentStr;
-(void)showdataWithString:(NSString *)nameStr;
@end
