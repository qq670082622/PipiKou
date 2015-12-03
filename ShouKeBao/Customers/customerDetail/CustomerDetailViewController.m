//
//  CustomerDetailViewController.m
//  ShouKeBao
//
//  Created by 吴铭 on 15/3/30.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "CustomerDetailViewController.h"
#import "EditCustomerDetailViewController.h"
#import "CustomerOrdersUIViewController.h"
#import "remondViewController.h"
#import "IWHttpTool.h"
#import "MBProgressHUD+MJ.h"
#import "CustomModel.h"
#import "MobClick.h"
#import "attachmentViewController.h"
#import "AttachmentCollectionView.h"
#import "CustomerOrderViewController.h"
#import "IWHttpTool.h"  
#import "CustomModel.h"
@interface CustomerDetailViewController ()<UITextFieldDelegate,notifiToRefereshCustomerDetailInfo,UIActionSheetDelegate, UITableViewDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *SetRemindBtnOutlet;
@property (nonatomic, strong)NSMutableArray *dataArr;
@end

@implementation CustomerDetailViewController

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"客户详情";
    self.tableView.delegate = self;
   // [self.SetRemindBtnOutlet setHighlighted:NO];
    
    [self loadCustomerDetailData];
    if (self.note.text == nil) {
        self.note.text = @"备注信息";
    }
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,15,20)];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"backarrow"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.SetRemindBtnOutlet.imageEdgeInsets = UIEdgeInsetsMake(0, 32, 0, 0);
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"CustomerDetailViewController"];
    // [self.segmentControl setSelectedSegmentIndex:0];

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"CustomerDetailViewController"];
}

#pragma -mark 编辑用户资料后通知更新
- (void)refreshCustomerInfoWithName:(NSString *)name andQQ:(NSString *)qq andWeChat:(NSString *)weChat andPhone:(NSString *)phone andCardID:(NSString *)cardID andBirthDate:(NSString *)birthdate andNationablity:(NSString *)nationablity andNation:(NSString *)nation andPassportStart:(NSString *)passPortStart andPassPortAddress:(NSString *)passPortAddress andPassPortEnd:(NSString *)passPortEnd andAddress:(NSString *)address andPassport:(NSString *)passPort andNote:(NSString *)note{
    self.QQ.text = qq;
    self.weChat.text = weChat;
    self.tele.text = phone;
    self.note.text = note;
    self.userName.text = name;
    //   新添加
    self.userMessageID.text = cardID;
    self.bornDay.text = birthdate;
    self.countryID.text = nationablity;
    self.nationalID.text = nation;
    self.pasportStartDay.text = passPortStart;
    self.pasportAddress.text = passPortAddress;
    self.pasportInUseDay.text = passPortEnd;
    self.passPortId.text = passPort;
    self.livingAddress.text = address;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)remond:(id)sender {
    remondViewController *remond = [[remondViewController alloc] init];
    remond.ID = [self.dataArr[0]ID];
    remond.customModel = self.dataArr[0];
    [self.Nav pushViewController:remond animated:YES];
}

- (IBAction)deleteCustomer:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"您确定要删除吗？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles: nil];
     [sheet showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        MBProgressHUD *hudView = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
        hudView.labelText = @"删除中...";
        [hudView show:YES];
       
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:[self.dataArr[0]ID] forKey:@"CustomerID"];
        [IWHttpTool WMpostWithURL:@"/Customer/DeleteCustomer" params:dic success:^(id json) {
            NSLog(@"删除客户信息成功%@",json);

            [self.delegate deleteCustomerWith:nil];
            hudView.labelText = @"删除成功...";
            [hudView hide:YES afterDelay:0.4];
            
        } failure:^(NSError *error) {
            NSLog(@"删除客户请求失败%@",error);
        }];
        [self.Nav popViewControllerAnimated:YES];
    }
    if (buttonIndex == 1) {
        return;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0f;
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSString * telStr = [NSString stringWithFormat:@"tel://%@", self.tele.text];
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:telStr]];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                if (self.tele.text.length > 6) {
                    [[[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"是否要拨打电话%@", self.tele.text] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil]show];
                }else{
                    [[[UIAlertView alloc]initWithTitle:@"提示" message:@"电话号码不正确" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil]show];
                }
            }
                break;
            case 1:
//            {
//                if ([self.weChat.text isEqualToString:@""]) {
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"微信号码为空！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                    [alert show];
//                }else if(![self.weChat.text isEqualToString:@""] && ![[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"weixin://"]]){
//                    UIAlertView*ale=[[UIAlertView alloc] initWithTitle:@"提示" message:@"您没有安装手机微信，请安装手机微信后重试，或用PC进行操作。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                    [ale show];
//                }else if([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"weixin://"]] && ![self.weChat.text isEqualToString:@""]){
//                    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"weixin://"]];
//                }
//                
////                if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"weixin://"]] && ![self.weChat.text isEqualToString:@""]) {
////                    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"weixin://"]];
////                }
//            }
                break;
            case 2:
