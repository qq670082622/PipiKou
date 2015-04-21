//
//  CustomCell.m
//  ShouKeBao
//
//  Created by 吴铭 on 15/3/30.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "CustomCell.h"
#import "UIImageView+WebCache.h"
#import "IWHttpTool.h"
@implementation CustomCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)callAction:(id)sender {
    
    if (self.userTele.text.length>6) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.userTele.text];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];

    }
    else if (self.userTele.text.length<=6){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"失败" message:@"该客户电话号码错误" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
        [alert show];
    }
    }

+ (instancetype)cellWithTableView:(UITableView *)tableView
{ static NSString *cellID = @"customCell";
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:nil options:nil] lastObject];
       }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)setModel:(CustomModel *)model
{
    _model = model;
    self.userIcon.image =  [UIImage imageNamed:@"quanquange"];
    self.userName.text = model.Name;
    self.userTele.text = [NSString stringWithFormat:@"电话：%@",model.Mobile];
    self.userOders.text = [NSString stringWithFormat:@"订单数：%@",model.OrderCount];
    

    }

@end
