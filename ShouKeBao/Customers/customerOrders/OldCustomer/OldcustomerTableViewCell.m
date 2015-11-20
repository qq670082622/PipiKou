//
//  OldcustomerTableViewCell.m
//  ShouKeBao
//
//  Created by 张正梅 on 15/11/20.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "OldcustomerTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "IWHttpTool.h"
#import "MobClick.h"
#import "BaseClickAttribute.h"

@implementation OldcustomerTableViewCell

- (IBAction)callAction:(id)sender {
    
    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
    [MobClick event:@"CustomCallClick" attributes:dict];
    
    if (self.model.Mobile.length>6) {
        
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel://%@",self.model.Mobile];
        NSLog(@"电话号码是%@",str);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        
    }
    else if (self.model.Mobile.length<=6){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"失败" message:@"该客户电话号码错误" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
        
        [alert show];
    }
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *cellID = @"oldCustomCell";
    OldcustomerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"OldcustomerTableViewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

-(void)setModel:(CustomModel *)model{
    _model = model;
    self.userIcon.image =  [UIImage imageNamed:@"quanquange"];
    self.userName.text = model.Name;
    
    //    利用正则法则处理电话号码
    NSString *pattern = @"\\d";//@"[0-9]"
    NSRegularExpression *regular = [[NSRegularExpression alloc]initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *results = [regular matchesInString:model.Mobile options:0 range:NSMakeRange(0, model.Mobile.length)];
    
    NSMutableArray *arr = [NSMutableArray array];
    for (NSTextCheckingResult *result in results) {
        [arr addObject:[model.Mobile substringWithRange:result.range]];
    }
    NSString *tel = [NSString string];
    for (NSInteger i = 0; i < arr.count; i++) {
        tel = [tel stringByAppendingString:arr[i]];
    }
    
    self.userTele.text = [NSString stringWithFormat:@"电话：%@",tel];
    self.userOders.text = [NSString stringWithFormat:@"订单数：%@",model.OrderCount];
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
