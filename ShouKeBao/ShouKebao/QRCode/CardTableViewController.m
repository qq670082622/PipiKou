//
//  CardTableViewController.m
//  ShouKeBao
//
//  Created by 吴铭 on 15/5/29.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "CardTableViewController.h"
#import "WMAnimations.h"
#import "WriteFileManager.h"
#import "StrToDic.h"
#import "IWHttpTool.h"
#import "MBProgressHUD+MJ.h"
#import "MobClick.h"
@interface CardTableViewController ()<UITextFieldDelegate,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UITextField *nameText;

@property (weak, nonatomic) IBOutlet UILabel *sexLab;
@property (weak, nonatomic) IBOutlet UITextField *sexText;

@property (weak, nonatomic) IBOutlet UILabel *countryLab;
@property (weak, nonatomic) IBOutlet UITextField *countryText;

@property (weak, nonatomic) IBOutlet UILabel *cardNum;
@property (weak, nonatomic) IBOutlet UITextField *cardNumText;

@property (weak, nonatomic) IBOutlet UILabel *bornLab;
@property (weak, nonatomic) IBOutlet UITextField *bornText;

@property (weak, nonatomic) IBOutlet UILabel *startDayLab;
@property (weak, nonatomic) IBOutlet UITextField *startDayText;

@property (weak, nonatomic) IBOutlet UILabel *startPointLab;
@property (weak, nonatomic) IBOutlet UITextField *startPointText;

@property (weak, nonatomic) IBOutlet UILabel *effectiveLab;
@property (weak, nonatomic) IBOutlet UITextField *effectiveText;

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (strong, nonatomic) IBOutlet UIButton *saveBtn2;
@property (strong, nonatomic) IBOutlet UIButton *saveBtnFromOrder;
@property (nonatomic, strong)NSMutableDictionary * postDic;
- (IBAction)save:(id)sender;

@property(nonatomic,strong) NSMutableArray *scanningArr;

@property(weak,nonatomic) UIView *coverView;

@end

@implementation CardTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"护照";
    self.nameText.delegate = self;
    self.cardNumText.delegate = self;
   //如果是扫描直接进来
        
    self.nameText.text = [StrToDic cleanSpaceWithString:_nameLabStr];
    self.sexText.text = [StrToDic cleanSpaceWithString:_sexLabStr];
    self.countryText.text = [StrToDic cleanSpaceWithString:_countryLabStr];
    self.cardNumText.text = [StrToDic cleanSpaceWithString:_cardNumStr];
    self.bornText.text = [StrToDic cleanSpaceWithString:_bornLabStr];
    self.startDayText.text = [StrToDic cleanSpaceWithString:_startDayLabStr];
    self.startPointText.text = [StrToDic cleanSpaceWithString:_startPointLabStr];
    self.effectiveText.text = [StrToDic cleanSpaceWithString:_effectiveLabStr];
             
    
    
    [self animationWithLabs:[NSArray arrayWithObjects:self.nameLab,self.sexLab,self.countryLab,self.cardNum,self.bornLab,self.startDayLab,self.startPointLab,self.effectiveLab, nil]];
    [WMAnimations WMAnimationMakeBoarderWithLayer:self.saveBtn.layer andBorderColor:[UIColor blueColor] andBorderWidth:0.5 andNeedShadow:NO];
    
//    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,15,20)];
//    [leftBtn setBackgroundImage:[UIImage imageNamed:@"backarrow"] forState:UIControlStateNormal];
//    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
//    
//    self.navigationItem.leftBarButtonItem= leftItem;
    
    if (_ModifyDate.length<1) {
        self.ModifyDate = [NSMutableString stringWithFormat:@""];
    }
    if (self.isLogin) {
        if (self.isFromOrder||self.isFromeCamer) {
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FieldTextChange:) name:UITextFieldTextDidChangeNotification object:self.cardNumText];
    self.navigationItem.leftBarButtonItems = @[leftItem,turnOffItem];
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
//- (void)turnOff{
//    [self.navigationController popToRootViewControllerAnimated:YES];
//}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"ShouKeBaoCardTableView"];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"ShouKeBaoCardTableView"];
}

-(void)back
{
    [self.delegate toIfPush];
     //防止有编辑，但未保存，默认将其保存
    [self saveRecord];
        [self.navigationController popViewControllerAnimated:YES];
}



-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self allTFresignFirstResponder];
}
- (void)allTFresignFirstResponder{
    [self.nameText resignFirstResponder];
    [self.sexText resignFirstResponder];
    [self.countryText resignFirstResponder];
    [self.cardNumText resignFirstResponder];
    [self.bornText resignFirstResponder];
    [self.startDayText resignFirstResponder];
    [self.startPointText resignFirstResponder];
    [self.effectiveText resignFirstResponder];
}
-(NSMutableArray *)scanningArr
{
    if (_scanningArr == nil) {
        self.scanningArr = [NSMutableArray array];
    }
    return _scanningArr;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)animationWithLabs:(NSArray *)arr
{
    for (int i = 0; i<arr.count; i++) {
       
        UILabel *lab = arr[i];
        
        [WMAnimations WMAnimationMakeBoarderWithLayer:lab.layer andBorderColor:[UIColor grayColor] andBorderWidth:0.5 andNeedShadow:NO];
    }
}

