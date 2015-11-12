//
//  FKProductViewInTextBubbleView.h
//  TravelConsultant
//
//  Created by 冯坤 on 15/11/12.
//  Copyright (c) 2015年 冯坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FKProductModel.h"
@interface FKProductViewInTextBubbleView : UIView



+ (FKProductViewInTextBubbleView *)FKProductViewWithModel:(FKProductModel *)model
                                                 andFrame:(CGRect)frame;

@end
