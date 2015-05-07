//
//  GuideViewController.m
//  ShouKeBao
//
//  Created by 吴铭 on 15/5/7.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "GuideViewController.h"

@interface GuideViewController ()

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    @property (weak, nonatomic) IBOutlet UIImageView *guideMessageCenter;
//    @property (weak, nonatomic) IBOutlet UIImageView *guiSos;
//    @property (weak, nonatomic) IBOutlet UIImageView *guideStore;
//    @property (weak, nonatomic) IBOutlet UIImageView *guideProductDetailShare;
//    @property (weak, nonatomic) IBOutlet UIImageView *guiOrderSwip;
//    @property (weak, nonatomic) IBOutlet UIImageView *guideProductScreening;
//    @property (weak, nonatomic) IBOutlet UIImageView *guideProductSwipe;

    UITapGestureRecognizer *tapMessage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideMessageGuide)];
    [self.guideMessageCenter addGestureRecognizer:tapMessage];
    
    UITapGestureRecognizer *tapSos = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSosGuide)];
    [self.guiSos addGestureRecognizer:tapSos];
    
     UITapGestureRecognizer *tapStore = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideStoreGuide)];
    [self.guideStore addGestureRecognizer:tapStore];
    
    UITapGestureRecognizer *tapShare = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideShareGuide)];
    [self.guideProductDetailShare addGestureRecognizer:tapShare];
    
    UITapGestureRecognizer *tapOrderSwipe = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideOrderSwipeGuide)];
    [self.guiOrderSwip addGestureRecognizer:tapOrderSwipe];
    
    UITapGestureRecognizer *tapScreening = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideScreeningGuide)];
    [self.guideProductScreening addGestureRecognizer:tapScreening];
    
        UITapGestureRecognizer *tapProductSwipe = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideProdecutSwipeGuide)];
    [self.guideProductSwipe addGestureRecognizer:tapProductSwipe];
    
}
-(void)hideMessageGuide
{
    self.guideMessageCenter.hidden = YES;
}
-(void)hideSosGuide
{

    self.guiSos.hidden = YES;
}
-(void)hideStoreGuide
{
    self.guideStore.hidden = YES;
}
-(void)hideShareGuide
{
    self.guideProductDetailShare.hidden = YES;
}
-(void)hideOrderSwipeGuide
{

    self.guiOrderSwip.hidden = YES;
}
-(void)hideScreeningGuide
{

    self.guideProductScreening.hidden = YES;
}
-(void)hideProdecutSwipeGuide
{

    self.guideProductSwipe.hidden = YES;
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

@end
