//
//  QRCodeCell.m
//  ShouKeBao
//
//  Created by 冯坤 on 15/7/28.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "QRCodeCell.h"
#import "personIdModel.h"

@interface QRCodeCell ()
@property (nonatomic, strong)UIImageView *imgV;
@property (nonatomic, strong)UILabel *label;
@property (nonatomic, strong)UILabel *codeLab;
@property (nonatomic, strong)UILabel *creatLab;

@end




@implementation QRCodeCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat screenW = [[UIScreen mainScreen] bounds].size.width;
        self.imgV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 35, 35)];
        [self.contentView addSubview:self.imgV];
       self.label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.imgV.frame)+10, 10, 200, 20)];
        self.label.textColor = [UIColor blackColor];
        self.label.font = [UIFont systemFontOfSize:15];
        self.label.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.label];
        
        self.codeLab = [[UILabel alloc] initWithFrame:CGRectMake(self.label.frame.origin.x, CGRectGetMaxY(self.label.frame)+10, 200, 20)];
        self.codeLab.textColor = [UIColor grayColor];
        self.codeLab.font = [UIFont systemFontOfSize:12];
        self.codeLab.textAlignment = NSTextAlignmentLeft;
        
        [self.contentView addSubview:self.codeLab];
        
        self.creatLab = [[UILabel alloc] initWithFrame:CGRectMake(screenW-140, self.codeLab.frame.origin.y, 130, 20)];
        self.creatLab.textColor = [UIColor grayColor];
        self.creatLab.font = [UIFont systemFontOfSize:13];
        self.creatLab.textAlignment = NSTextAlignmentRight;
        
        [self.contentView addSubview:self.creatLab];
        
      
    }
    return self;

}

-(void)setModel:(personIdModel *)model{
    _model = model;
    
    self.label.text = model.UserName;
    NSLog(@"%@", model.UserName);
    self.creatLab.text = model.ModifyDate;
    if ([model.RecordType isEqualToString:@"2"]) {
        self.imgV.image = [UIImage imageNamed:@"passPort"];
        self.codeLab.text = model.PassportNum;
    }else if([model.RecordType isEqualToString:@"1"]){
        self.imgV.image = [UIImage imageNamed:@"IDInform"];
        self.codeLab.text = model.CardNum;
    }
}

//+(instancetype)relationHistoryXib{
//    return [[[NSBundle mainBundle] loadNibNamed:@"QRHistoryViewController" owner:nil options:nil] lastObject];
//}

@end
