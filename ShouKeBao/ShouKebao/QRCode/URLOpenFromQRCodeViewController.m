//
//  URLOpenFromQRCodeViewController.m
//  ShouKeBao
//
//  Created by 吴铭 on 15/4/3.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "URLOpenFromQRCodeViewController.h"

@interface URLOpenFromQRCodeViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *web;
@end

@implementation URLOpenFromQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"二维码网页";
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[[NSURL alloc]initWithString:self.url]];
    [self.web loadRequest:request];
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
