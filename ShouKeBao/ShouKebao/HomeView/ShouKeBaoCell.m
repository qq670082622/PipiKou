//
//  tableviewCell.m
//  ShouKeBao
//
//  Created by 吴铭 on 15/3/27.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "ShouKeBaoCell.h"
#import "HomeList.h"
#import "Recommend.h"
#import "HomeBase.h"
#import "NSDate+Category.h"

@interface ShouKeBaoCell()

@end

@implementation ShouKeBaoCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellID = @"ShouKeBaoCell";
    ShouKeBaoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[ShouKeBaoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
            }
    return self;
}

- (void)setup
{
    // 图标
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.layer.cornerRadius = 3;
    iconView.layer.masksToBounds = YES;
    [self.contentView addSubview:iconView];
    self.iconView = iconView;
    
    // 标题
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.font = [UIFont boldSystemFontOfSize:15];
    [self.contentView addSubview:titleLab];
    self.titleLab = titleLab;
    
    // 时间
    UILabel *timeLab = [[UILabel alloc] init];
    timeLab.textColor = [UIColor lightGrayColor];
    timeLab.textAlignment = NSTextAlignmentRight;
    timeLab.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:timeLab];
    self.timeLab = timeLab;
    
    //出发时间
    UILabel *goDate = [[UILabel alloc] init];
    goDate.textColor = [UIColor grayColor];
    goDate.textAlignment = NSTextAlignmentLeft;
    goDate.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:goDate];
    self.goDate = goDate;

    // 左边待定内容
    UILabel *leftLab = [[UILabel alloc] init];
    leftLab.font = [UIFont boldSystemFontOfSize:15];
    leftLab.textColor = [UIColor redColor];
    [self.contentView addSubview:leftLab];
    self.leftLab = leftLab;
    

    // 右边待定内容
    UILabel *rightLab = [[UILabel alloc] init];
    rightLab.font = [UIFont systemFontOfSize:12];
    rightLab.textAlignment = NSTextAlignmentRight;
    rightLab.textColor = [UIColor colorWithRed:13/255.0 green:122/255.0 blue:1 alpha:1];
    [self.contentView addSubview:rightLab];
    self.rightLab = rightLab;
    

    // 详情
    UILabel *detailLab = [[UILabel alloc] init];
    detailLab.textColor = [UIColor grayColor];
    detailLab.font = [UIFont systemFontOfSize:14];
    detailLab.numberOfLines = 0;
    [self.contentView addSubview:detailLab];
    self.detailLab = detailLab;
    
    //编号
    UILabel *codeLab = [[UILabel alloc] init];
    codeLab.font = [UIFont systemFontOfSize:12];
    codeLab.textAlignment = NSTextAlignmentLeft;
    codeLab.textColor = [UIColor colorWithRed:13/255.0 green:122/255.0 blue:1 alpha:1];
    [self.contentView addSubview:codeLab];
    self.codeLab = codeLab;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    
    // 图标
    CGFloat iconW = 35;
    self.iconView.frame = CGRectMake(gap, gap, iconW, iconW);
    
    // 标题
    CGFloat titleX = CGRectGetMaxX(self.iconView.frame) + gap;
    CGFloat titleW = (screenW - iconW - gap * 4) * 0.5;
    self.titleLab.frame = CGRectMake(titleX, gap, titleW, 20);
    // 右侧时间
    CGFloat timeX = CGRectGetMaxX(self.titleLab.frame) + gap;
    self.timeLab.frame = CGRectMake(timeX, gap, titleW, 20);
    
// 右边待定内容(订单人数)
    CGFloat rightX = screenW/2;
    CGFloat rightW = rightX - gap;
    CGFloat rightY = CGRectGetMaxY(self.timeLab.frame);
    self.rightLab.frame = CGRectMake(rightX, rightY, rightW, 15);
    
      //中间出发时间
    self.goDate.frame = CGRectMake(titleX, rightY, screenW*2/3, 15);
    
    // 详情
    CGFloat detailY = CGRectGetMaxY(self.rightLab.frame);
    CGFloat detailW = screenW - iconW - gap * 3;
    self.detailLab.frame = CGRectMake(titleX, detailY, detailW, 40);
    
    //编号
    CGFloat codeY = CGRectGetMaxY(self.detailLab.frame);
    self.codeLab.frame = CGRectMake(titleX, codeY, rightW, 15);
    
    // 左边待定内容(订单价格)
    CGFloat priceX = screenW - 60 - gap;
    CGFloat priceW = 60;
    self.leftLab.frame = CGRectMake(priceX, codeY, priceW, 15);
}

- (void)setModel:(HomeList *)model
{
    _model = model;
    
    //OrderStateDetail
 //   订单状态（1等待提交采购、2等待提交游客信息、3等待支付订单、4等待下载出团通知书	int
    // 根据订单配图标
    
    if ([model.OrderStateDetail integerValue] == 1) {
        self.iconView.image = [UIImage imageNamed:@"ddcaigou"];
        
    }else if ([model.OrderStateDetail integerValue] == 2){
        self.iconView.image = [UIImage imageNamed:@"dingdanqueren"];
    }else if ([model.OrderStateDetail integerValue] == 3){
        self.iconView.image = [UIImage imageNamed:@"dengdaizhif"];
   
    }else if ([model.OrderStateDetail integerValue] == 4){
            self.iconView.image = [UIImage imageNamed:@"xztzs"];

    }
    self.rightLab.text = [NSString stringWithFormat:@"%@ %@",model.PersonCount,model.ChildCount];
//    if ([model.IsSKBOrder integerValue] == 1) {
//        self.iconView.image = [UIImage imageNamed:@"zhike"];
//        // 右边待定内容
//        self.rightLab.text = [NSString stringWithFormat:@"%@ %@",model.PersonCount,model.ChildCount];
//    }
//    
//    else{
//        self.iconView.image = [UIImage imageNamed:@"dingdanyue"];
//      
//         self.rightLab.text = [NSString stringWithFormat:@"%@ %@",model.PersonCount,model.ChildCount];
//    }
    
    // 标题
    self.titleLab.text = model.ShowType;
    
    //GoDate
    NSDate *goDate = [NSDate dateWithTimeIntervalSince1970:[model.GoDate doubleValue]];
    NSLog(@"godate is %@",[goDate formattedTime]);
    if ([[goDate formattedTime] isEqualToString:@"00:00"]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"YYYY-MM-dd"];
      NSString  *date = [formatter stringFromDate:[NSDate date]];//得到时间戳
        NSString *last = [date substringFromIndex:date.length-1];//取出时间戳最后一位
        NSString *new = [NSString stringWithFormat:@"%ld",[last integerValue]+1];//将最后一位的字符数组＋1
        NSString *strat = [date substringToIndex:9];//取出前9位
        self.goDate.text = [NSString stringWithFormat:@"%@%@出发",strat,new];//拼接成新的时间戳
    }else{
    self.goDate.text = [NSString stringWithFormat:@"%@出发",[goDate formattedTime]];
    }
    // 时间
    NSDate *createDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:[model.CreatedDate doubleValue]];
    self.timeLab.text = [createDate formattedTime];
    
    // 左边待定内容
    self.leftLab.text = model.Price;
    
    // 右边待定内容
    self.codeLab.text = model.OrderCode;
    
    // 详情
    self.detailLab.text = model.ProductName;
}

@end
