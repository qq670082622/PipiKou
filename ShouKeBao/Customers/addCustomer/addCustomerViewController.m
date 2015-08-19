//
//  addCustomerViewController.m
//  ShouKeBao
//
//  Created by 吴铭 on 15/3/30.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "addCustomerViewController.h"
#import "IWHttpTool.h"
#import "MBProgressHUD+MJ.h"
#import "StrToDic.h"
#import "MobClick.h"
@interface addCustomerViewController ()<UITextFieldDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *tele;
@property (weak, nonatomic) IBOutlet UITextField *wechat;
@property (weak, nonatomic) IBOutlet UITextField *QQ;
@property (weak, nonatomic) IBOutlet UITextView *note;
//新添加的

- (IBAction)save:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *saveOutlet;

@end

@implementation addCustomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加客户";
    self.saveOutlet.layer.cornerRadius = 5;
    self.saveOutlet.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.saveOutlet.layer.borderWidth = 0.5;
    self.saveOutlet.layer.masksToBounds = YES;

//    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,15,20)];
//    [leftBtn setBackgroundImage:[UIImage imageNamed:@"backarrow"] forState:UIControlStateNormal];
//
//    
//    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
//    
//    self.navigationItem.leftBarButtonItem= leftItem;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKey)];
    [self.view addGestureRecognizer:tap];
    
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"CustomeraddCustomerView"];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"CustomeraddCustomerView"];
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)hideKey
{
   
    [self.name resignFirstResponder];
    [self.tele resignFirstResponder];
    [self.wechat resignFirstResponder];
    [self.QQ resignFirstResponder];
    [self.note resignFirstResponder];

}
//-(void)customerRightBarItem
//{
//    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
//    
//    [button setImage:[UIImage imageNamed:@"wancheng"] forState:UIControlStateNormal];
//    
//    [button addTarget:self action:@selector(saveTogo)forControlEvents:UIControlEventTouchUpInside];
//    
//    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithCustomView:button];
//    
//    self.navigationItem.rightBarButtonItem= barItem;
//}
//-(void)saveTogo
//{
//    
//}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.name resignFirstResponder];
     [self.tele resignFirstResponder];
     [self.wechat resignFirstResponder];
     [self.QQ resignFirstResponder];
    [self.note resignFirstResponder];
   
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)save:(id)sender {
   
    if (self.name.text.length>0 && self.tele.text.length>6) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:self.name.text forKey:@"Name"];
        [dic setObject:self.tele.text forKey:@"Mobile"];
        [dic setObject:self.wechat.text forKey:@"WeiXinCode"];
        [dic setObject:self.QQ.text forKey:@"QQCode"];
        [dic setObject:self.note.text forKey:@"Remark"];
        
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObject:dic];
        
        NSMutableDictionary *secondDic = [NSMutableDictionary dictionary];
        [secondDic setObject:arr forKey:@"CustomerList"];
       
        NSLog(@"-----------添加客户的发送json包是%@----------",[StrToDic jsonStringWithDicL:secondDic]);
        
        [IWHttpTool WMpostWithURL:@"/Customer/CreateCustomerList" params:secondDic success:^(id json) {
            NSLog(@"----创建单个客户成功 %@------",json);
        
            [MBProgressHUD showSuccess:@"添加成功"];
            [self.delegate toRefereshCustomers];
            
        } failure:^(NSError *error) {
            NSLog(@"-----创建单个客户失败 %@-----",error);
        }];
        
        [self.navigationController popViewControllerAnimated:YES];
 
    }
    
    if(self.name.text.length == 0 || self.tele.text.length<7){
       
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"抱歉😪,无法保存" message:@"您的客户资料有误" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert show];
    }
    
}
@end
