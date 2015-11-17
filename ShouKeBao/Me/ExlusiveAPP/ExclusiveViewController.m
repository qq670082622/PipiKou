//
//  ExclusiveViewController.m
//  ShouKeBao
//
//  Created by 张正梅 on 15/11/17.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "ExclusiveViewController.h"
#import "ExclusiveTableViewCell.h"
#import "EstablelishedViewController.h"
@interface ExclusiveViewController ()<UITableViewDataSource, UITableViewDelegate>
//头部
@property (weak, nonatomic) IBOutlet UIImageView *HeadImageViewSet;
@property (weak, nonatomic) IBOutlet UILabel *builtLable;
@property (weak, nonatomic) IBOutlet UILabel *customerCount;
@property (weak, nonatomic) IBOutlet UIButton *adviserBtn;
//table中间
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataArray;

//专属App
- (IBAction)touchExclusiveAppButton:(id)sender;

@end

@implementation ExclusiveViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setRightShareBarItem];
    [self setHeaderImageView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
    
    
    
    
    
    
    
    
    
    
    
}

#pragma mark - tableView-delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ExclusiveTableViewCell *cell = [ExclusiveTableViewCell cellWithTableView:tableView];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.tableView.frame.size.height/2;
}








- (void)setRightShareBarItem{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0,0,20,20)];
    [button setImage:[UIImage imageNamed:@"APPfenxiang"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(shareAction:)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *shareBarItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = shareBarItem;
}
- (void)setHeaderImageView{
    [self.view addSubview:self.HeadImageViewSet];
    [self.HeadImageViewSet addSubview:self.builtLable];
    [self.HeadImageViewSet addSubview:self.customerCount];
    [self.HeadImageViewSet addSubview:self.adviserBtn];
    
}


-(void)shareAction:(UIButton *)button{
    
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

- (IBAction)touchExclusiveAppButton:(id)sender {
    EstablelishedViewController *estableshedVC = [[EstablelishedViewController alloc]init];
    estableshedVC.title = @"专属APP";
    estableshedVC.naVC = self.navigationController;
    [self.navigationController pushViewController:estableshedVC animated:YES];
    
}
@end
