//
//  ShaiXuanViewController.m
//  ShouKeBao
//
//  Created by 吴铭 on 15/8/17.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "ShaiXuanViewController.h"
#import "ShaiXuanCell.h"
#import "ChooseDayViewController.h"
#import "BaseClickAttribute.h"
#import "MobClick.h"
#import "ConditionSelectViewController.h"
#import "WriteFileManager.h"
#import "MinMaxPriceSelectViewController.h"
#import "ProductList.h"
#import "WLRangeSlider.h"
#define kScreenSize [UIScreen mainScreen].bounds.size
@interface ShaiXuanViewController ()<UITableViewDataSource,UITableViewDelegate,ChooseDayViewControllerDelegate,passValue,passThePrice,UITextFieldDelegate>
@property (strong,nonatomic) NSMutableDictionary *conditionDic;//当前条件开关

@property(copy,nonatomic) NSMutableString *goDateStart;
@property(copy,nonatomic) NSMutableString *goDateEnd;
@property (copy,nonatomic) NSMutableString *jiafan;
@property (copy,nonatomic) NSMutableString *jishi;
@property(nonatomic,copy) NSMutableString *month;
@property (strong,nonatomic) NSMutableArray *subIndicateDataArr1;
@property(nonatomic) UISwitch *jiafanswitch;
@property(nonatomic) UISwitch *jishiswitch;
@property(nonatomic,assign) BOOL jiafanswitchisOn;
@property(nonatomic,assign) BOOL jishiswitchisOn;
@property(nonatomic) UIButton *priceBtnOutlet;
@property(nonatomic) UIButton *button;//价格
@property(nonatomic,strong)WLRangeSlider *rangeSlider;//滑杆


@end

@implementation ShaiXuanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    lowPlabel = [[UILabel alloc] init];
    tallPlabel = [[UILabel alloc] init];
    // Do any additional setup after loading the view.
    //self.view.window.rootViewController = [[UINavigationController alloc] init];
    dataArr = [[NSArray alloc] init];
    dataArr = @[@"目的地",@"出发城市",@"出发日期",@"行程天数",@"游览线路",@"供应商",@"主题推荐",@"酒店类型",@"出行方式",@"邮轮公司"];
    self.subIndicateDataArr1 = [NSMutableArray arrayWithObjects:@" ",@" ",@" ",@" ",@" ",@" ",@" ",@" ",@" ",@" ", nil];
    self.month = [NSMutableString stringWithFormat:@""];
    self.jiafanswitchisOn = YES;
    self.jishiswitchisOn = YES;
    self.title = @"筛选";
   // self.navigationController.navigationBarHidden = YES;
    //自定义导航栏
    [self creatNav];
    //自定义界面
    [self creatUI];
    NSLog(@"-------------------初始化时加返：%@及时:%@------------",_jiafan,_jishi);
  //  [self addGest];
    if ([_jiafan  isEqual: @"0"]) {
        self.jiafanswitch.on = NO;
        
    }else if ([_jiafan isEqual:@"1"]){
        self.jiafanswitch.on = YES;
    }
    if ([_jishi isEqual:@"0"]) {
        self.jishiswitch.on = NO;
    }else if ([_jishi isEqual:@"1"]){
        self.jishiswitch.on = YES;
    }
    //增加监听获取键盘高度
    [self monitor];
}
-(void)monitor{
    //增加监听，当键盘出现或改变时收出消息
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
//当键盘出现或改变时调用

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    
    int height = keyboardRect.size.height;
    NSLog(@"键盘高度%d",height);

    [UIView animateWithDuration:0.5 animations:^{
    CGRect subtab = subTable.frame;
    subtab.size.height-=height;
    subTable.frame = subtab;
    } completion:^(BOOL finished) {
        NSLog(@"执行动画完毕");
    }];
}


