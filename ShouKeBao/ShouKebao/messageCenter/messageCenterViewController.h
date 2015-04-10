//
//  messageCenterViewController.h
//  ShouKeBao
//
//  Created by 吴铭 on 15/4/3.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol notifiSKBToReferesh<NSObject>
-(void)refreshSKBMessgaeCount:(int)count;
@end

@interface messageCenterViewController : UIViewController
@property (nonatomic,strong) NSMutableDictionary *dataDic;
@property (nonatomic,weak) id<notifiSKBToReferesh>delegate;
@end