//            {
//                if ([self.QQ.text isEqualToString:@""]) {
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"QQ号码为空!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                    [alert show];
//                }else{
//                    if (![self joinGroup:nil key:nil]) {
//                        UIAlertView *ale = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您没有安装手机QQ，请安装手机QQ后重试，或用PC进行操作。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                        [ale show];
//                    }
//                }
//                
////                
////                if (![self joinGroup:nil key:nil] && ![self.QQ.text isEqualToString:@""]) {
////                    UIAlertView *ale = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您没有安装手机QQ，请安装手机QQ后重试，或用PC进行操作。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
////                    [ale show];
////                }
//            }
                break;

            default:
                break;
        }
    }

}


- (BOOL)joinGroup:(NSString *)groupUin key:(NSString *)key{
    NSString *urlStr = [NSString stringWithFormat:@"mqqapi://card/show_pslcard?src_type=internal&version=1&uin=6481427ed9be2a6b6df78d95f2abf8a0ebaed07baefe3a2bea8bd847cb9d84ed&card_type=group&source=external"];
    NSURL *url = [NSURL URLWithString:urlStr];
    if([[UIApplication sharedApplication] canOpenURL:url]){
        NSString *qqStr = [NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",self.QQ.text];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:qqStr]];
        return YES;
    }else
        return NO;
}

- (BOOL)joinWet:(NSString *)group key:(NSString *)key{
    return YES;
}

- (IBAction)clickButtonCaling:(id)sender {
    if (self.tele.text.length > 6) {
        [[[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"是否要拨打电话%@", self.tele.text] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil]show];
        
    }else{
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"电话号码不正确" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil]show];
    }
}

- (IBAction)attachmentAction:(id)sender {
//    attachmentViewController *AVC = [[attachmentViewController alloc] init];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Customer" bundle:nil];
    AttachmentCollectionView *AVC = [sb instantiateViewControllerWithIdentifier:@"AttachmentCollectionView"];
    AVC.picUrl = [self.dataArr[0]PicUrl];
    AVC.pictureList = [self.dataArr[0]PictureList];
    AVC.customerId = [self.dataArr[0]ID];
    NSLog(@"%@%@", [self.dataArr[0]ID], [self.dataArr[0]PicUrl]);
    [self.Nav pushViewController:AVC animated:YES];
    
}

- (void)loadCustomerDetailData{
    
    MBProgressHUD *hudView = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    hudView.labelText = @"加载中...";
    [hudView show:YES];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *appSkbUserID = self.AppSkbUserID;
    [dic setObject:self.customerId forKey:@"CustomerID"];
    [dic setObject:appSkbUserID forKey:@"AppSkbUserID"];
    NSLog(@"%@", self.customerId);
    [IWHttpTool WMpostWithURL:@"/Customer/GetCustomer" params:dic success:^(id json){
        NSLog(@"------管客户详情json is %@",json);
        
         NSDictionary *dic = json[@"Customer"];
        CustomModel *customerDetail = [CustomModel modalWithDict:dic];
        [self.dataArr addObject:customerDetail];
        [self setSubViews];
        NSLog(@".. %@  %@", self.dataArr, [self.dataArr[0]Name]);
        
        hudView.labelText = @"加载成功...";
        [hudView hide:YES afterDelay:0.4];
    } failure:^(NSError *error) {
        NSLog(@"-------管客户详情请求失败 error is %@",error);
    }];
}

-(void)setSubViews{
    self.QQ.text = [self.dataArr[0]QQCode];
    self.weChat.text =  [self.dataArr[0]WeiXinCode]; /*self.weChatStr;*/
    self.tele.text = [self.dataArr[0]Mobile];/*self.teleStr;*/
    self.note.text = [self.dataArr[0]Remark];/*self.noteStr;*/
    self.userName.text = [self.dataArr[0]Name];/*self.userNameStr;*/
    
    self.passPortId.text = [self.dataArr[0]PassportNum];
    self.userMessageID.text = [self.dataArr[0]CardNum];
    self.bornDay.text = [self.dataArr[0]BirthDay];
    self.countryID.text = [self.dataArr[0]Country];
    self.nationalID.text = [self.dataArr[0]Nationality];
    self.pasportStartDay.text = [self.dataArr[0]ValidStartDate];
    self.pasportAddress.text  = [self.dataArr[0]ValidAddress];
    self.pasportInUseDay.text = [self.dataArr[0]ValidEndDate];
    self.livingAddress.text = [self.dataArr[0]Address];
}

@end
