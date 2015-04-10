//
//  messageDetailViewController.h
//  ShouKeBao
//
//  Created by 吴铭 on 15/4/3.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol notifiToReferesh<NSObject>
-(void)toReferesh;
@end
@interface messageDetailViewController : UIViewController
@property(nonatomic,weak) id<notifiToReferesh>delegate;
@property (nonatomic,copy) NSString *ID;

@end
