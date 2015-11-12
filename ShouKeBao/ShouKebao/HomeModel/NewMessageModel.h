//
//  NewMessageModel.h
//  ShouKeBao
//
//  Created by 韩世民 on 15/11/12.
//  Copyright © 2015年 shouKeBao. All rights reserved.
//

#import "BaseModel.h"
#import <Foundation/Foundation.h>
@interface NewMessageModel : BaseModel
@property (nonatomic,copy) NSString *TitleLabel;
@property (nonatomic,copy) NSString *bodyLabel;
@property (nonatomic, copy) NSString *ID;//产品ID(用于收藏)
@property (nonatomic, copy) NSString *Code;//产品编号
@property (nonatomic, copy) NSString *PersonPrice;//门市价
@property (nonatomic, copy) NSString *PersonPeerPrice;//同行价
@property (nonatomic, copy) NSString *PersonProfit;//利润
@property (nonatomic, copy) NSString *PersonBackPrice;//加返
@property (copy , nonatomic) NSString *IsComfirmStockNow;//是否闪电发班
@property (nonatomic, copy) NSString *PicUrl;

@end
