//
//  OrderinformationCell.h
//  ShouKeBao
//
//  Created by 韩世民 on 15/10/20.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderinformationCell : UITableViewCell
{
    UILabel *ScheduleProductLabel;//预定产品
    UILabel *CustomerTimeLabel;//下单时间
    UILabel *SupplybusinessLabel;//供应商
    UILabel *GoSightseeingTimeLabel;//出游时间
    UILabel *TermOfNumbersLabel;//出团人数
    UILabel *CustomerstateLabel;//订单状态
//    UILabel *CellTitleLabel;//发票信息
    UILabel *InvoiceSumOfMoneyLabel;//发票金额
    UIButton *CusterAllMoneyBtn;//订单全款 - 20元   ＊＊后边需要修改
//    UILabel *CusterAllMoneyLabel;
    UILabel *InvoiceHeadLabel;//发票抬头
    UIButton *InvoiceSpecialBtn;//开票专用
    UIButton *InvoiceSpecialagencyBtn;//开票专用 - 旅行社
    UIButton *OtherBtn;//其他
    UITextField *textField;//其他后边的输入框
    UILabel *InvoiceContentAndType;//发票的内容及类型
    UIButton *TouristMoneyBtn;//旅行费
    UILabel *MailDestinationLabel;//寄送地址和联系方式
    UILabel *ContactPersonLabel;//联系人
    UILabel *ContactPhoneNumLabel;//联系电话
    UILabel *ContactAddressLabel;//地址
    UITextField *ContactPersonTF;
    UITextField *ContactPhoneNumTF;
//    UITextView *ContactAddressTF;
    UIButton *submitBtn;//提交
    UITextView *ContactAddressTF;
}
@property (nonatomic,strong)UINavigationController *nav;;
-(void)showDatawWithMe;
@end
