//
//  NewMessageCenterController.m
//  ShouKeBao
//
//  Created by 韩世民 on 15/11/6.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "NewMessageCenterController.h"
#import "NewMessageCell.h"
#import "TerraceMessageController.h"
#import "ZhiVisitorDynamicController.h"
#import "ChatListCell.h"
#define kScreenSize [UIScreen mainScreen].bounds.size
@interface NewMessageCenterController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property (nonatomic,strong) NSArray *NameArr;
@property (nonatomic,strong) NSArray *TimedataArr;
@property (nonatomic,strong) UIView *searchView;
@property (nonatomic,strong) NSMutableArray *NamedataArr;//存放网络数据
@property (nonatomic,strong) NSMutableArray *LocDataArr;//本地的搜索记录
@property (nonatomic,strong) NSMutableArray *searchDataArr;//服务器返回的数据
@property (nonatomic,strong) UITableView *SearTableView;
@property (nonatomic,strong) UIButton *cancalBtn;//自定义的取消button
@end

@implementation NewMessageCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"IM";
    _TimedataArr = @[@"09:25",@"11:11",@"13:50",@"18:12",@"23:13"];//测试数据
    
    
    _tableView.tableFooterView = [[UIView alloc] init];
    //[_tableView registerClass:[ChatListCell class] forCellReuseIdentifier:@"ChatListCell"];
}
#pragma mark - UITableViewDelegate&DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView.tag == 2011) {
        return 2;
    }
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 2011) {
        if (section == 0) {
            return 2;
        }
        return self.NamedataArr.count;
    }
//    return self.searchDataArr.count;
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView.tag == 2011) {
        if (section == 0) {
            return 0;
        }
        return 20;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   if (tableView.tag == 2011) {
        return 60;
    }
    return 50;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView.tag == 2011) {
        if (section == 0) {
            return 0;
        }
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 20)];
        headView.backgroundColor = [UIColor colorWithRed:(241.0/255.0) green:(242.0/255.0) blue:(244.0/255.0) alpha:1];
        return headView;
    }
    return nil;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 2011) {
        ChatListCell *cell = [[ChatListCell alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 60)];
        if (indexPath.section == 0) {
            cell.name = self.NameArr[indexPath.row];
            cell.detailMsg = @"收到消息";
        }else{
            cell.name = self.NamedataArr[indexPath.row];
        }
        cell.detailMsg = @"收到消息";
        cell.time = @"12.01";
        return cell;
    }
    NSLog(@"-----%ld",tableView.tag);
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 50)];
    cell.textLabel.text = @"这是一个测试";
    return cell;
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 2011) {
        return YES;
    }
    return NO;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView.tag == 2011) {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                TerraceMessageController *Terr = [[TerraceMessageController alloc] init];
                [self.navigationController pushViewController:Terr animated:YES];
            }else{
                ZhiVisitorDynamicController *zhiVisit = [[ZhiVisitorDynamicController alloc] init];
                [self.navigationController pushViewController:zhiVisit animated:YES];
            }
        }else{
            NSLog(@"我要往IM跳了,别拦我");
        }
    }else if(tableView.tag == 2012){
        NSLog(@"这是搜索的内容测试");
    }
    
   
}
#warning 下边这个方法需要修改
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 2011) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            // CustomModel *model = _dataArr[indexPath.row];
            //[self deleteTableViewCellwithId:model.ID];
            // 删除这行
            //[self.NamedataArr removeObjectAtIndex:indexPath.row];
            [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
   
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 2011) {
        UITableViewRowAction *toTop = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            NSLog(@"删除%ld,%ld",indexPath.section,indexPath.row);
            [tableView setEditing:NO animated:YES];
        }];
        toTop.backgroundColor =[UIColor redColor];
        UITableViewRowAction *toTop1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"标记未读" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            NSLog(@"标记未读%ld,%ld",indexPath.section,indexPath.row);
            [tableView setEditing:NO animated:YES];
        }];
        toTop1.backgroundColor =[UIColor lightGrayColor];
        return @[toTop,toTop1];
    }
    return nil;
}
#pragma mark - UISearchBarDelegate
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [_SearchBar setShowsCancelButton:NO];
    self.navigationController.navigationBarHidden=YES;

    searchBar.frame = CGRectMake(0, 20, kScreenSize.width-50, 44);
    
    for(id cc in [searchBar.subviews[0] subviews])
    {
        if([cc isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)cc;
            [btn setTitleColor:[UIColor colorWithRed:68/255.0 green:122/255.0 blue:208/255.0 alpha:1] forState:UIControlStateNormal];
        }
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.searchView addSubview:self.SearTableView];
    [self.view addSubview:self.cancalBtn];
    [self.view.superview addSubview:self.searchView];

    return YES;
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    for (UIView *searchbuttons in [[searchBar.subviews objectAtIndex:0] subviews])
    {
        if ([searchbuttons isKindOfClass:[UIButton class]])
        {
            UIButton *cancelButton = (UIButton *)searchbuttons;
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"取消"];
            NSMutableDictionary *muta = [NSMutableDictionary dictionary];
            [muta setObject:[UIColor colorWithRed:68/255.0 green:122/255.0 blue:208/255.0 alpha:1] forKey:NSForegroundColorAttributeName];
            [muta setObject:[UIFont systemFontOfSize:13] forKey:NSFontAttributeName];
            [attr addAttributes:muta range:NSMakeRange(0, 2)];
            [cancelButton setAttributedTitle:attr forState:UIControlStateNormal];
        }
    }
}
//实时下载 走下面方法
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"正在下载，更新数据");
    
}

