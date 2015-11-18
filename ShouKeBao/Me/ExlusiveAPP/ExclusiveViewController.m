//
//  ExclusiveViewController.m
//  ShouKeBao
//
//  Created by 张正梅 on 15/11/17.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "ExclusiveViewController.h"
#import "ExclusiveTableViewCell.h"
#import "EstablelishedViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "NSString+FKTools.h"
#import "MBProgressHUD+MJ.h"
#import "IWHttpTool.h"
#import "MeShareDetailModel.h"
#import "Customers.h"

@interface ExclusiveViewController ()<UITableViewDataSource, UITableViewDelegate>
//头部
@property (weak, nonatomic) IBOutlet UIImageView *HeadImageViewSet;
@property (weak, nonatomic) IBOutlet UILabel *builtLable;
@property (weak, nonatomic) IBOutlet UILabel *penpleL;


@property (weak, nonatomic) IBOutlet UILabel *customerCount;
@property (weak, nonatomic) IBOutlet UIButton *adviserBtn;
//table中间
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataArray;

//专属App
- (IBAction)touchExclusiveAppButton:(id)sender;
//分享
@property (nonatomic, strong)NSMutableDictionary *shareInfo;
@property (nonatomic, copy)NSString *IsBinding;
@end

@implementation ExclusiveViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self loadExclusiveAppData];
    
    [self setRightShareBarItem];
    [self setHeaderImageView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
   
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCustomerLableToComeInCustomer:)];
    [self.customerCount addGestureRecognizer:tap];
    
    
    
    
    
    
    
    
    
    
    
}
- (void)clickCustomerLableToComeInCustomer:(UITapGestureRecognizer *)tap{
    NSLog(@"mmmmmm//////");
    Customers *customerVC = [[Customers alloc]init];
    customerVC.customerType = 2;
    [self.navigationController pushViewController:customerVC animated:YES];
    
}

#pragma mark - tableView-delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ExclusiveTableViewCell *cell = [ExclusiveTableViewCell cellWithTableView:tableView];
    
    MeShareDetailModel *model = _dataArray[indexPath.row];
    cell.model = model;
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.tableView.frame.size.height;
}


- (void)loadExclusiveAppData{
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [IWHttpTool WMpostWithURL:@"/Customer/GetAppStatisticalInformationData" params:dic success:^(id json) {
            NSLog(@"------专属App的json is %@-------",json);
            self.IsBinding = json[@"IsBinding"];
            self.customerCount.text = json[@"Installed"];
            
            NSString *rank = json[@"AdvisorRank"];
            
            [self setHeaderWith:rank];
            
                MeShareDetailModel *model = [MeShareDetailModel shareDetailWithDict:json];
                [self.dataArray addObject:model];
            NSLog(@"dataArrray = %@", self.dataArray);
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            NSLog(@"-------管客户第一个接口请求失败 error is %@------",error);
        }];
}

