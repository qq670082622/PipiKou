//
//  NewNewsController.m
//  ShouKeBao
//
//  Created by 韩世民 on 15/11/5.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "NewNewsController.h"
#import "BaseClickAttribute.h"
#import "MobClick.h"
#import "MeHttpTool.h"
#import "MBProgressHUD+MJ.h"
@interface NewNewsController ()
@property (nonatomic,strong) UISwitch *switch2;//32
@property (nonatomic,strong) UISwitch *switch3;//33
@property (nonatomic,strong) UISwitch *switch1;//31
@end

@implementation NewNewsController

- (void)viewDidLoad {
    [super viewDidLoad];
    _switch1 = (UISwitch *)[self.view viewWithTag:31];
    _switch2 = (UISwitch *)[self.view viewWithTag:32];
    _switch3 = (UISwitch *)[self.view viewWithTag:33];
    // Do any additional setup after loading the view from its nib.
    self.title = @"新消息通知";
    UIUserNotificationSettings *mySet =[[UIApplication sharedApplication] currentUserNotificationSettings];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        if (mySet.types == UIRemoteNotificationTypeNone) {
            self.NewsState.text = @" 已关闭";
        }else{
            self.NewsState.text = @"已开启";
        }
    }else{
        if([[UIApplication sharedApplication] enabledRemoteNotificationTypes] == UIRemoteNotificationTypeNone){
            self.NewsState.text = @" 已关闭";
        }else{
         self.NewsState.text = @"已开启";
        }
    }
    
    //判断开关状态
    NSString *NewsDefine = [[NSUserDefaults standardUserDefaults] objectForKey:@"NewsRemind"];
    NSLog(@"%@", NewsDefine);
    if ([NewsDefine integerValue] == 1) {//勿扰模式
        _switch1.on = NO;
    }else{
        _switch1.on = YES;
    }
    NSString *NewsVoiceDefine = [[NSUserDefaults standardUserDefaults] objectForKey:@"NewsVoiceRemind"];
    NSLog(@"%@", NewsDefine);
    if ([NewsVoiceDefine integerValue] == 1) {//声音
        _switch2.on = NO;
    }else{
        _switch2.on = YES;
    }
    
    NSString *NewsShakeDefine = [[NSUserDefaults standardUserDefaults] objectForKey:@"NewsShakeRemind"];
    NSLog(@"%@", NewsDefine);
    if ([NewsShakeDefine integerValue] == 1) {//震动
        _switch3.on = NO;
    }else{
        _switch3.on = YES;
    }
}
-(NSUserDefaults *)NewsRemind{
    if (!_NewsRemind) {
        _NewsRemind = [[NSUserDefaults alloc] init];
    }
    return _NewsRemind;
}
-(NSUserDefaults *)NewsVoiceRemind{
    if (!_NewsVoiceRemind) {
        _NewsVoiceRemind = [[NSUserDefaults alloc] init];
    }
    return _NewsVoiceRemind;
}
-(NSUserDefaults *)NewsShakeRemind{
    if (!_NewsShakeRemind) {
        _NewsShakeRemind = [[NSUserDefaults alloc] init];
    }
    return _NewsShakeRemind;
}
/*
 [application enabledRemoteNotificationTypes] == UIRemoteNotificationTypeSound
 UIRemoteNotificationTypeAlert、 UIRemoteNotificationTypeBadge、UIRemoteNotificationTypeSound
 */
- (IBAction)NotDisturbSwitch:(UISwitch *)sender {
    NSLog(@"请勿打扰%d",sender.isOn);
    
    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
    [MobClick event:@"MeDonotDisturbMe" attributes:dict];
    if (sender.on == 0) {
        _switch1.on = NO;
        [self.NewsRemind setObject:@"1" forKey:@"NewsRemind"];
    }else{
        _switch1.on = YES;
        
        [self.NewsRemind setObject:@"2" forKey:@"NewsRemind"];
    }
    
    NSDictionary *param = @{@"DisturbSwitch":[NSString stringWithFormat:@"%d",sender.on]};
    [MeHttpTool setDisturbSwitchWithParam:param success:^(id json) {
        NSLog(@"json   %@",json);
        if ([json[@"IsSuccess"] integerValue] == 0) {
            [sender setOn:!sender.on animated:YES];
            [MBProgressHUD showError:@"设置失败"];
        }
    } failure:^(NSError *error) {
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)VoiceSwitch:(UISwitch *)sender {
    NSLog(@"声音%d",sender.isOn);
    if (sender.on) {
        sender.on = YES;
        [self.NewsRemind setObject:@"2" forKey:@"NewsVoiceRemind"];
    }else{
        sender.on = NO;
        [self.NewsRemind setObject:@"1" forKey:@"NewsVoiceRemind"];
    }
    
}

- (IBAction)ShakeSwitch:(UISwitch *)sender {
    NSLog(@"震动%d",sender.isOn);
    if (sender.on) {
        sender.on = YES;
        [self.NewsRemind setObject:@"2" forKey:@"NewsShakeRemind"];
    }else{
        sender.on = NO;
        [self.NewsRemind setObject:@"1" forKey:@"NewsShakeRemind"];
    }
    
}

@end
