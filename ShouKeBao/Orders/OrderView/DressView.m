//
//  DressView.m
//  ShouKeBao
//
//  Created by Chard on 15/3/26.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "DressView.h"


@interface DressView() <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSArray *dataSource;

@end

@implementation DressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.tableView];
        
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
        _dataSource = @[@[@"出发日期",@"大区",@"线路区域",@"国家/省份"],@[@"下单时间"]];
    }
    return _dataSource;
}

#pragma mark - private
- (void)setHeader
{
    UIView *cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 80)];
    
    UIView *header = [[[NSBundle mainBundle] loadNibNamed:@"DressHeader" owner:nil options:nil] lastObject];
    header.frame = CGRectMake(0, 20, self.bounds.size.width, 50);
    [cover addSubview:header];
    
    self.tableView.tableHeaderView = cover;
}

- (void)setFooter
{
    UIView *cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 60)];
    
    UIView *footer = [[[NSBundle mainBundle] loadNibNamed:@"DressFooter" owner:nil options:nil] lastObject];
    footer.frame = CGRectMake(0, 10, self.bounds.size.width, 50);
    [cover addSubview:footer];
    
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
    }
    
    cell.textLabel.text = self.dataSource[indexPath.section][indexPath.row];
    if ((indexPath.section == 0 || indexPath.section == 1) && indexPath.row == 0) {
        cell.detailTextLabel.text = @"不限";
    }else{
        switch (indexPath.row) {
            case 1:{
                cell.detailTextLabel.text = self.firstText;
                break;
            }
            case 2:{
                cell.detailTextLabel.text = self.secondText;
                break;
            }
            case 3:{
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
            case 0:
                type = timePick;
                break;
            case 1:
                type = datePick;
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
                case 1:
                    type = firstArea;
                    break;
                case 2:
                    type = secondArea;
                    break;
                case 3:
                    type = thirdArea;
                    break;
                default:
                    break;
            }
            [_delegate wantToPushAreaWithType:type];
        }
    }
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