- (IBAction)save:(id)sender {
    if (self.isFromOrder) {
        NSString * cardtye = self.isIDCard?@"0":@"1";
        NSString * sexx = [self.sexLabStr isEqualToString:@"M"]?@"0":@"1";
        NSMutableString * infoString = [NSMutableString string];
        if (self.bornText.text.length > 7) {
        [infoString appendString:[self.bornText.text substringWithRange:NSMakeRange(0, 4)]];
        [infoString appendFormat:@"-%@",[self.bornText.text substringWithRange:NSMakeRange(4, 2)]];
        [infoString appendFormat:@"-%@",[self.bornText.text substringWithRange:NSMakeRange(6, 2)]];
        }
        NSDictionary * dic = @{@"Name":self.nameText.text,@"Sex":sexx,@"CardType":cardtye,@"Birthday":infoString,@"CardNum":self.cardNumText.text,@"PicUrl":self.PicUrl,@"RecordId":self.RecordId};
        NSLog(@"%@", dic);
        self.delegateToOrder = self.VC;
        [self.delegateToOrder writeDelegate:dic];
        [self.navigationController popToViewController:self.VC animated:YES];

    }else{

    if (![self.nameText.text isEqualToString:@""]&&![self.cardNumText.text isEqualToString:@""]) {

    [self saveRecordToCustomer];
        if (self.isFromeCamer) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            if (self.postDic) {
                
            }else{
                [self allTFresignFirstResponder];
                [self WMPopCustomerAlertWithCopyStr:[NSString stringWithFormat:@"姓名:%@,性别:%@,国籍:%@,证件号码:%@,出生日期:%@,签证日期:%@,签证地:%@,有效期:%@",self.nameText.text,self.sexText.text,self.countryText.text,self.cardNumText.text,self.bornText.text,self.startDayText.text,self.startPointText.text,self.effectiveText.text]];
            }
        }
    }else{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"内容识别不全" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    }
    }
}


-(void)saveRecordToCustomer
{
    if (_isLogin) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        NSMutableArray * RecordIdsArr = [NSMutableArray array];
        [dic setObject:self.nameText.text forKey:@"UserName"];
        [dic setObject:self.sexText.text forKey:@"Sex"];
        [dic setObject:self.countryText.text forKey:@"Country"];
        [dic setObject:self.cardNumText.text forKey:@"PassportNum"];
        [dic setObject:self.startDayText.text forKey:@"ValidStartDate"];
        [dic setObject:self.bornText.text forKey:@"BirthDay"];
        [dic setObject:self.startPointText.text forKey:@"ValidAddress"];
        [dic setObject:self.effectiveText.text forKey:@"ValidEndDate"];
        [dic setObject:_RecordId forKey:@"RecordId"];
        
        //判断是否重复
        [RecordIdsArr addObject:_RecordId];
        NSMutableDictionary * RecordIdsDic = [NSMutableDictionary dictionary];//@"/Customer/CreateCustomerList"
        [RecordIdsDic setObject:RecordIdsArr forKey:@"RecordIds"];

        
         [dic setObject:_ModifyDate forKey:@"ModifyDate"];
        [dic setObject:@"2" forKey:@"RecordType"];
        [dic setObject:_PicUrl forKey:@"PicUrl"];
        NSMutableArray *arr = [NSMutableArray array];
        
        [arr addObject:dic];
        NSMutableDictionary *mudi = [NSMutableDictionary dictionary];
        [mudi setObject:arr forKey:@"CredentialsPicRecordList"];
        self.postDic = mudi;

        
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
        //储存未登录时的识别纪录
        NSMutableArray *arr = [NSMutableArray arrayWithArray:[WriteFileManager readData:@"record2"]];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:self.nameText.text forKey:@"UserName"];
        [dic setObject:self.sexText.text forKey:@"Sex"];
        [dic setObject:self.countryText.text forKey:@"Country"];
        [dic setObject:self.cardNumText.text forKey:@"PassportNum"];
        [dic setObject:self.startDayText.text forKey:@"ValidStartDate"];
        [dic setObject:self.bornText.text forKey:@"BirthDay"];
        [dic setObject:self.startPointText.text forKey:@"ValidAddress"];
        [dic setObject:self.effectiveText.text forKey:@"ValidEndDate"];
        [dic setObject:_RecordId forKey:@"RecordId"];
         [dic setObject:_ModifyDate forKey:@"ModifyDate"];
        [dic setObject:@"2" forKey:@"RecordType"];
        [dic setObject:_PicUrl forKey:@"PicUrl"];
        
        [arr addObject:dic];
        
        [WriteFileManager saveData:arr name:@"record2"];
        
    }

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self saveAfterWith];
    }
}

