//
//  MyListViewController.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/1.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "MyListViewController.h"
#import "ProductCell.h"
#import "MGSwipeButton.h"
#import "MeHttpTool.h"
#import "MJRefresh.h"
#import "ProductModal.h"
#import "ProductHistoryCell.h"
#import "MBProgressHUD+MJ.h"
#import "ProduceDetailViewController.h"
#import "MobClick.h"
#define pageSize 10

@interface MyListViewController ()<MGSwipeTableCellDelegate>

@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,assign) NSInteger pageIndex;

@property (nonatomic,copy) NSString *totalCount;

@end

@implementation MyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.rowHeight = 160;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self iniHeader];
    
    [self setNav];
    
    [self.tableView headerBeginRefreshing];
}
-(void)viewWillAppear:(BOOL)animated
{
    [MobClick beginLogPageView:@"MeMyFavoritesView"];
    [super viewWillAppear:animated];
  
}
-(void)viewWillDisappear:(BOOL)animated
{
    [MobClick endLogPageView:@"MeMyFavoritesView"];
    [super viewWillDisappear:animated];
   
}
#pragma mark - loadDataSource
- (void)loadDataSource
{
    NSDictionary *param = @{@"PageSize":[NSString stringWithFormat:@"%d",pageSize],
                            @"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.pageIndex]};
    if (self.listType == collectionType) {
        self.title = @"我的收藏";
        [MeHttpTool getFavoritesProductListWithParam:param success:^(id json) {
            [self.tableView headerEndRefreshing];
            [self.tableView footerEndRefreshing];
            if (json) {
                NSLog(@"-----%@",json);
                self.totalCount = json[@"TotalCount"];
                if (self.pageIndex == 1) {
                    [self.dataSource removeAllObjects];
                }
                for (NSDictionary *dic in json[@"ProductList"]) {
                    ProductModal *model = [ProductModal modalWithDict:dic];
                    [self.dataSource addObject:model];
                }
                [self.tableView reloadData];
            }
        } failure:^(NSError *error) {
            
        }];
    }else{
        self.title = @"客户最近浏览";
        [MeHttpTool getHistoryProductListWithParam:param success:^(id json) {
            [self.tableView headerEndRefreshing];
            [self.tableView footerEndRefreshing];
            if (json) {
                NSLog(@"-----%@",json);
                self.totalCount = json[@"TotalCount"];
                if (self.pageIndex == 1) {
                    [self.dataSource removeAllObjects];
                }
                for (NSDictionary *dic in json[@"ProductList"]) {
                    ProductModal *model = [ProductModal modalWithDict:dic];
                    [self.dataSource addObject:model];
                }
                [self.tableView reloadData];
            }
        } failure:^(NSError *error) {
            
        }];
    }
}

#pragma mark - getter
- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

#pragma mark - private
- (void)setNav
{
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,20,20)];
    
    [leftBtn setImage:[UIImage imageNamed:@"backarrow"] forState:UIControlStateNormal];
    
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    self.navigationItem.leftBarButtonItem= leftItem;
}

-(void)back
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)getEndPage
{
    NSInteger cos = [self.totalCount integerValue] % pageSize;
    if (cos == 0) {
        return [self.totalCount integerValue] / pageSize;
    }else{
        return [self.totalCount integerValue] / pageSize + 1;
    }
}

-(void)iniHeader
{    //下啦刷新
    [self.tableView addHeaderWithTarget:self action:@selector(headRefresh) dateKey:nil];
    
    //上啦刷新
    [self.tableView addFooterWithTarget:self action:@selector(footRefresh)];
    
    //设置文字
    self.tableView.headerPullToRefreshText = @"下拉刷新";
    self.tableView.headerRefreshingText = @"正在刷新中";
    
    self.tableView.footerPullToRefreshText = @"上拉刷新";
    self.tableView.footerRefreshingText = @"正在刷新";
}

-(void)headRefresh
{
    self.pageIndex = 1;
    [self loadDataSource];
}

-(void)footRefresh
{
    self.pageIndex ++;
    if (self.pageIndex < [self getEndPage]) {
        [self loadDataSource];
    }else{
        [self.tableView footerEndRefreshing];
    }
}



