//
//  ScanningViewController.m
//  ShouKeBao
//
//  Created by 吴铭 on 15/5/29.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "ScanningViewController.h"
#import "QRCodeViewController.h"
#import "PersonIDViewController.h"
#import "CardTableViewController.h"
//#import "PassPortViewController.h"
#import "QRHistoryViewController.h"
#import "userIDTableviewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ResizeImage.h"
#import "IWHttpTool.h"

@interface ScanningViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic,strong) QRCodeViewController *QRCodevc;
@property (nonatomic,strong)PersonIDViewController *personIDVC;
//@property (nonatomic,strong)PassPortViewController *passPortVC;
- (IBAction)leftAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *leftBtnOutlet;
@property (weak, nonatomic) IBOutlet UIButton *rightBtnOutlet;

- (IBAction)rightAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *midOutlet;
- (IBAction)midAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *indicat;
@property (weak, nonatomic) IBOutlet UIView *audioView;

@property (weak, nonatomic) IBOutlet UIView *controlView;
@property (nonatomic, strong)  V8HorizontalPickerView *pickerView;
@property (nonatomic,strong) NSArray *pickerData;
@property (nonatomic,copy)NSMutableString *selectedStr;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) NSInteger selectIndex;
@property (nonatomic,assign) BOOL canClick;
@property(nonatomic,copy) NSMutableString *filePath;
//---------
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (weak, nonatomic) IBOutlet UIImageView *photoImg;

@end

@implementation ScanningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.isLogin) {
        
        
        self.pickerData = [NSArray arrayWithObjects:@"身份证",@"护照", nil];
        
        
        [self getCamera];
        
    

    }else if(self.isLogin){
        self.pickerData = [NSArray arrayWithObjects:@"二维码",@"身份证",@"护照", nil];
    }
 
    
    CGFloat pickX = [[UIScreen mainScreen] bounds].size.width/2 - 125;
    CGFloat pickW = 250;
    CGFloat pickY = 0;
    CGFloat pickH = 20;
    self.pickerView.delegate = self;
    self.pickerView = [[V8HorizontalPickerView alloc] initWithFrame:CGRectMake(pickX, pickY, pickW, pickH) withDataSource:_pickerData];
    self.pickerView.backgroundColor   = [UIColor clearColor];
    self.pickerView.selectedTextColor = [UIColor whiteColor];//147 198 228
    self.pickerView.textColor   = [UIColor colorWithRed:147/255.f green:198/255.f blue:228/255.f alpha:1];
    self.pickerView.selectionPoint = CGPointMake(self.pickerView.frame.size.width/2, 0);
  
    if (!self.isLogin) {
        self.title = @"身份证扫描";
        [self.pickerView scrollToElement:1 animated:YES];
        self.selectIndex = 1;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 2.0s后执行block里面的代码
            [self.pickerView scrollToElement:0 animated:YES];
            self.selectIndex = 0;
        });

        
    }else if(self.isLogin){
        
        self.title = @"二维码扫描";
         [self.view addSubview:self.QRCodevc.view];
        [self.pickerView scrollToElement:0 animated:YES];
        self.selectIndex = 0;
    }

    
    [self.controlView addSubview:_pickerView];
    
   
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,20,20)];
    
    [leftBtn setImage:[UIImage imageNamed:@"backarrow"] forState:UIControlStateNormal];
    
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    self.navigationItem.leftBarButtonItem= leftItem;
    
   
    [self addGes];
    
  
   
    
}


