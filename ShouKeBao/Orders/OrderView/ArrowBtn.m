//
//  ArrowBtn.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/17.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "ArrowBtn.h"
#import "NSString+QD.h"

@interface ArrowBtn()

@property (nonatomic,weak) UILabel *title;

@property (nonatomic,weak) UIImageView *icon;

@end

@implementation ArrowBtn

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *title = [[UILabel alloc] init];
        title.font = [UIFont systemFontOfSize:15];
        [self addSubview:title];
        self.title = title;
        
        UIImageView *icon = [[UIImageView alloc] init];
        icon.image = [UIImage imageNamed:@"xiangxia"];
        [self addSubview:icon];
        self.icon = icon;
    }
    return self;
}
-(void)setIconImage:(UIImage *)iconImage{
    _iconImage = iconImage;
    self.icon.image = iconImage;
}
-(void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
    self.title.textColor = textColor;
}
- (void)setText:(NSString *)text
{
    _text = text;
    
    self.title.text = text;
    
    CGSize maxSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
    CGSize titleSize = [NSString textSizeWithText:text font:[UIFont systemFontOfSize:16] maxSize:maxSize];
    CGFloat titleX = (self.frame.size.width - titleSize.width) * 0.5;
    CGFloat titleY = (self.frame.size.height - titleSize.height) * 0.5;
    self.title.frame = CGRectMake(titleX, titleY, titleSize.width, titleSize.height);
    
    CGFloat iconX = CGRectGetMaxX(self.title.frame) + 2;
    CGFloat iconY = (self.frame.size.height - 10) * 0.5;
    self.icon.frame = CGRectMake(iconX, iconY, 10, 10);
}

@end
