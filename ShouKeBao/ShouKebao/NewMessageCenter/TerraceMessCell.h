//
//  TerraceMessCell.h
//  ShouKeBao
//
//  Created by 韩世民 on 15/11/12.
//  Copyright © 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TerraceMessageModel;
@interface TerraceMessCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *Imageview;
@property (weak, nonatomic) IBOutlet UILabel *DataLabel;
@property (weak, nonatomic) IBOutlet UILabel *BodyLabel;
@property (nonatomic, strong)TerraceMessageModel * model;
@end