-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addGes
{
    UISwipeGestureRecognizer *recognizerLeft;
    recognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizerLeft setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    
    [self.view addGestureRecognizer:recognizerLeft];
    
    UISwipeGestureRecognizer *recognizerRight;
    recognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizerRight setDirection:(UISwipeGestureRecognizerDirectionRight)];
    
    [self.view addGestureRecognizer:recognizerRight];

    
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:@"0" forKey:@"needLoad"];
    [def synchronize];
    if (!self.isLogin) {
        //如果往左滑
        
        if(recognizer.direction==UISwipeGestureRecognizerDirectionLeft) {
            
            if (_selectIndex == 0) {
                
                _selectIndex = 1;

            }
           else if (_selectIndex == 1) {
             
            }else{
                            }
            
            NSLog(@"----index is %ld------",(long)_selectIndex);
            
            [self.pickerView scrollToElement:_selectIndex animated:YES];
            
            
            
        }else if (recognizer.direction==UISwipeGestureRecognizerDirectionRight)
            //往右划
        {
            
            if (_selectIndex == 0) {
                //[self.previewLayer removeFromSuperlayer];
            }else{
                //[self getCamera];
                
                _selectIndex = 0;
            }
            NSLog(@"----index is %ld------",(long)_selectIndex);
            
            [self.pickerView scrollToElement:_selectIndex animated:YES];
            
        }

 
    
    }else if (self.isLogin){
    //如果往左滑
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionLeft) {
        if (_selectIndex == 0) {
            [self getCamera];
             _selectIndex +=1;
        }
        
      
       else if(_selectIndex == 1){
            
            _selectIndex +=1;
        }

        NSLog(@"----index is %ld------",(long)_selectIndex);
        
        [self.pickerView scrollToElement:_selectIndex animated:YES];
       
       
    
    }else if (recognizer.direction==UISwipeGestureRecognizerDirectionRight)
    //往右划
    {
       
         if (_selectIndex == 1) {
             
             [self.previewLayer removeFromSuperlayer];
             [self.session stopRunning];
             _selectIndex -=1;
         }else if(_selectIndex == 2){
             

            _selectIndex -=1;
        }
        
        NSLog(@"----index is %ld------",(long)_selectIndex);

  [self.pickerView scrollToElement:_selectIndex animated:YES];
       
    }
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(hideButn:) userInfo:nil repeats:YES];
    // [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    self.timer = timer;

    [self.view bringSubviewToFront:self.controlView];
   
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.timer invalidate];
}
//打开相机
-(void)getCamera
{
    // 1. 实例化拍摄设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // 2. 设置输入设备
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    
    // 3. 设置元数据输出
    // 3.1 实例化拍摄元数据输出
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    // 3.3 设置输出数据代理
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // 4. 添加拍摄会话
    // 4.1 实例化拍摄会话
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    // 4.2 添加会话输入
    [session addInput:input];
    // 4.3 添加会话输出
    [session addOutput:output];
    // 4.3 设置输出数据类型，需要将元数据输出添加到会话后，才能指定元数据类型，否则会报错
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    self.session = session;
    
    // 5. 视频预览图层
    // 5.1 实例化预览图层, 传递_session是为了告诉图层将来显示什么内容
    AVCaptureVideoPreviewLayer *preview = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    
    preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
   
    CGFloat previewW = [[UIScreen mainScreen] bounds].size.width;
    CGFloat previewH = [[UIScreen mainScreen] bounds].size.height - 94;
    preview.frame = CGRectMake(0, 0, previewW, previewH);
//    preview.frame = self.audioView.bounds;
    // 5.2 将图层插入当前视图
     [self.photoImg.layer insertSublayer:preview atIndex:100];
    
    self.previewLayer = preview;
    
    // 6. 启动会话
    [_session startRunning];
    
}

#pragma -mark scroviewDelegate

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate

{
    NSLog(@"-------%ld---------",(long)self.pickerView.currentSelectedIndex);
    

}

#pragma -mark pickerViewDelegate
-(void)hideButn:(NSTimer*)timer
{
    NSInteger selectIndex = (long)self.pickerView.currentSelectedIndex;
    
     self.selectIndex = selectIndex;
    
    self.selectedStr = [NSMutableString stringWithFormat:@"%@", self.pickerData[selectIndex]];
   //  NSLog(@"选择的value is %@",_selectedStr);
   
    
    if ([_selectedStr  isEqual: @"二维码"]) {
                [self.personIDVC.view removeFromSuperview];
                //[self.passPortVC.view removeFromSuperview];
                [self.view addSubview:self.QRCodevc.view];
        [self.view bringSubviewToFront:self.controlView];
                self.title = @"二维码扫描";
        [self setTreeBtnImagesWithNo];
        
        
                    }else if ([_selectedStr isEqualToString:@"身份证"]){
                [self.QRCodevc.view removeFromSuperview];
                //[self.passPortVC.view removeFromSuperview];
                [self.view addSubview:self.personIDVC.view];
                self.title = @"身份证扫描";
                        
                       [self setTreeBtnImagesWithYes];
            }else{
                [self.QRCodevc.view removeFromSuperview];
                //[self.personIDVC.view removeFromSuperview];
                //[self.view addSubview:self.passPortVC.view];
                self.title = @"护照扫描";
               

                    [self setTreeBtnImagesWithYes];
            }
    

}
-(void)setTreeBtnImagesWithNo
{
    [self.leftBtnOutlet setImage:[UIImage imageNamed:@"QRPhotosNo"] forState:UIControlStateNormal];
    [self.rightBtnOutlet setImage:[UIImage imageNamed:@"QRHistoruNo"] forState:UIControlStateNormal];
    [self.midOutlet setImage:[UIImage imageNamed:@"midBtnNo"] forState:UIControlStateNormal];
    self.canClick = NO;
}
-(void)setTreeBtnImagesWithYes
{
       
    [self.leftBtnOutlet setImage:[UIImage imageNamed:@"QRPhotos"] forState:UIControlStateNormal];
    [self.rightBtnOutlet setImage:[UIImage imageNamed:@"QRHistory"] forState:UIControlStateNormal];
    [self.midOutlet setImage:[UIImage imageNamed:@"midBtn"] forState:UIControlStateNormal];
    self.canClick = YES;
}

- (void)horizontalPickerView:(V8HorizontalPickerView *)picker didSelectElementAtIndex:(NSInteger)index {

    
}

- (NSInteger)numberOfElementsInHorizontalPickerView:(V8HorizontalPickerView *)picker {
    
    return 3;
    
}

