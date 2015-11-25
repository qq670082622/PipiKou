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
#import "IChatManagerConversation.h"
#import "EaseMob.h"

static id _naNC;
static id _invitationInfo;


@interface CustomCell ()
@property (nonatomic, strong)UIView * redDot;

@end


@implementation CustomCell


- (void)awakeFromNib {
    [self.information addSubview:self.redDot];
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
    
    if ([self.model.IsOpenIM integerValue] == 0) {
        //            [self achieveInvitationInfoData:self.model.ID];
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"TA还不是你的绑定APP客户,马上邀请TA绑定你的专属APP吧!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"邀请", nil];
        [alert show];
    }else{
        NSLog(@"%@", self.model.AppSkbUserId);
        if (_delegate && [_delegate respondsToSelector:@selector(transformPerformation:)]) {
            [_delegate transformPerformation:self.model];
        }
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSLog(@".....self.InvitationInfo = %@", _invitationInfo);
    
    if (buttonIndex == 1) {
        //        点击邀请走的方法
        //  方式1:不能指定短信内容
        //        NSString *telStr = [NSString stringWithFormat:@"sms://%@", self.telStr];
        //        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telStr]];
        
        //  方式2:指定短信内容
        if([MFMessageComposeViewController canSendText]){// 判断设备能不能发送短信
            MFMessageComposeViewController *MFMessageVC = [[MFMessageComposeViewController alloc] init];
            
            MFMessageVC.body = _invitationInfo;
            MFMessageVC.recipients = @[self.telStr];
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

- (void)achieveInvitationInfoData:(NSString *)CustomerID {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:CustomerID forKey:@"CustomerID"];
    
    [IWHttpTool WMpostWithURL:@"/Customer/GetCustomer" params:dic success:^(id json){
        NSLog(@"---cell---管客户json is %@-------",json);
        //    self.InvitationInfo = json[@"Customer"][@"InvitationInfo"];
    } failure:^(NSError *error) {
        NSLog(@"接口请求失败 error is %@------",error);
    }];
}

+(instancetype)cellWithTableView:(UITableView *)tableView InvitationInfo:(NSString *)invitationInfo navigationC:(UINavigationController *)naNC{
    
    _invitationInfo = invitationInfo;
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
    
    _model = model;
    //获取消息数， 展示是否有消息未读
    NSUInteger unreaderMessageCount = [[EaseMob sharedInstance].chatManager unreadMessagesCountForConversation:self.model.AppSkbUserId];
    if (unreaderMessageCount) {
        self.redDot.hidden = NO;
    }else{
        self.redDot.hidden = YES;
    }
    NSLog(@"&&&&&&--%lud", (unsigned long)unreaderMessageCount);

    
    
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
    self.telStr = tel;
    self.userTele.text = [NSString stringWithFormat:@"电话：%@",tel];
    self.userOders.text = [NSString stringWithFormat:@"订单数：%@",model.OrderCount];
    
    
    if ([self.model.IsOpenIM integerValue] == 0) {
        [self.information setImage:[UIImage imageNamed:@"grayxiaoxi"] forState:UIControlStateNormal];
    }
    
    
    //    if ([self.model.IsOpenIM integerValue] == 1 /*&& 提示有对话消息时*/) {
    //        [self.information setImage:[UIImage imageNamed:@"redMessage"] forState:UIControlStateNormal];
    //    }
  
}
-(UIView *)redDot{
    if (!_redDot) {
        _redDot = [[UIView alloc]initWithFrame:CGRectMake(22, 3, 8, 8)];
        _redDot.backgroundColor = [UIColor redColor];
        _redDot.layer.cornerRadius = 4.0;
        _redDot.layer.masksToBounds = YES;
    }
    return _redDot;
}


@end
