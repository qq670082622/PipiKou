//
//  attachmentViewController.m
//  ShouKeBao
//
//  Created by 吴铭 on 15/6/5.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "attachmentViewController.h"
//#import "MLPhotoBrowserSignleViewController.h"
#import "WriteFileManager.h"
#import "MBProgressHUD+MJ.h"
#import "UIImageView+WebCache.h"
#import "MobClick.h"
@interface attachmentViewController ()
@property (nonatomic ,strong) NSMutableArray *dataSource;
@property(nonatomic , assign) BOOL isEditing;
@property (weak, nonatomic) IBOutlet UIView *subView;
@property(weak,nonatomic) UIButton *btn1;
@property(weak,nonatomic) UIButton *btn2;
@property(weak,nonatomic) UIButton *btn3;
@property(weak,nonatomic) UIButton *btn4;
@property(weak,nonatomic) UIButton *btn5;
@property(weak,nonatomic) UIButton *btn6;
@property(weak,nonatomic) UIButton *btn7;
@property(weak,nonatomic) UIButton *btn8;
@property(weak,nonatomic) UIButton *btn9;
- (IBAction)deleteAction:(id)sender;
@property(nonatomic,strong) NSMutableArray *deleteArr;
@property (weak, nonatomic)  UIView *imageSuperView;
@property (weak, nonatomic)  UIImageView *imgV;

@end

@implementation attachmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"证件附件旧代码";
    // Do any additional setup after loading the view from its nib.
    [self loadData];
    [self setUpRightButton];
    self.isEditing = NO;
    //61,49
    CGFloat screenW = [[UIScreen mainScreen] bounds].size.width;
    CGFloat screenH = [[UIScreen mainScreen] bounds].size.height;
    UIView *back = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenW, screenH)];
    back.backgroundColor = [UIColor blackColor];
    
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(screenW/2, screenH/2,0, 0)];
    [back addSubview:imgv];
    imgv.userInteractionEnabled = YES;
    self.imageSuperView = back;
    self.imgV = imgv;
    [self.view addSubview:_imageSuperView];
    self.imageSuperView.hidden = YES;
    [self.imgV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideImageSuperView)]];
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"CustomerattachmentView"];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"CustomerattachmentView"];
}

-(void)hideImageSuperView
{
    self.imageSuperView.hidden = YES;
}

-(void)setUpRightButton{
    
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStyleBordered target:self action:@selector(EditCustomerDetail)];
    
    self.navigationItem.rightBarButtonItem= barItem;
}

-(void)EditCustomerDetail
{
   
    if (self.subView.hidden == YES && !_isEditing) {
        self.subView.hidden = NO;
        self.isEditing = YES;
        [self setBtnsHideens];
        self.navigationItem.rightBarButtonItem.title = @"取消";
      
        
    }else if (self.subView.hidden == NO && self.isEditing){
        
        self.subView.hidden = YES;
       self.isEditing = NO;
        self.navigationItem.rightBarButtonItem.title = @"编辑";
         [self setBtnsHideens];
    }
}

-(void)setBtnsHideens
{
    if (_isEditing) {
         self.btn1.hidden = NO;
         self.btn2.hidden = NO;
         self.btn3.hidden = NO;
         self.btn4.hidden = NO;
         self.btn5.hidden = NO;
         self.btn6.hidden = NO;
         self.btn7.hidden = NO;
         self.btn8.hidden = NO;
         self.btn9.hidden = NO;
    }else if (!_isEditing){
        self.btn1.hidden = YES;
        self.btn2.hidden = YES;
        self.btn3.hidden = YES;
        self.btn4.hidden = YES;
        self.btn5.hidden = YES;
        self.btn6.hidden = YES;
        self.btn7.hidden = YES;
        self.btn8.hidden = YES;
        self.btn9.hidden = YES;

    }
}

