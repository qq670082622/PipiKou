//
//  userIDTableviewController.m
//  ShouKeBao
//
//  Created by 吴铭 on 15/5/29.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "userIDTableviewController.h"
#import "WMAnimations.h"
#import "StrToDic.h"
#import "WriteFileManager.h"
#import "IWHttpTool.h"
#import "WMAnimations.h"
#import "MBProgressHUD+MJ.h"
@interface userIDTableviewController ()<UITextFieldDelegate, UITextViewDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UITextField *nameText;

@property (weak, nonatomic) IBOutlet UILabel *cardNum;
@property (weak, nonatomic) IBOutlet UITextField *cardText;

@property (weak, nonatomic) IBOutlet UILabel *bornLab;
@property (weak, nonatomic) IBOutlet UITextField *bornText;

@property (weak, nonatomic) IBOutlet UILabel *nationalLab;
@property (weak, nonatomic) IBOutlet UITextField *nationalText;

@property (weak, nonatomic) IBOutlet UILabel *addressLab;

@property (weak, nonatomic) IBOutlet UITextView *addressText;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
- (IBAction)save:(id)sender;

@property(nonatomic,strong) NSMutableArray *scanningArr;

@property(nonatomic,weak) UIView *coverView;
@end

@implementation userIDTableviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"二代身份证";
       //4 0
//    card.UserName = json[@"UserName"];
//    card.address = json[@"Address"];
//    card.birthDay = json[@"BirthDay"];
//    card.cardNumber = json[@"CardNum"];
//    card.Nation = json[@"Nation"];
//    card.sex = json[@"Sex"];

    
    
    
        
        self.nameText.text = _UserName;
    self.nationalText.text = _Nationality;
    self.cardText.text = _cardNumber;
    self.bornText.text = _birthDay;
        self.addressText.text = _address;
        
   
//            UILabel *testLab = [[UILabel alloc] initWithFrame:self.view.frame];
//            testLab.backgroundColor = [UIColor whiteColor];
//            testLab.font = [UIFont systemFontOfSize:8];
//            testLab.text = [NSString stringWithFormat:@"name %@----nation %@-------card %@--------birth%@------ address%@",_UserName,_Nationality,_cardNumber,_birthDay,_address];
//            testLab.numberOfLines = 0;
//            [self.view.window addSubview:testLab];

        
    
    
    
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,20,20)];
    
    [leftBtn setImage:[UIImage imageNamed:@"backarrow"] forState:UIControlStateNormal];
    
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    self.navigationItem.leftBarButtonItem= leftItem;
    
    [self animationWithLabs:[NSArray arrayWithObjects:self.nameLab,self.cardNum,self.bornLab,self.nationalLab,self.addressLab, nil]];
    [WMAnimations WMAnimationMakeBoarderWithLayer:self.saveBtn.layer andBorderColor:[UIColor blueColor] andBorderWidth:0.5 andNeedShadow:NO];
    
    
    

}

-(void)back
{
    [self.delegate toIfPush2];
    [self.navigationController popViewControllerAnimated:YES];
}

//生成后马上保存到本地
-(void)saveScanningWithDic:(NSDictionary *)dic andType:(NSString *)type
{
    
    
           NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
        NSDate *date = [NSDate date];
        NSString *dateStr = [StrToDic stringFromDate:date];
        [muDic setObject:dateStr forKey:@"createTime"];
        [muDic setObject:type forKey:@"type"];
        [muDic addEntriesFromDictionary:dic];
        
        personIdModel *model = [personIdModel modelWithDict:muDic];
        NSMutableArray *modelArr = [NSMutableArray arrayWithArray:[WriteFileManager WMreadData:@"scanning"]];
        [modelArr addObject:model];
        [WriteFileManager WMsaveData:modelArr name:@"scanning"];
        
        UILabel *testLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, 320, 500)];
        testLab.backgroundColor = [UIColor whiteColor];
        testLab.text = [NSString stringWithFormat:@"(用来测试后台返回的数据，8秒后自动删除)\n\n字典是 is %@----",modelArr];
        testLab.numberOfLines = 0;
        [self.view.window addSubview:testLab];
    self.addressText.text = [NSString stringWithFormat:@"%@",[WriteFileManager WMreadData:@"scanning"]];
    
}
-(void)animationWithLabs:(NSArray *)arr
{
    for (int i = 0; i<arr.count; i++) {
        
        UILabel *lab = arr[i];
        
        [WMAnimations WMAnimationMakeBoarderWithLayer:lab.layer andBorderColor:[UIColor grayColor] andBorderWidth:0.5 andNeedShadow:NO];
    }
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.nameText resignFirstResponder];
    [self.bornText resignFirstResponder];
    [self.cardText resignFirstResponder];
    [self.nationalText resignFirstResponder];
    [self.addressText resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)save:(id)sender {
  
    if (_isLogin) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];//@"/Customer/CreateCustomerList"
        [dic setObject:self.nameText.text forKey:@"UserName"];
        [dic setObject:self.nationalText.text forKey:@"Nationality"];
        [dic setObject:self.cardText.text forKey:@"cardNumber"];
        [dic setObject:self.bornText.text forKey:@"birthDay"];
        [dic setObject:self.addressText.text forKey:@"address"];
        [dic setObject:_RecordId forKey:@"RecordId"];
        [dic setObject:@"1" forKey:@"RecordType"];
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObject:dic];
        NSMutableDictionary *mudi = [NSMutableDictionary dictionary];
        
        [mudi setObject:arr forKey:@"CredentialsPicRecordList"];

        [IWHttpTool WMpostWithURL:@"Customer/SyncCredentialsPicRecord" params:dic success:^(id json) {
            NSLog(@"批量导入客户成功 返回json is %@",json);
            //            2/添加客户
            NSMutableDictionary *customerDic = [NSMutableDictionary dictionary];
            [customerDic setObject:[NSArray arrayWithObject:_RecordId] forKey:@"RecordIds"];
            [IWHttpTool WMpostWithURL:@"Customer/CopyCredentialsPicRecordToCustomer" params:customerDic success:^(id json) {
                NSLog(@"添加陈工");
           //测试，是添加成功的
//                            UILabel *testLab = [[UILabel alloc] initWithFrame:self.view.frame];
//                            testLab.backgroundColor = [UIColor whiteColor];
//                            testLab.font = [UIFont systemFontOfSize:8];
//                            testLab.text = [NSString stringWithFormat:@"身份证保存记录返回的JSON IS %@",json];
//                            testLab.numberOfLines = 0;
//                            [self.view.window addSubview:testLab];

            
            } failure:^(NSError *error) {
                NSLog(@"");
            }];
                      
        } failure:^(NSError *error) {
            NSLog(@"批量导入客户失败，返回error is %@",error);
        }];

        
        
        
