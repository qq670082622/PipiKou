//
//  SearchProductViewController.h
//  ShouKeBao
//
//  Created by 吴铭 on 15/3/26.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKViewController.h"

@protocol passSearchKey<NSObject>
-(void)passSearchKeyFromSearchVC:(NSString *)searchKey;
@end

@interface SearchProductViewController : SKViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *inputView;
@property (weak, nonatomic) IBOutlet UIView *gestureView;
@property (nonatomic ,assign)BOOL isFromFindProduct;
- (IBAction)search;
- (IBAction)clearinPutView:(id)sender;
-(IBAction)hotWordSearch:(id)sender;
//@property (weak, nonatomic) IBOutlet UITableView *historyTable;
@property (nonatomic,weak) id<passSearchKey>delegate;
@end
