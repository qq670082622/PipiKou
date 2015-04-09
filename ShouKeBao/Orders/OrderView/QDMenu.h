//
//  QDMenu.h
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/9.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QDMenu;

@protocol  QDMenuDelegate <NSObject>

- (void)menu:(QDMenu *)menu didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface QDMenu : UIImageView

@property (nonatomic,weak) id<QDMenuDelegate> delegate;

@property (nonatomic,strong) NSMutableArray *dataSource;

@end
