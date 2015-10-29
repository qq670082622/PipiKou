//
//  TravelConsultantViewControllerNoShare.m
//  ShouKeBao
//
//  Created by 冯坤 on 15/10/20.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "TravelConsultantViewControllerNoShare.h"
#define fiveSize ([UIScreen mainScreen].bounds.size.height == 568)
#define sixSize ([UIScreen mainScreen].bounds.size.height == 667)
#define sixPSize ([UIScreen mainScreen].bounds.size.height > 668)

@interface TravelConsultantViewControllerNoShare ()

@end

@implementation TravelConsultantViewControllerNoShare

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"专属App";
    UIFont * fiveAndSixFont = [UIFont systemFontOfSize:15.0];
    UIFont * sixPFont = [UIFont systemFontOfSize:16.0];
    
    if (fiveSize || sixSize) {
        self.trvelLable.font = fiveAndSixFont;
        self.leavelLabel.font = fiveAndSixFont;
        self.productLab.font = fiveAndSixFont;
        self.storeLab.font = fiveAndSixFont;
        self.scanLab.font = fiveAndSixFont;
    }else if(sixPSize){
        self.trvelLable.font = sixPFont;
        self.leavelLabel.font = sixPFont;
        self.productLab.font = sixPFont;
        self.storeLab.font = sixPFont;
        self.scanLab.font = sixPFont;
    }
    
    
    // Do any additional setup after loading the view.
}
- (IBAction)bottomBtnAction:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
    TravelConsultantViewControllerNoShare * TCTVC = [sb instantiateViewControllerWithIdentifier:@"TravelConsultantVCNS"];
    [self.navigationController pushViewController:TCTVC animated:YES];
    
}
- (void)back{
    [self.navigationController popToRootViewControllerAnimated:YES];
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

@end
