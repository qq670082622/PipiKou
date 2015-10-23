//
//  ShaiXuanCell.m
//  ShouKeBao
//
//  Created by 吴铭 on 15/8/17.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "ShaiXuanCell.h"
#define kScreenSize [UIScreen mainScreen].bounds.size
@implementation ShaiXuanCell

- (void)awakeFromNib {
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatUI];
    }
    return self;
}
-(void)creatUI{
    NameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, kScreenSize.width/3, 20)];
    NameLabel.text = @"";
    [self.contentView addSubview:NameLabel];
    
    CityLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenSize.width/2, 15, kScreenSize.width/3+20, 20)];
    CityLabel.text = @"";
    CityLabel.font = [UIFont systemFontOfSize:12];
    CityLabel.textAlignment = NSTextAlignmentRight;
    CityLabel.textColor = [UIColor orangeColor];
    
    [self.contentView addSubview:CityLabel];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenSize.width-30, 15,20, 20)];
    imageView.image = [UIImage imageNamed:@"xiangyou"];
    [self.contentView addSubview:imageView];
}
-(void)showdataWithString:(NSString *)nameStr{
    NameLabel.text = self.str;
    NSLog(@",,,,,,, %@", self.str);
    if ([self.contentStr isEqualToString:@"不限"]) {
        CityLabel.textColor = [UIColor lightGrayColor];
        CityLabel.text =  self.contentStr;
    }else{
        CityLabel.textColor = [UIColor orangeColor];
        CityLabel.text =  self.contentStr;
    }
    
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