-(UIView *)searchView{
    if (!_searchView) {
        _searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreenSize.width, kScreenSize.height-64)];
        _searchView.backgroundColor = [UIColor whiteColor];
    }
    return _searchView;
}
-(NSArray *)NameArr{
    if (!_NameArr) {
        _NameArr = [[NSArray alloc] initWithObjects:@"平台消息",@"直客动态", nil];
    }
    return _NameArr;
}
-(NSMutableArray *)NamedataArr{
    if (!_NamedataArr) {
        _NamedataArr = [[NSMutableArray alloc] initWithObjects:@"预谋",@"了好久",@"贺成祥", nil];
    }
    return _NamedataArr;
}
-(UIButton *)cancalBtn{
    if (!_cancalBtn) {
        _cancalBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenSize.width - 50, 20, 50, 44)];
        //_cancalBtn.backgroundColor = [UIColor colorWithRed:(232.0/225.0) green:(233.0/255.0) blue:(234.0/255.0) alpha:1];
        [_cancalBtn setBackgroundColor:[UIColor colorWithRed:232/255.0 green:234/255.0 blue:235.0/255.0 alpha:1]];
        [_cancalBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cancalBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_cancalBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_cancalBtn addTarget:self action:@selector(BtnClickdasf) forControlEvents:UIControlEventTouchUpInside];
        
        //加一块黑边
        UIView *blackBound = [[UIView alloc] initWithFrame:CGRectMake(0,43.5, 50, 0.5)];
        blackBound.backgroundColor = [UIColor colorWithRed:(80.0/255.0) green:(81.0/255.0) blue:(81.0/255.0) alpha:1];
        [_cancalBtn addSubview:blackBound];
    }
    return _cancalBtn;
}
-(void)BtnClickdasf{
    NSLog(@"正在点击");
    _SearchBar.text = @"";
    self.navigationController.navigationBarHidden=NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    _SearchBar.frame = CGRectMake(0, 0, kScreenSize.width, 44);
    [self.searchView removeFromSuperview];
    [_SearchBar setShowsCancelButton:NO];
    [_SearchBar resignFirstResponder];
    [_cancalBtn removeFromSuperview];
}
-(UITableView *)SearTableView{
    if (!_SearTableView) {
        _SearTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height-64) style:UITableViewStylePlain];
        _SearTableView.tag = 2012;
        _SearTableView.delegate = self;
        _SearTableView.dataSource = self;
//        _SearTableView.tableFooterView = [[UIView alloc]init];
    }
    return _SearTableView;
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"开始滚动了");
    [_SearchBar resignFirstResponder];
    
    for(id control in [_SearchBar subviews])
    {
        NSLog(@"%@",control);
        
            UIButton * btn =(UIButton *)control;
            btn.enabled=YES;
    }

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"点击搜索了");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
