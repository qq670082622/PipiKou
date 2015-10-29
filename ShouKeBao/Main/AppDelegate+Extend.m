//
//  AppDelegate+Extend.m
//  ShouKeBao
//
//  Created by 冯坤 on 15/10/13.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "AppDelegate+Extend.h"
#import "UserInfo.h"
#import "UMessage.h"
#import "LoginTool.h"
#define foureSize ([UIScreen mainScreen].bounds.size.height == 480)
#define fiveSize ([UIScreen mainScreen].bounds.size.height == 568)
#define sixSize ([UIScreen mainScreen].bounds.size.height == 667)
#define sixPSize ([UIScreen mainScreen].bounds.size.height > 668)



@implementation AppDelegate (Extend)

-(void)setStartAnamation{
    UIImageView * luanchImage = [[UIImageView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UIImageView *longLine = [[UIImageView alloc]init];
    UIImageView *yuandian = [[UIImageView alloc]initWithFrame:CGRectMake(0, -4, 10, 10)];
    
    if (foureSize) {
        longLine.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/8, [UIScreen mainScreen].bounds.size.height/2+15, [UIScreen mainScreen].bounds.size.width*3/4, 2);
        luanchImage.image = [UIImage imageNamed:@"4start"];
        longLine.image = [UIImage imageNamed:@"changxian4_5"];
        yuandian.image = [UIImage imageNamed:@"yuandian4_5"];
    
    }else{
        
        longLine.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/8, [UIScreen mainScreen].bounds.size.height/2, [UIScreen mainScreen].bounds.size.width*3/4, 2);
        if(fiveSize){
            luanchImage.image = [UIImage imageNamed:@"5start"];
            longLine.image = [UIImage imageNamed:@"changxian4_5"];
            yuandian.image = [UIImage imageNamed:@"yuandian4_5"];
            
        }else if (sixSize){
            luanchImage.image = [UIImage imageNamed:@"6start"];
            longLine.image = [UIImage imageNamed:@"changxian_6"];
            yuandian.image = [UIImage imageNamed:@"yuandian_6"];
            
        }else if(sixPSize){
            luanchImage.image = [UIImage imageNamed:@"6pstart"];
            longLine.image = [UIImage imageNamed:@"changxian_6p"];
            yuandian.image = [UIImage imageNamed:@"yuandian_6p"];
        }
        
    }
    
    
    luanchImage.userInteractionEnabled = YES;
    [self.window addSubview:luanchImage];
    
    [luanchImage addSubview:longLine];
    [longLine addSubview:yuandian];


    //加载动画
    [UIView animateWithDuration:1.0 animations:^{
        yuandian.frame = CGRectMake([UIScreen mainScreen].bounds.size.width*3/4, -4, 10, 10);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 animations:^{
            luanchImage.alpha = 0;
        } completion:^(BOOL finished) {
            [luanchImage removeFromSuperview];
        }];
    }];
    
    
    

}
- (void)loginApp{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *account = [def objectForKey:UserInfoKeyAccount];
    NSString *password = [def objectForKey:UserInfoKeyAccountPassword];
    if (account.length && password.length) {
        [self checkPasswordWithAccount:account passWord:password];
    }
}
- (void)checkPasswordWithAccount:(NSString *)account passWord:(NSString *)passWord
{
    NSDictionary *param = @{@"LoginName":account,
                            @"LoginPassword":passWord};
    NSLog(@"%@", param);
    // 请求登录
    [LoginTool travelLoginWithParam:param success:^(id json) {
        NSLog(@"%@", json);
        if ([json[@"IsSuccess"] integerValue] != 1) {
            
            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"您的帐号密码已经被修改，请重新登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]show];
            [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:UserInfoKeyAccount];
            [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:UserInfoKeyAccountPassword];
        }
    } failure:^(NSError *error) {
//        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"您的帐号密码已经被修改" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]show];
    }];
}

- (void)value{
    
}



@end
