//
//  IdentifyViewController.m
//  ShouKeBao
//
//  Created by 张正梅 on 15/10/15.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "IdentifyViewController.h"
#import "QRPhotoTableViewController.h"
#import "QRHistoryTableViewController.h"


@interface IdentifyViewController ()


@property (nonatomic, strong)QRPhotoTableViewController *QRPhotoVC;
@property (nonatomic, strong)QRHistoryTableViewController *QRHistoryVC;

@property (nonatomic, strong)UIBarButtonItem *barItem;
@property (nonatomic, assign)BOOL PhotoFlag;



@end

@implementation IdentifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//     self.navigationItem.leftBarButtonItems = @[leftItem,turnOffItem];
    
    [self setNavSegementView];
    [self stepRightItem];
    [self.view addSubview:self.QRPhotoVC.view];
    
}
- (void)setNavSegementView{
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 28)];
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"识别图片",@"识别记录",nil];
    self.control = [[UISegmentedControl alloc] initWithItems:segmentedArray];
    
    [self.control addTarget:self action:@selector(switchAction:)forControlEvents:UIControlEventValueChanged];
    [self.control setTintColor:[UIColor whiteColor]];
    self.control.frame = CGRectMake(0, 0, 150, 28);
    [self.control setSelected:YES];
    
    [self.control setSelectedSegmentIndex:0];
    [titleView addSubview:self.control];
//    self.control = segment;
    self.navigationItem.titleView = titleView;
    
}

-(void)switchAction:(UISegmentedControl *)sender
{
    UISegmentedControl *control = (UISegmentedControl *)sender;
    _control = control;
    if (_control.selectedSegmentIndex == 0/* && self.historyFlag == 0*/) {
        self.QRHistoryVC.isEditing = 1;
//        [self.QRHistoryVC.table setEditing:NO animated:YES];
//        self.QRHistoryVC.subView.hidden = YES;
        [self.QRHistoryVC editHistoryDetail];
        [self.view addSubview:self.QRPhotoVC.view];
        self.barItem.title = @"编辑";
        if (self.QRHistoryVC) {
            [self.QRHistoryVC.view removeFromSuperview];
        }
        
    }else if (_control.selectedSegmentIndex == 1/* && self.PhotoFlag ==0*/){
        self.QRPhotoVC.PhotoFlag = 1;
        [self.QRPhotoVC editCustomerPhoto];
//        self.QRPhotoVC.subViewPhoto.hidden = YES;
//        [self.QRPhotoVC.collectionV reloadData];
        [self.view addSubview:self.QRHistoryVC.view];
        self.barItem.title = @"编辑";
        if (self.QRPhotoVC) {
            [self.QRPhotoVC.view removeFromSuperview];
        }
        
//    }else{
//        self.barItem.title = @"取消";
    }
}

-(QRHistoryTableViewController *)QRHistoryVC{
    if (!_QRHistoryVC) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"QR" bundle:nil];
        _QRHistoryVC = [sb instantiateViewControllerWithIdentifier:@"QRHistoryView"];
        _QRHistoryVC.isLogin = self.isLogin;
    }
    return _QRHistoryVC;
}

- (QRPhotoTableViewController *)QRPhotoVC{
    
    if (!_QRPhotoVC) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"QR" bundle:nil];
        _QRPhotoVC = (QRPhotoTableViewController *)[sb instantiateViewControllerWithIdentifier:@"QRPhotoTableView"];
        _QRPhotoVC.IDVC = self;
    }
    return _QRPhotoVC;
}

-(void)stepRightItem
{
    self.barItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStyleBordered target:self action:@selector(editCustomerDetail)];
    self.navigationItem.rightBarButtonItem = self.barItem;
}

-(void)editCustomerDetail{
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    NSLog(@"index= %ld, %ld", _control.selectedSegmentIndex, self.control.selectedSegmentIndex);
    if (self.control.selectedSegmentIndex==0) {
        self.historyFlag = 0;
//        if (self.historyFlag == 0) {
            if (self.PhotoFlag == 0) {
//                [self.control setEnabled:NO forSegmentAtIndex:1];
                self.navigationItem.rightBarButtonItem.title = @"取消";
            }else{
                self.navigationItem.rightBarButtonItem.title = @"编辑";
//                [self.control setEnabled:YES forSegmentAtIndex:1];
            }
            
            self.PhotoFlag = !self.PhotoFlag;
            [center postNotificationName:@"edit1" object:@"QRPhoto" userInfo:nil];
//        }
    }else if(self.control.selectedSegmentIndex==1){
        self.PhotoFlag = 0;
//        if (self.PhotoFlag == 0) {
            if (self.historyFlag==0 ) {
//            [self.control setEnabled:NO forSegmentAtIndex:0];
                self.navigationItem.rightBarButtonItem.title = @"取消";
            }else if(self.historyFlag == 1){
                self.navigationItem.rightBarButtonItem.title = @"编辑";
//                [self.control setEnabled:YES forSegmentAtIndex:0];
            }
            self.historyFlag = !self.historyFlag;
            [center postNotificationName:@"edit2" object:@"QRHistory" userInfo:nil];
//        }
    }
}


- (void)change{
    self.navigationItem.rightBarButtonItem.title = @"编辑";
    [self.control setEnabled:YES forSegmentAtIndex:0];
}

- (void)dealloc
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self];
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