//            [self.saveBtn setTitle:@"已保存" forState:UIControlStateNormal];
//            [self.saveBtn setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
//            self.saveBtn.userInteractionEnabled = NO;

     
        
    }else if (!_isLogin){
    
        NSMutableArray *arr = [NSMutableArray arrayWithArray:[WriteFileManager readData:@"record2"]];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:self.nameText.text forKey:@"UserName"];
         [dic setObject:self.nationalText.text forKey:@"Nationality"];
         [dic setObject:self.cardText.text forKey:@"cardNumber"];
         [dic setObject:self.bornText.text forKey:@"birthDay"];
         [dic setObject:self.addressText.text forKey:@"address"];
         [dic setObject:_RecordId forKey:@"RecordId"];
        [dic setObject:@"1" forKey:@"RecordType"];
        [arr addObject:dic];
        [WriteFileManager saveData:arr name:@"record2"];
        
        UILabel *testLab = [[UILabel alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        testLab.backgroundColor = [UIColor whiteColor];
        testLab.font = [UIFont systemFontOfSize:8];
        testLab.text = [NSString stringWithFormat:@"---------------未登录时保存的客户arr is %@---------------",[WriteFileManager readData:@"record2"]];
        testLab.numberOfLines = 0;
        [self.view.window addSubview:testLab];

//        self.nameText.text = _UserName;
//        self.nationalText.text = _Nationality;
//        self.cardText.text = _cardNumber;
//        self.bornText.text = _birthDay;
//        self.addressText.text = _address;

    }
    
    //测试有无保存记录
  //  NSMutableArray *arr = [NSMutableArray arrayWithObject:[WriteFileManager WMreadData:@"record"]];
    

//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存成功" message:@"已成功提取信息，您可以方便地在“我的客户中”查看和编辑" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
//        [alert show];
    
//    self.nameText.text = _UserName;
//    self.nationalText.text = _Nationality;
//    self.cardText.text = _cardNumber;
//    self.bornText.text = _birthDay;
//    self.addressText.text = _address;
    [self WMPopCustomerAlertWithCopyStr:[NSString stringWithFormat:@"姓名:%@,民族%@,身份证号%@,出生日期%@,地址%@",self.nameText.text,self.nationalText.text,self.cardText.text,self.bornText.text,self.addressText.text]];
   
}

