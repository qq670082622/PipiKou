//
//  QRCodeViewController.m
//  ShouKeBao
//
//  Created by 吴铭 on 15/4/3.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "QRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "URLOpenFromQRCodeViewController.h"
#import "WMAnimations.h"
#import "ProduceDetailViewController.h"
#import "ScanningViewController.h"
#import "MobClick.h"
#import "BaseClickAttribute.h"
#import "NSString+FKTools.h"
//
@interface QRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate,notifiQRCodeToRefresh,notiQRCToStartRuning>
@property (weak, nonatomic) IBOutlet UIView *viewPreview;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;




@property (strong, nonatomic) UIView *boxView;
@property (nonatomic) BOOL isReading;
@property (strong, nonatomic) CALayer *scanLayer;
@property (strong,nonatomic) NSTimer *timer;
-(BOOL)startReading;
-(void)stopReading;

//捕捉会话
@property (nonatomic, strong) AVCaptureSession *captureSession;
//展示layer
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, strong) AVCaptureConnection * connection;
@end

@implementation QRCodeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.title = @"二维码扫描";
    _captureSession = nil;
    _isReading = NO;
    //判断摄像头访问权限
    NSString * mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus  authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    
    if (authorizationStatus == AVAuthorizationStatusRestricted|| authorizationStatus == AVAuthorizationStatusDenied) {
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"无法访问相机" message:@"请在【设置->隐私->相机】下允许“旅游圈”访问相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        
    }else{
    }
//    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,15,20)];
//    [leftBtn setBackgroundImage:[UIImage imageNamed:@"backarrow"] forState:UIControlStateNormal];
//    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
//    
//    self.navigationItem.leftBarButtonItem= leftItem;

    CGFloat viewW = [[UIScreen mainScreen] bounds].size.width;
    
    CGFloat screenH = [[UIScreen mainScreen] bounds].size.height;
    CGFloat viewH = screenH - 157;
    //CGFloat viewH = screenH ;
    self.viewPreview.frame = CGRectMake(0, 0, viewW, viewH);
    [self startReading];

    [self openUrl];
    
    
    
}
- (void)back{
    [self.navigationController popViewControllerAnimated:NO];

}
#pragma mark 设置焦距
- (void)setFocalLength:(CGFloat)lengthScale
{
    [UIView animateWithDuration:0.5 animations:^{
        [_videoPreviewLayer setAffineTransform:CGAffineTransformMakeScale(lengthScale, lengthScale)];
        _connection.videoScaleAndCropFactor = lengthScale;
    }];
}

-(void)listenNeedLoad
{
    //    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    //    NSString *result = [def objectForKey:@"needLoad"];
    //    if ([result isEqualToString:@"1"]) {
    //    [self stopReading];
    //    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    _isOpen = YES;
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"ShouKeBaoQRCodeView"];
    
    [self.captureSession startRunning];//当QR被父vc remove时候关闭识别，当被添加的时候打开识别
    
    //------------当唤出证件神器 以下代码放viewdidload上
    
}

