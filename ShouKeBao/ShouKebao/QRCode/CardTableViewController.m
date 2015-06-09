//
//  CardTableViewController.m
//  ShouKeBao
//
//  Created by 吴铭 on 15/5/29.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "CardTableViewController.h"
#import "WMAnimations.h"
@interface CardTableViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *sexLab;
@property (weak, nonatomic) IBOutlet UILabel *countryLab;
@property (weak, nonatomic) IBOutlet UILabel *cardNum;
@property (weak, nonatomic) IBOutlet UILabel *bornLab;
@property (weak, nonatomic) IBOutlet UILabel *startDayLab;
@property (weak, nonatomic) IBOutlet UILabel *startPointLab;
@property (weak, nonatomic) IBOutlet UILabel *effectiveLab;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
- (IBAction)save:(id)sender;

@end

@implementation CardTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"护照";
    
    self.nameLab.text = [NSString stringWithFormat:@"    姓名：%@",_nameLabStr];
    self.sexLab.text = [NSString stringWithFormat:@"    性别：%@",_sexLabStr];
    self.countryLab.text = [NSString stringWithFormat:@"    国级：%@",_countryLabStr];
    self.cardNum.text = [NSString stringWithFormat:@"    护照编号：%@",_cardNumStr];
    self.bornLab.text = [NSString stringWithFormat:@"    生日：%@",_bornLabStr];
    self.startDayLab.text = [NSString stringWithFormat:@"    签证日期：%@",_startDayLabStr];
    self.startPointLab.text = [NSString stringWithFormat:@"    签发地：%@",_startPointLabStr];
    self.effectiveLab.text = [NSString stringWithFormat:@"    有效期：%@",_effectiveLabStr];
    
    
    [self animationWithLabs:[NSArray arrayWithObjects:self.nameLab,self.sexLab,self.countryLab,self.cardNum,self.bornLab,self.startDayLab,self.startPointLab,self.effectiveLab, nil]];
    [WMAnimations WMAnimationMakeBoarderWithLayer:self.saveBtn.layer andBorderColor:[UIColor blueColor] andBorderWidth:0.5 andNeedShadow:NO];
    
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,20,20)];
    
    [leftBtn setImage:[UIImage imageNamed:@"backarrow"] forState:UIControlStateNormal];
    
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    self.navigationItem.leftBarButtonItem= leftItem;

}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"等接口" message:@"别慌" delegate:self cancelButtonTitle:@"🐶遵命，吴爷" otherButtonTitles: nil];
    [alert show];
}
@end
