//
//  BatchAddViewController.h
//  ShouKeBao
//
//  Created by 吴铭 on 15/3/30.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKViewController.h"
@protocol notifiCustomersToReferesh<NSObject>
-(void)referesh;
@end
@interface BatchAddViewController : SKViewController
{
    BOOL All;
    UIButton *allbutton;
}
@property(nonatomic,weak) id<notifiCustomersToReferesh>delegate;
@end
