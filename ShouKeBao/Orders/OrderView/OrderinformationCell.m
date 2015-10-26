//
//  OrderinformationCell.m
//  ShouKeBao
//
//  Created by 韩世民 on 15/10/20.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "OrderinformationCell.h"
#import "InvoiceDetailController.h"
#define kScreenSize [UIScreen mainScreen].bounds.size
@implementation OrderinformationCell

- (void)awakeFromNib {
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    
    //预定产品
    ScheduleProductLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, kScreenSize.width-10, 35)];
    ScheduleProductLabel.numberOfLines = 2;
    ScheduleProductLabel.font = [UIFont systemFontOfSize:14];
    ScheduleProductLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:ScheduleProductLabel];
    
    //下单时间
    CustomerTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 35, kScreenSize.width-10, 20)];
    CustomerTimeLabel.font = [UIFont systemFontOfSize:14];
    CustomerTimeLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:CustomerTimeLabel];
    
    //供应商
    SupplybusinessLabel = [[UILabel alloc] initWithFrame:CGRectMake(21.5, 55, kScreenSize.width-21.5, 20)];
    SupplybusinessLabel.font = [UIFont systemFontOfSize:14];
    SupplybusinessLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:SupplybusinessLabel];
    
    //出游时间
    GoSightseeingTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 75, kScreenSize.width-10, 20)];;
    GoSightseeingTimeLabel.font = [UIFont systemFontOfSize:14];
    GoSightseeingTimeLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:GoSightseeingTimeLabel];
    
    //出团人数
    TermOfNumbersLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 95, kScreenSize.width-10, 20)];
    TermOfNumbersLabel.font = [UIFont systemFontOfSize:14];
    TermOfNumbersLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:TermOfNumbersLabel];
    
    //订单状态
    CustomerstateLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 115, kScreenSize.width-10, 20)];
    CustomerstateLabel.font = [UIFont systemFontOfSize:14];
    CustomerstateLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:CustomerstateLabel];
    
    //发票信息
    UIView *Invoicebg = [[UIView alloc] initWithFrame:CGRectMake(0, 135,kScreenSize.width, 30)];
    Invoicebg.backgroundColor = [UIColor colorWithRed:(249.0/255.0) green:(249.0/255.0) blue:(249.0/255.0) alpha:1];
    UILabel *InvoiceInforLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, kScreenSize.width-20, 30)];
    InvoiceInforLabel.text = @"发票信息";
    InvoiceInforLabel.font = [UIFont boldSystemFontOfSize:16];
    [Invoicebg addSubview:InvoiceInforLabel];
    [self.contentView addSubview:Invoicebg];
    
    //发票金额
    InvoiceSumOfMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 165, kScreenSize.width-20, 20)];
    InvoiceSumOfMoneyLabel.textColor = [UIColor lightGrayColor];
    InvoiceSumOfMoneyLabel.font = [UIFont systemFontOfSize:14];
    InvoiceSumOfMoneyLabel.text = @"发票金额 :";
    [self.contentView addSubview:InvoiceSumOfMoneyLabel];
    
    CusterAllMoneyBtn = [[UIButton alloc] initWithFrame:CGRectMake(60, 185, kScreenSize.width/3, 30)];
    [CusterAllMoneyBtn setTitle:@"订单全额 - 20元" forState:UIControlStateNormal];
    [CusterAllMoneyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [CusterAllMoneyBtn setImage:[UIImage imageNamed:@"hongdian"] forState:UIControlStateNormal];
    CusterAllMoneyBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    CusterAllMoneyBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:CusterAllMoneyBtn];
    
    //发票抬头
    InvoiceHeadLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 215, kScreenSize.width/2, 20)];
    InvoiceHeadLabel.textColor = [UIColor lightGrayColor];
    InvoiceHeadLabel.font = [UIFont systemFontOfSize:14];
    InvoiceHeadLabel.text = @"发票抬头 :";
    [self.contentView addSubview:InvoiceHeadLabel];

    NSArray *titleArr = @[@"开发专用",@"开发专用－旅行社",@"其他"];
    for (NSInteger i = 0; i<3; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(60, 235+i*20, kScreenSize.width/3, 20)];
        button.tag = 301+i;
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"hongdian"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self.contentView addSubview:button];
    }
    
    //输入框
    textField = [[UITextField alloc] initWithFrame:CGRectMake(100, 275, kScreenSize.width/2+40, 20)];
    textField.text = @"请描述您的需求，你的客户经理会与您联系";
    textField.font = [UIFont systemFontOfSize:11];
    textField.borderStyle = UITextBorderStyleLine;
    [self.contentView addSubview:textField];
    
    //发票的内容及类型
    InvoiceContentAndType = [[UILabel alloc]initWithFrame:CGRectMake(8, 295, kScreenSize.width/3, 20)];
    InvoiceContentAndType.textColor = [UIColor lightGrayColor];
    InvoiceContentAndType.font = [UIFont systemFontOfSize:14];
    InvoiceContentAndType.text = @"发票内容及类型 :";
    [self.contentView addSubview:InvoiceContentAndType];
    
    //旅行费
    TouristMoneyBtn = [[UIButton alloc] initWithFrame:CGRectMake(60, 315, kScreenSize.width/2, 20)];
    [TouristMoneyBtn setTitle:@"旅游费－普通纸质发票" forState:UIControlStateNormal];
    [TouristMoneyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [TouristMoneyBtn setImage:[UIImage imageNamed:@"hongdian"] forState:UIControlStateNormal];
    TouristMoneyBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    TouristMoneyBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.contentView addSubview:TouristMoneyBtn];
    
    //寄送地址和联系方式
    MailDestinationLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 335, kScreenSize.width/2, 20)];
    MailDestinationLabel.textColor = [UIColor lightGrayColor];
    MailDestinationLabel.font = [UIFont systemFontOfSize:14];
    MailDestinationLabel.text = @"寄送地址和联系方式 :";
    [self.contentView addSubview:MailDestinationLabel];
    
    //联系人
    ContactPersonLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 355, kScreenSize.width/2, 20)];
    ContactPersonLabel.font = [UIFont systemFontOfSize:13];
    ContactPersonLabel.text = @"联系人 :";
    [self.contentView addSubview:ContactPersonLabel];
    ContactPersonTF = [[UITextField alloc] initWithFrame:CGRectMake(120, 355, kScreenSize.width/2, 18)];
    ContactPersonTF.text = @"";
    ContactPersonTF.font = [UIFont systemFontOfSize:11];
    ContactPersonTF.borderStyle = UITextBorderStyleLine;
    [self.contentView addSubview:ContactPersonTF];
    
    //联系电话
    ContactPhoneNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 375, kScreenSize.width/2, 20)];
    ContactPhoneNumLabel.font = [UIFont systemFontOfSize:13];
    ContactPhoneNumLabel.text = @"联系电话 :";
    [self.contentView addSubview:ContactPhoneNumLabel];
    ContactPhoneNumTF = [[UITextField alloc] initWithFrame:CGRectMake(120, 377, kScreenSize.width/2, 18)];
    ContactPhoneNumTF.text = @"";
    ContactPhoneNumTF.font = [UIFont systemFontOfSize:11];
    ContactPhoneNumTF.borderStyle = UITextBorderStyleLine;
    [self.contentView addSubview:ContactPhoneNumTF];
    
    //地址
    ContactAddressLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 395, kScreenSize.width/2, 20)];
    ContactAddressLabel.font = [UIFont systemFontOfSize:13];
    ContactAddressLabel.text = @"地址 :";
    [self.contentView addSubview:ContactAddressLabel];

    ContactAddressTF = [[UITextView alloc] initWithFrame:CGRectMake(120, 398, kScreenSize.width/2, 36)];
    /*
     _textView.layer.borderColor = UIColor.grayColor.CGColor;
     _textView.layer.borderWidth = 1;
     _textView.layer.cornerRadius = 6;
     _textView.layer.masksToBounds = YES;
     */
    ContactAddressTF.layer.borderColor = UIColor.blackColor.CGColor;
    ContactAddressTF.layer.borderWidth = 1;
    ContactAddressTF.text = @"asdfhasldghahsglkaslj";
    [self.contentView addSubview:ContactAddressTF];
    
    
    //提交
    submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenSize.width/3, 445, kScreenSize.width/3, 30)];
    submitBtn.backgroundColor = [UIColor colorWithRed:(240.0/255.0) green:(240.0/255.0) blue:(240.0/255.0) alpha:1];
    [submitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    submitBtn.tag = 106;
    [self.contentView addSubview:submitBtn];
}
-(void)BtnClick:(UIButton *)button{
    NSLog(@"点击三选一了");
    if (button.tag == 106) {
        InvoiceDetailController *invdet = [[InvoiceDetailController alloc] init];
        [self.nav pushViewController:invdet animated:YES];
    }
}
-(void)showDatawWithMe{
        ScheduleProductLabel.text = @"预定产品 :";
        CustomerTimeLabel.text = @"下单时间 :";
        SupplybusinessLabel.text = @"供应商 :";
        GoSightseeingTimeLabel.text = @"出游日期 :";
        TermOfNumbersLabel.text = @"出团人数 :";
        CustomerstateLabel.text = @"订单状态 :";
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
