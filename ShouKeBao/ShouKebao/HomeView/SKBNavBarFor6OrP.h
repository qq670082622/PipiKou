//
//  SKBNavBarFor6OrP.h
//  ShouKeBao
//
//  Created by 吴铭 on 15/6/23.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SKBNavBarFor6OrP : UIView
@property (weak, nonatomic) IBOutlet UIButton *station;
@property (weak, nonatomic) IBOutlet UIView *line;
@property(nonatomic,strong) NSTimer *timer;
+(instancetype)SKBNavBarFor6OrP;
@end
