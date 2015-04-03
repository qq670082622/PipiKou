//
//  DressView.h
//  ShouKeBao
//
//  Created by Chard on 15/3/26.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    firstArea,
    secondArea,
    thirdArea,
} areaType;

typedef enum : NSUInteger {
    timePick,
    datePick,
} timeType;

@class DressView;

@protocol DressViewDelegate <NSObject>

- (void)wantToPushAreaWithType:(areaType)type;

- (void)didSelectedTimeWithType:(timeType)type;

@end

@interface DressView : UIView

@property (nonatomic,weak) id<DressViewDelegate> delegate;

@property (nonatomic,strong) UITableView *tableView;

@property (weak, nonatomic) IBOutlet UISwitch *IsRefund;

@property (nonatomic,copy) NSString *firstText;

@property (nonatomic,copy) NSString *secondText;

@property (nonatomic,copy) NSString *thirdText;

@end