//当键退出时调用

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    //获取键盘的高度
    
    NSDictionary *userInfo = [aNotification userInfo];
    
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    
    int height = keyboardRect.size.height;
    NSLog(@"键盘高度%d",height);
    CGRect subtab = subTable.frame;
    subtab.size.height+=height;
    subTable.frame = subtab;
    
}
//- (void)addGest{
//    UIScreenEdgePanGestureRecognizer *screenEdge = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleScreen:)];
//    screenEdge.edges = UIRectEdgeLeft;
//    [self.view addGestureRecognizer:screenEdge];
//}
//-(void)handleScreen:(UIScreenEdgePanGestureRecognizer *)sender{
//    CGPoint sliderdistance = [sender translationInView:self.view];
//    if (sliderdistance.x>self.view.bounds.size.width/3) {
//        [self back];
//    }
//    //NSLog(@"%f",sliderdistance.x);
//}
-(void)back
{
    //[self.navigationController popViewControllerAnimated:YES];
     self.primaryNum = 0;
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //根据预选值，选择相应的价格区间
    NSLog(@"%ld",self.primaryNum);
    if (self.primaryNum>1000) {
        UIButton *but = [self.view viewWithTag:self.primaryNum];
        but.selected = YES;
    }else if(self.primaryNum == 7){
        _rangeSlider.leftValue = self.MinPricecondition.floatValue;
        _rangeSlider.rightValue = self.MaxPricecondition.floatValue;
    }else if(self.primaryNum == 8){
        lowPrice.text = self.MinPricecondition;
        tallPrice.text = self.MaxPricecondition;
    }
    
}
-(void)creatNav{
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,55,15)];
    [leftBtn setImage:[UIImage imageNamed:@"fanhuian"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"fanhuian"] forState:UIControlStateHighlighted];
    leftBtn.imageEdgeInsets = UIEdgeInsetsMake(-1, -10, 0, 50);
    [leftBtn setTitle:@"返回" forState:UIControlStateNormal];
    leftBtn.tag = 101;
    leftBtn.titleEdgeInsets = UIEdgeInsetsMake(0,-40, 0, 0);
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [leftBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *turnOff = [UIButton buttonWithType:UIButtonTypeCustom];
    turnOff.titleLabel.font = [UIFont systemFontOfSize:15];
    turnOff.frame = CGRectMake(0, 0, 30, 15);
    [turnOff addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [turnOff setTitle:@"重置"  forState:UIControlStateNormal];
    turnOff.tag = 102;
    turnOff.titleEdgeInsets = UIEdgeInsetsMake(-2, 0, 0, 0);
    [turnOff setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
   UIBarButtonItem * turnOffItem = [[UIBarButtonItem alloc] initWithCustomView:turnOff];
    self.navigationItem.rightBarButtonItem = turnOffItem;

}
-(void)creatUI{
    subTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height-64) style:UITableViewStylePlain];
    
    subTable.delegate = self;
    subTable.dataSource = self;
    subTable.rowHeight = 50;
    //注册复用cell
    [subTable registerClass:[ShaiXuanCell class] forCellReuseIdentifier:@"ShaiXuan"];
    
    //自定义尾视图
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 443)];//原来是158，388
    UIView *footSta = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 8)];
    footSta.backgroundColor = [UIColor lightGrayColor];
    footSta.alpha = 0.3;
    [footView addSubview:footSta];
    
    //自定义加反cell
    UIView *CellView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 8, kScreenSize.width, 42)];
    UIView *garyBack = [[UIView alloc] initWithFrame:CGRectMake(0, 49, kScreenSize.width, 1)];
    garyBack.backgroundColor = [UIColor lightGrayColor];
    garyBack.alpha = 0.3;
    [CellView1 addSubview:garyBack];
    UILabel *jiafanlabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 40,30)];
    jiafanlabel.text = @"加返";
    [CellView1 addSubview:jiafanlabel];
    //加返switch
    self.jiafanswitch = [[UISwitch alloc] initWithFrame:CGRectMake(kScreenSize.width-kScreenSize.width/5, 10, kScreenSize.width/5, 40)];
    [self.jiafanswitch addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventValueChanged];
    self.jiafanswitch.tag = 105;
    [CellView1 addSubview:self.jiafanswitch];
    
    //自定义及时确定cell
    UIView *CellView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 50, kScreenSize.width, 50)];
    UILabel *jishiLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10,kScreenSize.width/3, 40)];
    jishiLabel.text = @"及时确定";
    [CellView2 addSubview:jishiLabel];
    
    //及时确定switch
    self.jishiswitch = [[UISwitch alloc] initWithFrame:CGRectMake(kScreenSize.width-kScreenSize.width/5, 10, kScreenSize.width/5, 40)];
    [self.jishiswitch addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventValueChanged];
    self.jishiswitch.tag = 106;
    [CellView2 addSubview:self.jishiswitch];
    
    UIView *footSta1 = [[UIView alloc] initWithFrame:CGRectMake(0, 100, kScreenSize.width, 8)];
    footSta1.backgroundColor = [UIColor lightGrayColor];
    footSta1.alpha = 0.3;
    [footView addSubview:footSta1];
    
    //价格区间Cell
    UIView *CellView3 = [[UIView alloc]initWithFrame:CGRectMake(0, 108, kScreenSize.width, 50)];
    self.button = [[UIButton alloc] initWithFrame:CGRectMake(0 , 15, kScreenSize.width-50, 50)];
    [self.button setTitle:@"价格区间" forState:UIControlStateNormal];
    //self.button.titleEdgeInsets = UIEdgeInsetsMake(-40, -180, 0, 0) ;
    self.button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.button.titleEdgeInsets = UIEdgeInsetsMake(-40, 10, 0, 0);
    self.button.titleLabel.font = [UIFont systemFontOfSize:17];
    self.button.tag = 104;
    self.button.enabled = NO;
    [self.button addTarget:self  action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [CellView3 addSubview:self.button];
    //6个价格button
    NSArray *jiageArr = @[@"10000以下",@"20000以下",@"30000以下",@"40000以下",@"50000以下",@"60000以下"];
    for (int i = 0; i < 6; i++) {
        sixbutton = [[UIButton alloc] initWithFrame:CGRectMake(i%3*kScreenSize.width/3+kScreenSize.width/21, i/3*kScreenSize.height/12+150, 80, 26)];
        sixbutton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sixbtnbg"]];
        [sixbutton setTitle:jiageArr[i] forState:UIControlStateNormal];
        [sixbutton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [sixbutton setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        [sixbutton setBackgroundImage:[UIImage imageNamed:@"btnClick"] forState:UIControlStateSelected];
        sixbutton.titleLabel.font = [UIFont systemFontOfSize:12];
        [sixbutton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        sixbutton.tag = 1001+i;
        [footView addSubview:sixbutton];
    }
    
    //价格区间滑杆
    _rangeSlider = [[WLRangeSlider alloc] initWithFrame:CGRectMake(15,270 , kScreenSize.width-30, 30)];
     [_rangeSlider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventAllTouchEvents];

    [footView addSubview:_rangeSlider];
    
    lowPlabel.frame = CGRectMake(18, 250, 50, 30);
    lowPlabel.text = @"¥0";
    lowPlabel.font = [UIFont systemFontOfSize:12];
    lowPlabel.textColor = [UIColor orangeColor];
   
    tallPlabel.frame = CGRectMake(kScreenSize.width-kScreenSize.width/7, 250, 50, 30);
    tallPlabel.text = @"¥60000";
    tallPlabel.font = [UIFont systemFontOfSize:12];
    tallPlabel.textColor = [UIColor orangeColor];
   
    //自定义价格
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 322, kScreenSize.width/3, 50)];//原290
    label.text = @"自定义价格";
    
    
    lowPrice = [[UITextField alloc] initWithFrame:CGRectMake(kScreenSize.width/3+6, 335, 80, 25)];
    lowPrice.background = [UIImage imageNamed:@"jiagebian"];
    lowPrice.delegate = self;
    lowPrice.tag = 210;
    lowPrice.placeholder = @"  ¥";
   [lowPrice setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    UIView *midView = [[UIView alloc] initWithFrame:CGRectMake(kScreenSize.width-kScreenSize.width/2+kScreenSize.width/8, 345, 15, 1)];
    midView.backgroundColor = [UIColor lightGrayColor];
    
    
    tallPrice = [[UITextField alloc] initWithFrame:CGRectMake(kScreenSize.width-kScreenSize.width/3+kScreenSize.width/20, 335, 80, 25)];
    tallPrice.background = [UIImage imageNamed:@"jiagebian"];
    tallPrice.delegate = self;
    tallPrice.tag = 220;
    tallPrice.placeholder = @"  ¥";
    [tallPrice setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    //确定按钮上面的一条线
    UIView *qdTop = [[UIView alloc] initWithFrame:CGRectMake(0, 390, kScreenSize.width, 1)];
    qdTop.backgroundColor = [UIColor lightGrayColor];
    qdTop.alpha = 0.8;
    
    //确定按钮
    UIButton *centerBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 398, kScreenSize.width-30, 30)];
    centerBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"quedingbg"]];
    [centerBtn setTitle:@"确定" forState:UIControlStateNormal];
    [centerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [centerBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    centerBtn.tag = 107;
    

    
    
    [footView addSubview:lowPlabel];
    [footView addSubview:tallPlabel];
    [footView addSubview:label];
    [footView addSubview:lowPrice];
    [footView addSubview:midView];
    [footView addSubview:tallPrice];
    [footView addSubview:qdTop];
    [footView addSubview:centerBtn];
    [footView addSubview:footSta];
    [footView addSubview:CellView1];
    [footView addSubview:CellView2];
    [footView addSubview:footSta1];
    [footView addSubview:CellView3];
    
    subTable.tableFooterView = footView;
    [self.view addSubview:subTable];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat tabscr = subTable.contentOffset.y;
    if (tabscr <= 0) {
        CGPoint point = CGPointMake(0, 0);
        subTable.contentOffset = point;
    }
}
//收键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [lowPrice resignFirstResponder];
    [tallPrice resignFirstResponder];
    return YES;
}
#pragma  - mark 判断字符串内容是否为纯数字
- (BOOL)isPureInt:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    int val;
    
    if ([scan scanInt:&val] && [scan isAtEnd]) {
        return YES;
    }else if([string isEqualToString:@""] && [scan isAtEnd]){
        return YES;
    }
    return NO;
}
#pragma  - mark TextFieldDelegate
-(void)textFieldDidEndEditing:(UITextField *)textField{
    self.primaryNum = 8;
    if (textField.tag == 210) {
        [self.conditionDic setObject:textField.text forKey:@"MinPrice"];
        NSLog(@"textfield--:%@",textField.text);
    }else if(textField.tag == 220){
        [self.conditionDic setObject:textField.text forKey:@"MaxPrice"];
        NSLog(@"textfield--:%@",textField.text);
    }
    [lowPrice resignFirstResponder];
    [tallPrice resignFirstResponder];
    
    //改变六个button和滑杆的选种状态
    lowPlabel.textColor = [UIColor lightGrayColor];
    tallPlabel.textColor = [UIColor lightGrayColor];
    _rangeSlider.trackHighlightTintColor=[UIColor lightGrayColor];
    for (NSInteger qw =1001; qw<1007; qw++) {
        UIButton *myButton1 = [self.view viewWithTag:qw];
        myButton1.selected = NO;
    }
    
}

