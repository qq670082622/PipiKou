//
//  addSubCondController.m
//  ShouKeBao
//
//  Created by 韩世民 on 15/10/26.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "addSubCondController.h"
#import "NMRangeSlider.h"
#define kScreenSize [UIScreen mainScreen].bounds.size
@interface addSubCondController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *cellNameArr;
@property (nonatomic,strong) UIView *footView;
@property(nonatomic) NMRangeSlider *Slider;
@property(nonatomic) NSArray *sixbtndata;//6个价格区间数据(不一定是6个)
@property (nonatomic,strong) UIButton *PreserveBtn;//保存

@end

@implementation addSubCondController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"添加订阅条件";
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatRightNav];
    //
    UIView *footSta = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 8)];
    footSta.backgroundColor = [UIColor lightGrayColor];
    footSta.alpha = 0.3;
    
    UILabel *CellNamelab = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, kScreenSize.width/2, 20)];
    CellNamelab.text = @"价格区间";
    [self.footView addSubview:CellNamelab];
    
    //6个button
    for (int i = 0; i < self.sixbtndata.count; i++) {
        sixbutton = [[UIButton alloc] initWithFrame:CGRectMake(i%3*kScreenSize.width/3+kScreenSize.width/21, i/3*kScreenSize.height/12+45, 80, 26)];
        sixbutton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sixbtnbg"]];
        //[sixbutton setTitle:[_sixbtndata[i] objectForKey:@"Text"]  forState:UIControlStateNormal];
        [sixbutton setTitle:_sixbtndata[i] forState:UIControlStateNormal];
        [sixbutton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [sixbutton setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        [sixbutton setBackgroundImage:[UIImage imageNamed:@"btnClick"] forState:UIControlStateSelected];
        sixbutton.titleLabel.font = [UIFont systemFontOfSize:12];
        [sixbutton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        sixbutton.tag = 1001+i;
        [self.footView addSubview:sixbutton];
    }
    //价格区间滑杆
    self.Slider = [[NMRangeSlider alloc] initWithFrame:CGRectMake(15,170 , kScreenSize.width-30, 30)];
    //self.Slider.minimumValue = [NSString stringWithFormat:@"%@",[self.siftHLDic objectForKey:@"MinPrice"]].floatValue;
      self.Slider.minimumValue = 0;
    //self.Slider.maximumValue = [NSString stringWithFormat:@"%@",[self.siftHLDic objectForKey:@"MaxPrice"]].floatValue;
      self.Slider.maximumValue = 60000;
    //self.Slider.upperValue = [NSString stringWithFormat:@"%@",[self.siftHLDic objectForKey:@"MaxPrice"]].floatValue;
      self.Slider.upperValue = 60000;
      [self.Slider addTarget:self action:@selector(updateSliderLabels) forControlEvents:UIControlEventAllTouchEvents];
    
    //左滑轮价格
    lowPlabel = [[UILabel alloc] init];
    lowPlabel.frame = CGRectMake(10, 140, 70, 30);
    //lowPlabel.text = [NSString stringWithFormat:@"¥%@",[self.siftHLDic objectForKey:@"MinPrice"]] ;
    lowPlabel.text = @"¥0";
    lowPlabel.font = [UIFont systemFontOfSize:12];
    lowPlabel.textColor = [UIColor orangeColor];
    
    //右滑轮价格
    tallPlabel = [[UILabel alloc] init];
    tallPlabel.frame = CGRectMake(kScreenSize.width-50, 140, 70, 30);
    //tallPlabel.text =  [NSString stringWithFormat:@"¥%@",[self.siftHLDic objectForKey:@"MaxPrice"]];
    tallPlabel.text = @"¥60000";
    tallPlabel.font = [UIFont systemFontOfSize:12];
    tallPlabel.textColor = [UIColor orangeColor];
    
    //两个输入框
    UILabel *Lowlabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 207, kScreenSize.width/3, 50)];
    Lowlabel.text = @"自定义价格";
    
    
    lowPrice = [[UITextField alloc] initWithFrame:CGRectMake(kScreenSize.width/2-kScreenSize.width/6, 220, 80, 25)];
    lowPrice.background = [UIImage imageNamed:@"jiagebian"];
    lowPrice.delegate = self;
    lowPrice.tag = 210;
    lowPrice.placeholder = @"  ¥";
    [lowPrice setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    UIView *midView = [[UIView alloc] initWithFrame:CGRectMake(kScreenSize.width/2+kScreenSize.width/10, 230, 15, 1)];
    midView.backgroundColor = [UIColor lightGrayColor];
    
    tallPrice = [[UITextField alloc] initWithFrame:CGRectMake(kScreenSize.width/2+kScreenSize.width/6, 220, 80, 25)];
    tallPrice.background = [UIImage imageNamed:@"jiagebian"];
    tallPrice.delegate = self;
    tallPrice.tag = 220;
    tallPrice.placeholder = @"  ¥";
    [tallPrice setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    [self.footView addSubview:midView];
    [self.footView addSubview:Lowlabel];
    [self.footView addSubview:lowPrice];
    [self.footView addSubview:tallPrice];
    [self.footView addSubview:lowPlabel];
    [self.footView addSubview:tallPlabel];
    [self.footView addSubview:self.Slider];
    [self.footView addSubview:footSta];
    
    [self.view addSubview:self.tableView];
    //确定Btn
    self.PreserveBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, kScreenSize.height-114, kScreenSize.width, 50)];
    self.PreserveBtn.backgroundColor = [UIColor orangeColor];
    [self.PreserveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [self.PreserveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:self.PreserveBtn];
    }

- (void) updateSliderLabels
{
    CGPoint lowerCenter;
    lowerCenter.x = (self.Slider.lowerCenter.x + self.Slider.frame.origin.x+10);
    lowerCenter.y = (self.Slider.center.y - 30.0f);
    lowPlabel.center = lowerCenter;
    lowPlabel.text = [NSString stringWithFormat:@"¥%d", (int)self.Slider.lowerValue];
    
    CGPoint upperCenter;
    upperCenter.x = (self.Slider.upperCenter.x + self.Slider.frame.origin.x+10);
    upperCenter.y = (self.Slider.center.y - 30.0f);
    tallPlabel.center = upperCenter;
    tallPlabel.text = [NSString stringWithFormat:@"¥%d", (int)self.Slider.upperValue];
}
-(NSArray *)cellNameArr{
    if (_cellNameArr == nil) {
        _cellNameArr = [[NSArray alloc] initWithObjects:@"目的地",@"出发日期",@"行程天数",@"出发地",@"供应商" ,nil];
    }
    return _cellNameArr;
}
-(NSArray *)sixbtndata{
    if (_sixbtndata == nil) {
        _sixbtndata = [[NSArray alloc] init];
        _sixbtndata = @[@"8899以下",@"8900-9599",@"9600-12399",@"12400-13899",@"13900-16299",@"16300以上"];
    }
    return _sixbtndata;
}
-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0 , kScreenSize.width, kScreenSize.height-64) style:UITableViewStylePlain];
        _tableView.rowHeight = 50;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        _tableView.tableFooterView = self.footView;
    }
    return _tableView;
}
-(UIView *)footView{
    if (_footView == nil) {
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 360)];
        _footView.backgroundColor = [UIColor whiteColor];
        
    }
    return _footView;
}
/*
 //自定义尾视图
 UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 443)];//原来是158，388
 UIView *footSta = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 8)];
 footSta.backgroundColor = [UIColor lightGrayColor];
 footSta.alpha = 0.3;
 [footView addSubview:footSta];

 */
