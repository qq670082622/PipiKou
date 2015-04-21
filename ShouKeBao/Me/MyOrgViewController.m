//
//  MyOrgViewController.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/3/31.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "MyOrgViewController.h"
#import "MeHttpTool.h"

@interface MyOrgViewController ()

@property (weak, nonatomic) IBOutlet UILabel *companyName;

@property (weak, nonatomic) IBOutlet UILabel *address;

@property (weak, nonatomic) IBOutlet UILabel *contactName;

@property (weak, nonatomic) IBOutlet UILabel *phone;

@property (weak, nonatomic) IBOutlet UILabel *email;

@property (weak, nonatomic) IBOutlet UILabel *qq;

@property (weak, nonatomic) IBOutlet UILabel *wechat;

@property (weak, nonatomic) IBOutlet UITextView *remark;
@end

@implementation MyOrgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNav];
    
    [self loadDataSource];
}

#pragma mark - private
- (void)setNav
{
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

#pragma mark - loadDataSource
- (void)loadDataSource
{
    [MeHttpTool getBusinessWithsuccess:^(id json) {
        if (![json[@"Busienss"] isKindOfClass:[NSNull class]]) {
            NSLog(@"-----%@",json);
            NSDictionary *dic = json[@"Busienss"];
            NSMutableDictionary *muta = dic.mutableCopy;
            NSArray *array = [dic allKeys];
            for (NSString *key in array) {
                if ([[muta objectForKey:key] isKindOfClass:[NSNull class]]) {
                    [muta setValue:@"" forKey:key];
                }
            }
            
            self.companyName.text = muta[@"Name"];
            self.address.text = muta[@"Address"];
            self.contactName.text = muta[@"ContactName"];
            self.phone.text = muta[@"ContactMobile"];
            self.email.text = muta[@"Email"];
            self.qq.text = muta[@"QQCode"];
            self.wechat.text = muta[@"WeiXinCode"];
            self.remark.text = muta[@"Desc"];
        }
    } failure:^(NSError *error) {
        
    }];
}

@end
