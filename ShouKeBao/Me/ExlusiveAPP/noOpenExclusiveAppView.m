//
//  noOpenExclusiveAppView.m
//  ShouKeBao
//
//  Created by 张正梅 on 15/11/18.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "noOpenExclusiveAppView.h"

#define kScreenWidth   [UIScreen mainScreen].bounds.size.width
#define kScreenHeight  [UIScreen mainScreen].bounds.size.height
#define SYSTEM_VERSION   [[UIDevice currentDevice].systemVersion floatValue]

//屏幕宽度相对iPhone6屏幕宽度的比例
#define KWidth_Scale    [UIScreen mainScreen].bounds.size.width/375.0f
#define KHeight    [UIScreen mainScreen].bounds.size.height/667.0f

@implementation noOpenExclusiveAppView

static id _Tel;
static id _shareView;


+(void)backgroundShareView:(id)backgroundShareView andUrl:(NSString *)url{
    _Tel = url;
    
    //  自定义弹出的分享view
    UIView *shareView = [[UIView alloc] initWithFrame:CGRectMake(10, 15, kScreenWidth-20, /*(300-10-15-10)*KHeight*/ /*kScreenHeight/2.0f-60+20*KHeight_Scale*/260)];
    shareView.backgroundColor = [UIColor colorWithRed:236/255.0f green:236/255.0f blue:236/255.0f alpha:1];
    shareView.tag = 441;
    [backgroundShareView addSubview:shareView];
    _shareView = shareView;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, -10, shareView.frame.size.width-180, 25*KHeight)];
    titleLabel.backgroundColor = [UIColor colorWithRed:251/255.0f green:78/255.0f blue:10/255.0f alpha:1];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"怎么享受这些好处？";
    titleLabel.layer.masksToBounds = YES;
    titleLabel.layer.cornerRadius = 2;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:15*KWidth_Scale];
    [shareView addSubview:titleLabel];
    
    
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(30*KHeight, CGRectGetMaxY(titleLabel.frame), shareView.frame.size.width-40, 50*KHeight)];
    contentLabel.text = @"非常简单，让尽可能多的客人，安装您的专属App";
    contentLabel.numberOfLines = 0;
    contentLabel.textColor = [UIColor grayColor];
    contentLabel.textAlignment = NSTextAlignmentLeft;
    contentLabel.font = [UIFont systemFontOfSize:12];
    [shareView addSubview:contentLabel];
    
    
    UILabel *rContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(contentLabel.frame)+10, shareView.frame.size.width-40, 50*KHeight)];
    rContentLabel.text = @"不够银级，马上找您的客户经理勾兑一下！";
    rContentLabel.numberOfLines = 0;
    rContentLabel.textColor = [UIColor orangeColor];
    rContentLabel.textAlignment = NSTextAlignmentCenter;
    rContentLabel.font = [UIFont systemFontOfSize:12];
    [shareView addSubview:rContentLabel];
    
    
    UIButton *contactB = [UIButton buttonWithType:UIButtonTypeCustom];
    contactB.frame = CGRectMake(30, CGRectGetMaxY(rContentLabel.frame), shareView.frame.size.width-60, 50*KHeight);
    [shareView addSubview:contactB];
    contactB.backgroundColor = [UIColor colorWithRed:251/255.0f green:78/255.0f blue:10/255.0f alpha:1];
    [contactB setTitle:@"立即联系客户经理" forState:UIControlStateNormal];
    contactB.layer.masksToBounds = YES;
    contactB.layer.cornerRadius = 2;
    [contactB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [contactB addTarget:self action:@selector(callPhone) forControlEvents:UIControlEventTouchUpInside];
    
}


+ (void)callPhone{
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel://%@",_Tel];
    NSLog(@"电话号码是%@",str);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
