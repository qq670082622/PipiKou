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
#import "Lotuseed.h"
#import "SubstationParttern.h"
#import "attachmentViewController.h"
@interface CustomerDetailViewController ()<UITextFieldDelegate,notifiToRefereshCustomerDetailInfo,UIActionSheetDelegate>
@property (nonatomic,weak) UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UIButton *SetRemindBtnOutlet;

@end

@implementation CustomerDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customerRightBarItem];
    self.title = @"客户详情";
    
//    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 28)];
//    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"客户资料",@"订单详情",nil];
//    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:segmentedArray];
//    [segment addTarget:self action:@selector(sex:)forControlEvents:UIControlEventValueChanged];
//    [segment setTintColor:[UIColor whiteColor]];
//    segment.frame = CGRectMake(0, 0, 150, 28);
//    [segment setSelected:YES];
//    [segment setSelectedSegmentIndex:0];
//    [titleView addSubview:segment];
//    self.segmentControl = segment;
//    self.navigationItem.titleView = titleView;
    
   // [self.SetRemindBtnOutlet setHighlighted:NO];
    
    [self setSubViews];
    if (self.note.text == nil) {
        self.note.text = @"备注信息";
    }
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,20,20)];
    
    [leftBtn setImage:[UIImage imageNamed:@"backarrow"] forState:UIControlStateNormal];
    
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    self.navigationItem.leftBarButtonItem= leftItem;
    
       
    self.SetRemindBtnOutlet.imageEdgeInsets = UIEdgeInsetsMake(0, 32, 0, 0);
}

-(void)back
{
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
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   // [self.segmentControl setSelectedSegmentIndex:0];
}
//-(void)sex:(id)sender
//{
//    UISegmentedControl *control = (UISegmentedControl *)sender;
//    if (control.selectedSegmentIndex == 1) {
//        CustomerOrdersUIViewController *orders = [[CustomerOrdersUIViewController alloc] init];
//        [self.navigationController pushViewController:orders animated:NO];
//    }
//}
-(void)customerRightBarItem
{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
    
    [button setImage:[UIImage imageNamed:@"bianji"] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(EditCustomerDetail)forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem= barItem;
}
-(void)EditCustomerDetail
{
    SubstationParttern *par = [SubstationParttern sharedStationName];
    [Lotuseed onEvent:@"EditCustomerDetail" attributes:@{@"stationName":par.stationName}];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Customer" bundle:nil];
    
    EditCustomerDetailViewController *edit = [sb instantiateViewControllerWithIdentifier:@"EditCustomer"];
    edit.ID = self.ID;
    edit.QQStr = self.QQ.text;
    edit.wechatStr = self.weChat.text;
    edit.noteStr = self.note.text;
    edit.teleStr = self.tele.text;
    edit.nameStr = self.userName.text;
    edit.delegate = self;
    [self.navigationController pushViewController:edit animated:YES];
}

#pragma -mark 编辑用户资料后通知更新
-(void)refreshCustomerInfoWithName:(NSString *)name andQQ:(NSString *)qq andWeChat:(NSString *)weChat andPhone:(NSString *)phone andNote:(NSString *)note
{
    
    self.QQ.text = qq;
    self.weChat.text = weChat;
    self.tele.text = phone;
    self.note.text = note;
    self.userName.text = name;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)remond:(id)sender {
     SubstationParttern *par = [SubstationParttern sharedStationName];
    [Lotuseed onEvent:@"ClickCustomerRemind" attributes:@{@"stationName":par.stationName}];
    
    remondViewController *remond = [[remondViewController alloc] init];
    remond.ID = self.ID;
    remond.customModel = self.customMoel;
    [self.navigationController pushViewController:remond animated:YES];
}

- (IBAction)deleteCustomer:(id)sender {
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"您确定要删除吗？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles: nil];
    [sheet showInView:self.view];
    
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
            hudView.labelText = @"删除成功...";
            [hudView hide:YES afterDelay:0.4];
             SubstationParttern *par = [SubstationParttern sharedStationName];
            [Lotuseed onEvent:@"deleteCustomer" attributes:@{@"stationName":par.stationName}];
        
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

- (IBAction)attachmentAction:(id)sender {
    attachmentViewController *att = [[attachmentViewController alloc] init];
    [self.navigationController pushViewController:att animated:YES];
    
}
@end
