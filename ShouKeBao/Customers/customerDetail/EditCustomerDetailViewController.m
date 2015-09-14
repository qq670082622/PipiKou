//
//  EditCustomerDetailViewController.m
//  ShouKeBao
//
//  Created by 吴铭 on 15/3/30.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "EditCustomerDetailViewController.h"
#import "MBProgressHUD+MJ.h"
#import "IWHttpTool.h"
#import "MobClick.h"
@interface EditCustomerDetailViewController ()<UITextFieldDelegate,UITextViewDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *tele;
@property (weak, nonatomic) IBOutlet UITextField *wechat;
@property (weak, nonatomic) IBOutlet UITextField *QQ;

@property (weak, nonatomic) IBOutlet UIView *contentName;
@property (weak, nonatomic) IBOutlet UIView *contentTel;
@property (weak, nonatomic) IBOutlet UITextView *note;

//新添加的编辑选项
@property (weak, nonatomic) IBOutlet UITextField *personCardID;//身份证
@property (weak, nonatomic) IBOutlet UITextField *birthdate;//出生日期
@property (weak, nonatomic) IBOutlet UITextField *nationality;//国籍
@property (weak, nonatomic) IBOutlet UITextField *nation;//民族
@property (weak, nonatomic) IBOutlet UITextField *passportData;//护照签发日期
@property (weak, nonatomic) IBOutlet UITextField *passportAddress;//护照签发地址
@property (weak, nonatomic) IBOutlet UITextField *passportValidity;//护照有效期
@property (weak, nonatomic) IBOutlet UITextField *address;//地址
@property (weak, nonatomic) IBOutlet UITextField *passport;//护照

@property (weak, nonatomic) IBOutlet UIView *contentWechat;
@property (weak, nonatomic) IBOutlet UIView *contenQQ;
@property (weak, nonatomic) IBOutlet UIView *contentCardID;
@property (weak, nonatomic) IBOutlet UIView *contentBirthdate;
@property (weak, nonatomic) IBOutlet UIView *contentNationality;
@property (weak, nonatomic) IBOutlet UIView *contentNation;
@property (weak, nonatomic) IBOutlet UIView *contentPassportStart;
@property (weak, nonatomic) IBOutlet UIView *contentPassportAddress;
@property (weak, nonatomic) IBOutlet UIView *contentPassportEnd;
@property (weak, nonatomic) IBOutlet UIView *contentAddress;
@property (weak, nonatomic) IBOutlet UIView *contentPassport;
@property (weak, nonatomic) IBOutlet UIView *contentNote;




- (IBAction)save:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *saveOutlet;

@end

@implementation EditCustomerDetailViewController

