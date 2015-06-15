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

    if(_model){
        self.nameText.text = _model.UserName;
        self.nationalText.text = _model.Nation;
        self.cardText.text = _model.CardNum;
        self.bornText.text = _model.BirthDay;
        self.addressText.text = _model.Address;
    
    }else{
       
       //     [self saveScanningWithDic:_json andType:@"personId"];
        
        
       

    self.nameText.text = _UserName;
    self.nationalText.text = _Nation;
    self.cardText.text = _cardNumber;
    self.bornText.text = _birthDay;
        self.addressText.text = _address;
        
      //  [self saveScanningWithDic:_json andType:@"personId"];
        
//        NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
//        NSDate *date = [NSDate date];
//        NSString *dateStr = [StrToDic stringFromDate:date];
//        [muDic setObject:dateStr forKey:@"createTime"];
//        [muDic setObject:@"personId" forKey:@"type"];
//        [muDic addEntriesFromDictionary:_json];
//        
//        personIdModel *model = [personIdModel modelWithDict:muDic];
//        NSMutableArray *modelArr = [NSMutableArray arrayWithArray:[WriteFileManager readFielWithName:@"scanning"]];
//        [modelArr addObject:model];
//        [WriteFileManager saveFileWithArray:modelArr Name:@"scanning"];
//        
//        UILabel *testLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, 320, 500)];
//        testLab.backgroundColor = [UIColor whiteColor];
//        testLab.text = [NSString stringWithFormat:@"(用来测试后台返回的数据，8秒后自动删除)\n\n字典是 is %@----",modelArr];
//        testLab.numberOfLines = 0;
//        [self.view.window addSubview:testLab];
//        self.addressText.text = [NSString stringWithFormat:@"储存前的arr is %@／储存后arr is%@",modelArr,[WriteFileManager readFielWithName:@"scanning"]];

        
    }
    
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)save:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"等接口" message:@"别慌" delegate:self cancelButtonTitle:@"yes" otherButtonTitles: nil];
    [alert show];
}
@end
