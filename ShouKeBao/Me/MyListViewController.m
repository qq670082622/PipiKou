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

@interface MyListViewController ()<MGSwipeTableCellDelegate>

@property (nonatomic,strong) NSMutableArray *dataSource;

@end

@implementation MyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadDataSource];
}

#pragma mark - loadDataSource
- (void)loadDataSource
{
    NSDictionary *param = @{};
    if (self.listType == collectionType) {
        [MeHttpTool getFavoritesProductListWithParam:param success:^(id json) {
            if (json) {
                NSLog(@"-----%@",json);
            }
        } failure:^(NSError *error) {
            
        }];
    }else{
        [MeHttpTool getHistoryProductListWithParam:param success:^(id json) {
            if (json) {
                NSLog(@"-----%@",json);
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
// 右边滑动的按钮
- (NSArray *)createRightButtons:(ProductModal *)model
{
    NSMutableArray * result = [NSMutableArray array];
    NSString *add = [NSString stringWithFormat:@"最近班期:%@\n\n供应商:%@",model.LastScheduleDate,model.SupplierName];
    NSString* titles[2] = {@"", add};
    UIColor * colors[2] = {[UIColor clearColor], [UIColor lightGrayColor]};
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
        button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        CGRect frame = button.frame;
        frame.size.width = i == 1 ? 200 : 50;
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
//    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
//    NSLog(@"------%@",indexPath);
//    
//    ProductModal *model = self.dataSource[indexPath.row];
//    NSString *result = [model.IsFavorites isEqualToString:@"0"]?@"1":@"0";
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    [dic setObject:model.ID forKey:@"ProductID"];
//    [dic setObject:result forKey:@"IsFavorites"];///Product/ SetProductFavorites
    
    return YES;
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductCell *cell = [ProductCell cellWithTableView:tableView];
    cell.delegate = self;
    
    cell.rightSwipeSettings.transition = MGSwipeTransitionStatic;
    
//    cell.rightButtons = [self createRightButtons:model];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

@end
