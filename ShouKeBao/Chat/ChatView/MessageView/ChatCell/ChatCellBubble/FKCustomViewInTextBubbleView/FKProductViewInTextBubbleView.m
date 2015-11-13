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
@property (nonatomic, strong)UIImageView * productImageView;
@property (nonatomic, strong)UILabel * nameLabel;
@end


@implementation FKProductViewInTextBubbleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 20)];
        [self addSubview:self.nameLabel];
        
        self.productImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.nameLabel.frame), frame.size.width, frame.size.height - CGRectGetHeight(self.nameLabel.frame))];
        [self addSubview:self.productImageView];
    }
    return self;
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