//滑杆出发事件
- (void)valueChanged:(WLRangeSlider *)slider{
    self.primaryNum = 7;
    lowPrice.text = nil;
    tallPrice.text = nil;
    //左滑动按钮
    lowPlabel.text = [NSString stringWithFormat:@"¥%ld",(NSInteger)slider.leftValue];
    NSInteger po =(NSInteger)slider.leftValue;
    float ty = (float)po/60000;
    float haha = _rangeSlider.frame.size.width-30;
    lowPlabel.frame = CGRectMake(ty*haha+15, 250, 50, 30);
    
    //右滑动按钮
    tallPlabel.text = [NSString stringWithFormat:@"¥%ld",(NSInteger)slider.rightValue];
    NSInteger qw =(NSInteger)slider.rightValue;
    float er = (float)qw/60000;
    NSLog(@"%0.4f---%ld",(float)qw/60000,(NSInteger)slider.rightValue);
    float heihei = _rangeSlider.frame.size.width-30;
    tallPlabel.frame = CGRectMake(er*heihei+15, 250, 50, 30);
    
    //增加筛选条件
    [self.conditionDic setObject:[NSString stringWithFormat:@"%ld",(NSInteger)slider.leftValue]  forKey:@"MinPrice"];
    [self.conditionDic setObject:[NSString stringWithFormat:@"%ld",(NSInteger)slider.rightValue] forKey:@"MaxPrice"];
    
    //改变button的不选中效果
    for (NSInteger qw =1001; qw<1007; qw++) {
        UIButton *myButton1 = [self.view viewWithTag:qw];
            myButton1.selected = NO;
    }
    //改变滑杆的选种效果
    lowPlabel.textColor = [UIColor orangeColor];
    tallPlabel.textColor = [UIColor orangeColor];
    _rangeSlider.trackHighlightTintColor=[UIColor orangeColor];
}
-(NSMutableDictionary *)conditionDic
{
    if (_conditionDic == nil) {
        self.conditionDic = [NSMutableDictionary dictionary];
    }
    return _conditionDic;
}
-(NSMutableArray *)conditionArr
{
    if (_conditionArr == nil) {
        _conditionArr = [NSMutableArray array];
    }
    return _conditionArr;
}
-(void)refereshSelectData
{
    NSArray *priceData = [NSArray arrayWithObject:@"价格区间"];
    [WriteFileManager saveData:priceData name:@"priceData"];
    NSMutableArray *arr = [NSMutableArray arrayWithObjects:@{@"123":@"456"} ,nil];
    [WriteFileManager WMsaveData:arr name:@"conditionSelect"];
}

