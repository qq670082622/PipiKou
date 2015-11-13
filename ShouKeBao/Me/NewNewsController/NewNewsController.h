//
//  NewNewsController.h
//  ShouKeBao
//
//  Created by 韩世民 on 15/11/5.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "SKViewController.h"

@interface NewNewsController : SKViewController
@property (weak, nonatomic) IBOutlet UILabel *NewsState;
- (IBAction)NotDisturbSwitch:(UISwitch *)sender;
- (IBAction)VoiceSwitch:(UISwitch *)sender;

- (IBAction)ShakeSwitch:(UISwitch *)sender;

@property (nonatomic,strong) NSUserDefaults *NewsRemind;
@property (nonatomic,strong) NSUserDefaults *NewsVoiceRemind;
@property (nonatomic,strong) NSUserDefaults *NewsShakeRemind;
/*
 消息提醒：0,不开启
         1,开启
 */

@end
