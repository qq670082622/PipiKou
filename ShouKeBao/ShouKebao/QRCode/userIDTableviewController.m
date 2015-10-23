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
#import "MobClick.h"
#import "BaseClickAttribute.h"
#import "NSString+FKTools.h"
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
@property (strong, nonatomic) IBOutlet UIButton *saveBtn2;
@property (strong, nonatomic) IBOutlet UIButton *saveBtnFromOrder;
@property (nonatomic, strong)NSMutableDictionary * postDic;

- (IBAction)save:(id)sender;

@property(nonatomic,strong) NSMutableArray *scanningArr;

@property(nonatomic,weak) UIView *coverView;
@end

@implementation userIDTableviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"二代身份证";
    
        self.nameText.text = [StrToDic cleanSpaceWithString:_UserName];
    self.nationalText.text = [StrToDic cleanSpaceWithString:_Nationality];
    self.cardText.text = [StrToDic cleanSpaceWithString:_cardNumber];
    self.bornText.text = [StrToDic cleanSpaceWithString:_birthDay];
        self.addressText.text = [StrToDic cleanSpaceWithString:_address];
    
    [self animationWithLabs:[NSArray arrayWithObjects:self.nameLab,self.cardNum,self.bornLab,self.nationalLab,self.addressLab, nil]];
    [WMAnimations WMAnimationMakeBoarderWithLayer:self.saveBtn.layer andBorderColor:[UIColor clearColor ] andBorderWidth:0.5 andNeedShadow:NO];
    NSLog(@"%@, %@", self.PicUrl, self.RecordId);

    if (_ModifyDate.length<1) {
        self.ModifyDate = [NSMutableString stringWithFormat:@""];
    }
    if (self.isLogin) {
        if (self.isFromOrder||self.isFromCamer) {
            self.saveBtn.hidden = YES;
            self.saveBtn2.hidden = YES;
            self.saveBtnFromOrder.hidden = NO;
        }else{
            self.saveBtn.hidden = NO;
            self.saveBtn2.hidden = YES;
            self.saveBtnFromOrder.hidden = YES;
        }
    }else{
        self.saveBtnFromOrder.hidden = YES;
        self.saveBtn.hidden = YES;
        self.saveBtn2.hidden = NO;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FieldTextChange:) name:UITextFieldTextDidChangeNotification object:self.nameText];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FieldTextChange:) name:UITextFieldTextDidChangeNotification object:self.cardText];
    
    //[self setUpleftBarButtonItems];
    [self changeButton];

}
//-(void)setUpleftBarButtonItems
//{
//    UIButton *back = [UIButton buttonWithType:UIButtonTypeSystem];
//    back.frame = CGRectMake(0, 0, 45, 10);
//    [back setTitle:@"〈返回" forState:UIControlStateNormal];
//    back.titleLabel.font = [UIFont systemFontOfSize:14];
//    [back setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:back];
//    
//    UIButton *turnOff = [UIButton buttonWithType:UIButtonTypeCustom];
//    turnOff.titleLabel.font = [UIFont systemFontOfSize:14];
//    turnOff.frame = CGRectMake(0, 0, 30, 10);
//    [turnOff addTarget:self action:@selector(turnOff) forControlEvents:UIControlEventTouchUpInside];
//    [turnOff setTitle:@"关闭"  forState:UIControlStateNormal];
//    [turnOff setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    UIBarButtonItem *turnOffItem = [[UIBarButtonItem alloc] initWithCustomView:turnOff];
//    [self.navigationItem setLeftBarButtonItems:@[backItem,turnOffItem] animated:YES];
//}
- (void)turnOff{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [MobClick beginLogPageView:@"ShouKeBaouserIDTableview"];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"ShouKeBaouserIDTableview"];
}

-(void)back
{
    [self.delegate toIfPush2];
    [self saveWithRecord];
    [self.navigationController popViewControllerAnimated:YES];
}



