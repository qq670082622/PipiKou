//
//  CustomerDetailAndOrderViewController.m
//  ShouKeBao
//
//  Created by 冯坤 on 15/8/7.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "CustomerDetailAndOrderViewController.h"
#import "CustomerOrderViewController.h"
#import "CustomerDetailViewController.h"
#import "CustomModel.h"
#import "Customers.h"
#import "EditCustomerDetailViewController.h"
#import "BaseClickAttribute.h"
#import "MobClick.h"
@interface CustomerDetailAndOrderViewController ()
@property (nonatomic, weak) UISegmentedControl *segmentControl;
@property (nonatomic, strong)CustomerOrderViewController * orderVC;
@property (nonatomic, strong)CustomerDetailViewController * detailVC;

@property (nonatomic, strong)UIButton *button;
@end

@implementation CustomerDetailAndOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavSegementView];
//     self.title = @"客户资料";
    [self customerRightBarItem];
    self.button.hidden = NO;
    [self addGest];
    [self.view addSubview:self.detailVC.view];
    
}
- (void)addGest{
    UISwipeGestureRecognizer *recognizer = recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleScreen:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    
    [[self view] addGestureRecognizer:recognizer];
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)handleScreen:(UISwipeGestureRecognizer *)sender{
        [self back];
}
- (void)setNavSegementView{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 28)];
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"客户资料",@"订单详情",nil];
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:segmentedArray];
    [segment addTarget:self action:@selector(sex:)forControlEvents:UIControlEventValueChanged];
    [segment setTintColor:[UIColor whiteColor]];
    segment.frame = CGRectMake(0, 0, 150, 28);
    [segment setSelected:YES];
    [segment setSelectedSegmentIndex:0];
    [titleView addSubview:segment];
    self.segmentControl = segment;
    self.navigationItem.titleView = titleView;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)sex:(UISegmentedControl *)sender
{
    UISegmentedControl *control = (UISegmentedControl *)sender;
    
    if (control.selectedSegmentIndex == 0) {
        self.button.hidden = NO;
        [self.view addSubview:self.detailVC.view];
        if (self.orderVC) {
            [self.orderVC.view removeFromSuperview];
            
        }
        NSLog(@"客户资料" );
        //    [self.navigationController popViewControllerAnimated:NO];
    }else if (control.selectedSegmentIndex == 1){
        BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
        [MobClick event:@"CustomerOrderDetailClick" attributes:dict];

        self.button.hidden = YES;
        [self.view addSubview:self.orderVC.view];
        if (self.detailVC) {
            [self.detailVC.view removeFromSuperview];
          
        }
        NSLog(@"订单详情" );
    }
}
-(CustomerOrderViewController *)orderVC{

    if (!_orderVC) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Customer" bundle:nil];
        _orderVC = [sb instantiateViewControllerWithIdentifier:@"CustomerOrderID"];
        _orderVC.customerId = self.customerID;
        _orderVC.mainNav = self.navigationController;
        
        
    }
    return _orderVC;
}
-(CustomerDetailViewController *)detailVC{

    if (!_detailVC) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Customer" bundle:nil];
        _detailVC = [sb instantiateViewControllerWithIdentifier:@"customerDetail"];
        _detailVC.Nav = self.navigationController;
//            _detailVC.QQStr = self.model.QQCode;
//            _detailVC.ID = self.model.ID;
//            _detailVC.weChatStr = self.model.WeiXinCode;
//            _detailVC.teleStr = self.model.Mobile;
//            _detailVC.noteStr = self.model.Remark;
//            _detailVC.userNameStr = self.model.Name;
//            _detailVC.customMoel = self.model;
//            _detailVC.picUrl = self.model.PicUrl;
//        _detailVC.pictureArray = self.model.PictureList;
//        NSLog(@"%@", _detailVC.pictureArray);
        _detailVC.customerId = self.customerID;
        _detailVC.AppSkbUserID = self.appUserID;
        NSLog(@"%@---%@", _detailVC.customerId, self.appUserID);

//            _detailVC.delegate = self.customVC;
//            _detailVC.keyWordss = self.keyWords;
    }
    return _detailVC;
}
-(void)customerRightBarItem
{
    self.button = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
    
    [self.button setImage:[UIImage imageNamed:@"bianji"] forState:UIControlStateNormal];
    
    [self.button addTarget:self action:@selector(EditCustomerDetail)forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithCustomView:self.button];
    
    self.navigationItem.rightBarButtonItem= barItem;
}
-(void)EditCustomerDetail
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Customer" bundle:nil];
    
    EditCustomerDetailViewController *edit = [sb instantiateViewControllerWithIdentifier:@"EditCustomer"];
    edit.ID = self.customerID;
    edit.QQStr = self.detailVC.QQ.text;
    edit.wechatStr = self.detailVC.weChat.text;
    edit.noteStr = self.detailVC.note.text;
    edit.teleStr = self.detailVC.tele.text;
    edit.nameStr = self.detailVC.userName.text;
    edit.delegate = self.detailVC;
    //    添加的内容
    edit.personCardIDStr = self.detailVC.userMessageID.text;
    edit.birthdateStr = self.detailVC.bornDay.text;
    edit.nationalityStr = self.detailVC.countryID.text;
    edit.nationStr = self.detailVC.nationalID.text;
    edit.passportDataStr = self.detailVC.pasportStartDay.text;
    edit.passportAddressStr = self.detailVC.pasportAddress.text;
    edit.passportValidityStr = self.detailVC.pasportInUseDay.text;
    edit.addressStr = self.detailVC.livingAddress.text;
    edit.passportStr = self.detailVC.passPortId.text;
    [self.navigationController pushViewController:edit animated:YES];
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
