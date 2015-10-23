//
//  PersonIDViewController.m
//  ShouKeBao
//
//  Created by 吴铭 on 15/5/29.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "PersonIDViewController.h"
#import "ScanningViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "MobClick.h"
#import "BaseClickAttribute.h"
@interface PersonIDViewController ()
@property (weak, nonatomic) IBOutlet UIView *viewPreview;

@property (strong, nonatomic) IBOutlet UIImageView *boxView;
@property (weak, nonatomic) IBOutlet UIImageView *wangge;
@property (weak, nonatomic) IBOutlet UILabel *warningLab1;
@property (weak, nonatomic) IBOutlet UILabel *warningLab2;

@property (weak, nonatomic) IBOutlet UIView *loadingView;

//@property (weak, nonatomic) IBOutlet UIImageView *photoImageview;
@property (weak,nonatomic) UIImageView *line;
@property (nonatomic) BOOL isReading;
@property (strong, nonatomic) CALayer *scanLayer;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) BOOL changeLab;
//----------------------------------------
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;


//拍照按钮
-(BOOL)startReading;
-(void)stopReading;


@end

@implementation PersonIDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
   
}


-(void)setLoading
{
    CGFloat imgX = CGRectGetMaxX(self.wangge.frame);
    CGFloat imgY = self.wangge.frame.origin.y;
    CGFloat imgW = 8;
    CGFloat imgH = self.wangge.frame.size.height;
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(imgX, imgY, imgW, imgH)];
    line.image = [UIImage imageNamed:@"heiLine"];
    [self.wangge addSubview:line];
    self.line = line;
    
    NSTimer *time = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(runTheLine:) userInfo:nil repeats:YES];
    self.timer = time;
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

-(void)runTheLine:(NSTimer *)timer
{
    //定时事件1
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *result = [def objectForKey:@"needLoad"];
    if ([result isEqualToString:@"1"]) {
        self.boxView.hidden = YES;
        self.loadingView.hidden = NO;
    }else if([result isEqualToString:@"0"]){
        self.boxView.hidden = NO;
        self.loadingView.hidden = YES;
    }

    //定时事件2
//    if (_changeLab == YES) {
//        self.warningLab1.hidden = NO;
//        self.warningLab2.hidden = YES;
//       
//        self.changeLab = NO;
//    }else if (_changeLab == NO){
//        self.warningLab1.hidden = YES;
//        self.warningLab2.hidden = NO;
//
//        self.changeLab = YES;
//    }

    [UIView animateWithDuration:0.1 animations:^{
        self.line.transform = CGAffineTransformMakeTranslation(-10, 0);
    }];
    

    
    CGRect frame = _line.frame;

    if (frame.origin.x < 0) {
       
        frame.origin.x = CGRectGetMaxX(self.wangge.frame);
        _line.frame = frame;
        
    }else{
        frame.origin.x -= 25;
        [UIView animateWithDuration:0.1 animations:^{
            _line.frame = frame;
        }];
    }
    
   
   
    
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"ShouKeBaoPersonIDView"];
//    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
//    [MobClick event:@"ShouKeBaoPersonIDViewNum" attributes:dict];
//    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
//    [MobClick event:@"ShoukeBaouserIDTableviewNum" attributes:dict];

//    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
//    [def setObject:@"0" forKey:@"needLoad"];
//    [def synchronize];
    
  
    [self.line removeFromSuperview];
       [self setLoading];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"ShouKeBaoPersonIDView"];

    [self.timer invalidate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