//仅同步记录
-(void)saveWithRecord{

    if (_isLogin) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];//@"/Customer/CreateCustomerList"
        [dic setObject:self.nameText.text forKey:@"UserName"];
        [dic setObject:self.nationalText.text forKey:@"Nationality"];
        [dic setObject:self.cardText.text forKey:@"CardNum"];
        [dic setObject:self.bornText.text forKey:@"birthDay"];
        [dic setObject:self.addressText.text forKey:@"address"];
        [dic setObject:_RecordId forKey:@"RecordId"];
        [dic setObject:_ModifyDate forKey:@"ModifyDate"];
        [dic setObject:@"1" forKey:@"RecordType"];
        if (_PicUrl) {
             [dic setObject:_PicUrl forKey:@"PicUrl"];
        }
       
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObject:dic];
        NSMutableDictionary *mudi = [NSMutableDictionary dictionary];
        
        [mudi setObject:arr forKey:@"CredentialsPicRecordList"];
        

        [IWHttpTool WMpostWithURL:@"Customer/SyncCredentialsPicRecord" params:mudi success:^(id json) {
            NSLog(@"同步客户纪录客户成功 返回json is %@",json);
            //            2/添加客户
            
        } failure:^(NSError *error) {
            NSLog(@"同步客户纪录客户失败，返回error is %@",error);
        }];
        
        
    }else if (!_isLogin){
        
        NSMutableArray *arr = [NSMutableArray arrayWithArray:[WriteFileManager readData:@"record"]];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:self.nameText.text forKey:@"UserName"];
        [dic setObject:self.nationalText.text forKey:@"Nationality"];
        [dic setObject:self.cardText.text forKey:@"CardNum"];
        [dic setObject:self.bornText.text forKey:@"birthDay"];
        [dic setObject:self.addressText.text forKey:@"address"];
        [dic setObject:_RecordId forKey:@"RecordId"];
        [dic setObject:@"1" forKey:@"RecordType"];
          [dic setObject:_ModifyDate forKey:@"ModifyDate"];
        if (_PicUrl) {
             [dic setObject:_PicUrl forKey:@"PicUrl"];
        }
       [arr addObject:dic];
        [WriteFileManager saveData:arr name:@"record"];
        
        
    }
    

}
//同步记录并添加为客户
-(void)saveWithRecordAndAddCustomer
{
    
    if (_isLogin) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];//@"/Customer/CreateCustomerList"
        NSMutableArray * RecordIdsArr = [NSMutableArray array];
        [dic setObject:self.nameText.text forKey:@"UserName"];
        [dic setObject:self.nationalText.text forKey:@"Nationality"];
        [dic setObject:self.cardText.text forKey:@"CardNum"];
        [dic setObject:self.bornText.text forKey:@"birthDay"];
        [dic setObject:self.addressText.text forKey:@"address"];
        [dic setObject:_RecordId forKey:@"RecordId"];
          [dic setObject:_ModifyDate forKey:@"ModifyDate"];
        [dic setObject:@"1" forKey:@"RecordType"];
        if (_PicUrl) {
            [dic setObject:_PicUrl forKey:@"PicUrl"];
        }
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObject:dic];
        NSLog(@"%@", dic);
        NSMutableDictionary *mudi = [NSMutableDictionary dictionary];
        [mudi setObject:arr forKey:@"CredentialsPicRecordList"];
        self.postDic = mudi;
        
        //判断是否重复
        [RecordIdsArr addObject:_RecordId];
        NSMutableDictionary * RecordIdsDic = [NSMutableDictionary dictionary];//@"/Customer/CreateCustomerList"
        [RecordIdsDic setObject:RecordIdsArr forKey:@"RecordIds"];
        NSLog(@"%@", RecordIdsDic);
        [IWHttpTool WMpostWithURL:@"Customer/IsHaveSameCustomer" params:RecordIdsDic success:^(id json) {
            NSLog(@"%@", json);
            if ([[NSString stringWithFormat:@"%@", json[@"IsHaveSameRecord"]]isEqualToString:@"1"]) {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"客户已存在，是否覆盖" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"覆盖", nil];
                [alert show];
            }else{
                [self saveAfterWith];
            }
        } failure:^(NSError *error) {
            NSLog(@"%@", error);
        }];

    }else if (!_isLogin){
        
        NSMutableArray *arr = [NSMutableArray arrayWithArray:[WriteFileManager readData:@"record2"]];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:self.nameText.text forKey:@"UserName"];
        [dic setObject:self.nationalText.text forKey:@"Nationality"];
        [dic setObject:self.cardText.text forKey:@"CardNum"];
        [dic setObject:self.bornText.text forKey:@"birthDay"];
        [dic setObject:self.addressText.text forKey:@"address"];
        [dic setObject:_RecordId forKey:@"RecordId"];
          [dic setObject:_ModifyDate forKey:@"ModifyDate"];
        [dic setObject:@"1" forKey:@"RecordType"];
        if (_PicUrl) {
            [dic setObject:_PicUrl forKey:@"PicUrl"];
        }        [arr addObject:dic];
        [WriteFileManager saveData:arr name:@"record2"];
        NSLog(@"dic is %@,---,arr is %@,---,读取的是arr is%@",dic,arr,[WriteFileManager readData:@"record2"]);
        
    }

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self saveAfterWith];
    }
}

