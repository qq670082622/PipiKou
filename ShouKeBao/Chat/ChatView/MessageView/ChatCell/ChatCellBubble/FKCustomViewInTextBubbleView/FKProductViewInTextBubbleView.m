//
//  FKProductViewInTextBubbleView.m
//  TravelConsultant
//
//  Created by 冯坤 on 15/11/12.
//  Copyright (c) 2015年 冯坤. All rights reserved.
//

#import "FKProductViewInTextBubbleView.h"
#import "UIImageView+EMWebCache.h"
@interface FKProductViewInTextBubbleView()
@property (nonatomic, strong)UILabel * nameLabel;
@property (nonatomic, strong)UILabel * dateLabel;
@property (nonatomic, strong)UILabel * productTitleLabel;
@property (nonatomic, strong)UIImageView * productImageView;

@property (nonatomic, strong)UILabel * productCodeLabel;
@property (nonatomic, strong)UILabel * exclusivePrice;

@end


@implementation FKProductViewInTextBubbleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpSubViewsWithFrame:frame];
    }
    return self;
}
- (void)setUpSubViewsWithFrame:(CGRect)frame{
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 3, frame.size.width, 20)];
    self.nameLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:self.nameLabel];
    
    UIView * upLine = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.nameLabel.frame)+5, frame.size.width, 0.5)];
    upLine.backgroundColor = [UIColor lightTextColor];
    [self addSubview:upLine];
    
    self.dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(upLine.frame), frame.size.width, 17)];
    self.dateLabel.textColor = [UIColor lightTextColor];
    self.dateLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.dateLabel];
    
    self.productTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.dateLabel.frame), frame.size.width, 36)];
    self.productTitleLabel.numberOfLines = 0;
    self.productTitleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.productTitleLabel];
    
    self.productImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.productTitleLabel.frame), frame.size.width, 150)];
    [self addSubview:self.productImageView];
    
    UIView * upViewInImage = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 17)];
    upViewInImage.backgroundColor =[UIColor blackColor];
    upViewInImage.alpha = 0.5;
    [self.productImageView addSubview:upViewInImage];
    
    self.productCodeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 17)];
    self.productCodeLabel.font = [UIFont systemFontOfSize:13];
    self.productCodeLabel.textColor = [UIColor whiteColor];
    [self.productImageView addSubview:self.productCodeLabel];
    
    UIView * downViewInImage = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.productImageView.frame)-25, frame.size.width, 25)];
    downViewInImage.backgroundColor =[UIColor blackColor];
    downViewInImage.alpha = 0.5;
    [self.productImageView addSubview:downViewInImage];
    
    self.exclusivePrice = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width-90, self.productImageView.frame.size.height-25, 90, 25)];
    self.exclusivePrice.font = [UIFont systemFontOfSize:16];
    self.exclusivePrice.textColor = [UIColor brownColor];
    [self.productImageView addSubview:self.exclusivePrice];
    
    UILabel * exclusivePriceLab = [[UILabel alloc]initWithFrame:CGRectMake(0, self.productImageView.frame.size.height-25, frame.size.width-90, 25)];
    exclusivePriceLab.font = [UIFont systemFontOfSize:15];
    exclusivePriceLab.textColor = [UIColor whiteColor];
    exclusivePriceLab.textAlignment = NSTextAlignmentRight;
    exclusivePriceLab.text = @"专属价：";
    [self.productImageView addSubview:exclusivePriceLab];
    
    UIView * downLine = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.productImageView.frame)+7, frame.size.width, 0.5)];
    downLine.backgroundColor = [UIColor lightTextColor];
    [self addSubview:downLine];
    
    UILabel * showMoreProduct = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(downLine.frame)+7, frame.size.width, 20)];
    showMoreProduct.font = [UIFont systemFontOfSize:15];
    showMoreProduct.textColor = [UIColor grayColor];
    showMoreProduct.text = @"点击查看更多产品";
    [self addSubview:showMoreProduct];
    
    UILabel * arrawLab = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width - 50, 0, 50, 20)];
    arrawLab.textColor = [UIColor grayColor];
    arrawLab.text = @"〉";
    arrawLab.font = [UIFont systemFontOfSize:20];
    arrawLab.textAlignment = NSTextAlignmentRight;
    [showMoreProduct addSubview:arrawLab];
    
}
+ (FKProductViewInTextBubbleView *)FKProductViewWithModel:(FKProductModel *)model
                                                 andFrame:(CGRect)frame{
    FKProductViewInTextBubbleView * FKV = [[FKProductViewInTextBubbleView alloc]initWithFrame:frame];
    //根据model传进来值进行赋值
    [FKV.productImageView sd_setImageWithURL:[NSURL URLWithString:model.productImageUrl] placeholderImage:nil];
    FKV.nameLabel.text = model.productName;
    return FKV;
}


@end
