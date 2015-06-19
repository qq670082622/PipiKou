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

- (IBAction)save:(id)sender;

@property(nonatomic,strong) NSMutableArray *scanningArr;

@property(weak,nonatomic) UIView *coverView;

@end

@implementation CardTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"护照";
   //如果是扫描直接进来
        
      
    self.nameText.text = _nameLabStr;
    self.sexText.text = _sexLabStr;
    self.countryText.text = _countryLabStr;
    self.cardNumText.text = _cardNumStr;
    self.bornText.text = _bornLabStr;
    self.startDayText.text = _startDayLabStr;
    self.startPointText.text = _startPointLabStr;
    self.effectiveText.text = _effectiveLabStr;
             
    
    
    [self animationWithLabs:[NSArray arrayWithObjects:self.nameLab,self.sexLab,self.countryLab,self.cardNum,self.bornLab,self.startDayLab,self.startPointLab,self.effectiveLab, nil]];
    [WMAnimations WMAnimationMakeBoarderWithLayer:self.saveBtn.layer andBorderColor:[UIColor blueColor] andBorderWidth:0.5 andNeedShadow:NO];
    
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,20,20)];
    
    [leftBtn setImage:[UIImage imageNamed:@"backarrow"] forState:UIControlStateNormal];
    
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    self.navigationItem.leftBarButtonItem= leftItem;

}

-(void)back
{[self.delegate toIfPush];
    [self.navigationController popViewControllerAnimated:YES];
}


//生成后马上保存到本地.--------已作废
-(void)saveScanningWithDic:(NSDictionary *)dic andType:(NSString *)type
{
    if (dic[@"UserName"]) {
        NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
        NSDate *date = [NSDate date];
        NSString *dateStr = [StrToDic stringFromDate:date];
        [muDic setObject:dateStr forKey:@"createTime"];
        [muDic setObject:type forKey:@"type"];
        [muDic addEntriesFromDictionary:dic];
        
        
        //        UILabel *testLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, 320, 500)];
        //        testLab.backgroundColor = [UIColor whiteColor];
        //        //testLab.text = [NSString stringWithFormat:@"(用来测试后台返回的数据，8秒后自动删除)\n\n字典是 is %@----",muDic];
        //        testLab.numberOfLines = 0;
        //        [self.view.window addSubview:testLab];
        
        
        
        personIdModel *model = [personIdModel modelWithDict:muDic];
        NSMutableArray *modelArr = [NSMutableArray arrayWithArray:[WriteFileManager WMreadData:@"scanning"]];
        [modelArr addObject:model];
        [WriteFileManager WMsaveData:modelArr name:@"scanning"];
        
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
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
        [dic setObject:@"2" forKey:@"RecordType"];
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObject:dic];
        NSMutableDictionary *mudi = [NSMutableDictionary dictionary];
      
        [mudi setObject:arr forKey:@"CredentialsPicRecordList"];
       
        //1.同步扫描纪录
        [IWHttpTool WMpostWithURL:@"Customer/SyncCredentialsPicRecord" params:dic success:^(id json) {
            NSLog(@"批量导入客户成功 返回json is %@",json);
//            2/添加客户
            NSMutableDictionary *customerDic = [NSMutableDictionary dictionary];
            [customerDic setObject:[NSArray arrayWithObject:_RecordId] forKey:@"RecordIds"];
            [IWHttpTool WMpostWithURL:@"Customer/CopyCredentialsPicRecordToCustomer" params:customerDic success:^(id json) {
                NSLog(@"添加陈工");
            } failure:^(NSError *error) {
                NSLog(@"");
            }];
//            UILabel *testLab = [[UILabel alloc] initWithFrame:self.view.frame];
//            testLab.backgroundColor = [UIColor whiteColor];
//            testLab.font = [UIFont systemFontOfSize:8];
//            testLab.text = [NSString stringWithFormat:@"保存记录返回的JSON IS %@",json];
//            testLab.numberOfLines = 0;
//            [self.view.window addSubview:testLab];
           
            
//            [self.saveBtn setTitle:@"已保存" forState:UIControlStateNormal];
//            [self.saveBtn setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
//            self.saveBtn.userInteractionEnabled = NO;
        
        
        } failure:^(NSError *error) {
            NSLog(@"批量导入客户失败，返回error is %@",error);
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
        [dic setObject:@"2" forKey:@"RecordType"];
       
        [arr addObject:dic];
        
        [WriteFileManager saveData:arr name:@"record2"];
       
    }
    
    
    //    @property (nonatomic,copy) NSString *UserName;
    //    @property (nonatomic,copy) NSString *Address;
    //    @property (nonatomic,copy) NSString *BirthDay;
    //    @property (nonatomic,copy) NSString *CardNum;
    //    @property (nonatomic,copy) NSString *Nation;//民族
    //    @property (nonatomic,copy) NSString *Sex;
    
    //    @property (nonatomic,copy) NSString *type;
    //    @property(nonatomic,copy) NSString *Country;//国家
    //    @property(nonatomic,copy) NSString *PassportNum;//护照号
    //    @property(nonatomic,copy) NSString *ValidStartDate;
    //    @property(nonatomic,copy) NSString *ValidAddress;
    //    @property(nonatomic,copy) NSString *ValidEndDate;
    //    @property (nonatomic,copy) NSString *PicUrl;
    //    @property (nonatomic,copy) NSString *ModifyDate;//修改日期
    //    @property (nonatomic,copy) NSString *RecordId;//纪录ID

    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存成功" message:@"已成功提取信息，您可以方便地在“我的客户中”查看和编辑" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
//        [alert show];
   [self WMPopCustomerAlertWithCopyStr:[NSString stringWithFormat:@"姓名:%@,性别:%@,国籍:%@,证件号码:%@,出生日期:%@,签证日期:%@,签证地:%@,有效期:%@",self.nameText.text,self.sexText.text,self.countryText.text,self.cardNumText.text,self.bornText.text,self.startDayText.text,self.startPointText.text,self.effectiveText.text]];

   
//    self.nameText.text = _nameLabStr;
//    self.sexText.text = _sexLabStr;
//    self.countryText.text = _countryLabStr;
//    self.cardNumText.text = _cardNumStr;
//    self.bornText.text = _bornLabStr;
//    self.startDayText.text = _startDayLabStr;
//    self.startPointText.text = _startPointLabStr;
//    self.effectiveText.text = _effectiveLabStr;
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
