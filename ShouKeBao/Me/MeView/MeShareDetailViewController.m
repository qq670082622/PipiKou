//
//  MeShareDetailViewController.m
//  ShouKeBao
//
//  Created by 张正梅 on 15/10/22.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "MeShareDetailViewController.h"
#import "MeShareDetailTableViewCell.h"
#import "MeShareChooseViewController.h"
#import "MeSearchViewController.h"

#define VIEW_width self.view.frame.size.width
#define VIEW_height self.view.frame.size.height
#define gap 10

@interface MeShareDetailViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate>
@property (nonatomic, strong)UITableView *shareTableView;
@property (nonatomic, strong)NSMutableArray *shareDataArr;
@property (nonatomic, strong)UIView *chooseView;
@property (nonatomic, assign)BOOL shareFlag;

@end

@implementation MeShareDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"分享详情";
    [self setRightBarButton];
    [self.view addSubview:self.shareTableView];
    [self.view addSubview:self.chooseView];
    
    
}

#pragma mark - 各种初始化
- (UITableView *)shareTableView{
    if (!_shareTableView) {
        self.shareTableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
        self.shareTableView.delegate = self;
        self.shareTableView.dataSource = self;
    }
    return _shareTableView;
}

-(NSMutableArray *)shareDataArr{
    if (_shareDataArr == nil) {
        self.shareDataArr = [NSMutableArray array];
    }
    return _shareDataArr;
}

    
- (UIView *)chooseView{
    if (!_chooseView) {
        self.chooseView = [[UIView alloc]initWithFrame:CGRectMake(VIEW_width-150-gap, 2, 150, 100)];
        self.chooseView.backgroundColor = [UIColor blackColor];
        self.chooseView.alpha = 0.3;
        self.chooseView.hidden = YES;
        
        UIButton *searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 150, 50)];
        [searchBtn setTitle:@"搜索产品" forState:UIControlStateNormal];
        [searchBtn setImage:[UIImage imageNamed:@"check"]forState:UIControlStateNormal];
        searchBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        searchBtn.titleLabel.textColor = [UIColor grayColor];
        [searchBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 20, 5, 100)];
        [searchBtn setTitleEdgeInsets:UIEdgeInsetsMake(5, 7, 5, 5)];
        [searchBtn addTarget:self action:@selector(searchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.chooseView addSubview:searchBtn];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 50, 150, 1)];
        line.backgroundColor = [UIColor grayColor];
        [self.chooseView addSubview:line];
        
        
        UIButton *chooseBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 50, 150, 50)];
        [chooseBtn setTitle:@"筛选产品" forState:UIControlStateNormal];
        [chooseBtn setImage:[UIImage imageNamed:@"check"]forState:UIControlStateNormal];
        chooseBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        chooseBtn.titleLabel.textColor = [UIColor grayColor];
        [chooseBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 20, 5, 100)];
        [chooseBtn setTitleEdgeInsets:UIEdgeInsetsMake(5, 7, 5, 5)];
        [chooseBtn addTarget:self action:@selector(chooseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.chooseView addSubview:chooseBtn];
    
    }
    return _chooseView;
}


#pragma mark - UITableView - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MeShareDetailTableViewCell *cell = [MeShareDetailTableViewCell cellWithTableView:tableView];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (void)setRightBarButton{
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"anquanqiangdu"] style:UIBarButtonItemStylePlain  target:self action:@selector(editBarButtonAction)];
    self.navigationItem.rightBarButtonItem = barItem;
}


- (void)editBarButtonAction{
    if (self.shareFlag) {
        self.chooseView.hidden = YES;
    }else{
        self.chooseView.hidden = NO;
    }
    self.shareFlag = !self.shareFlag;
    
}

- (void)searchButtonAction:(UIButton *)button{
    MeSearchViewController *meSearchVC = [[MeSearchViewController alloc]init];
    self.chooseView.hidden = YES;
    meSearchVC.title = @"产品搜索";
    [self.navigationController pushViewController:meSearchVC animated:YES];
    
}
- (void)chooseButtonAction:(UIButton *)button{
    MeShareChooseViewController *meShareChooseVC = [[MeShareChooseViewController alloc]init];
    self.chooseView.hidden = YES;
    [self.navigationController pushViewController:meShareChooseVC animated:YES];
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
