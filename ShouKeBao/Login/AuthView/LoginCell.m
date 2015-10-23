//
//  LoginCell.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/23.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "LoginCell.h"
#import "UIImage+QD.h"

@interface LoginCell()

@property (nonatomic,weak) UIImageView *inputBg;

@end

@implementation LoginCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"logincell";
    LoginCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[LoginCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    UIImageView *inputBg = [[UIImageView alloc] init];
    inputBg.image = [UIImage resizedImageWithName:@"bg_white"];
    [self.contentView addSubview:inputBg];
    self.inputBg = inputBg;
    
    UIImageView *icon = [[UIImageView alloc] init];
    [self.contentView addSubview:icon];
    self.icon = icon;
    
    UITextField *inputField = [[UITextField alloc] init];
    inputField.clearButtonMode = UITextFieldViewModeWhileEditing;
    inputField.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:inputField];
    self.inputField = inputField;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    
    CGFloat bgX = 15;
    self.inputBg.frame = CGRectMake(bgX, 7.5, screenW - 30, 50);
    
    self.icon.frame = CGRectMake(bgX + 10, 22.5, 18, 20);
    
    CGFloat fieldX = CGRectGetMaxX(self.icon.frame) + 10;
    CGFloat fieldW = screenW - fieldX - 15 - 10;
    self.inputField.frame = CGRectMake(fieldX, 17.5, fieldW, 30);
}

@end