-(void)btnClick:(UIButton *)button{
    [lowPrice resignFirstResponder];
    [tallPrice resignFirstResponder];
    for (NSInteger qw =1001; qw<1007; qw++) {
        if (button.tag == qw) {
            button.selected = YES;
            
        }else{
            UIButton *myButton1 = [self.view viewWithTag:qw];
            myButton1.selected = NO;
        }
    }
    switch (button.tag) {
        case 101:
        {//返回
            self.primaryNum = 0;
            [self dismissViewControllerAnimated:YES completion:nil];
        }
            break;
        case 102:
        {//重置
            NSLog(@"点击重置");
            //筛选条件置为nil
            self.conditionDic = nil;
            //lowPlabel.frame=CGRectMake(kScreenSize.width/3+6, 325, 80, 25);
           // tallPlabel.frame = CGRectMake(kScreenSize.width-kScreenSize.width/3+kScreenSize.width/20, 325, 80, 25);
            _rangeSlider.leftValue = 0.0;
            _rangeSlider.rightValue = 60000;
            [_rangeSlider updateLayerFrames];
            [self valueChanged:_rangeSlider];
            //两个输入框置为nil
            lowPrice.text = nil;
            tallPrice.text = nil;
            
            [self refereshSelectData];
            NSMutableAttributedString *pric = [[NSMutableAttributedString alloc] initWithString:@"价格区间"];
            
            NSArray *priceData = [NSArray arrayWithObject:@"价格区间"];
            [WriteFileManager saveData:priceData name:@"priceData"];
            
            [self.jiafanswitch setOn:NO];
            self.jishi = [NSMutableString stringWithFormat:@"0"];
            self.jiafan = [NSMutableString stringWithFormat:@"0"];
            [self.jishiswitch setOn:NO];
            
            self.subIndicateDataArr1 = [NSMutableArray arrayWithObjects:@" ",@" ",@" ",@" ",@" ",@" ",@" ",@" ",@" ",@" ", nil];
            self.goDateStart = [NSMutableString stringWithFormat:@""];
            self.goDateEnd = [NSMutableString stringWithFormat:@""];
            self.month = [NSMutableString stringWithFormat:@""];
            [subTable reloadData];
            //改变滑杆的选种效果以及位置
            lowPlabel.textColor = [UIColor lightGrayColor];
            tallPlabel.textColor = [UIColor lightGrayColor];
            _rangeSlider.trackHighlightTintColor=[UIColor lightGrayColor];
        }
            break;
        case 104:
        {//价格区间
            NSLog(@"点击价格区间");
        }
            break;
        case 105:
        {//加反switch
            NSLog(@"加反变化");
            if (self.jiafanswitchisOn) {
                NSLog(@"已经打开");
                self.jiafan = [NSMutableString stringWithFormat:@"1"];
                self.jiafanswitchisOn = NO;
            }else{
                self.jiafan = [NSMutableString stringWithFormat:@"0"];
                self.jiafanswitchisOn = YES;
            }
        }
            break;
        case 106:
        {//及时switch
            NSLog(@"及时变化");
            if (self.jishiswitchisOn) {
                NSLog(@"已经打开");
                self.jishi = [NSMutableString stringWithFormat:@"1"];
                self.jishiswitchisOn = NO;
            }else{
                self.jishi = [NSMutableString stringWithFormat:@"0"];
                self.jishiswitchisOn = YES;
            }
        }
            break;
        case 107:
        {//确定按钮
            BOOL minBool = [self isPureInt:lowPrice.text];
            BOOL maxBool = [self isPureInt:tallPrice.text];
            long minPrice = [lowPrice.text longLongValue];
            long maxPrice = [tallPrice.text longLongValue];
            BOOL minBiger = minPrice>maxPrice;
            
            if (minBool  && maxBool && !minBiger) {
                NSLog(@"符合条件");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh" object:[NSString stringWithFormat:@"%ld",self.primaryNum] userInfo:self.conditionDic];
                
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            else if(!minBool || !maxBool ){
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"抱歉" message:@"您的输入并非纯数字，请重新输入" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
                [alert show];
                lowPrice.text = @"";
                tallPrice.text = @"";
                
            }else if (minBiger){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"抱歉" message:@"您输入的最小价格大于最大价格，请重新输入" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
                [alert show];
                lowPrice.text = @"";
                tallPrice.text = @"";
            }else if ( maxPrice == 0){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"抱歉" message:@"价格不能为0，请重新输入" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
                [alert show];
                lowPrice.text = @"";
                tallPrice.text = @"";
            }

        }
            break;
        //以下6个是价格btn
        case 1001:
        {
            //NSLog(@"10000以下");
            [self.conditionDic setObject:@"0" forKey:@"MinPrice"];
            [self.conditionDic setObject:@"10000" forKey:@"MaxPrice"];
            lowPlabel.textColor = [UIColor lightGrayColor];
            tallPlabel.textColor = [UIColor lightGrayColor];
            _rangeSlider.trackHighlightTintColor=[UIColor lightGrayColor];
            lowPrice.text = nil;
            tallPrice.text = nil;
            self.primaryNum =1001;
        }
            break;
        case 1002:
        {
           // NSLog(@"20000以下");
            [self.conditionDic setObject:@"0" forKey:@"MinPrice"];
            [self.conditionDic setObject:@"20000" forKey:@"MaxPrice"];
            lowPlabel.textColor = [UIColor lightGrayColor];
            tallPlabel.textColor = [UIColor lightGrayColor];
            _rangeSlider.trackHighlightTintColor=[UIColor lightGrayColor];
            lowPrice.text = nil;
            tallPrice.text = nil;
            self.primaryNum =1002;
        }
            break;
        case 1003:
        {
           // NSLog(@"30000以下");
            [self.conditionDic setObject:@"0" forKey:@"MinPrice"];
            [self.conditionDic setObject:@"30000" forKey:@"MaxPrice"];
            lowPlabel.textColor = [UIColor lightGrayColor];
            tallPlabel.textColor = [UIColor lightGrayColor];
            _rangeSlider.trackHighlightTintColor=[UIColor lightGrayColor];
            lowPrice.text = nil;
            tallPrice.text = nil;
            self.primaryNum =1003;
        }
            break;
        case 1004:
        {
            //NSLog(@"40000以下");
            [self.conditionDic setObject:@"0" forKey:@"MinPrice"];
            [self.conditionDic setObject:@"40000" forKey:@"MaxPrice"];
            lowPlabel.textColor = [UIColor lightGrayColor];
            tallPlabel.textColor = [UIColor lightGrayColor];
            _rangeSlider.trackHighlightTintColor=[UIColor lightGrayColor];
            lowPrice.text = nil;
            tallPrice.text = nil;
            self.primaryNum =1004;
        }
            break;
        case 1005:
        {
            //NSLog(@"50000以下");
            [self.conditionDic setObject:@"0" forKey:@"MinPrice"];
            [self.conditionDic setObject:@"50000" forKey:@"MaxPrice"];
            lowPlabel.textColor = [UIColor lightGrayColor];
            tallPlabel.textColor = [UIColor lightGrayColor];
            _rangeSlider.trackHighlightTintColor=[UIColor lightGrayColor];
            lowPrice.text = nil;
            tallPrice.text = nil;
            self.primaryNum =1005;
        }
            break;
        case 1006:
        {
            //NSLog(@"60000以下");
            [self.conditionDic setObject:@"0" forKey:@"MinPrice"];
            [self.conditionDic setObject:@"60000" forKey:@"MaxPrice"];
            lowPlabel.textColor = [UIColor lightGrayColor];
            tallPlabel.textColor = [UIColor lightGrayColor];
            _rangeSlider.trackHighlightTintColor=[UIColor lightGrayColor];
            lowPrice.text = nil;
            tallPrice.text = nil;
            self.primaryNum =1006;
        }
            break;
            
        default:
            break;
    }
}
-(void)passTheButtonValue:(NSString *)value andName:(NSString *)name
{
    //self.subView.hidden = NO;
    [self.conditionDic setObject:value forKey:@"GoDate"];
    self.month = [NSMutableString stringWithFormat:@"%@",name];
    NSLog(@"-----------------productList 获得的name is %@ value is %@",name,value);
    [subTable reloadData];
}
#pragma  mark -priceDelegate
-(void)passTheMinPrice:(NSString *)min AndMaxPrice:(NSString *)max
{
    NSLog(@"价格筛选--------%@------------%@------",min,max);
    //self.subView.hidden = NO;
  
    if (![max  isEqual: @""]) {
        
        [self.conditionDic setObject:min forKey:@"MinPrice"];
        [self.conditionDic setObject:max forKey:@"MaxPrice"];
        
        NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"价格区间：%@元－%@元",min,max]];
        [self.button setTitle:[NSString stringWithFormat:@"价格区间：%@元－%@元",min,max] forState:UIControlStateNormal];
        [attriString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(5, attriString.length - 5)];
        [self.priceBtnOutlet setAttributedTitle:attriString forState:UIControlStateNormal];
        
        NSArray *priceData = [NSArray arrayWithObjects:min,max,self.priceBtnOutlet.titleLabel.text ,nil];
        [WriteFileManager saveData:priceData name:@"priceData"];
        
    }else if ([max isEqualToString:@"0"]){
        
        [self.priceBtnOutlet setTitle:@"价格区间" forState:UIControlStateNormal];
        [self.conditionDic setObject:@"" forKey:@"MinPrice"];
        [self.conditionDic setObject:@"" forKey:@"MaxPrice"];
        
    }else if ([max  isEqual: @""]){
        
        [self.priceBtnOutlet setTitle:@"价格区间" forState:UIControlStateNormal];
        [self.conditionDic setObject:@"" forKey:@"MinPrice"];
        [self.conditionDic setObject:@"" forKey:@"MaxPrice"];
    }
}

