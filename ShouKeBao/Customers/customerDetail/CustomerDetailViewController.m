//
//  CustomerDetailViewController.m
//  ShouKeBao
//
//  Created by 吴铭 on 15/3/30.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "CustomerDetailViewController.h"
#import "EditCustomerDetailViewController.h"
#import "CustomerOrdersUIViewController.h"
#import "remondViewController.h"
#import "IWHttpTool.h"
#import "MBProgressHUD+MJ.h"
#import "CustomModel.h"
#import "MobClick.h"
#import "attachmentViewController.h"
#import "CustomerOrderViewController.h"

@interface CustomerDetailViewController ()<UITextFieldDelegate,notifiToRefereshCustomerDetailInfo,UIActionSheetDelegate, UITableViewDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *SetRemindBtnOutlet;
@end

@implementation CustomerDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"客户详情";
    self.tableView.delegate = self;
   // [self.SetRemindBtnOutlet setHighlighted:NO];
    
    [self setSubViews];
    if (self.note.text == nil) {
        self.note.text = @"备注信息";
    }
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,15,20)];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"backarrow"] forState:UIControlStateNormal];

    
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    self.navigationItem.leftBarButtonItem= leftItem;
    self.SetRemindBtnOutlet.imageEdgeInsets = UIEdgeInsetsMake(0, 32, 0, 0);
  
}

-(void)back
{
//     [self.initDelegate reloadMethod];
    [self.navigationController popViewControllerAnimated:YES];
}

//-(BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    [self.weChat resignFirstResponder];
//   [self.QQ resignFirstResponder];
//    [self.note resignFirstResponder];
//    [self.tele resignFirstResponder];
//    return YES;
//}
//-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    if ([text isEqualToString:@"\n"]) {
//        [self.note resignFirstResponder];
//        return NO;
//    }
//    return YES;
//    
//}
//@property (weak, nonatomic) IBOutlet UILabel *passPortId;
//@property (weak, nonatomic) IBOutlet UILabel *userMessageID;
//
//@property (weak, nonatomic) IBOutlet UILabel *bornDay;
//
//@property (weak, nonatomic) IBOutlet UILabel *countryID;
//@property (weak, nonatomic) IBOutlet UILabel *nationalID;
//@property (weak, nonatomic) IBOutlet UILabel *pasportStartDay;
//@property (weak, nonatomic) IBOutlet UILabel *pasportAddress;
//@property (weak, nonatomic) IBOutlet UILabel *pasportInUseDay;
//@property (weak, nonatomic) IBOutlet UILabel *livingAddress;

-(void)setSubViews{
        self.QQ.text = self.QQStr;
    self.weChat.text = self.weChatStr;
    self.tele.text = self.teleStr;
    self.note.text = self.noteStr;
    self.userName.text = self.userNameStr;
    
    
    self.passPortId.text = self.customMoel.PassportNum;
    self.userMessageID.text = self.customMoel.CardNum;
    self.bornDay.text = self.customMoel.BirthDay;
    self.countryID.text = self.customMoel.Country;
    self.nationalID.text = self.customMoel.Nationality;
    self.pasportStartDay.text = self.customMoel.ValidStartDate;
    self.pasportAddress.text  = self.customMoel.ValidAddress;
    self.pasportInUseDay.text = self.customMoel.ValidEndDate;
    self.livingAddress.text = self.customMoel.Address;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"CustomerDetailViewController"];
    // [self.segmentControl setSelectedSegmentIndex:0];

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"CustomerDetailViewController"];
}

//-(void)sex:(id)sender
//{
//    UISegmentedControl *control = (UISegmentedControl *)sender;
//    if (control.selectedSegmentIndex == 1) {
//        CustomerOrdersUIViewController *orders = [[CustomerOrdersUIViewController alloc] init];
//        [self.navigationController pushViewController:orders animated:NO];
//    }
//}

