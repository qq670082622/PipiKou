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

@end

@implementation CardTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"护照";
    
    if (_model) {
        
//        card.nameLabStr = json[@"UserName"];
//        card.sexLabStr = json[@"Sex"];
//        card.countryLabStr = json[@"Nationality"];
//        card.cardNumStr = json[@"PassportNum"];
//        card.bornLabStr = json[@"BirthDay"];
//        card.startDayLabStr = json[@"ValidStartDate"];
//        card.startPointLabStr = json[@"ValidAddress"];
//        card.effectiveLabStr = json[@"ValidEndDate"];
        
        self.nameText.text = _model.UserName;
        self.sexText.text = _model.Sex;
        self.countryText.text = _model.Nationality;
        self.cardNumText.text = _model.PassportNum;
        self.bornText.text = _model.BirthDay;
        self.startDayText.text = _model.ValidStartDate;
        self.startPointText.text = _model.ValidAddress;
        self.effectiveText.text = _model.ValidEndDate;
    }else{
        
      
    self.nameText.text = _nameLabStr;
    self.sexText.text = _sexLabStr;
    self.countryText.text = _countryLabStr;
    self.cardNumText.text = _cardNumStr;
    self.bornText.text = _bornLabStr;
    self.startDayText.text = _startDayLabStr;
    self.startPointText.text = _startPointLabStr;
    self.effectiveText.text = _effectiveLabStr;
             
    }
    
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


//生成后马上保存到本地
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"等接口" message:@"别慌" delegate:self cancelButtonTitle:@"yes" otherButtonTitles: nil];
    [alert show];
}
@end
