//
//  messageDetailViewController.h
//  ShouKeBao
//
//  Created by 吴铭 on 15/4/3.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
//@protocol notifiToReferesh<NSObject>
//-(void)toReferesh;
//@end
@interface messageDetailViewController : UIViewController
{
    UIBarButtonItem *leftItem;
    UIBarButtonItem * turnOffItem;
}
//@property(nonatomic,weak) id<notifiToReferesh>delegate;
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *messageURL;
@property (nonatomic,copy) NSString *createDate;
@property (nonatomic,copy) NSString *messageTitle;
@property (nonatomic, strong)NSMutableDictionary * shareInfo;

@property (nonatomic) NSInteger m;

@end
