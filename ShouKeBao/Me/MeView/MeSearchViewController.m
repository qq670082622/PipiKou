//
//  MeSearchViewController.m
//  ShouKeBao
//
//  Created by 张正梅 on 15/10/22.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "MeSearchViewController.h"
#import "SKSearchBar.h"
#import "MeSearchView.h"
#import "WriteFileManager.h"
#define View_width self.view.frame.size.width
#define View_height self.view.frame.size.height
#define searchHistoryPlaceholder @"订单号/产品名称/供应商名称"

@interface MeSearchViewController ()<UISearchBarDelegate>
@property (nonatomic,strong) SKSearchBar *searchBar;
@property (nonatomic,copy) NSString *searchK;
@property (nonatomic,weak) UIView *sep2;
@property (nonatomic,strong) MeSearchView *meHistoryView;
@end

@implementation MeSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.meHistoryView];
    [self.searchBar becomeFirstResponder];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MeShareSearch:) name:@"MeShareSearch" object:nil];
}


- (SKSearchBar *)searchBar
{
    if (_searchBar == nil) {
        _searchBar = [[SKSearchBar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
        _searchBar.delegate = self;
        _searchBar.barStyle = UISearchBarStyleDefault;
        _searchBar.translucent = NO;
        _searchBar.placeholder = searchHistoryPlaceholder;
        _searchBar.barTintColor = [UIColor colorWithRed:232/255.0 green:234/255.0 blue:235/255.0 alpha:1];
        _searchBar.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    }
    return _searchBar;
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
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}
// 这个方法里面纯粹调样式
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    for (UIView *searchbuttons in [[searchBar.subviews objectAtIndex:0] subviews]){
        
        if ([searchbuttons isKindOfClass:[UIButton class]]){
        UIButton *cancelButton = (UIButton *)searchbuttons;
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"搜索🔍"];
        NSMutableDictionary *muta = [NSMutableDictionary dictionary];
        [muta setObject:[UIColor colorWithRed:68/255.0 green:122/255.0 blue:208/255.0 alpha:1] forKey:NSForegroundColorAttributeName];
        [muta setObject:[UIFont systemFontOfSize:13] forKey:NSFontAttributeName];
        [attr addAttributes:muta range:NSMakeRange(0, 2)];
        [cancelButton setAttributedTitle:attr forState:UIControlStateNormal];
        break;
    }
  }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSString *trimStr = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.searchK = trimStr;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.searchDisplayController setActive:NO animated:YES];
    
    if (self.searchK.length) {
        [searchBar endEditing:YES];
        NSMutableArray *tmp = [NSMutableArray array];
        // 先取出原来的记录
        NSArray *arr = [WriteFileManager readFielWithName:@"MeShareSearch"];
        [tmp addObjectsFromArray:arr];
        
        // 再加上新的搜索记录
        [tmp addObject:self.searchK];
        
        // 并保存
        [WriteFileManager saveFileWithArray:tmp Name:@"MeShareSearch"];
//        [self searchLoadData];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    self.searchBar.placeholder = searchHistoryPlaceholder;
    
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    NSLog(@"网络请求数据....");
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)MeShareSearch:(NSNotification *)noty
{
    self.searchK = noty.userInfo[@"searchKey"];
    [self.searchDisplayController setActive:NO animated:YES];
//    [self searchLoadData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.transmitDelegate transmitPopKeyWord:self.searchBar.text];
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
