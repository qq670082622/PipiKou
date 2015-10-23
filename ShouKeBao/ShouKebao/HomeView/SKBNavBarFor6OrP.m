//
//  SKBNavBarFor6OrP.m
//  ShouKeBao
//
//  Created by 吴铭 on 15/6/23.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "SKBNavBarFor6OrP.h"
#import "WMAnimations.h"
@implementation SKBNavBarFor6OrP

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib
{
    [super awakeFromNib];
    [WMAnimations WMAnimationMakeBoarderWithLayer:self.station.layer andBorderColor:[UIColor clearColor] andBorderWidth:0 andNeedShadow:NO];
    [WMAnimations WMAnimationMakeBoarderNoCornerRadiosWithLayer:self.line.layer andBorderColor:[UIColor lightTextColor] andBorderWidth:1 andNeedShadow:NO];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(changeStationName) userInfo:nil repeats:YES];
    self.timer = timer;
   // CGFloat screenW = [[UIScreen mainScreen] bounds].size.width;
    //self.frame = CGRectMake(28, 0, screenW/2 - 14, 34);
}

-(void)changeStationName
{
    NSUserDefaults *udf = [NSUserDefaults standardUserDefaults];
    [self.station setTitle:[udf objectForKey:@"SubstationName"] forState:UIControlStateNormal];
     //NSLog(@"navBarViewFor6OrP ' s subStationName is %@",[udf objectForKey:@"SubstationName"]);
    
    
}


+(instancetype)SKBNavBarFor6OrP
{
    
    return [[[NSBundle mainBundle] loadNibNamed:@"SKBNavBarFor6OrP" owner:nil options:nil] lastObject];
}

@end
