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
#define searchHistoryPlaceholder @"订单号/产品名称/供应商名称"

@interface MeSearchViewController ()
@property (nonatomic,copy) NSString *searchK;
@property (nonatomic,weak) UIView *sep2;
@property (nonatomic,strong) MeSearchView *meHistoryView;
@property (nonatomic,strong)UIView *suLine;
@property (nonatomic, strong)UIButton *imageAndTitle;


@end

@implementation MeSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.searchBar];
//    [self.view addSubview:self.imageAndTitle];
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
        _searchBar = [[SKSearchBar alloc] initWithFrame:CGRectMake(0, 0, View_width, 40)];
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
- (UIButton *)imageAndTitle{
    if (!_imageAndTitle) {
        self.imageAndTitle = [UIButton buttonWithType:UIButtonTypeCustom];
        self.imageAndTitle.frame = CGRectMake(View_width-70, 0, 70, 40);
        [self.imageAndTitle setTitle:@"搜索" forState:UIControlStateNormal];
        [self.imageAndTitle.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [self.imageAndTitle setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.imageAndTitle setBackgroundColor:[UIColor colorWithRed:(226.0/255.0) green:(229.0/255.0) blue:(230.0/255.0) alpha:1]];
        self.imageAndTitle.layer.borderColor = [UIColor blackColor].CGColor;
        self.imageAndTitle.layer.borderWidth = 0.5;
        [self.imageAndTitle setImage:[UIImage imageNamed:@"fdjBtn"] forState:UIControlStateNormal];
        [self.imageAndTitle addTarget:self action:@selector(imageAndTitleAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _imageAndTitle;
}

- (MeSearchView *)meHistoryView{
    if (_meHistoryView == nil) {
        self.meHistoryView = [[MeSearchView alloc] initWithFrame:CGRectMake(0, 40+2, View_width, View_height-42-49)];
        self.meHistoryView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:241/255.0 alpha:1];
    }
    return _meHistoryView;
}

#pragma mark - 记录数据本地获取
- (void)loadRecordData{
        if (self.searchK.length) {
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
            UIButton *findButton = (UIButton *)searchbuttons;
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"🔍搜索"];
            NSMutableDictionary *muta = [NSMutableDictionary dictionary];
            [muta setObject:[UIColor grayColor] forKey:NSForegroundColorAttributeName];
            [muta setObject:[UIFont systemFontOfSize:13] forKey:NSFontAttributeName];
            [attr addAttributes:muta range:NSMakeRange(0, 4)];
            [findButton setAttributedTitle:attr forState:UIControlStateNormal];
//            [findButton setImage:[UIImage imageNamed:@"fdjBtn"] forState:UIControlStateNormal];

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
        [self saveHistorySearchKey];
        //        [self searchLoadData];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    [self saveHistorySearchKey];
//    [self.navigationController popViewControllerAnimated:NO];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    if (self.searchBar.text.length|| [self.searchBar.text isEqualToString:@" "]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
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
- (void)MeShareSearch:(NSNotification *)noty
{
    self.searchBar.text = noty.userInfo[@"searchKey"];
//    [self.transmitDelegate transmitPopKeyWord:self.searchBar.text];
    [self.navigationController popViewControllerAnimated:NO];
}


//自定义搜索方法
- (void)imageAndTitleAction:(UIButton *)button{
//    if (!self.searchBar.text.length) {
//        [self.transmitDelegate transmitPopKeyWord:self.searchBar.text];
//    }
//    [self.navigationController popViewControllerAnimated:NO];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.transmitDelegate transmitPopKeyWord:self.searchBar.text];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)back{
    [self.navigationController popViewControllerAnimated:NO];
    
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
