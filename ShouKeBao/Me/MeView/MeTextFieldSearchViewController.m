//
//  MeTextFieldSearchViewController.m
//  ShouKeBao
//
//  Created by 张正梅 on 15/10/29.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "MeTextFieldSearchViewController.h"
#import "MeSearchView.h"
#import "WriteFileManager.h"

#define VIEW_width [UIScreen mainScreen].bounds.size.width
#define VIEW_height self.view.frame.size.height
#define searchHistoryPlaceholder @"产品名称/编号/目的地"

@interface MeTextFieldSearchViewController ()<UITextFieldDelegate>
@property (nonatomic, strong)UIView *backGroundView;
@property (nonatomic, strong)UIButton *searchButton;
@property (nonatomic,strong) MeSearchView *meHistoryView;
@end

@implementation MeTextFieldSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backGroundView];
    [self.backGroundView addSubview:self.inputTextView];
    [self.backGroundView addSubview:self.searchButton];
    
    [self.inputTextView becomeFirstResponder];
    [self.view addSubview:self.meHistoryView];
    
}
- (UIView *)backGroundView{
    if (!_backGroundView) {
        self.backGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, VIEW_width, 40)];
        self.backGroundView.backgroundColor = [UIColor colorWithRed:(226.0/255.0) green:(229.0/255.0) blue:(230.0/255.0) alpha:1];
    }
    return _backGroundView;
}

- (UITextField *)inputTextView{
    if (!_inputTextView) {
        self.inputTextView = [[UITextField alloc]initWithFrame:CGRectMake(10, 6, VIEW_width-70, 28)];
        if (self.detail_key.length) {
            self.inputTextView.text = self.detail_key;
        }else{
            self.inputTextView.placeholder = searchHistoryPlaceholder;
        }
        self.inputTextView.clearButtonMode = UITextFieldViewModeAlways;
        self.inputTextView.font = [UIFont systemFontOfSize:13];
        self.inputTextView.borderStyle = UITextBorderStyleRoundedRect;
        self.inputTextView.delegate = self;
    }
    return _inputTextView;
}

- (UIButton *)searchButton{
    if (!_searchButton) {
        _searchButton = [[UIButton alloc]initWithFrame:CGRectMake(VIEW_width-60, 6, 60, 28)];
//        _searchButton.backgroundColor = [UIColor purpleColor];
        [_searchButton setTitle:@"搜索" forState:UIControlStateNormal];
        [_searchButton setImage:[UIImage imageNamed:@"fdjBtn"] forState:UIControlStateNormal];
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
        self.meHistoryView = [[MeSearchView alloc] initWithFrame:CGRectMake(0, 40+2, VIEW_width, VIEW_height-42-49)];
        self.meHistoryView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:241/255.0 alpha:1];
    }
    return _meHistoryView;
}

- (void)searchBarButtonAction{
    if (self.inputTextView.text.length) {
        [self saveHistorySearchKey];
        [self.searchDelegate searchBarText:self.inputTextView.text];
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        
        
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MeShareSearch:) name:@"MeShareSearch" object:nil];
}

#pragma mark - 通知
- (void)MeShareSearch:(NSNotification *)noty{
    [self.searchDelegate transmitPopKeyWord:noty.userInfo[@"searchKey"]];
    [self.navigationController popViewControllerAnimated:NO];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
   
    if (self.inputTextView.text.length) {
        [self.searchDelegate searchBarText:self.inputTextView.text];
        [self saveHistorySearchKey];
        [self.navigationController popViewControllerAnimated:NO];

    }else{
        
    }
    
    return YES;
}


#pragma mark - 记录数据本地获取
- (void)saveHistorySearchKey{
    NSMutableArray *tmp = [NSMutableArray array];
    // 先取出原来的记录
    NSArray *arr = [WriteFileManager readFielWithName:@"MeShareSearch"];
    [tmp addObjectsFromArray:arr];
    
    // 再加上新的搜索记录
    if (self.inputTextView.text.length) {
        [tmp addObject:self.inputTextView.text];
        // 并保存
        [WriteFileManager saveFileWithArray:tmp Name:@"MeShareSearch"];
    }
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:NO];
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

- (IBAction)inputTextView:(id)sender {
}
- (IBAction)searchButton:(id)sender {
}
@end