-(void)customerRightBarItem
{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0,0,40,40)];
    [button setTitle:@"保存" forState:UIControlStateNormal];
    
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(save:)forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem= barItem;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑资料";
    self.navigationItem.leftBarButtonItems = @[leftItem,turnOffItem];
    [self customerRightBarItem];
  //新添加的编辑内容
    UILabel *starName = [[UILabel alloc]initWithFrame:CGRectMake(5, 3, 5, 40)];
    starName.textColor = [UIColor redColor];
    starName.text = @"*";
    UILabel *nameL = [[UILabel alloc]initWithFrame:CGRectMake(10, 3, 45, 40)];
    nameL.text = @"姓名";
    [self.contentName addSubview:nameL];
    [self.contentName addSubview:starName];
    self.name.text = self.nameStr;
    
    UILabel *starTel = [[UILabel alloc]initWithFrame:CGRectMake(5, 3, 5, 40)];
    starTel.textColor = [UIColor redColor];
    starTel.text = @"*";
    UILabel *telL = [[UILabel alloc]initWithFrame:CGRectMake(10, 3, 45, 40)];
    telL.text = @"电话";
    [self.contentTel addSubview:telL];
    [self.contentTel addSubview:starTel];
    self.tele.text = self.teleStr;
    
    UILabel *wechatL = [[UILabel alloc]initWithFrame:CGRectMake(10, 3, 100, 40)];
    wechatL.text = @"微信";
    [self.contentWechat addSubview:wechatL];
    self.wechat.text = self.wechatStr;
    
    UILabel *qqL = [[UILabel alloc]initWithFrame:CGRectMake(10, 3, 45, 40)];
    qqL.text = @"QQ";
    [self.contenQQ addSubview:qqL];
    self.QQ.text = self.QQStr;
    
    UILabel *noteL = [[UILabel alloc]initWithFrame:CGRectMake(10, 3, 45, 40)];
    noteL.text = @"备注";
    [self.contentNote addSubview:noteL];
    self.note.text = self.noteStr;
    
    UILabel *cardIDL = [[UILabel alloc]initWithFrame:CGRectMake(10, 3, 120, 40)];
    cardIDL.text = @"身份证号";
    [self.contentCardID addSubview:cardIDL];
    self.personCardID.text = self.personCardIDStr;
    
    
    UILabel *birthdateL = [[UILabel alloc]initWithFrame:CGRectMake(10, 3, 100, 40)];
    birthdateL.text = @"出生日期";
    [self.contentBirthdate addSubview:birthdateL];
    self.birthdate.text = self.birthdateStr;
    
    UILabel *nationalityL = [[UILabel alloc]initWithFrame:CGRectMake(10, 3, 45, 40)];
    nationalityL.text = @"国籍";
    [self.contentNationality addSubview:nationalityL];
    self.nationality.text = self.nationalityStr;
    
    UILabel *nationL = [[UILabel alloc]initWithFrame:CGRectMake(10, 3, 45, 40)];
    nationL.text = @"民族";
    [self.contentNation addSubview:nationL];
    self.nation.text = self.nationStr;
    
    UILabel *passportDataL = [[UILabel alloc]initWithFrame:CGRectMake(10, 3, 120, 40)];
    passportDataL.text = @"护照签发日期";
    [self.contentPassportStart addSubview:passportDataL];
    self.passportData.text = self.passportDataStr;
    
    UILabel *passportAddressL = [[UILabel alloc]initWithFrame:CGRectMake(10, 3, 120, 40)];
    passportAddressL.text = @"护照签发地";
    [self.contentPassportAddress addSubview:passportAddressL];
    self.passportAddress.text = self.passportAddressStr;
    
    UILabel *passportValidityL = [[UILabel alloc]initWithFrame:CGRectMake(10, 3, 120, 40)];
    passportValidityL.text = @"护照签有效期";
    [self.contentPassportEnd addSubview:passportValidityL];
    self.passportValidity.text = self.passportValidityStr;
    
    UILabel *addressL = [[UILabel alloc]initWithFrame:CGRectMake(10, 3, 45, 40)];
    addressL.text = @"地址";
    [self.contentAddress addSubview:addressL];
    self.address.text = self.addressStr;
    
    UILabel *passportL = [[UILabel alloc]initWithFrame:CGRectMake(10, 3, 45, 40)];
    passportL.text = @"护照";
    [self.contentPassport addSubview:passportL];
    self.passport.text = self.passportStr;
    
    
    
//    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,15,20)];
//    [leftBtn setBackgroundImage:[UIImage imageNamed:@"backarrow"] forState:UIControlStateNormal];
//    
//    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
//    
//    self.navigationItem.leftBarButtonItem= leftItem;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKey)];
    [self.view addGestureRecognizer:tap];
    
}





- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"CustomerEditCustomerDetailView"];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"CustomerEditCustomerDetailView"];
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self hideKey];
}

