//
//  CantactView.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/3/27.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "CantactView.h"
#import "OrderModel.h"

@interface CantactView()

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UIButton *mobile;

@property (weak, nonatomic) IBOutlet UIButton *qqNum;

@end

@implementation CantactView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ContactView" owner:nil options:nil] lastObject];
    }
    return self;
}

- (void)setModel:(OrderModel *)model
{
    _model = model;
    
    self.name.text = model.FollowPerson[@"Name"];
    
    [self.mobile setTitle:model.FollowPerson[@"Tel"] forState:UIControlStateNormal];
    
    [self.qqNum setTitle:model.FollowPerson[@"QQ"] forState:UIControlStateNormal];
}

- (IBAction)callPhone:(id)sender
{
    NSLog(@"-------");
    NSString *phone = [NSString stringWithFormat:@"tel://%@",self.model.FollowPerson[@"Tel"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
}

- (IBAction)addQQ:(id)sender
{
    NSLog(@"-----");
    if (![self joinGroup:nil key:nil]) {
        UIAlertView*ale=[[UIAlertView alloc] initWithTitle:@"提示" message:@"您没有安装手机QQ，请安装手机QQ后重试，或用PC进行操作。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [ale show];
    }
}

- (BOOL)joinGroup:(NSString *)groupUin key:(NSString *)key{
    NSString *urlStr = [NSString stringWithFormat:@"mqqapi://card/show_pslcard?src_type=internal&version=1&uin=6481427ed9be2a6b6df78d95f2abf8a0ebaed07baefe3a2bea8bd847cb9d84ed&card_type=group&source=external"];
    NSURL *url = [NSURL URLWithString:urlStr];
    if([[UIApplication sharedApplication] canOpenURL:url]){
            NSString *qqStr = [NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",self.model.FollowPerson[@"QQ"]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:qqStr]];
            return YES;
    }
    else return NO;
}

@end