- (NSString *)horizontalPickerView:(V8HorizontalPickerView *)picker titleForElementAtIndex:(NSInteger)index {
   
    return [self.pickerData objectAtIndex:index];
    
}

- (NSInteger) horizontalPickerView:(V8HorizontalPickerView *)picker widthForElementAtIndex:(NSInteger)index {
    
    
  return 70.f; // 20px padding on each side
    
}



#pragma -mark getter

-(QRCodeViewController *)QRCodevc
{
    if (_QRCodevc == nil) {
        self.QRCodevc = [[QRCodeViewController alloc] init];
        self.QRCodevc.view.frame = self.audioView.frame;
        [self addChildViewController:_QRCodevc];
    }
    return _QRCodevc;
}
-(PersonIDViewController *)personIDVC
{
    if (_personIDVC == nil) {
        self.personIDVC = [[PersonIDViewController alloc] init];
        self.personIDVC.view.frame = self.audioView.frame;
        [self addChildViewController:_personIDVC];
    }
    return _personIDVC;
}





-(void)openAlbum{
    UIImagePickerController *album = [[UIImagePickerController alloc] init];
    album.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    album.delegate = self;
    [self presentViewController:album animated:YES completion:nil];

}
#pragma -mark pickerViewDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
   
    UIImage *selectImage = info[UIImagePickerControllerOriginalImage];
    [self.previewLayer removeFromSuperlayer];//放弃上次拍照的留照

    CALayer *imageLayer = [CALayer layer];
    imageLayer.frame = self.photoImg.bounds;

    imageLayer.contents = (id)selectImage.CGImage;
 
    [self.photoImg.layer insertSublayer:imageLayer atIndex:100];
    self.photoImg.contentMode = UIViewContentModeScaleAspectFill;
 
  
    [self.previewLayer removeFromSuperlayer];
    [self.session stopRunning];


    [self midAction:nil];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//左右按钮事件
- (IBAction)leftAction:(id)sender {
    if (_canClick == YES) {
        [self openAlbum];
        
   
    }
    
}

- (IBAction)rightAction:(id)sender {
    if (_canClick == YES) {
        
        [self.navigationController pushViewController:[[QRHistoryViewController alloc] init] animated:YES];
        [self ifPush];

    }
  
}

- (IBAction)midAction:(id)sender {

   NSLog(@"----selectStr is %@----",_selectedStr);
    if (_canClick == YES) {
        
        [self getVoice];
        
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        [def setObject:@"1" forKey:@"needLoad"];
        [def synchronize];
        // 2. 删除预览图层
       
        self.photoImg.image = [self imageFromView:self.audioView];
              [self.session stopRunning];
        //[self.previewLayer removeFromSuperlayer];
        
        if([self.selectedStr isEqualToString:@"身份证"]){
//            if (self.photoImg.image) {
//                NSData *data = UIImageJPEGRepresentation(self.photoImg.image, 1.0);
//                NSString *imageStr = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
//                [IWHttpTool postWithURL:@"File/UploadIDCard" params:@{@"FileStreamData":imageStr,@"PictureType":@3}  success:^(id json) {
//                    NSLog(@"------图片--图片---json is %@----图片----",json);
//                    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(50, 80, 320, 400)];
//                    lab.backgroundColor = [UIColor redColor];
//                    lab.text = [NSString stringWithFormat:@"生日%@\n证件号码%@\n民族%@\n性别%@\n姓名%@",json[@"BirthDay"],json[@"CardNum"],json[@"Nation"],json[@"Sex"],json[@"UserName"]];
//                    lab.numberOfLines = 0;
//                    UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(50, 80, 220,220)];
//                    imgv.image = self.photoImg.image;
//                    [self.view.window addSubview:lab];
//                    [self.view.window addSubview:imgv];
//                    
//                } failure:^(NSError *error) {
//                    NSLog(@"----图片-eeror is %@------图片------",error) ;
//                }];
                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 2.0s后执行block里面的代码
                            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Customer" bundle:nil];
                             userIDTableviewController *card = [sb instantiateViewControllerWithIdentifier:@"userID"];
                             [self.navigationController pushViewController:card animated:YES];
                                      
                                        [self ifPush];
                        });

            }else if([self.selectedStr isEqualToString:@"护照"]){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 2.0s后执行block里面的代码
                            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Customer" bundle:nil];
                        CardTableViewController *card = [sb instantiateViewControllerWithIdentifier:@"customerCard"];
                        [self.navigationController pushViewController:card animated:YES];
                [self ifPush];

            });
            
    }

    }
}

-(void)ifPush
{
  [self.previewLayer removeFromSuperlayer];
    [self getCamera];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:@"0" forKey:@"needLoad"];
    [def synchronize];
    
}

- (UIImage *)imageFromView: (UIView *) theView
{
    
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

#pragma -mark 声音
-(void)getVoice{
    
    //添加提示音
    SystemSoundID messageSound;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"caremaCut" ofType:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&messageSound);
    
    AudioServicesPlaySystemSound (messageSound);
}
@end