-(void)hideKey
{
    [self.name resignFirstResponder];
    
    [self.tele resignFirstResponder];
    
    [self.wechat resignFirstResponder];
    
    [self.QQ resignFirstResponder];
    
    [self.note resignFirstResponder];
    
    //    添加   ***************
    [self.personCardID resignFirstResponder];
    [self.birthdate resignFirstResponder];
    [self.nation resignFirstResponder];
    [self.nationality resignFirstResponder];
    [self.passportData resignFirstResponder];
    [self.passportValidity resignFirstResponder];
    [self.passportAddress resignFirstResponder];
    [self.passport resignFirstResponder];
    [self.address resignFirstResponder];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    [self.wechat resignFirstResponder];
//    [self.QQ resignFirstResponder];
//    [self.note resignFirstResponder];
//    [self.tele resignFirstResponder];
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



- (IBAction)save:(id)sender {
    NSLog(@"ddd");
    
    MBProgressHUD *hudView = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    hudView.labelText = @"保存中...";
    [hudView show:YES];
    
    
    if (self.name.text.length>0 && self.tele.text.length>6) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:self.name.text forKey:@"Name"];
        [dic setObject:self.tele.text forKey:@"Mobile"];
        [dic setObject:self.wechat.text forKey:@"WeiXinCode"];
        [dic setObject:self.QQ.text forKey:@"QQCode"];
        [dic setObject:self.note.text forKey:@"Remark"];
        [dic setObject:self.ID forKey:@"ID"];
        
//        新添加的内容
        [dic setObject:self.personCardID.text forKey:@"CardNum"];
        [dic setObject:self.birthdate.text forKey:@"BirthDay"];
        [dic setObject:self.nationality.text forKey:@"Nationality"];
        [dic setObject:self.nation.text forKey:@"Country"];
        [dic setObject:self.passportData.text forKey:@"ValidStartDate"];
        [dic setObject:self.passportAddress.text forKey:@"ValidAddress"];
        [dic setObject:self.passportValidity.text forKey:@"ValidEndDate"];
        [dic setObject:self.address.text forKey:@"Address"];
        [dic setObject:self.passport.text forKey:@"PassportNum"];

       // NSMutableArray *arr = [NSMutableArray array];
        //[arr addObject:dic];kjhkjhjk

        //       指定第一页为代理人嘛
//        self.initDelegate = [self.navigationController.viewControllers objectAtIndex:0];

        NSMutableDictionary *secondDic = [NSMutableDictionary dictionary];
        [secondDic setObject:dic forKey:@"Customer"];
        
        [IWHttpTool WMpostWithURL:@"Customer/EditCustomer" params:secondDic success:^(id json) {
            NSLog(@"---- b编辑单个客户成功 %@------",json);
            if ( [[NSString stringWithFormat:@"%@",json[@"IsSuccess"]]isEqualToString:@"0"]) {
                UIAlertView * aler = [[UIAlertView alloc]initWithTitle:@"提示" message:json[@"ErrorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [aler show];
            }
            
//            [self.delegate refreshCustomerInfoWithName:self.name.text andQQ:self.QQ.text andWeChat:self.wechat.text andPhone:self.tele.text andNote:self.note.text];
            
            [self.delegate refreshCustomerInfoWithName:self.name.text andQQ:self.QQ.text andWeChat:self.wechat.text andPhone:self.tele.text andCardID:self.personCardID.text andBirthDate:self.birthdate.text andNationablity:self.nationality.text andNation:self.nation.text andPassportStart:self.passportData.text andPassPortAddress:self.passportAddress.text andPassPortEnd:self.passportValidity.text andAddress:self.address.text andPassport:self.passport.text andNote:self.note.text];
  
//             [self.initDelegate reloadMethod];
        
            
            //  3, 通知中心的使用
            //    发送一个消息
            NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
            //    参数1:发送消息的事件名(必须一致)
            //    参数2:可以使用这个参数,传递一个对象给观察者
            //    参数3:一些消息的参数信息(系统用得较多)
            
            //    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            //    [dic setObject:self.userName.text forKey:@"Name"];
            //    [dic setObject:self.tele.text forKey:@"Mobile"];
            //    [dic setObject:self.weChat.text forKey:@"WeiXinCode"];
            //    [dic setObject:self.QQ.text forKey:@"QQCode"];
            //    [dic setObject:self.note.text forKey:@"Remark"];
            //    [dic setObject:self.ID forKey:@"ID"];
            
            //    CustomModel *model = [[CustomModel alloc]initWithDict:dic];
            hudView.labelText = @"保存成功...";
            [center postNotificationName:@"下班" object:@"开心" userInfo:nil];
            
            [hudView hide:YES afterDelay:0.4];
        [self.navigationController popViewControllerAnimated:YES];
            
        } failure:^(NSError *error) {
            NSLog(@"-----创建单个客户失败 %@-----",error);
        }];
   
    }else if(self.name.text.length == 0 || self.tele.text.length<7){
        [hudView hide:YES afterDelay:0.0];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"😪，无法保存" message:@"您的客户资料不正确!" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert show];
    }

    
    
    
}




@end
