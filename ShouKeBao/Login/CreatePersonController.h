//
//  CreatePersonController.h
//  ShouKeBao
//
//  Created by 金超凡 on 15/5/5.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "SKTableViewController.h"

typedef enum : NSUInteger {
    CreatePersonType,
    CreateSKBType,
} CreateType;

@class CreatePersonController;

@protocol CreatePersonControllerDelegate <NSObject>
/**
 *  成功创建后回调
 */
- (void)didFinishCreateSkb:(CreatePersonController *)createVc;

@end

@interface CreatePersonController : SKTableViewController

@property (nonatomic,assign) CreateType createType;

@property (nonatomic,weak) id<CreatePersonControllerDelegate> delegate;

@end