-(void)notiQRCToStartRuning
{
    [self startReading];
}
-(void)refresh
{
    [self startReading];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"ShouKeBaoQRCodeView"];
    
    [self.captureSession stopRunning];
}
//实现startReading方法（这可就是重点咯）
- (BOOL)startReading {
    NSError *error;
    //1.初始化捕捉设备（AVCaptureDevice），类型为AVMediaTypeVideo
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //2.用captureDevice创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }

    //3.创建媒体数据输出流
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    //4.实例化捕捉会话
    _captureSession = [[AVCaptureSession alloc] init];
    //4.1.将输入流添加到会话
    [_captureSession addInput:input];
    //4.2.将媒体输出流添加到会话中
    [_captureSession addOutput:captureMetadataOutput];
    //5.创建串行队列，并加媒体输出流添加到队列当中
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    //5.1.设置代理
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    //5.2.设置输出媒体数据类型为QRCode
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    //6.实例化预览图层
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    //7.设置预览图层填充方式
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    //8.设置图层的frame
    [_videoPreviewLayer setFrame:_viewPreview.layer.bounds];
    //[_videoPreviewLayer setFrame:self.view.frame];
    //9.将图层添加到预览view的图层上
    [_viewPreview.layer addSublayer:_videoPreviewLayer];
    //10.设置扫描范围
    captureMetadataOutput.rectOfInterest = CGRectMake(0.2f, 0.2f, 0.8f, 0.8f);
    _connection = [captureMetadataOutput connectionWithMediaType:AVMediaTypeVideo];
    [self setFocalLength:2.0];//1倍正常，2x，3x，4x依次放大
    //10.1.扫描框
    CGFloat boxX = _viewPreview.bounds.size.width * 0.1f;
    CGFloat wid = _viewPreview.bounds.size.width*0.8f;
    _boxView = [[UIView alloc] initWithFrame:CGRectMake(boxX, _viewPreview.bounds.size.height/2 - wid/2, wid, wid)];
    _boxView.layer.borderColor = [UIColor whiteColor].CGColor;
    _boxView.layer.borderWidth = 1.0f;
    [_viewPreview addSubview:_boxView];
    //提示label
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(boxX, CGRectGetMaxY(_boxView.frame), wid, 30)];
    lab.text = @"请将二维码/条形码放入框内，可自动进行扫描";
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:11];
    lab.textColor = [UIColor whiteColor];
    [_viewPreview addSubview:lab];
    //10.2.扫描线
    
    _scanLayer = [[CALayer alloc] init];
    _scanLayer.frame = CGRectMake(0, 0, _boxView.bounds.size.width, 8);
    _scanLayer.contents = (id)[UIImage imageNamed:@"widLine"].CGImage;
    
    
    [_boxView.layer addSublayer:_scanLayer];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(moveScanLayer:) userInfo:nil repeats:YES];
    [timer fire];
    
    //10.开始扫描
    [_captureSession startRunning];
    return YES;
}
//实现AVCaptureMetadataOutputObjectsDelegate协议方法
#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    //判断是否有数据
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        //判断回传的数据类型
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            [_lblStatus performSelectorOnMainThread:@selector(setText:) withObject:[metadataObj stringValue] waitUntilDone:NO];
            
            
            [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
            
            _isReading = NO;
        }
    }
    // NSLog(@" 外 url is %@",_lblStatus.text);
    
}
//实现计时器方法moveScanLayer:(NSTimer *)timer
- (void)moveScanLayer:(NSTimer *)timer
{
    CGRect frame = _scanLayer.frame;
    if (_boxView.frame.size.height < _scanLayer.frame.origin.y+25) {
        frame.origin.y = 0;
        _scanLayer.frame = frame;
    }else{
        frame.origin.y += 25;
        [UIView animateWithDuration:0.1 animations:^{
            _scanLayer.frame = frame;
        }];
    }
    
    
}
////实现开始和停止方法
//- (void)startStopReading{
//    if (!_isReading) {
//        if ([self startReading]) {
//            [_startBtn setTitle:@"停止扫描" forState:UIControlStateNormal];
//            // [_lblStatus setText:@"Scanning for QR Code"];
//        }
//    }
//    else{
//        [self stopReading];
//        [_startBtn setTitle:@"开始扫描!" forState:UIControlStateNormal];
//    }
//    _isReading = !_isReading;
//}

- (void)openUrl {
    if (_isOpen) {
    if (self.lblStatus.text.length>3) {
        NSRange range = [self.lblStatus.text rangeOfString:@"lvyouquan"];
        NSRange loginRange = [self.lblStatus.text rangeOfString:@"CodeForLogin"];
        NSRange downloadRang = [self.lblStatus.text.lowercaseString rangeOfString:@"downloadskbapp"];//扫码下载
        if (range.location == NSNotFound | loginRange.location != NSNotFound | downloadRang.location != NSNotFound) {
            BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
            [MobClick event:@"MeCancelMyStore" attributes:dict];

            URLOpenFromQRCodeViewController *QRcodeWeb = [[URLOpenFromQRCodeViewController alloc] init];
            QRcodeWeb.delegate = self;
            QRcodeWeb.url = self.lblStatus.text;
//            [[[UIAlertView alloc]initWithTitle:@"huoqu" message:self.lblStatus.text delegate:nil cancelButtonTitle:self.title otherButtonTitles:nil, nil]show];

            _isOpen = NO;
//            if (loginRange.location != NSNotFound) {
//                QRcodeWeb.titleStr = @" ";
//            }
            if ([self.lblStatus.text myContainsString:@"QRCodeTitle="]) {
                NSString * tempStr = [self.lblStatus.text componentsSeparatedByString:@"QRCodeTitle="][1];
                if ([tempStr myContainsString:@"&"]) {
                   NSString * titleStr = [tempStr componentsSeparatedByString:@"&"][0];
                    QRcodeWeb.titleStr = [titleStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                }else{
                    QRcodeWeb.titleStr = [tempStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                }
            }
            if (downloadRang.location != NSNotFound) {
                QRcodeWeb.titleStr = @"扫码下载";
            }
            [self.navigationController pushViewController:QRcodeWeb animated:YES ];
            NSLog(@"打开了网页:%@",_lblStatus.text);
            
        }else{
            ProduceDetailViewController *detail = [[ProduceDetailViewController alloc] init];
            detail.noShareInfo = YES;
            detail.produceUrl = self.lblStatus.text;
            detail.delegate = self;
            detail.fromType = FromQRcode;
            
            _isOpen = NO;
            [self.navigationController pushViewController:detail animated:YES];
        }
        
    }
    }
    CGFloat viewW = [[UIScreen mainScreen] bounds].size.width;//self.view.bounds.size.width;
    
    CGFloat screenH = [[UIScreen mainScreen] bounds].size.height;
    CGFloat viewH = screenH - 157;
    self.viewPreview.frame = CGRectMake(0, 0, viewW, viewH);
}

-(void)stopReading{
    [_captureSession stopRunning];
    _captureSession = nil;
    [_scanLayer removeFromSuperlayer];
    [_videoPreviewLayer removeFromSuperlayer];
    [self openUrl];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