- (void)saveAfterWith{
    [IWHttpTool WMpostWithURL:@"Customer/SyncCredentialsPicRecord" params:self.postDic success:^(id json) {
        NSLog(@"批量导入客户成功 返回json is %@",json);
        //            2/添加客户
        NSMutableDictionary *customerDic = [NSMutableDictionary dictionary];
        [customerDic setObject:[NSArray arrayWithObject:_RecordId] forKey:@"RecordIds"];
        NSLog(@"%@", customerDic);
        [IWHttpTool WMpostWithURL:@"Customer/CopyCredentialsPicRecordToCustomer" params:customerDic success:^(id json) {
            if (!self.isFromCamer) {
            [self WMPopCustomerAlertWithCopyStr:[NSString stringWithFormat:@"姓名:%@,民族%@,身份证号%@,出生日期%@,地址%@",self.nameText.text,self.nationalText.text,self.cardText.text,self.bornText.text,self.addressText.text]];
            }
            self.delegateToOrder = self.VC;
            [self.delegateToOrder toRefereshCustomers];
            NSLog(@"添加陈工,json is %@",json);
        } failure:^(NSError *error) {
            NSLog(@"");
        }];
        
    } failure:^(NSError *error) {
        NSLog(@"批量导入客户失败，返回error is %@",error);
    }];

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
    if (self.isFromOrder) {
        NSString * cardtye = self.isIDCard?@"0":@"1";
        NSString * sexx = [self.sex isEqualToString:@"男"]?@"0":@"1";
        NSMutableString * infoString = [NSMutableString string];
        if (![self.bornText.text isEqualToString:@""]) {
            if ([self.bornText.text myContainsString:@"年"]&&[self.bornText.text myContainsString:@"月"]&&[self.bornText.text myContainsString:@"日"]) {
                [infoString appendString:[self.bornText.text componentsSeparatedByString:@"年"][0]];
                NSString * str2 = [self.bornText.text componentsSeparatedByString:@"年"][1];
                [infoString appendFormat:@"-%@", [str2 componentsSeparatedByString:@"月"][0]];
                NSString * str3 = [str2 componentsSeparatedByString:@"月"][1];
                [infoString appendFormat:@"-%@", [str3 componentsSeparatedByString:@"日"][0]];
            }
        }
        NSLog(@"%@, %@", self.PicUrl, self.RecordId);
        NSDictionary * dic = @{@"Name":self.nameText.text,@"Sex":sexx,@"CardType":cardtye,@"Birthday":infoString,@"CardNum":self.cardText.text,@"PicUrl":self.PicUrl,@"RecordId":self.RecordId};
        NSLog(@"%@", dic);
        self.delegateToOrder = self.VC;
        [self.delegateToOrder writeDelegate:dic];

        [self.navigationController popToViewController:self.VC animated:YES];
    }else{
    if (![self.nameText.text isEqualToString:@""]&&![self.cardText.text isEqualToString:@""]) {
    [self saveWithRecordAndAddCustomer];
        if (self.isFromCamer) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            if (self.postDic) {
            }else{
            [self WMPopCustomerAlertWithCopyStr:[NSString stringWithFormat:@"姓名:%@,民族%@,身份证号%@,出生日期%@,地址%@",self.nameText.text,self.nationalText.text,self.cardText.text,self.bornText.text,self.addressText.text]];
            }
        }
    }else{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"内容识别不全" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    }
    }
   
}

