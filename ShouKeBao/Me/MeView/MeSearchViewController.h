//
//  MeSearchViewController.h
//  ShouKeBao
//
//  Created by 张正梅 on 15/10/22.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "SKViewController.h"
#import "SKSearchBar.h"
//协议传值
//@protocol transmitPopKeyWords <NSObject>
//@end

@protocol searchBarText <NSObject>
- (void)searchBarText:(NSString *)text;
- (void)transmitPopKeyWord:(NSString *)keyWords;

@end

@protocol backChanpinDetail <NSObject>
- (void)backChanpinDetail;
@end

@interface MeSearchViewController : SKViewController<UITextFieldDelegate,UISearchBarDelegate>
@property (nonatomic,strong) SKSearchBar *searchBar;
@property (nonatomic, strong)UITextField *inputSearchView;

//@property(nonatomic, weak)id<transmitPopKeyWords>transmitDelegate;
@property(nonatomic, weak)id<backChanpinDetail>delegate;
@property(nonatomic, weak)id<searchBarText>searchDelegate;

@property(nonatomic, strong)NSString *detail_key;
@end