-(NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        self.dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
-(NSMutableArray *)deleteArr
{
    if (_deleteArr == nil) {
        self.deleteArr = [NSMutableArray array];
    }
    return _deleteArr;
}
-(void)loadData
{
//    [self.dataSource addObject:@"test1"];
//    [self.dataSource addObject:@"test2"];
//    [self.dataSource addObject:@"test1"];
//    [self.dataSource addObject:@"test2"];
//    [self.dataSource addObject:@"test1"];
//    [self.dataSource addObject:@"test2"];
//    [self.dataSource addObject:@"test1"];
    NSArray * picArray = [self.picUrl componentsSeparatedByString:@","];
    for (NSString * str in picArray) {
        [self.dataSource addObject:str];
    }
//    if (_picUrl.length<6) {
//        [self.dataSource removeAllObjects];
//        [self.dataSource addObject:@"test1"];
//    }
     NSMutableArray *muA = [NSMutableArray arrayWithArray:[WriteFileManager readData:@"attach"]];
    if (self.dataSource.count>0 && (![muA containsObject:_customerId]) && _picUrl.length>6) {
        CGFloat marginX = 25;
        CGFloat marginY = 15;
        CGFloat screenW = [[UIScreen mainScreen] bounds].size.width;
        CGFloat imgW = (screenW - 4*marginX)/3;
        //bangdingshouji
        for (int i = 0; i<self.dataSource.count; i++) {
            UIImageView *imgV = [[UIImageView alloc] init];
            [imgV sd_setImageWithURL:[NSURL URLWithString:[self.dataSource objectAtIndex:i]]];
            int row = i/3;
            int col = i%3;
            CGFloat imgX = marginX + col*(marginX + imgW);
            CGFloat imgY = marginY + row*(marginY + imgW);
            imgV.frame = CGRectMake(imgX, imgY, imgW, imgW);
            imgV.userInteractionEnabled = YES;
            [imgV setTag:i];
            
            
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setBackgroundImage:[UIImage imageNamed:@"attachmentNo"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"attachmentYes"] forState:UIControlStateSelected];
            CGFloat btnW = 30;
            CGFloat btnX = (imgW - btnW)/2;
            btn.frame = CGRectMake(btnX, btnX, btnW, btnW);
            [btn addTarget:self action:@selector(changePic:) forControlEvents:UIControlEventTouchUpInside];
            btn.hidden = YES;
            [imgV addSubview:btn];
            if (i==0) {
                self.btn1 = btn;
            }else if (i==1){
                self.btn2 = btn;
            }else if (i==2){
                self.btn3 = btn;
            }else if (i==3){
                self.btn4 = btn;
            }else if (i==4){
                self.btn5 = btn;
            }else if (i==5){
                self.btn6 = btn;
            }else if (i==6){
                self.btn7 = btn;
            }else if (i==7){
                self.btn8 = btn;
            }else if (i==8){
                self.btn9 = btn;
            }
            
            
            
            [imgV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(beSelected:)]];
            [self.view addSubview:imgV];
        }

       // [self.view bringSubviewToFront:self.imgV];
    }else{
        UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:@"抱歉" message:@"该客户还没有附件哦（通过证件神器扫描身份证或者护照可得到附件照片，并在此处查看）" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alrt show];
    }
  }

-(void)changePic:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    if (btn.selected == NO) {
        [btn setSelected:YES];
    }else if (btn.selected == YES){
        [btn setSelected:NO];
    }
}

-(void)beSelected:(UIGestureRecognizer *)sender
{
    
    int selectTag  = (int)sender.view.tag;
    NSArray *arr =  self.view.subviews;
    NSMutableArray *tagArr = [NSMutableArray array];
    for (UIView *view in arr) {
        [tagArr addObject:[NSString stringWithFormat:@"%ld",(long)view.tag]];
    }
    
    NSMutableArray *selectArr = [NSMutableArray array];
    for (int i = 0; i<tagArr.count; i++) {
        if (selectTag == [tagArr[i] integerValue]) {
            
            [selectArr addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    
    int yesInt = [[selectArr firstObject] intValue];//当前被选中的index为几
    NSLog(@"被选中的是第%d个",yesInt);
    
//    self.imageSuperView.hidden = NO;
//    if (yesInt == 0) {
//        self.imgV.image = [UIImage imageNamed:self.dataSource[0]];
        [self.imgV sd_setImageWithURL:[NSURL URLWithString:[self.dataSource objectAtIndex:yesInt]]];
//        MLPhotoBrowserSignleViewController *browserVc = [[MLPhotoBrowserSignleViewController alloc] init];
//        [browserVc showHeadPortrait:self.imgV originUrl:nil];

//    }else if (yesInt != 0){
//        self.imgV.image = [UIImage imageNamed:self.dataSource[yesInt - 1]];
//        MLPhotoBrowserSignleViewController *browserVc = [[MLPhotoBrowserSignleViewController alloc] init];
//        [browserVc showHeadPortrait:self.imgV originUrl:nil];
//        
//
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)deleteAction:(UIButton *)sender {
    MBProgressHUD *hudView = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    hudView.labelText = @"删除中...";
    [hudView show:YES];
    self.navigationItem.rightBarButtonItem.title = @"编辑";
    self.subView.hidden = YES;
    self.isEditing = NO;
    if (self.btn1.selected == YES) {
        [self.deleteArr addObject:@"0"];
    }
    if (self.btn2.selected == YES) {
        [self.deleteArr addObject:@"1"];
    }
    if (self.btn3.selected == YES) {
        [self.deleteArr addObject:@"2"];
    }
    if (self.btn4.selected == YES) {
        [self.deleteArr addObject:@"3"];
    }
    if (self.btn5.selected == YES) {
        [self.deleteArr addObject:@"4"];
    }
    if (self.btn6.selected == YES ) {
        [self.deleteArr addObject:@"5"];
    }
    if (self.btn7.selected == YES) {
        [self.deleteArr addObject:@"6"];
    }
    if (self.btn8.selected == YES) {
        [self.deleteArr addObject:@"7"];
    }
    if (self.btn9.selected == YES) {
        [self.deleteArr addObject:@"8"];
    }
    NSLog(@"将被删除的图片下表依次是%@~~~",_deleteArr);
   

    NSMutableArray *muArr = [NSMutableArray arrayWithArray:[WriteFileManager readData:@"attach"]];
    [muArr addObject:_customerId];
    [WriteFileManager saveData:muArr name:@"attach"];
   //成功保存 NSLog(@"保存后的arr is %@",[NSMutableArray arrayWithArray:[WriteFileManager readData:@"attach"]]);
    [self setBtnsHideens];
    [self.navigationController popViewControllerAnimated:YES];
    hudView.labelText = @"删除成功...";
    [hudView hide:YES afterDelay:0.4];

}

@end
