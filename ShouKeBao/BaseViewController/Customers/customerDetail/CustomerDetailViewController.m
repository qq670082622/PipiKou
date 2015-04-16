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

@interface CustomerDetailViewController ()<UITextFieldDelegate,notifiToRefereshCustomerDetailInfo>
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
    
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.weChat resignFirstResponder];
   [self.QQ resignFirstResponder];
    [self.note resignFirstResponder];
    [self.tele resignFirstResponder];
    return YES;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [self.note resignFirstResponder];
        return NO;
    }
    return YES;
    
}
-(void)setSubViews{
        self.QQ.text = self.QQStr;
    self.weChat.text = self.weChatStr;
    self.tele.text = self.teleStr;
    self.note.text = self.noteStr;
    self.userName.text = self.userNameStr;
    
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
    EditCustomerDetailViewController *edit = [[EditCustomerDetailViewController alloc] init];
    edit.ID = self.ID;
    edit.QQStr = self.QQStr;
    edit.wechatStr = self.weChatStr;
    edit.noteStr = self.noteStr;
    edit.teleStr = self.teleStr;
    edit.nameStr = self.userNameStr;
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
    
    remondViewController *remond = [[remondViewController alloc] init];
    remond.ID = self.ID;
    remond.customModel = self.customMoel;
    [self.navigationController pushViewController:remond animated:YES];
}

- (IBAction)deleteCustomer:(id)sender {
    MBProgressHUD *hudView = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    hudView.labelText = @"删除中...";
    [hudView show:YES];

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.ID forKey:@"CustomerID"];
    [IWHttpTool WMpostWithURL:@"/Customer/DeleteCustomer" params:dic success:^(id json) {
        NSLog(@"删除客户信息成功%@",json);
        hudView.labelText = @"删除成功...";
 [hudView hide:YES afterDelay:0.4];
    } failure:^(NSError *error) {
        NSLog(@"删除客户请求失败%@",error);
    }];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