-(void)creatRightNav{
    UIButton *turnOff = [UIButton buttonWithType:UIButtonTypeCustom];
    turnOff.titleLabel.font = [UIFont systemFontOfSize:15];
    turnOff.frame = CGRectMake(0, 0, 30, 10);
    turnOff.tag = 211;
    [turnOff addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [turnOff setTitle:@"重置"  forState:UIControlStateNormal];
    turnOff.titleEdgeInsets = UIEdgeInsetsMake(-2, -35, 0, 0);
    [turnOff setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    turnOffItem = [[UIBarButtonItem alloc] initWithCustomView:turnOff];
    self.navigationItem.rightBarButtonItem = turnOffItem;
}

-(void)btnClick:(UIButton *)button{
    NSLog(@"点击重置");
    for (NSInteger qw =1001; qw<1007; qw++) {
        if (button.tag == qw) {
            button.selected = YES;
        }else{
            UIButton *myButton1 = (UIButton *)[self.view viewWithTag:qw];
            myButton1.selected = NO;
        }
    }
}
#pragma mark - UITableView的协议方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cellNameArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 50)];
    cell.textLabel.text = self.cellNameArr[indexPath.row];
    UILabel *noLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenSize.width/2, 10, kScreenSize.width/3+20, 30)];
    noLabel.text = @"不限";
    noLabel.textAlignment = UITextLayoutDirectionRight;
    noLabel.textColor = [UIColor lightGrayColor];
    noLabel.font = [UIFont systemFontOfSize:14];
    [cell addSubview:noLabel];
    UIImageView *rigImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenSize.width - 30, 15, 20, 20)];
    rigImageView.image = [UIImage imageNamed:@"xiangyou"];
    [cell addSubview:rigImageView];
    return cell;
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
