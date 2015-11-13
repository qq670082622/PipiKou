//
//  MySubscribeController.m
//  ShouKeBao
//
//  Created by 韩世民 on 15/10/26.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "MySubscribeController.h"
#import "addSubCondController.h"
#import "IWHttpTool.h"
#define kScreenSize [UIScreen mainScreen].bounds.size
@interface MySubscribeController ()
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic) BOOL IsData;
@property (nonatomic,strong) UIView *emptyView;
@property (nonatomic,strong) UIImageView *emptyImageView;
@property (nonatomic,copy) UILabel *emptyLabel;
@property (nonatomic,strong) UIButton *nowAddSubBtn;
@end

@implementation MySubscribeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的订阅";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self creatRightNav];
    [IWHttpTool WMpostWithURL:@"/Product/GetAppSubscribeProductList" params:nil success:^(id json) {
        NSLog(@"有数据");
        NSLog(@"--%@",json[@"ProductList"]);
        if (json[@"ProductList"] == nil) {
            _IsData = NO;
        }else{
            _IsData = YES;
        }
    } failure:^(NSError *error) {
        NSLog(@"返回失败");
        _IsData = NO;
    }];
    if (_IsData) {
        NSLog(@"加载数据页面");
    }else{
        NSLog(@"加载空页面");
        [self.emptyView addSubview:self.emptyImageView];
        [self.emptyView addSubview:self.emptyLabel];
        [self.emptyView addSubview:self.nowAddSubBtn];
        [self.view addSubview:self.emptyView];
    }
}
-(UIButton *)nowAddSubBtn{
    if (_nowAddSubBtn == nil) {
        _nowAddSubBtn  = [[UIButton alloc] initWithFrame:CGRectMake(50, kScreenSize.height - kScreenSize.height/3- 50, kScreenSize.width-100, 50)];
        _nowAddSubBtn.tag = 210;
        _nowAddSubBtn.backgroundColor = [UIColor orangeColor];
        _nowAddSubBtn.layer.masksToBounds = YES;
        _nowAddSubBtn.layer.cornerRadius  = 3;
        [_nowAddSubBtn setTitle:@"立即添加订阅" forState:UIControlStateNormal];
        [_nowAddSubBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_nowAddSubBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nowAddSubBtn;
}
-(UILabel *)emptyLabel{
    if (_emptyLabel == nil) {
        _emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenSize.width/2-50, kScreenSize.height/5+50, 110, 30)];
        _emptyLabel.text = @"您还没有订阅!";
        _emptyLabel.font = [UIFont systemFontOfSize:17];
        _emptyLabel.textColor = [UIColor colorWithRed:(58.0/255.0) green:(57.0/255.0) blue:(58.0/255.0) alpha:1];
    }
    return _emptyLabel;
}
-(UIView *)emptyView{
    if (_emptyView == nil) {
        _emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height-64)];
        _emptyView.backgroundColor = [UIColor whiteColor];
    }
    return _emptyView;
}
-(UIImageView *)emptyImageView{
    if (_emptyImageView == nil) {
        _emptyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenSize.width/2-25, kScreenSize.height/5, 50, 50)];
        _emptyImageView.backgroundColor = [UIColor blueColor];
    }
    return _emptyImageView;
}
-(void)creatRightNav{
    UIButton *turnOff = [UIButton buttonWithType:UIButtonTypeCustom];
    turnOff.titleLabel.font = [UIFont systemFontOfSize:15];
    turnOff.frame = CGRectMake(0, 0, 30, 10);
    turnOff.tag = 211;
    [turnOff addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [turnOff setTitle:@"修改"  forState:UIControlStateNormal];
    turnOff.titleEdgeInsets = UIEdgeInsetsMake(-2, -35, 0, 0);
    [turnOff setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    turnOffItem = [[UIBarButtonItem alloc] initWithCustomView:turnOff];
    self.navigationItem.rightBarButtonItem = turnOffItem;
}
-(void)btnClick:(UIButton *)button{
    if (button.tag == 210) {
        NSLog(@"点击跳转");
        addSubCondController *controller = [[addSubCondController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }else if(button.tag == 211){
        NSLog(@"点击修改");
    }
    
    
}
-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height-64) style:UITableViewStylePlain];
        _tableView.rowHeight = 100;
    }
    return _tableView;
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
