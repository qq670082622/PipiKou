//
//  LeaveShare.h
//  ShouKeBao
//
//  Created by 韩世民 on 15/10/10.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProduceDetailViewController;
@interface LeaveShare : UIView
@property (weak, nonatomic) IBOutlet UILabel *bodydifferenceColor;
@property (nonatomic,strong) UINavigationController *nav;
@property (nonatomic, strong)ProduceDetailViewController * theVC;
-(void)thisatest:(NSString *)body;
- (IBAction)CancelBtn:(UIButton *)sender;

- (IBAction)NeedShareBtn:(UIButton *)sender;


@end
