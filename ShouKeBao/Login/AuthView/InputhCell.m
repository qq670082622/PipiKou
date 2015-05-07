//
//  InputhCell.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/5/5.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "InputhCell.h"

@implementation InputhCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"logincell";
    InputhCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[InputhCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
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
    
    
    CGFloat inputX = 100;
    CGFloat inputW = screenW - inputX - 10;
    self.inputField.frame = CGRectMake(inputX, 10, inputW, 30);
    
    CGRect rect = self.detailTextLabel.frame;
    rect.origin.x = 100;
    self.detailTextLabel.frame = rect;
}

@end