- (void)setHeaderWith:(NSString *)rank{
    switch ([rank integerValue]) {
        case 1000:
            [self.adviserBtn setImage:[UIImage imageNamed:@"jianxi"] forState:UIControlStateNormal];
            [self.adviserBtn setTitle:@"见习顾问" forState:UIControlStateNormal];
            
            break;
        case 2000:
            [self.adviserBtn setImage:[UIImage imageNamed:@"tongpai"] forState:UIControlStateNormal];
            [self.adviserBtn setTitle:@"铜牌顾问" forState:UIControlStateNormal];
            break;
        case 3000:
            [self.adviserBtn setImage:[UIImage imageNamed:@"yinpai"] forState:UIControlStateNormal];
            [self.adviserBtn setTitle:@"银牌顾问" forState:UIControlStateNormal];
            break;
        case 4000:
            [self.adviserBtn setImage:[UIImage imageNamed:@"huangjin"] forState:UIControlStateNormal];
            [self.adviserBtn setTitle:@"黄金顾问" forState:UIControlStateNormal];
            break;
        case 5000:
            [self.adviserBtn setImage:[UIImage imageNamed:@"baijin"] forState:UIControlStateNormal];
            [self.adviserBtn setTitle:@"白金顾问" forState:UIControlStateNormal];
            break;
        case 6000:
            [self.adviserBtn setImage:[UIImage imageNamed:@"zuanshi"] forState:UIControlStateNormal];
            [self.adviserBtn setTitle:@"钻石顾问" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}




- (void)setRightShareBarItem{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0,0,20,20)];
    [button setImage:[UIImage imageNamed:@"APPfenxiang"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(shareAction:)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *shareBarItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = shareBarItem;
}
- (void)setHeaderImageView{
    [self.view addSubview:self.HeadImageViewSet];
    [self.HeadImageViewSet addSubview:self.builtLable];
    [self.HeadImageViewSet addSubview:self.penpleL];
    [self.HeadImageViewSet addSubview:self.customerCount];
    [self.HeadImageViewSet addSubview:self.adviserBtn];
    
}


-(void)shareAction:(UIButton *)button{
    
    id<ISSContent> publishContent = [ShareSDK content:self.shareInfo[@"Desc"]
                                       defaultContent:self.shareInfo[@"Desc"]
                                                image:[ShareSDK imageWithUrl:self.shareInfo[@"Pic"]]
                                                title:self.shareInfo[@"Title"]
                                                  url:self.shareInfo[@"Url"]                                  description:self.shareInfo[@"Desc"]
                                            mediaType:SSPublishContentMediaTypeNews];
    
    [publishContent addCopyUnitWithContent:[NSString stringWithFormat:@"%@",self.shareInfo[@"Url"]] image:nil];
    NSLog(@"%@444", self.shareInfo);
    [publishContent addSMSUnitWithContent:[NSString stringWithFormat:@"%@", self.shareInfo[@"Url"]]];
    NSLog(@"self.shareInfo %@, %@", self.shareInfo[@"Url"], self.shareInfo[@"ShareUrl"]);
    
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:button arrowDirect:UIPopoverArrowDirectionUp];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                //                                [self.warningLab removeFromSuperview];
                                if (state == SSResponseStateSuccess)
                                {
                                    
                                    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
                                    [postDic setObject:@"0" forKey:@"ShareType"];
                                    if (self.shareInfo[@"Url"]) {
                                        [postDic setObject:self.shareInfo[@"Url"]  forKey:@"ShareUrl"];
                                    }
//                                    [postDic setObject:self.webView.request.URL.absoluteString forKey:@"PageUrl"];
                                    if (type ==ShareTypeWeixiSession) {
                                        
                                    }else if(type == ShareTypeQQ){
                                        
                                    }else if(type == ShareTypeQQSpace){
                                        
                                    }else if(type == ShareTypeWeixiTimeline){
                                    }
                                    //                                    [IWHttpTool postWithURL:@"Common/SaveShareRecord" params:postDic success:^(id json) {
                                    //                                        NSDictionary * dci = json;
                                    //                                        NSMutableString * string = [NSMutableString string];
                                    //                                        for (id str in dci.allValues) {
                                    //                                            [string appendString:str];
                                    //                                        }
                                    //
                                    //                                    } failure:^(NSError *error) {
                                    //
                                    //                                    }];
                                    //产品详情
                                    if (type == ShareTypeCopy) {
                                        [MBProgressHUD showSuccess:@"复制成功"];
                                    }else{
                                        [MBProgressHUD showSuccess:@"分享成功"];
                                    }
                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 2.0s后执行block里面的代码
                                        [MBProgressHUD hideHUD];
                                    });
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                }else if (state == SSResponseStateCancel){
                                    
                                }
                            }];
    
    NSLog(@"%@",self.shareInfo[@"Url"]);
    [self addAlert];
    
}

-(void)addAlert{
    NSArray *windowArray = [UIApplication sharedApplication].windows;
    UIWindow *actionWindow = (UIWindow *)[windowArray lastObject];
    // 以下就是不停的寻找子视图，修改要修改的
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    CGFloat labY = 180;
    if (screenH == 667) {
        labY = 260;
    }else if (screenH == 568){
        labY = 160;
    }else if (screenH == 480){
        labY = 180;
    }else if (screenH == 736){
        labY = 440;
    }
    CGFloat labW = [[UIScreen mainScreen] bounds].size.width;
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, screenH, labW, 30)];
    lab.text = @"您分享出去的内容对外只显示门市价";
    lab.textColor = [UIColor blackColor];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:12];
    [actionWindow addSubview:lab];
    [UIView animateWithDuration:0.38 animations:^{
        lab.transform = CGAffineTransformMakeTranslation(0, labY-screenH - 8);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.17 animations:^{
            lab.transform = CGAffineTransformMakeTranslation(0, labY-screenH);
        }];
    }];
    //    self.warningLab = lab;
    
}
- (NSMutableDictionary *)shareInfo{
    if (!_shareInfo) {
        self.shareInfo = [NSMutableDictionary dictionary];
    }
    return _shareInfo;
}
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
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

- (IBAction)touchExclusiveAppButton:(id)sender {
    EstablelishedViewController *estableshedVC = [[EstablelishedViewController alloc]init];
    estableshedVC.title = @"专属APP";
    estableshedVC.isExclusiveCustomer = self.IsBinding;
    estableshedVC.naVC = self.navigationController;
    [self.navigationController pushViewController:estableshedVC animated:YES];
    
}
@end
