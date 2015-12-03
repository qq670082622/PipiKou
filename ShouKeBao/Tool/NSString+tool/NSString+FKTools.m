//
//  NSString+FKTools.m
//  ShouKeBao
//
//  Created by 冯坤 on 15/9/9.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "NSString+FKTools.h"
#import "CommandTo.h"
#import "LeaveShare.h"
#import "UIImageView+WebCache.h"
#import "ProduceDetailViewController.h"
@implementation NSString (FKTools)
- (BOOL)myContainsString:(NSString*)other{
    NSRange range = [self rangeOfString:other];
    return range.length != 0;
}
- (CGFloat)heigthWithsysFont:(CGFloat)font
                   withWidth:(CGFloat)width{
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:font], NSFontAttributeName, nil];
    CGRect rect = [self boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return rect.size.height;
}
- (CGFloat)widthWithsysFont:(CGFloat)font{
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:font], NSFontAttributeName, nil];
    CGRect rect = [self boundingRectWithSize:CGSizeMake(0, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return rect.size.width;
}
+(void)showbackgroundgray{
    //半透明背景
    UIView *backgroundGray = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    backgroundGray.backgroundColor = [UIColor blackColor];
    backgroundGray.alpha = 0.5;
    backgroundGray.tag = 102;
    [[[UIApplication sharedApplication].delegate window] addSubview:backgroundGray];

}
+(void)showcommendToDetailbody:(NSString *)body Di:(NSString *)Di song:(NSString *)song retailsales:(NSString *)retailsalesLabel CommandSamePrice:(NSString *)CommandSamePrice Picurl:(NSString *)Picurl NewPageUrl:(NSString *)NewPageUrl shareInfo:(NSDictionary *)shareInfo exist:(NSInteger)exist Nav:(UINavigationController *)nav{
    CommandTo *commandto;
    if (exist == 0) {
     commandto = [[[NSBundle mainBundle] loadNibNamed:@"CommandTo" owner:self options:nil] lastObject];
    }
    commandto.NAV = nav;
    NSLog(@"%@", commandto.NAV);
    commandto.backgroundView.layer.cornerRadius = 4;
    commandto.backgroundView.layer.masksToBounds = YES;
    [commandto.PicImage sd_setImageWithURL:[NSURL URLWithString:Picurl] placeholderImage:[UIImage imageNamed:@"CommandplaceholderImage"]];
    commandto.tag = 101;
    commandto.frame = CGRectMake(10, [UIScreen mainScreen].bounds.size.height/4,[UIScreen mainScreen].bounds.size.width-20, [UIScreen mainScreen].bounds.size.height/2);
    commandto.NewPageUrl = NewPageUrl;
    commandto.bodyLabel.text = body;
    commandto.DiLabel.text = Di;
    commandto.SongLabel.text = song;
    commandto.retailsalesLabel.text = retailsalesLabel;
    commandto.PriceLabel.text = CommandSamePrice;
    [[[UIApplication sharedApplication].delegate window] addSubview:commandto];
}
+(void)showLeaveShareNav:(UINavigationController *)nav  InVC:(UIViewController *)controller{
    ProduceDetailViewController * VC = (ProduceDetailViewController *)controller;
    LeaveShare *leaveS = [[[NSBundle mainBundle] loadNibNamed:@"LeaveShare" owner:self options:nil] lastObject];
    leaveS.theVC = VC;
    leaveS.layer.cornerRadius = 8;
    leaveS.tag = 103;
    leaveS.nav =nav;

    leaveS.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-260)/2, [UIScreen mainScreen].bounds.size.height/3,260, 160);
    leaveS.bodydifferenceColor.text  = @"    你知道么？每1秒就会产生1个分享，每5次分享就会产生1个订单，赶快分享吧，分享越多，机会越多!";
    NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc] initWithString:leaveS.bodydifferenceColor.text];
    [mutStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(30, 2)];
    [mutStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(22, 2)];
    
    [leaveS.bodydifferenceColor setAttributedText:mutStr];
    
    [[[UIApplication sharedApplication].delegate window] addSubview:leaveS];


}


+(NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString {
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    return responseJSON;
}


+(BOOL)stringIsEmpty:(id)str{
    NSLog(@"%@", str);
    if ([str isKindOfClass:[NSNull class]]||[str isEqualToString:@""]||!str) {
        return YES;
    }
    return NO;
}
@end
