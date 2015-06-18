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
        [dic setObject:[NSArray arrayWithObject:_RecordId] forKey:@"RecordIds"];
        
        [IWHttpTool WMpostWithURL:@"Customer/CopyCredentialsPicRecordToCustomer" params:dic success:^(id json) {
            NSLog(@"批量导入客户成功 返回json is %@",json);
            
//            UILabel *testLab = [[UILabel alloc] initWithFrame:self.view.frame];
//            testLab.backgroundColor = [UIColor whiteColor];
//            testLab.font = [UIFont systemFontOfSize:8];
//            testLab.text = [NSString stringWithFormat:@"保存记录返回的JSON IS %@",json];
//            testLab.numberOfLines = 0;
//            [self.view.window addSubview:testLab];
            
            
        } failure:^(NSError *error) {
            NSLog(@"批量导入客户失败，返回error is %@",error);
        }];
        
    }
    
    //测试有无保存记录
  //  NSMutableArray *arr = [NSMutableArray arrayWithObject:[WriteFileManager WMreadData:@"record"]];
    

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存成功" message:@"已成功提取信息，您可以方便地在“我的客户中”查看和编辑" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
    
   
}
@end
