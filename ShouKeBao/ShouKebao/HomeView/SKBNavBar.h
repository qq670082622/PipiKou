//
//  SKBNavBar.h
//  ShouKeBao
//
//  Created by 吴铭 on 15/6/23.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface SKBNavBar : UIView
@property (weak, nonatomic) IBOutlet UIButton *stationBtn;
@property (weak, nonatomic) IBOutlet UIView *line;
@property(nonatomic,strong) NSTimer *timer;
+(instancetype)SKBNavBar;
@end
