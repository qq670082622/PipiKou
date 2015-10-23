//
//  SKBNavBar.m
//  ShouKeBao
//
//  Created by 吴铭 on 15/6/23.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "SKBNavBar.h"
#import "WMAnimations.h"
@implementation SKBNavBar

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
    [WMAnimations WMAnimationMakeBoarderWithLayer:self.stationBtn.layer andBorderColor:[UIColor clearColor] andBorderWidth:0 andNeedShadow:NO];
    [WMAnimations WMAnimationMakeBoarderNoCornerRadiosWithLayer:self.line.layer andBorderColor:[UIColor lightTextColor] andBorderWidth:1 andNeedShadow:NO];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(changeStationName) userInfo:nil repeats:YES];
    self.timer = timer;
   
    // CGFloat screenW = [[UIScreen mainScreen] bounds].size.width;
    //self.frame = CGRectMake(28, 0, screenW/2 - 14, 34);
}

-(void)changeStationName
{
    NSUserDefaults *udf = [NSUserDefaults standardUserDefaults];
    [self.stationBtn setTitle:[udf objectForKey:@"SubstationName"] forState:UIControlStateNormal];
   // NSLog(@"navBarView ' s subStationName is %@",[udf objectForKey:@"SubstationName"]);
    

}


+(instancetype)SKBNavBar
{
    
 return [[[NSBundle mainBundle] loadNibNamed:@"SKBNavBar" owner:nil options:nil] lastObject];
}

@end
