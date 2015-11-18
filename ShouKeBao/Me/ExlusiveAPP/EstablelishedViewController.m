//
//  EstablelishedViewController.m
//  ShouKeBao
//
//  Created by 张正梅 on 15/11/17.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "EstablelishedViewController.h"
#import "ExclusiveShareView.h"
#import "noOpenExclusiveAppView.h"
#import <ShareSDK/ShareSDK.h>
#import "StrToDic.h"
#import "ProductModal.h"

#define KHeight_Scale    [UIScreen mainScreen].bounds.size.height/667.0f
@interface EstablelishedViewController ()

@property (nonatomic, strong)NSMutableDictionary *shareInfo;
@property (nonatomic, strong)NSMutableArray *dataArr;
- (IBAction)returnButton:(id)sender;
- (IBAction)cancleButton:(id)sender;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *backgroundShareView;



@end

@implementation EstablelishedViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
 
//    480 330 667  = 330*667/480
    self.scrollView.contentSize = CGSizeMake(0, self.view.frame.size.height+380*KHeight_Scale);
    
    if ([self.isExclusiveCustomer isEqualToString:@"1"]) {
           [self shareView];
    }else{
          [self noOpenAxclusiveApp];
    }
    
   

    
    
    
    
}

//未开通App界面
- (void)noOpenAxclusiveApp{
    [noOpenExclusiveAppView backgroundShareView:self.backgroundShareView andUrl:nil];
    
}

//已开通App界面
- (void)shareView{
    
    NSDictionary *tmp = [StrToDic dicCleanSpaceWithDict:self.shareInfo];
//    ProductModal *model = _dataArr[0];
//    NSDictionary *temp = [StrToDic dicCleanSpaceWithDict:model.ShareInfo];
    
    //构造分享内容
    id<ISSContent>publishContent = [ShareSDK content:tmp[@"Desc"]
                                      defaultContent:tmp[@"Desc"]
                                               image:[ShareSDK imageWithUrl:tmp[@"Pic"]]
                                               title:tmp[@"Title"]
                                                 url:tmp[@"Url"]                                             description:tmp[@"Desc"]
                                           mediaType:SSPublishContentMediaTypeNews];
    
    [publishContent addCopyUnitWithContent:[NSString stringWithFormat:@"%@",self.shareInfo[@"Url"]] image:nil];
    NSLog(@"%@444", self.shareInfo);
    [publishContent addSMSUnitWithContent:[NSString stringWithFormat:@"%@", self.shareInfo[@"Url"]]];
    
//    [ExclusiveShareView shareWithContent:publishContent andUrl:tmp[@"Url"]];
    
    [ExclusiveShareView shareWithContent:publishContent backgroundShareView:self.backgroundShareView andUrl:tmp[@"Url"]];
}


- (NSMutableDictionary *)shareInfo{
    if (!_shareInfo) {
        self.shareInfo = [NSMutableDictionary dictionary];
    }
    return _shareInfo;
}
- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        self.dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)returnButton:(id)sender {
    [self.naVC popViewControllerAnimated:YES];
    
    
}

- (IBAction)cancleButton:(id)sender {
    [self.naVC popViewControllerAnimated:NO];
}
@end
