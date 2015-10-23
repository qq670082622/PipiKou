//
//  AddViewController.m
//  ShouKeBao
//
//  Created by 张正梅 on 15/8/19.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "AddViewController.h"
#import "IWHttpTool.h"
#import "MBProgressHUD+MJ.h"
#import "StrToDic.h"
#import "MobClick.h"

@interface AddViewController ()<UITextFieldDelegate,UITextViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *tele;
@property (weak, nonatomic) IBOutlet UITextField *wechat;
@property (weak, nonatomic) IBOutlet UITextField *QQ;
@property (weak, nonatomic) IBOutlet UITextField *passportID;//护照
@property (weak, nonatomic) IBOutlet UITextField *personID;
@property (weak, nonatomic) IBOutlet UITextField *birthday;
@property (weak, nonatomic) IBOutlet UITextField *nationality;//国籍
@property (weak, nonatomic) IBOutlet UITextField *nation;
@property (weak, nonatomic) IBOutlet UITextField *passportDate;//护照签发日期
@property (weak, nonatomic) IBOutlet UITextField *passportAddress;
@property (weak, nonatomic) IBOutlet UITextField *passportValidite;
//护照有效期
@property (weak, nonatomic) IBOutlet UITextField *address;
@property (weak, nonatomic) IBOutlet UITextField *note;

@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"添加客户";

    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0,0,50,40)];
    [button setTitle:@"保存" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.titleEdgeInsets = UIEdgeInsetsMake(-2, 20, 0, 0);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(saveCustomer:)forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem= barItem;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKey)];
    [self.view addGestureRecognizer:tap];
    
    
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
    [self.passportID resignFirstResponder];
    [self.personID resignFirstResponder];
    [self.birthday resignFirstResponder];
    [self.nationality resignFirstResponder];
    [self.nation resignFirstResponder];
    [self.passportDate resignFirstResponder];
    [self.passportAddress resignFirstResponder];
    [self.passportValidite resignFirstResponder];
    [self.address resignFirstResponder];
    [self.note resignFirstResponder];
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self hideKey];
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
   return 10.0f;
}

- (void)saveCustomer:(UIButton *)save{

    NSLog(@"self.tele.text.length = %@", self.tele.text);
    if (self.name.text.length>0 && self.tele.text.length>6) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:self.name.text forKey:@"Name"];
        [dic setObject:self.tele.text forKey:@"Mobile"];
        [dic setObject:self.wechat.text forKey:@"WeiXinCode"];
        [dic setObject:self.QQ.text forKey:@"QQCode"];
        [dic setObject:self.note.text forKey:@"Remark"];
        
        
        [dic setObject:self.personID.text forKey:@"CardNum"];
        [dic setObject:self.birthday.text forKey:@"BirthDay"];
        [dic setObject:self.nationality.text forKey:@"Nationality"];
        [dic setObject:self.nation.text forKey:@"Country"];
        [dic setObject:self.passportDate.text forKey:@"ValidStartDate"];
        [dic setObject:self.passportAddress.text forKey:@"ValidAddress"];
        [dic setObject:self.passportValidite.text forKey:@"ValidEndDate"];
        [dic setObject:self.address.text forKey:@"Address"];
        [dic setObject:self.passportID.text forKey:@"PassportNum"];
        
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObject:dic];
        
        NSMutableDictionary *secondDic = [NSMutableDictionary dictionary];
        [secondDic setObject:arr forKey:@"CustomerList"];
        
        NSLog(@"-----------添加客户的发送json包是%@----------",[StrToDic jsonStringWithDicL:secondDic]);
        
        [IWHttpTool WMpostWithURL:@"/Customer/CreateCustomerList" params:secondDic success:^(id json) {
            NSLog(@"----创建单个客户成功 %@------",json);
           
            [self.delegate toRefereshCustomers];
            [MBProgressHUD showSuccess:@"添加成功"];
        
        } failure:^(NSError *error) {
            NSLog(@"-----创建单个客户失败 %@-----",error);
        }];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
    if(self.name.text.length == 0 || self.tele.text.length<7){
        NSLog(@"self.name.text.length = %ld, self.tele.text.length = %ld", self.name.text.length, self.tele.text.length);
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"抱歉😪,无法保存" message:@"您的客户资料有误" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert show];
    }
    
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
