//
//  AttachmentCollectionView.h
//  ShouKeBao
//
//  Created by 冯坤 on 15/10/16.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttachmentCollectionView : UICollectionViewController

@property (nonatomic,copy) NSString *picUrl;
@property (nonatomic,copy) NSString *customerId;
@property (nonatomic, strong)NSArray * pictureList;
@end
