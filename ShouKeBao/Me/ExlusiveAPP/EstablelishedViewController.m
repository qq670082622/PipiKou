//
//  EstablelishedViewController.m
//  ShouKeBao
//
//  Created by 张正梅 on 15/11/17.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "EstablelishedViewController.h"
#import "ExclusiveShareView.h"
@interface EstablelishedViewController ()

- (IBAction)returnButton:(id)sender;
- (IBAction)cancleButton:(id)sender;

@end

@implementation EstablelishedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

   self.navigationController.navigationBarHidden = YES;
    
    
    
    
    
    
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

- (IBAction)returnButton:(id)sender {
    [self.naVC popViewControllerAnimated:YES];
    
    
}

- (IBAction)cancleButton:(id)sender {
    [self.naVC popViewControllerAnimated:NO];
}
@end
