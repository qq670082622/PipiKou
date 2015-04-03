//
//  addRemondViewController.m
//  ShouKeBao
//
//  Created by 吴铭 on 15/3/31.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "addRemondViewController.h"
#import "IWHttpTool.h"
#import "StrToDic.h"
@interface addRemondViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *descript;
- (IBAction)setTime:(id)sender;


@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation addRemondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customerRightBarItem];
}
-(void)customerRightBarItem
{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
    
    [button setImage:[UIImage imageNamed:@"wancheng"] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(complete)forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem= barItem;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.descript resignFirstResponder];
       return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [self.descript resignFirstResponder];
        return NO;
    }
    return YES;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)setTime:(id)sender {
    if (self.datePicker.hidden == YES) {
        self.datePicker.hidden = NO;
    }else if (self.datePicker.hidden == NO){
        self.datePicker.hidden = YES;
    }
    
   }

- (void)complete {
   NSString *date = [StrToDic stringFromDate:self.datePicker.date];
   
    if (self.descript.text.length>1 ) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        NSMutableDictionary *arrDic = [NSMutableDictionary dictionary];
        //NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
        [arrDic setObject:self.descript.text forKey:@"Content"];
        //NSMutableDictionary *dic2 = [NSMutableDictionary dictionary];
        [arrDic setObject:date forKey:@"RemindTime"];
       
        
        [dic setObject:arrDic forKey:@"CustomerRemind"];
        [dic setObject:self.ID forKey:@"CustomerID"];

        [IWHttpTool WMpostWithURL:@"/Customer/CreateCustomerRemind" params:dic success:^(id json) {
            NSLog(@"创建客户提醒成功 ：%@",json);
        } failure:^(NSError *error) {
            NSLog(@"创建客户提醒的请求失败%@",error);
        }];
    }else if (self.descript.text.length>2 ){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"最起码填写3个字吧？😄" message:@"若您想放弃添加提醒，点击返回按钮可以啦！～" delegate:self cancelButtonTitle:@"谢谢，我知道了" otherButtonTitles: nil];
        [alert show];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
