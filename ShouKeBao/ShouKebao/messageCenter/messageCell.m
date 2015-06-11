//
//  messageCell.m
//  ShouKeBao
//
//  Created by 吴铭 on 15/4/3.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "messageCell.h"
#import "NSDate+Category.h"
#import "WriteFileManager.h"
@implementation messageCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+(instancetype)cellWithTableView:(UITableView *)tableView
{ static NSString *cellID = @"messageCell";
    messageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"messageCell" owner:nil options:nil] lastObject];
     cell.selectionStyle = UITableViewCellSelectionStyleNone;   
    }
    return cell;
}

-(void)setModel:(messageModel *)model
{
   
    _model = model;
    self.title.text = model.title;
    

    NSDate *createDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:[model.CreatedDate doubleValue]];
    self.time.text = [createDate formattedTime];
   
    [self.isReadArr addObjectsFromArray:[WriteFileManager readData:@"messageRead"]];
    if (![_isReadArr containsObject:model.ID]) {
        self.hongdian.hidden = NO;
    }
    
}
-(NSMutableArray *)isReadArr
{
    if (_isReadArr == nil) {
        self.isReadArr = [NSMutableArray array];
        }
    return _isReadArr;
}
@end
