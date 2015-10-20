//
//  OrderinformationCell.h
//  ShouKeBao
//
//  Created by 韩世民 on 15/10/20.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderinformationCell : UITableViewCell
//@property (nonatomic,copy)UILabel *ScheduleProductLabel;//预定产品
//@property (nonatomic,copy)UILabel *CustomerTimeLabel;//下单时间
//@property (nonatomic,copy) UILabel *SupplybusinessLabel;//供应商
//@property (nonatomic,copy)UILabel *GoSightseeingTimeLabel;//出游时间
//@property (nonatomic,copy)UILabel *TermOfNumbersLabel;//出团人数
//@property (nonatomic,copy)UILabel *CustomerstateLabel;//订单状态
//@property (nonatomic,copy)UILabel *CellTitleLabel;//发票信息
//@property (nonatomic,copy) UILabel *InvoiceSumOfMoneyLabel;//发票金额
//@property (nonatomic,copy)UILabel *CusterAllMoneyLabel;//订单全款 - 20元   ＊＊后边需要修改
//@property (nonatomic,copy)UILabel *InvoiceHeadLabel;//发票抬头
//@property (nonatomic,strong)UIButton *InvoiceSpecialBtn;//开票专用
//@property (nonatomic,strong)UIButton *InvoiceSpecialagencyBtn;//开票专用 - 旅行社
//@property (nonatomic,strong)UIButton *OtherBtn;//其他
//@property (nonatomic,copy)UILabel *InvoiceContentAndType;//发票的内容及类型
//@property (nonatomic,strong)UIButton *TouristMoneyBtn;//旅行费
//@property (nonatomic,copy)UILabel *MailDestinationLabel;//寄送地址和联系方式
//@property (nonatomic,copy)UILabel *ContactPersonLabel;//联系人
//@property (nonatomic,copy)UILabel *ContactPhoneNumLabel;//联系电话
//@property (nonatomic,copy)UILabel *ContactAddressLabel;//地址

{
    UILabel *ScheduleProductLabel;//预定产品
    UILabel *CustomerTimeLabel;//下单时间
    UILabel *SupplybusinessLabel;//供应商
    UILabel *GoSightseeingTimeLabel;//出游时间
    UILabel *TermOfNumbersLabel;//出团人数
    UILabel *CustomerstateLabel;//订单状态
//    UILabel *CellTitleLabel;//发票信息
//    UILabel *InvoiceSumOfMoneyLabel;//发票金额
//    UILabel *CusterAllMoneyLabel;//订单全款 - 20元   ＊＊后边需要修改
//    UILabel *InvoiceHeadLabel;//发票抬头
//    UIButton *InvoiceSpecialBtn;//开票专用
//    UIButton *InvoiceSpecialagencyBtn;//开票专用 - 旅行社
//    UIButton *OtherBtn;//其他
//    UILabel *InvoiceContentAndType;//发票的内容及类型
//    UIButton *TouristMoneyBtn;//旅行费
//    UILabel *MailDestinationLabel;//寄送地址和联系方式
//    UILabel *ContactPersonLabel;//联系人
//    UILabel *ContactPhoneNumLabel;//联系电话
//    UILabel *ContactAddressLabel;//地址
}
-(void)showDatawWithMe;
@end
