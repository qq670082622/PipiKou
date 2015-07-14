//
//  DressView.m
//  ShouKeBao
//
//  Created by Chard on 15/3/26.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "DressView.h"
#import "DressFooter.h"
#import "BaseClickAttribute.h"
#import "MobClick.h"
@interface DressView() <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSArray *dataSource;

@end

@implementation DressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.tableView];
        self.goDateText = @"不限";
        self.createDateText = @"不限";
        
        [self setHeader];
        
        [self setFooter];
    }
    return self;
}

#pragma mark - getter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 50;
    }
    return _tableView;
}

- (NSArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = @[@[@"出发日期",@"大区",@"线路区域",@"国家/地区"],@[@"下单时间"]];
    }
    return _dataSource;
}

#pragma mark - private
- (void)setHeader
{
    UIView *cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 60)];
//    引入Xib
    UIView *header = [[[NSBundle mainBundle] loadNibNamed:@"DressHeader" owner:nil options:nil] lastObject];
    header.frame = CGRectMake(0, 0, self.bounds.size.width, 50);
    [cover addSubview:header];
    
    self.tableView.tableHeaderView = cover;
}

- (void)setFooter
{
    UIView *cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 60)];
    
    DressFooter *footer = [[[NSBundle mainBundle] loadNibNamed:@"DressFooter" owner:nil options:nil] lastObject];
    footer.frame = CGRectMake(0, 10, self.bounds.size.width, 50);
    [cover addSubview:footer];
    self.IsRefund = footer.isRefund;
    
    self.tableView.tableFooterView = footer;
}

// 返回
- (IBAction)back:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DressViewClickBack" object:nil];
}

// 重置
- (IBAction)reset:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DressViewClickReset" object:nil];
}

// 确定
- (IBAction)confirm:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DressViewClickConfirm" object:nil];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"orderdresscell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    }
    
    cell.textLabel.text = self.dataSource[indexPath.section][indexPath.row];
    if ((indexPath.section == 0 || indexPath.section == 1) && indexPath.row == 0) {
        if (indexPath.section == 0) {
            cell.detailTextLabel.text = self.goDateText;
            if (![self.goDateText isEqualToString:@"不限"]) {
                cell.detailTextLabel.textColor = [UIColor orangeColor];
            }else{
                cell.detailTextLabel.textColor = [UIColor grayColor];
            }
        }else{
            if (![self.createDateText isEqualToString:@"不限"]) {
                cell.detailTextLabel.textColor = [UIColor orangeColor];
            }else{
                cell.detailTextLabel.textColor = [UIColor grayColor];
            }
            cell.detailTextLabel.text = self.createDateText;
        }
        
    }else{
        switch (indexPath.row) {
            case 1:{
                if (!self.firstText.length) {
                    self.firstText = @"全部";
                }
                if (![self.firstText isEqualToString:@"全部"]) {
                    cell.detailTextLabel.textColor = [UIColor orangeColor];
                }else{
                    cell.detailTextLabel.textColor = [UIColor grayColor];

                }
                cell.detailTextLabel.text = self.firstText;
                break;
            }
            case 2:{
                if ([self.firstText isEqualToString:@"全部"]) {
                    cell.textLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
                }else{
                    cell.textLabel.textColor = [UIColor blackColor];
                }
                if (![self.secondText isEqualToString:@""]) {
                    cell.detailTextLabel.textColor = [UIColor orangeColor];
                }else{
                    cell.detailTextLabel.textColor = [UIColor grayColor];

                }
                cell.detailTextLabel.text = self.secondText;
                break;
            }
            case 3:{
                if (!self.secondText.length) {
                    cell.textLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
                }else{
                    cell.textLabel.textColor = [UIColor blackColor];
                }
                if (![self.secondText isEqualToString:@""]) {
                    cell.detailTextLabel.textColor = [UIColor orangeColor];
                }else{
                    cell.detailTextLabel.textColor = [UIColor grayColor];

                }
                cell.detailTextLabel.text = self.thirdText;
                break;
            }
            default:
                break;
        }
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ((indexPath.section == 0 || indexPath.section == 1) && indexPath.row == 0){
        timeType type = 0;
        switch (indexPath.section) {
            case 0:{
                type = timePick;
                BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
                [MobClick event:@"OrderTimeSX" attributes:dict];
            }
                break;
            case 1:{
                type = datePick;
                BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
                [MobClick event:@"OrderDateSX" attributes:dict];

            }
                break;
            default:
                break;
        }
        
        if (_delegate && [_delegate respondsToSelector:@selector(didSelectedTimeWithType:)]) {
            [_delegate didSelectedTimeWithType:type];
        }
    }else{
        if (_delegate && [_delegate respondsToSelector:@selector(wantToPushAreaWithType:)]) {
            areaType type = 0;
            switch (indexPath.row) {
                case 1:{
                    type = firstArea;
                
                    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
                    [MobClick event:@"OrderAreaSX" attributes:dict];

                }
                    break;
                case 2:{
                    type = secondArea;
                    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
                    [MobClick event:@"OrderLineSX" attributes:dict];
                    }
                    break;
                case 3:{
                    type = thirdArea;
                    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
                    [MobClick event:@"OrderProvinceSX" attributes:dict];

                }
                    break;
                default:
                    break;
            }
            [_delegate wantToPushAreaWithType:type];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0f;
}

@end