// 右边滑动的按钮
- (NSArray *)createRightButtons:(ProductModal *)model
{
    NSMutableArray * result = [NSMutableArray array];
    NSString *add = [NSString stringWithFormat:@"最近班期:%@\n\n供应商:%@",model.LastScheduleDate,model.SupplierName];
    NSString* titles[2] = {@"", add};
    UIColor * colors[2] = {[UIColor clearColor], [UIColor colorWithRed:232/255.0 green:234/255.0 blue:235/255.0 alpha:1]};
    for (int i = 0; i < 2; i ++)
    {
        MGSwipeButton *button = [MGSwipeButton buttonWithTitle:titles[i] backgroundColor:colors[i] callback:^BOOL(MGSwipeTableCell * sender){
            NSLog(@"Convenience callback received (right). %d",i);
            return YES;
        }];
        
        if (i == 0) {
            NSString *img = [model.IsFavorites isEqualToString:@"1"] ? @"uncollection_icon" : @"collection_icon";
            [button setBackgroundImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
        }else{
            button.titleLabel.numberOfLines = 0;
            button.enabled = NO;
        }
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button setTitleColor:[UIColor colorWithRed:3/255.0 green:3/255.0 blue:3/255.0 alpha:1] forState:UIControlStateNormal];
        CGRect frame = button.frame;
        CGFloat cancelW = self.listType == collectionType ? 42 : 47;
        frame.size.width = i == 1 ? 200 : cancelW;
        button.frame = frame;
        
        [result addObject:button];
    }
    return result;
}

#pragma mark - MGSwipeTableCellDelegate
- (BOOL)swipeTableCell:(MGSwipeTableCell *)cell canSwipe:(MGSwipeDirection)direction
{
    return YES;
}

- (NSArray *)swipeTableCell:(MGSwipeTableCell *)cell swipeButtonsForDirection:(MGSwipeDirection)direction swipeSettings:(MGSwipeSettings *)swipeSettings expansionSettings:(MGSwipeExpansionSettings *)expansionSettings
{
    return [NSArray array];
}

// 收藏按钮点击
- (BOOL)swipeTableCell:(MGSwipeTableCell *)cell tappedButtonAtIndex:(NSInteger)index direction:(MGSwipeDirection)direction fromExpansion:(BOOL)fromExpansion
{
    
   
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];

    ProductModal *model = self.dataSource[indexPath.row];
    NSDictionary *param = @{@"ProductID":model.ID,
                            @"IsFavorites":[NSString stringWithFormat:@"%d",![model.IsFavorites integerValue]]};
    [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    [MeHttpTool cancelFavouriteWithParam:param success:^(id json) {
        NSLog(@"-----%@",json);
        [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
        if ([json[@"IsSuccess"] integerValue] == 1) {
            
            if (self.listType == collectionType) {
                [self.dataSource removeObjectAtIndex:indexPath.row];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            }else{
                model.IsFavorites = [NSString stringWithFormat:@"%d",![model.IsFavorites integerValue]];
                [self.dataSource replaceObjectAtIndex:indexPath.row withObject:model];
                [self.tableView reloadData];
            }
        }else{
            [MBProgressHUD showError:json[@"ErrorMsg"]];
        }
    } failure:^(NSError *error) {
        
    }];
    
    return YES;
}



#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductCell *cell = [ProductCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.delegate = self;
    
    cell.isHistory = self.listType == collectionType ? NO : YES;
    ProductModal *model = self.dataSource[indexPath.row];
    cell.modal = model;
    
    cell.rightSwipeSettings.transition = MGSwipeTransitionStatic;
    cell.rightButtons = [self createRightButtons:model];
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductModal *model = self.dataSource[indexPath.row];
    
    ProduceDetailViewController *detail = [[ProduceDetailViewController alloc] init];
    detail.produceUrl = model.LinkUrl;
    detail.productName = model.Name;
    [self.navigationController pushViewController:detail animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.listType == collectionType) {
        return 140;
    }else{
        return 170;
    }
}

@end
