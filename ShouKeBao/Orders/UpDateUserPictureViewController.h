//
//  UpDateUserPictureViewController.h
//  ShouKeBao
//
//  Created by 冯坤 on 15/10/21.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "SKViewController.h"

@interface UpDateUserPictureViewController : SKViewController
- (IBAction)ensureClick:(id)sender;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong)NSMutableArray * dateArray;
@property (nonatomic, strong)NSMutableArray * customerIds;
@property (nonatomic, strong)id VC;
@end