#pragma mark - ChooseDayViewControllerDelegate
- (void)finishChoosedTimeArr:(NSArray *)timeArr andType:(timeType)type
{
    //self.subView.hidden = NO;
    if (type == timePick) {
        self.goDateStart = timeArr[0];
        self.goDateEnd = timeArr[1];
        // self.dressView.goDateText = [NSString stringWithFormat:@"%@~%@",self.goDateStart,self.goDateEnd];
    }else{
        self.goDateStart = timeArr[0];
        self.goDateEnd = timeArr[1];
        // self.createDateStart = timeArr[0];
        // self.createDateEnd = timeArr[1];
        // self.dressView.createDateText = [NSString stringWithFormat:@"%@~%@",self.createDateStart,self.createDateEnd];
    }
    [self.conditionDic setObject:_goDateStart forKey:@"StartDate"];
    [self.conditionDic setObject:_goDateEnd forKey:@"EndDate"];
    [subTable reloadData];
}
#pragma mark TableViewDataSource & UDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShaiXuanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShaiXuan" forIndexPath:indexPath];
    cell.str = dataArr[indexPath.row];
    NSLog(@"%@",cell.str);
    if (indexPath.row == 2) {
        if (_goDateEnd.length>3) {
            cell.contentStr = [NSString stringWithFormat:@"%@~%@",_goDateStart,_goDateEnd];
        }else if (_goDateEnd.length<=2){
            cell.contentStr = @"不限";
        }
        if (_month.length>1) {
            cell.contentStr = [NSString stringWithFormat:@"%@",_month];
        }
    }else if (indexPath.row != 2) {
        
        cell.contentStr = self.subIndicateDataArr1[indexPath.row];
        NSString *detailStr = self.subIndicateDataArr1[indexPath.row];
        if (!detailStr.length || [detailStr isEqualToString:@" "]) {
            cell.contentStr = @"不限";
        }else{
            cell.contentStr = self.subIndicateDataArr1[indexPath.row];
        }
    }

    
    [cell showdataWithString:cell.str];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [lowPrice resignFirstResponder];
    [tallPrice resignFirstResponder];
    if (indexPath.row == 2) {
        ChooseDayViewController *choose = [[ChooseDayViewController alloc]init];
        choose.delegate = self;
        BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
        [MobClick event:@"FindProductStartTimeSX" attributes:dict];
        
        NSInteger a = (6*(indexPath.section)) + (indexPath.row);//获得当前点击的row行数
        NSDictionary *conditionDic = _conditionArr[a];
        NSLog(@"______%@",_conditionArr[a]);
        choose.buttons = conditionDic;
        choose.needMonth = @"1";
        //subTable.hidden = YES;
        NSLog(@"__%@",_conditionArr[a]);
        [self.navigationController pushViewController:choose animated:YES];
       // UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:choose];
        //[self presentViewController:choose animated:YES completion:nil];
        //[self.navigationController pushViewController:choose animated:YES];
    }else if(indexPath.row != 2){
        switch (indexPath.row) {
            case 0:{
                BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
                [MobClick event:@"FindProductDestinationSX" attributes:dict];
            }
                break;
            case 1:
            {
                BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
                [MobClick event:@"FindProductStartCitySX" attributes:dict];
                
            }
                break;
            case 3:
            {
                BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
                [MobClick event:@"FindProductDayNumberSX" attributes:dict];
                
            }
                break;
            case 4:
            {
                BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
                [MobClick event:@"FindProductVisitLineSX" attributes:dict];
                
            }
                break;
            case 5:
            {
                BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
                [MobClick event:@"FindProductSupplierSX" attributes:dict];
                
            }
                break;
            case 6:
            {
                BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
                [MobClick event:@"FindProductThemeSX" attributes:dict];
                
            }
                break;
            case 7:
            {
                BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
                [MobClick event:@"FindProductHotelTypeSX" attributes:dict];
                
            }
                break;
            case 8:
            {
                BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
                [MobClick event:@"FindProductTripModeSX" attributes:dict];
                
            }
                break;
            case 9:
            {
                BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
                [MobClick event:@"FindProductShipCompanySX" attributes:dict];
                
            }
                break;

            default:
                break;
        }
        NSInteger a = indexPath.row;//获得当前点击的row行数
        //    NSLog(@"-------------a is %ld  ----_conditionArr[a] is %@------------",(long)a,_conditionArr[a]);
        NSDictionary *conditionDic = _conditionArr[a];
        NSLog(@"------%@",_conditionArr[indexPath.row]);
        ConditionSelectViewController *conditionVC = [[ConditionSelectViewController alloc] init];
        
        conditionVC.delegate = self;
        
        conditionVC.conditionDic = conditionDic;
        
        NSArray *arr = [NSArray arrayWithObjects:[NSString  stringWithFormat:@"%ld",(long)
                                                  indexPath.section],[NSString  stringWithFormat:@"%ld",(long)indexPath.row], nil];
        conditionVC.superViewSelectIndexPath = arr;//取出第几行被选择
        
        //取出conditionVC的navTile
        //NSString *conditionVCTile;
        conditionVC.title = dataArr[indexPath.row];
       //self.subView.hidden = YES;
        [self.navigationController pushViewController:conditionVC animated:YES];
        //[self presentViewController:conditionVC animated:YES completion:nil] ;

    }
}
#pragma  mark - conditionDetail delegate//key 指大字典的key value指字典中某一子value的值
-(void)passKey:(NSString *)key andValue:(NSString *)value andSelectIndexPath:(NSArray *)selectIndexPath andSelectValue:(NSString *)selectValue
{
    //确认列表选择值
    // self.conditionDic = [NSMutableDictionary dictionary];
    
    if (value) {
        [self.conditionDic setObject:value forKey:key];
        
        NSLog(@"-------------传过来的key is %@------------",key);
//        if ([selectIndexPath[0]isEqualToString:@"0"]) {
//            
//            NSInteger a = [selectIndexPath[1] integerValue];//分析selected IndexPath.row的值
//            
//            self.subIndicateDataArr1[a] = selectValue;
//            
//        }else if ([selectIndexPath[0] isEqualToString:@"1"]){
//            
//            NSInteger a = [selectIndexPath[1] integerValue];
//            
//            self.subIndicateDataArr2[a] = selectValue;
//        }
         NSInteger a = [selectIndexPath[1] integerValue];
        self.subIndicateDataArr1[a] = selectValue;
        //self.subView.hidden = NO;
        //NSLog(@"subindicateArr 1 :------------%@------------- 2:%@--------------- ",_subIndicateDataArr1,_subIndicateDataArr2);
        [subTable reloadData];
        //[self loadDataSourceWithCondition];
        
//    }else if (!value){
//        self.subView.hidden = NO;
//    }
    
    
    
    NSLog(@"-----------conditionDic is %@--------",self.conditionDic);
    
}
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    _month = nil;
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