#pragma -mark 编辑用户资料后通知更新
- (void)refreshCustomerInfoWithName:(NSString *)name andQQ:(NSString *)qq andWeChat:(NSString *)weChat andPhone:(NSString *)phone andCardID:(NSString *)cardID andBirthDate:(NSString *)birthdate andNationablity:(NSString *)nationablity andNation:(NSString *)nation andPassportStart:(NSString *)passPortStart andPassPortAddress:(NSString *)passPortAddress andPassPortEnd:(NSString *)passPortEnd andAddress:(NSString *)address andPassport:(NSString *)passPort andNote:(NSString *)note
{
    
    self.QQ.text = qq;
    self.weChat.text = weChat;
    self.tele.text = phone;
    self.note.text = note;
    self.userName.text = name;
    //   新添加
    self.userMessageID.text = cardID;
    self.bornDay.text = birthdate;
    self.countryID.text = nationablity;
    self.nationalID.text = nation;
    self.passPortId.text = passPortStart;
    self.pasportAddress.text = passPortAddress;
    self.pasportInUseDay.text = passPortEnd;
    self.passPortId.text = passPort;
    self.livingAddress.text = address;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)remond:(id)sender {
    NSLog(@"gggggggggg");
    
    remondViewController *remond = [[remondViewController alloc] init];
    remond.ID = self.ID;
    remond.customModel = self.customMoel;
    [self.navigationController pushViewController:remond animated:YES];
   
    
}

- (IBAction)deleteCustomer:(id)sender {
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"您确定要删除吗？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles: nil];
     [sheet showInView:self.view];
    
//   搜索删除后执行的方法
//      [self.delegate deleteCustomerWith:self.tele.text];
 
  }
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {

        MBProgressHUD *hudView = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
        hudView.labelText = @"删除中...";
        [hudView show:YES];
       
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:self.ID forKey:@"CustomerID"];
        [IWHttpTool WMpostWithURL:@"/Customer/DeleteCustomer" params:dic success:^(id json) {
            NSLog(@"删除客户信息成功%@",json);
            
//   删除后需要刷新列表的执行的方法
//   协议传值3:让第二页的代理人(delegate)执行说好的协议方法 
            [self.delegate deleteCustomerWith:self.keyWordss];
          
            
            
//            NSLog(@"删除客户信息后%@",dic);
            
            hudView.labelText = @"删除成功...";
            [hudView hide:YES afterDelay:0.4];
            
        } failure:^(NSError *error) {
            NSLog(@"删除客户请求失败%@",error);
        }];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    if (buttonIndex == 1) {
        return;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0f;
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSString * telStr = [NSString stringWithFormat:@"tel://%@", self.tele.text];
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:telStr]];
    }

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                if (self.tele.text.length > 6) {
                    [[[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"是否要拨打电话%@", self.tele.text] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil]show];
                    
                }else{
                    [[[UIAlertView alloc]initWithTitle:@"提示" message:@"电话号码不正确" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil]show];
                }
            
            }
                break;
            case 1:
            {
//                if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
//                    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"weixin://"]];
//                }

            }
                break;
            case 2:
            {
                if (![self joinGroup:nil key:nil]) {
                    UIAlertView*ale=[[UIAlertView alloc] initWithTitle:@"提示" message:@"您没有安装手机QQ，请安装手机QQ后重试，或用PC进行操作。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [ale show];
                }

            }
                break;

            default:
                break;
        }
    }

}
- (BOOL)joinGroup:(NSString *)groupUin key:(NSString *)key{
    NSString *urlStr = [NSString stringWithFormat:@"mqqapi://card/show_pslcard?src_type=internal&version=1&uin=6481427ed9be2a6b6df78d95f2abf8a0ebaed07baefe3a2bea8bd847cb9d84ed&card_type=group&source=external"];
    NSURL *url = [NSURL URLWithString:urlStr];
    if([[UIApplication sharedApplication] canOpenURL:url]){
        NSString *qqStr = [NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",self.QQ.text];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:qqStr]];
        return YES;
    }
    else return NO;
}

- (IBAction)attachmentAction:(id)sender {
    attachmentViewController *att = [[attachmentViewController alloc] init];
    att.picUrl = _picUrl;
    att.customerId =  _customerId;
    NSLog(@"%@%@", _customerId, _picUrl);
    [self.navigationController pushViewController:att animated:YES];
    
}
@end
