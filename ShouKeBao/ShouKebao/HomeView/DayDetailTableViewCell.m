//
//  DayDetailTableViewCell.m
//  ShouKeBao
//
//  Created by 冯坤 on 15/10/26.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "DayDetailTableViewCell.h"
#import "DayDetail.h"
@implementation DayDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *cellID = @"DayDetailTableviewCell";
    DayDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DayDetailTableviewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}
- (IBAction)shareClick:(id)sender {
    
    
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
