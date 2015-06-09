//
//  userIDTableviewController.m
//  ShouKeBao
//
//  Created by 吴铭 on 15/5/29.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "userIDTableviewController.h"
#import "WMAnimations.h"
@interface userIDTableviewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *cardNum;
@property (weak, nonatomic) IBOutlet UILabel *bornLab;
@property (weak, nonatomic) IBOutlet UILabel *nationalLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
- (IBAction)save:(id)sender;

@end

@implementation userIDTableviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"二代身份证";
    //4 0
    self.nameLab.text = [NSString stringWithFormat:@"    姓名：%@",_UserName];
    //self.sexLab.text = _sex;
    self.nationalLab.text = [NSString stringWithFormat:@"    民族：%@",_Nation];
    self.cardNum.text = [NSString stringWithFormat:@"    身份证号码：%@",_cardNumber];
    self.bornLab.text = [NSString stringWithFormat:@"    生日：%@",_birthDay];
    self.addressLab.text = [NSString stringWithFormat:@"    地址：%@",_address];
    //    @property(nonatomic,copy) NSString *address;
    //    @property(nonatomic,copy) NSString *birthDay;
    //    @property(nonatomic,copy) NSString *cardNumber;
    //    @property(nonatomic,copy) NSString *Nation;
    //    @property(nonatomic,copy) NSString *sex;
    //    @property(nonatomic,copy) NSString *UserName;

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
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)animationWithLabs:(NSArray *)arr
{
    for (int i = 0; i<arr.count; i++) {
        
        UILabel *lab = arr[i];
        
        [WMAnimations WMAnimationMakeBoarderWithLayer:lab.layer andBorderColor:[UIColor grayColor] andBorderWidth:0.5 andNeedShadow:NO];
    }
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"等接口" message:@"别慌" delegate:self cancelButtonTitle:@"🐶遵命，吴爷" otherButtonTitles: nil];
    [alert show];
}
@end
