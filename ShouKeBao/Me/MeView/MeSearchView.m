//
//  MeSearchView.m
//  ShouKeBao
//
//  Created by 张正梅 on 15/10/23.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "MeSearchView.h"
#import "WriteFileManager.h"
#import "NSArray+QD.h"
@interface MeSearchView() <UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
//我的分享
@property (nonatomic,strong) NSMutableArray *meSearchArr;
@property (nonatomic,weak) UIButton *clearBtn;
@end
@implementation MeSearchView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.meSearchTableView];
        UIButton *clear = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _meSearchTableView.frame.size.width, 44)];
        clear.backgroundColor = [UIColor whiteColor];
        clear.hidden = YES;
        clear.titleLabel.font = [UIFont systemFontOfSize:15];
        [clear setTitle:@"清除历史记录" forState:UIControlStateNormal];
        [clear setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [clear addTarget:self action:@selector(clearMeSearch:) forControlEvents:UIControlEventTouchUpInside];
        self.meSearchTableView.tableFooterView = clear;
        self.clearBtn = clear;
    }
    return self;
}

- (UITableView *)meSearchTableView{
    if (!_meSearchTableView) {
        _meSearchTableView = [[UITableView alloc] initWithFrame:CGRectMake(15, 0, self.frame.size.width - 30, self.frame.size.height - 10) style:UITableViewStyleGrouped];
        _meSearchTableView.tag = 1001;
        _meSearchTableView.dataSource = self;
        _meSearchTableView.delegate = self;
        _meSearchTableView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:241/255.0 alpha:1];
    }
    return _meSearchTableView;
}

- (NSMutableArray *)meSearchArr{
    if (!_meSearchArr) {
        NSArray *arr = [WriteFileManager readFielWithName:@"MeShareSearch"];
        NSArray *repeatNo = [NSArray arrayWithMemberIsOnly:arr];
        _meSearchArr = [NSMutableArray arrayWithArray:repeatNo];
    }
    return _meSearchArr;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.meSearchArr.count) {
        self.clearBtn.hidden = NO;
    }
    return self.meSearchArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"historyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    cell.textLabel.text = [self.meSearchArr objectAtIndex:[self.meSearchArr count]-(indexPath.row + 1)];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"MeShareSearch" object:nil userInfo:@{@"searchKey": cell.textLabel.text}];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, tableView.frame.size.width, 20)];
    title.text = @"历史搜索";
    title.textColor = [UIColor lightGrayColor];
    title.font = [UIFont systemFontOfSize:15];
    [cover addSubview:title];
    
    return cover;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.window endEditing:YES];
}

- (void)clearMeSearch:(UIButton *)btn
{
    [self.meSearchArr removeAllObjects];
    [WriteFileManager saveFileWithArray:self.meSearchArr Name:@"MeShareSearch"];
    [self.meSearchTableView reloadData];
    self.clearBtn.hidden = YES;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}








/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
