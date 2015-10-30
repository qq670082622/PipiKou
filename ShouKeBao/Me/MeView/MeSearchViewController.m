//
//  MeSearchViewController.m
//  ShouKeBao
//
//  Created by 张正梅 on 15/10/22.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "MeSearchViewController.h"
#import "MeSearchView.h"
#import "WriteFileManager.h"
#import "ButtonAndImageView.h"
#define View_width self.view.frame.size.width
#define View_height self.view.frame.size.height
#define searchHistoryPlaceholder @"产品名称/编号/目的地"

@interface MeSearchViewController ()
@property (nonatomic,copy) NSString *searchK;
@property (nonatomic,weak) UIView *sep2;
@property (nonatomic,strong) MeSearchView *meHistoryView;
@property (nonatomic,strong)UIView *suLine;
@property (nonatomic, strong)UIButton *imageAndTitle;
@property (nonatomic, strong)UIView *backGroundView;
@property (nonatomic, strong)UIButton *searchButton;

@property (nonatomic, assign)BOOL tellFlage;

@end

@implementation MeSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.backGroundView];
    
    [self.backGroundView addSubview:self.searchButton];
    [self.view addSubview:self.meHistoryView];
    [self.searchBar becomeFirstResponder];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MeShareSearch:) name:@"MeShareSearch" object:nil];
}
#pragma mark - 各种初始化
- (SKSearchBar *)searchBar{
    if (_searchBar == nil) {
        _searchBar = [[SKSearchBar alloc] initWithFrame:CGRectMake(0, 0, View_width-60, 40)];
        _searchBar.delegate = self;
        _searchBar.barStyle = UISearchBarStyleDefault;
        _searchBar.translucent = NO;
        if (self.detail_key.length) {
            _searchBar.text = self.detail_key;
        }else{
            _searchBar.placeholder = searchHistoryPlaceholder;
        }
        _searchBar.barTintColor = [UIColor colorWithRed:232/255.0 green:234/255.0 blue:235/255.0 alpha:1];
        _searchBar.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    }
    return _searchBar;
}

- (UIView *)backGroundView{
    if (!_backGroundView) {
        
        
        self.backGroundView = [[UIView alloc]initWithFrame:CGRectMake(View_width-60, 0, 60, 40)];
        self.backGroundView.backgroundColor = [UIColor colorWithRed:(226.0/255.0) green:(229.0/255.0) blue:(230.0/255.0) alpha:1];
        
        UIView *upview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 0.5)];
        upview.backgroundColor = [UIColor blackColor];
        [self.backGroundView addSubview:upview];
        
        UIView *downview = [[UIView alloc]initWithFrame:CGRectMake(0, 39.5, 60, 0.5)];
        downview.backgroundColor = [UIColor blackColor];
        [self.backGroundView addSubview:downview];
        
    }
    return _backGroundView;
}
- (UIButton *)searchButton{
    if (!_searchButton) {
        _searchButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 6, 60, 28)];
        [_searchButton setTitle:@"搜索" forState:UIControlStateNormal];
        [_searchButton setImage:[UIImage imageNamed:@"fdjBtn"] forState:UIControlStateNormal];
        _searchButton.backgroundColor = [UIColor clearColor];
        [_searchButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_searchButton setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 20)];
        [_searchButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 7, 0, 5)];
        [_searchButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_searchButton addTarget:self action:@selector(searchBarButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchButton;
}

- (MeSearchView *)meHistoryView{
    if (_meHistoryView == nil) {
        self.meHistoryView = [[MeSearchView alloc] initWithFrame:CGRectMake(0, 40+2, View_width, View_height-42-49)];
        self.meHistoryView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:241/255.0 alpha:1];
    }
    return _meHistoryView;
}

#pragma mark - UISearchBar的delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:NO animated:YES];
    return YES;
}
// 这个方法里面纯粹调样式
//- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
//{
//    for (UIView *searchbuttons in [[searchBar.subviews objectAtIndex:0] subviews]){
//
//        if ([searchbuttons isKindOfClass:[UIButton class]]){
//            UIButton *findButton = (UIButton *)searchbuttons;
//            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"搜索"];
//            NSMutableDictionary *muta = [NSMutableDictionary dictionary];
//            [muta setObject:[UIColor grayColor] forKey:NSForegroundColorAttributeName];
//            [muta setObject:[UIFont systemFontOfSize:13] forKey:NSFontAttributeName];
//            [attr addAttributes:muta range:NSMakeRange(0, 2)];
//            [findButton setAttributedTitle:attr forState:UIControlStateNormal];
//
//            break;
//        } }
//}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSString *trimStr = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.searchK = trimStr;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    if (self.searchK.length || self.detail_key.length) {
        [searchBar endEditing:YES];
        [self saveHistorySearchKey];
    }
}



- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    
    if (searchBar.text.length || [searchBar.text isEqualToString:@" "]){
        [self.searchDelegate searchBarText:searchBar.text];
        [self.navigationController popViewControllerAnimated:NO];
        
    }
}

#pragma mark - 通知。历史纪录调用的方法
- (void)MeShareSearch:(NSNotification *)noty{
    self.searchBar.text = noty.userInfo[@"searchKey"];
    [self.searchDelegate transmitPopKeyWord:noty.userInfo[@"searchKey"]];
    [self.navigationController popViewControllerAnimated:NO];
    
}

#pragma mark - 记录数据本地获取
- (void)saveHistorySearchKey{
    NSMutableArray *tmp = [NSMutableArray array];
    // 先取出原来的记录
    NSArray *arr = [WriteFileManager readFielWithName:@"MeShareSearch"];
    [tmp addObjectsFromArray:arr];
    
    // 再加上新的搜索记录
    if (self.searchK.length) {
        [tmp addObject:self.searchK];
        // 并保存
        [WriteFileManager saveFileWithArray:tmp Name:@"MeShareSearch"];
    }
}

- (void)searchBarButtonAction{
    if (self.searchBar.text.length) {
        [self saveHistorySearchKey];
        [self.searchDelegate searchBarText:self.searchBar.text];
        [self.navigationController popViewControllerAnimated:NO];
    }else{
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
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