- (void)saveAfterWith{

    //1.同步扫描纪录
    [IWHttpTool WMpostWithURL:@"Customer/SyncCredentialsPicRecord" params:self.postDic success:^(id json) {
        NSLog(@"批量导入客户成功 返回json is %@",json);
        //            2/添加客户
        NSMutableDictionary *customerDic = [NSMutableDictionary dictionary];
        [customerDic setObject:[NSArray arrayWithObject:_RecordId] forKey:@"RecordIds"];
        [IWHttpTool WMpostWithURL:@"Customer/CopyCredentialsPicRecordToCustomer" params:customerDic success:^(id json) {
            NSLog(@"%d", self.isFromeCamer);
            if (!self.isFromeCamer) {
                [self allTFresignFirstResponder];
                [self WMPopCustomerAlertWithCopyStr:[NSString stringWithFormat:@"姓名:%@,性别:%@,国籍:%@,证件号码:%@,出生日期:%@,签证日期:%@,签证地:%@,有效期:%@",self.nameText.text,self.sexText.text,self.countryText.text,self.cardNumText.text,self.bornText.text,self.startDayText.text,self.startPointText.text,self.effectiveText.text]];
            }
            self.delegateToOrder = self.VC;
            [self.delegateToOrder toRefereshCustomers];
            NSLog(@"添加陈工");
            //测试是成功的
        } failure:^(NSError *error) {
            NSLog(@"");
        }];
        
        
        
    } failure:^(NSError *error) {
        NSLog(@"批量导入客户失败，返回error is %@",error);
    }];

}
-(void)saveRecord
{
    if (_isLogin) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:self.nameText.text forKey:@"UserName"];
        [dic setObject:self.sexText.text forKey:@"Sex"];
        [dic setObject:self.countryText.text forKey:@"Country"];
        [dic setObject:self.cardNumText.text forKey:@"PassportNum"];
        [dic setObject:self.startDayText.text forKey:@"ValidStartDate"];
        [dic setObject:self.bornText.text forKey:@"BirthDay"];
        [dic setObject:self.startPointText.text forKey:@"ValidAddress"];
        [dic setObject:self.effectiveText.text forKey:@"ValidEndDate"];
        [dic setObject:_RecordId forKey:@"RecordId"];
         [dic setObject:_ModifyDate forKey:@"ModifyDate"];
        [dic setObject:@"2" forKey:@"RecordType"];
        [dic setObject:_PicUrl forKey:@"PicUrl"];
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObject:dic];
        NSMutableDictionary *mudi = [NSMutableDictionary dictionary];
        
        [mudi setObject:arr forKey:@"CredentialsPicRecordList"];
        
        //1.同步扫描纪录
        [IWHttpTool WMpostWithURL:@"Customer/SyncCredentialsPicRecord" params:mudi success:^(id json) {
            NSLog(@"批量导入客户成功 返回json is %@",json);
                  } failure:^(NSError *error) {
            NSLog(@"批量导入客户失败，返回error is %@",error);
        }];
        
    }else if (!_isLogin){
        //储存未登录时的识别纪录
        NSMutableArray *arr = [NSMutableArray arrayWithArray:[WriteFileManager readData:@"record"]];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:self.nameText.text forKey:@"UserName"];
        [dic setObject:self.sexText.text forKey:@"Sex"];
        [dic setObject:self.countryText.text forKey:@"Country"];
        [dic setObject:self.cardNumText.text forKey:@"PassportNum"];
        [dic setObject:self.startDayText.text forKey:@"ValidStartDate"];
        [dic setObject:self.bornText.text forKey:@"BirthDay"];
        [dic setObject:self.startPointText.text forKey:@"ValidAddress"];
        [dic setObject:self.effectiveText.text forKey:@"ValidEndDate"];
        [dic setObject:_RecordId forKey:@"RecordId"];
         [dic setObject:_ModifyDate forKey:@"ModifyDate"];
        [dic setObject:@"2" forKey:@"RecordType"];
        [dic setObject:_PicUrl forKey:@"PicUrl"];
        
        [arr addObject:dic];
        
        [WriteFileManager saveData:arr name:@"record"];
        
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
    cancle.titleLabel.font = [UIFont systemFontOfSize:15];
    cancle.frame = CGRectMake(alertW/2 - 30, CGRectGetMaxY(line.frame)+15, 60, 25);
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
    if (![self.nameText.text isEqualToString:@""]&&![self.cardNumText.text isEqualToString:@""]) {
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