-(void)WMPopCustomerAlertWithCopyStr:(NSString *)copyStr//自定义拷贝弹窗
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    pasteboard.string = copyStr;
    
    UIView *cover = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    cover.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    
    UIView *alert = [[UIView alloc] init];
    CGFloat alertX = 25;
    CGFloat alertY = [[UIScreen mainScreen] bounds].size.height/2-80;
    CGFloat alertW = [[UIScreen mainScreen] bounds].size.width - 50;
       alert.backgroundColor = [UIColor whiteColor];
    [WMAnimations WMAnimationMakeBoarderWithLayer:alert.layer andBorderColor:[UIColor lightGrayColor] andBorderWidth:0.5 andNeedShadow:NO];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(alertX, 15, alertW - alertX*2, 65)];
    lab.numberOfLines = 0;
    lab.text = @"信息已经提取为客户，是否还提取粘贴到..";
    lab.textColor = [UIColor blackColor];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:15];
    
    CGFloat btnY = CGRectGetMaxY(lab.frame)+15;
    CGFloat btnW = (alertW - 5*alertX)/4;
    
    UIButton *weCaht = [UIButton buttonWithType:UIButtonTypeCustom];
    [weCaht setBackgroundImage:[UIImage imageNamed:@"weixincopy"] forState:UIControlStateNormal];
    weCaht.frame = CGRectMake(alertX, btnY, btnW, btnW);
    [weCaht addTarget:self action:@selector(openWechat) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *weLab = [[UILabel alloc] initWithFrame:CGRectMake(alertX, CGRectGetMaxY(weCaht.frame)+5, btnW, 15)];
    weLab.text = @"微信";
    weLab.textAlignment = NSTextAlignmentCenter;
    weLab.textColor = [UIColor lightGrayColor];
    weLab.font = [UIFont systemFontOfSize:15];
    
    UIButton *qq = [UIButton buttonWithType:UIButtonTypeCustom];
    [qq setBackgroundImage:[UIImage imageNamed:@"QQcopy"] forState:UIControlStateNormal];
    qq.frame = CGRectMake(CGRectGetMaxX(weCaht.frame)+alertX, btnY, btnW, btnW);
    [qq addTarget:self action:@selector(openQQ) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *qqLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(weCaht.frame)+alertX, CGRectGetMaxY(weCaht.frame)+5, btnW, 15)];
    qqLab.text = @"QQ";
    qqLab.textAlignment = NSTextAlignmentCenter;
    qqLab.textColor = [UIColor lightGrayColor];
    qqLab.font = [UIFont systemFontOfSize:15];
    
    UIButton *message = [UIButton buttonWithType:UIButtonTypeCustom];
    [message setBackgroundImage:[UIImage imageNamed:@"duanxincopy"] forState:UIControlStateNormal];
    message.frame = CGRectMake(CGRectGetMaxX(qq.frame)+alertX, btnY, btnW, btnW);
    [message addTarget:self action:@selector(openMessa) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *messageLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(qq.frame)+alertX, CGRectGetMaxY(weCaht.frame)+5, btnW, 15)];
    messageLab.text = @"短信";
    messageLab.textAlignment = NSTextAlignmentCenter;
    messageLab.textColor = [UIColor lightGrayColor];
    messageLab.font = [UIFont systemFontOfSize:15];
    
    UIButton *copo = [UIButton buttonWithType:UIButtonTypeCustom];
    [copo setBackgroundImage:[UIImage imageNamed:@"fuzhicopy"] forState:UIControlStateNormal];
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
    cancle.titleLabel.font = [UIFont systemFontOfSize:17];
    cancle.frame = CGRectMake(alertW/2 - 80, CGRectGetMaxY(line.frame)+10, 160, 35);
    [cancle addTarget:self action:@selector(cancleCover) forControlEvents:UIControlEventTouchUpInside];
    CGFloat alertH = CGRectGetMaxY(cancle.frame)+15;
    alert.frame = CGRectMake(alertX, alertY, alertW, alertH);
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
- (void)FieldTextChange:(NSNotification *)noty
{
    [self changeButton];
}
- (void)changeButton{
    if (![self.nameText.text isEqualToString:@""]&&![self.cardText.text isEqualToString:@""]) {
        self.saveBtn.backgroundColor = [UIColor blueColor];
        self.saveBtn2.backgroundColor = [UIColor blueColor];
        self.saveBtnFromOrder.backgroundColor = [UIColor blueColor];
        self.saveBtn.userInteractionEnabled= YES;
        self.saveBtn2.userInteractionEnabled= YES;
        self.saveBtnFromOrder.userInteractionEnabled= YES;
    }else{
        self.saveBtn.backgroundColor = [UIColor lightGrayColor];
        self.saveBtn2.backgroundColor = [UIColor lightGrayColor];
        self.saveBtnFromOrder.backgroundColor = [UIColor lightGrayColor];
        self.saveBtn.userInteractionEnabled= NO;
        self.saveBtn2.userInteractionEnabled= NO;
        self.saveBtnFromOrder.userInteractionEnabled= NO;
    }
    
}

@end