-(void)WMPopCustomerAlertWithCopyStr:(NSString *)copyStr//自定义拷贝弹窗
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    pasteboard.string = copyStr;
    
    UIView *cover = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    cover.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    
    UIView *alert = [[UIView alloc] init];
    CGFloat alertX = 25;
    CGFloat alertY = 200;
    CGFloat alertW = [[UIScreen mainScreen] bounds].size.width - 50;
    CGFloat alertH = 200;
    alert.frame = CGRectMake(alertX, alertY, alertW, alertH);
    alert.backgroundColor = [UIColor whiteColor];
    [WMAnimations WMAnimationMakeBoarderWithLayer:alert.layer andBorderColor:[UIColor lightGrayColor] andBorderWidth:0.5 andNeedShadow:NO];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(alertX, 15, alertW - alertX*2, 45)];
    lab.numberOfLines = 0;
    lab.text = @"信息已经提取到识别历史，是否还提取粘贴到？..";
    lab.textColor = [UIColor blackColor];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:12];
    
    CGFloat btnY = CGRectGetMaxY(lab.frame)+15;
    CGFloat btnW = (alertW - 5*alertX)/4;
    
    UIButton *weCaht = [UIButton buttonWithType:UIButtonTypeCustom];
    [weCaht setBackgroundImage:[UIImage imageNamed:@"weixin"] forState:UIControlStateNormal];
    weCaht.frame = CGRectMake(alertX, btnY, btnW, btnW);
    [weCaht addTarget:self action:@selector(openWechat) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *weLab = [[UILabel alloc] initWithFrame:CGRectMake(alertX, CGRectGetMaxY(weCaht.frame)+5, btnW, 15)];
    weLab.text = @"微信";
    weLab.textAlignment = NSTextAlignmentCenter;
    weLab.textColor = [UIColor lightGrayColor];
    weLab.font = [UIFont systemFontOfSize:15];
    
    UIButton *qq = [UIButton buttonWithType:UIButtonTypeCustom];
    [qq setBackgroundImage:[UIImage imageNamed:@"qq"] forState:UIControlStateNormal];
    qq.frame = CGRectMake(CGRectGetMaxX(weCaht.frame)+alertX, btnY, btnW, btnW);
    [qq addTarget:self action:@selector(openQQ) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *qqLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(weCaht.frame)+alertX, CGRectGetMaxY(weCaht.frame)+5, btnW, 15)];
    qqLab.text = @"QQ";
    qqLab.textAlignment = NSTextAlignmentCenter;
    qqLab.textColor = [UIColor lightGrayColor];
    qqLab.font = [UIFont systemFontOfSize:15];
    
    UIButton *message = [UIButton buttonWithType:UIButtonTypeCustom];
    [message setBackgroundImage:[UIImage imageNamed:@"fujian"] forState:UIControlStateNormal];
    message.frame = CGRectMake(CGRectGetMaxX(qq.frame)+alertX, btnY, btnW, btnW);
    [message addTarget:self action:@selector(openMessa) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *messageLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(qq.frame)+alertX, CGRectGetMaxY(weCaht.frame)+5, btnW, 15)];
    messageLab.text = @"短信";
    messageLab.textAlignment = NSTextAlignmentCenter;
    messageLab.textColor = [UIColor lightGrayColor];
    messageLab.font = [UIFont systemFontOfSize:15];
    
    UIButton *copo = [UIButton buttonWithType:UIButtonTypeCustom];
    [copo setBackgroundImage:[UIImage imageNamed:@"beizhu"] forState:UIControlStateNormal];
    copo.frame = CGRectMake(CGRectGetMaxX(message.frame)+alertX, btnY, btnW, btnW);
    [copo addTarget:self action:@selector(openCopo) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *copoLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(message.frame)+alertX, CGRectGetMaxY(weCaht.frame)+5, btnW, 15)];
    copoLab.text = @"复制";
    copoLab.textAlignment = NSTextAlignmentCenter;
    copoLab.textColor = [UIColor lightGrayColor];
    copoLab.font = [UIFont systemFontOfSize:15];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(alertX, CGRectGetMaxY(copoLab.frame)+15, alertW - alertX*2, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    
    UIButton *cancle = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancle setTitle:@"取消" forState:UIControlStateNormal];
    [cancle setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancle.titleLabel.font = [UIFont systemFontOfSize:15];
    cancle.frame = CGRectMake(alertW/2 - 30, CGRectGetMaxY(line.frame)+15, 60, 25);
    [cancle addTarget:self action:@selector(cancleCover) forControlEvents:UIControlEventTouchUpInside];
    
    [cover addSubview:alert];
    [alert addSubview:lab];
    [alert addSubview:weCaht];
    [alert addSubview:weLab];
    [alert addSubview:qq];
    [alert addSubview:qqLab];
    [alert addSubview:message];
    [alert addSubview:messageLab];
    [alert addSubview:copo];
    [alert addSubview:copoLab];
    [alert addSubview:line];
    [alert addSubview:cancle];
    [self.view.window addSubview:cover];
    self.coverView = cover;
    
    
}
-(void)openWechat
{
   
    NSURL * wechat_url = [NSURL URLWithString:@"weixin://qr/JnXv90fE6hqVrQOU9yA0"];
    
    if ([[UIApplication sharedApplication] canOpenURL:wechat_url]) {
        NSLog(@"canOpenURL");
        [[UIApplication sharedApplication] openURL:wechat_url];
    }
}
-(void)openQQ
{
    NSString *urlStr = [NSString stringWithFormat:@"mqqapi://card/show_pslcard?src_type=internal&version=1&uin=6481427ed9be2a6b6df78d95f2abf8a0ebaed07baefe3a2bea8bd847cb9d84ed&card_type=group&source=external"];
    NSURL *url = [NSURL URLWithString:urlStr];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
    
}
-(void)openMessa
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"sms://"]];
}
-(void)openCopo
{
    [MBProgressHUD showSuccess:@"复制成功"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 2.0s后执行block里面的代码
        [MBProgressHUD hideHUD];
    });
    
}

-(void)cancleCover{
    [self.coverView removeFromSuperview];
}

@end
