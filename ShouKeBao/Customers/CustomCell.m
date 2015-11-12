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
#import "MobClick.h"
#import "BaseClickAttribute.h"

static id _naNC;

@implementation CustomCell

 
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

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

- (IBAction)informationIM:(id)sender {
    
    //    if ([self.model.ProgressState integerValue] == 0) {
    //        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"TA还不是您的专属客户,马上向TA发送邀请成为您的专属客户吧!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"邀请", nil];
    //        [alert show];
    //    }else{
    //        if (_delegate && [_delegate respondsToSelector:@selector(transformPerformation:)]) {
    //            [_delegate transformPerformation:sender];
    //        }
    //
    //
    //    }
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"TA还不是您的专属客户,马上向TA发送邀请成为您的专属客户吧!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"邀请", nil];
    [alert show];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        //        点击邀请走的方法
        NSLog(@",,,.........");
        
        //  方式1:不能指定短信内容
        //        NSString *telStr = [NSString stringWithFormat:@"sms://%@", self.telStr];
        //        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telStr]];
        
        //  方式2:指定短信内容
        if([MFMessageComposeViewController canSendText]){// 判断设备能不能发送短信
            MFMessageComposeViewController *MFMessageVC = [[MFMessageComposeViewController alloc] init];
            // 设置短信内容
            MFMessageVC.body = @"吃饭了吗 好饿呀！！";
            // 设置收件人列表
            MFMessageVC.recipients = @[self.telStr];
            // 设置代理
            MFMessageVC.messageComposeDelegate = self;
            
            [_naNC presentViewController:MFMessageVC animated:YES completion:nil];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"该设备不支持短信功能" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
    }
}

//短信代理方法
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    // 关闭短信界面
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    if (result == MessageComposeResultCancelled) {
        NSLog(@"取消发送");
    } else if (result == MessageComposeResultSent) {
        NSLog(@"已经发出");
    } else {
        NSLog(@"发送失败");
    }
    
}



+ (instancetype)cellWithTableView:(UITableView *)tableView navigationC:(UINavigationController *)naNC{
    
     _naNC = naNC;
    static NSString *cellID = @"customCell";
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:nil options:nil] lastObject];
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
//        NSLog(@"%@   %@", NSStringFromRange(result.range), [d substringWithRange:result.range]);
        [arr addObject:[model.Mobile substringWithRange:result.range]];
    }
    NSString *tel = [NSString string];
    for (NSInteger i = 0; i < arr.count; i++) {
        tel = [tel stringByAppendingString:arr[i]];
    }
    self.telStr = tel;
    self.userTele.text = [NSString stringWithFormat:@"电话：%@",tel];
    self.userOders.text = [NSString stringWithFormat:@"订单数：%@",model.OrderCount];
    
    
//    if ([self.model.ProgressState integerValue] == 1) {
//        [self.information setImage:[UIImage imageNamed:@"redMessage"] forState:UIControlStateNormal];
//    }
    
    
}


@end
