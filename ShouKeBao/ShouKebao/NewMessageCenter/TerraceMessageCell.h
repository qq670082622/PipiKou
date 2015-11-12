//
//  TerraceMessageCell.h
//  ShouKeBao
//
//  Created by 韩世民 on 15/11/10.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TerraceMessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *DataLabel;
@property (weak, nonatomic) IBOutlet UIImageView *Imageview;
- (IBAction)DetailBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *Bodylabel;

@end
