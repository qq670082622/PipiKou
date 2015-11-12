//
//  DayDetailTableViewCell.m
//  ShouKeBao
//
//  Created by 冯坤 on 15/10/26.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "DayDetailTableViewCell.h"
#import "DayDetail.h"
#import "UIImageView+LBBlurredImage.h"

@implementation DayDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.descripBtn addTarget:self action:@selector(changeTheRowHeight:) forControlEvents:UIControlEventTouchUpInside];

    self.gaosiImage.image = [UIImage imageNamed:@"gaosimohu"];
    self.gaosiImage.alpha = 0.85;
    self.gaosiImage.contentMode = UIViewContentModeScaleToFill;
    self.gaosiImage.backgroundColor = [UIColor lightGrayColor];
    [self.gaosiImage setImageToBlur:[UIImage imageNamed:@"bg_nav"] blurRadius:kLBBlurredImageDefaultBlurRadius completionBlock:nil];
    [self.backgoundView sendSubviewToBack:self.gaosiImage];
    [self.backgoundView sendSubviewToBack:self.productImage];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *cellID = @"DayDetailTableviewCell";
    DayDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DayDetailTableViewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}
- (IBAction)shareClick:(id)sender {
    
    
}
- (void)changeTheRowHeight:(UIButton *)btn{
    self.isPlain = !self.isPlain;
    btn.selected = !btn.selected;
}
-(void)setDetail:(DayDetail *)detail{
    _detail = detail;
}
//高斯模糊实现
//CIContext *context = [CIContext contextWithOptions:nil];
//CIImage *image = [CIImage imageWithContentsOfURL:imageURL];
//CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
//[filter setValue:image forKey:kCIInputImageKey];
//[filter setValue:@2.0f forKey: @"inputRadius"];
//CIImage *result = [filter valueForKey:kCIOutputImageKey];
//CGImageRef outImage = [context createCGImage: result fromRect:[result extent]];
//UIImage * blurImage = [UIImage imageWithCGImage:outImage];
@end
