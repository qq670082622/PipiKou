//
//  MyOrgViewController.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/3/31.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "MyOrgViewController.h"
#import "MeHttpTool.h"
#import "MobClick.h"
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
    self.title = @"我的旅行社";
    // Do any additional setup after loading the view.
   // [self setNav];
    [self loadDataSource];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MeMyOrgViewController"];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MeMyOrgViewController"];
}
#pragma mark - private
//- (void)setNav
//{
//    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,15,20)];
//    [leftBtn setBackgroundImage:[UIImage imageNamed:@"backarrow"] forState:UIControlStateNormal];
//    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
//    
//    self.navigationItem.leftBarButtonItem= leftItem;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
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
