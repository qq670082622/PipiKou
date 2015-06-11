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
#import "LLSimpleCamera.h"
#import "ResizeImage.h"
#import "MBProgressHUD+MJ.h"
@interface ScanningViewController ()<LLSimpleCameraDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,AVCaptureMetadataOutputObjectsDelegate,MBProgressHUDDelegate>
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
//@property (nonatomic, strong) AVCaptureSession *session;
//@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@property (weak, nonatomic) IBOutlet UIImageView *photoImg;

//---------------lib
@property (strong, nonatomic) LLSimpleCamera *camera;

@property (strong, nonatomic) UIButton *snapButton;

@property(nonatomic,assign) BOOL cameraInUse;

@property (nonatomic, assign) BOOL isChange;

@end

@implementation ScanningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
  
    self.camera = [[LLSimpleCamera alloc] initWithQuality:CameraQualityPhoto];
    
    // attach to the view and assign a delegate
    [self.camera attachToViewController:self withDelegate:self];
    CGFloat cameraW = [[UIScreen mainScreen] bounds].size.width;
    CGFloat cameraH = [[UIScreen mainScreen] bounds].size.height - 94;
    self.camera.view.frame = CGRectMake(0, 0, cameraW, cameraH);
    self.camera.fixOrientationAfterCapture = NO;
    //self.snapButton = self.midOutlet;
//    [self addObserver:self forKeyPath:@"selectIndex" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    
    if (!self.isLogin) {
        
        
        self.pickerData = [NSArray arrayWithObjects:@"身份证",@"护照", nil];
        
        
      //  [self getCamera];
         [self.camera start];
    

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
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
//    self.isChange = YES;
//    NSLog(@"%d", self.isChange);
//}
//- (void)isChangeYet{
//    self.isChange = YES;
//}
-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    self.isChange = YES;
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
        
             [self.camera start];
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
             
            
             [self.camera stop];
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
   [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
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





-(void)horizontalPickerView:(V8HorizontalPickerView *)picker didSelectElementAtIndex:(NSInteger)index
{
//    if (index == 1 &&_selectIndex == 0) {
//        [self.QRCodevc.view removeFromSuperview];
//        [self.view addSubview: self.personIDVC.view];
//        [self.camera start];
//    }else if (index == 0 &&_selectIndex == 1){
//        [self.camera stop];
//        [self.personIDVC.view removeFromSuperview];
//        [self.view addSubview:self.QRCodevc.view];
//    }
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
        if (self.camera.isStart == YES) {
            [self.camera stop];
        }
        
                    }else if ([_selectedStr isEqualToString:@"身份证"]){
                //[self.passPortVC.view removeFromSuperview];
                        NSLog(@"%d", self.isChange);
                        if (self.isChange) {
                            self.personIDVC.view.alpha = 0;
                            [self.view addSubview:self.personIDVC.view];
                            [UIView animateWithDuration:0.5   animations:^{
                                self.QRCodevc.view.alpha = 0;
                                self.personIDVC.view.alpha = 1.0;
                            } completion:^(BOOL finished) {
                                [self.QRCodevc.view removeFromSuperview];
                            }];
                        }
                        if (self.camera.isStart == NO && _cameraInUse == NO) {
                            [self.camera start];
                        }
                self.title = @"身份证扫描";
                        
                       [self setTreeBtnImagesWithYes];
            }else{
                [self.QRCodevc.view removeFromSuperview];
                //[self.personIDVC.view removeFromSuperview];
                //[self.view addSubview:self.passPortVC.view];
                self.title = @"护照扫描";
               

                    [self setTreeBtnImagesWithYes];
            }
    
    self.isChange = NO;
    NSLog(@"%d222", self.isChange);
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



- (NSInteger)numberOfElementsInHorizontalPickerView:(V8HorizontalPickerView *)picker {
    if (!_isLogin) {
        return 2;
    }else {
    return 3;
    }
}

- (NSString *)horizontalPickerView:(V8HorizontalPickerView *)picker titleForElementAtIndex:(NSInteger)index {
   
    return [self.pickerData objectAtIndex:index];
    
}

- (NSInteger) horizontalPickerView:(V8HorizontalPickerView *)picker widthForElementAtIndex:(NSInteger)index {
    
    //wid =250
    if (self.pickerData.count == 3) {
        return 70.f;
    }else{
    
        return 100.f;
    }
   // 20px padding on each side
    
}
- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
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
#pragma -mark pickerViewDelegate//相册选择照片
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在拼命识别";
   
    UIImage *selectImage = info[UIImagePickerControllerOriginalImage];
    [self getImage:selectImage];
   
    
    self.photoImg.contentMode = UIViewContentModeScaleAspectFill;
    [self.camera stop];
    self.camera.view.hidden = YES;
    [self loadData];

}
//图片上传之前的处理
-(void)getImage:(UIImage *)normal
{
    double wideRadious = 500/normal.size.width;//只定500宽，不定高
  UIImage *resizeImage = [ResizeImage reSizeImage:normal toSize:CGSizeMake(500, normal.size.height*wideRadious)];
     NSData *imageData = UIImageJPEGRepresentation(resizeImage,1);
    long kb = [imageData length]/1024;
    if (kb<280) {
        self.photoImg.image = resizeImage;
    }else{
         double radious = kb/280;
        NSData *imageDataNew = UIImageJPEGRepresentation(resizeImage, radious);
        UIImage *imageNew = [UIImage imageWithData:imageDataNew];
        self.photoImg.image = imageNew;
    }
   
}
//相机得到照片
- (void)cameraViewController:(LLSimpleCamera *)cameraVC didCaptureImage:(UIImage *)image {
    
    // we should stop the camera, since we don't need it anymore. We will open a new vc.
    [self.camera stop];
    
    [self getImage:image];
    
    self.photoImg.contentMode = UIViewContentModeScaleAspectFill;

    [self  loadData];
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
      //  [self.camera stop];
   
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
       
        //[MBProgressHUD showHUDAddedTo:self.controlView animated:YES];
        self.cameraInUse = YES;
               [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"正在拼命识别";
        
        [hud show:YES];

        [self.camera capture];
            [self getVoice];

     
        
        //[self loadData];
        // 2. 删除预览图层
        
        
        
        

    }
    }

-(void)loadData
{
      NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:@"1" forKey:@"needLoad"];
    [def synchronize];
    
    if([self.selectedStr isEqualToString:@"身份证"]){
        
                        NSData *data = UIImageJPEGRepresentation(self.photoImg.image, 1.0);
                        NSString *imageStr = [data base64EncodedStringWithOptions:0];                [IWHttpTool postWithURL:@"File/UploadIDCard" params:@{@"FileStreamData":imageStr,@"PictureType":@3}  success:^(id json) {
                            NSLog(@"------图片--图片---json is %@----图片----",json);
                            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Customer" bundle:nil];
                userIDTableviewController *card = [sb instantiateViewControllerWithIdentifier:@"userID"];
                            card.UserName = json[@"UserName"];
                            card.address = json[@"Address"];
                            card.birthDay = json[@"BirthDay"];
                            card.cardNumber = json[@"CardNum"];
                            card.Nation = json[@"Nation"];
                            card.sex = json[@"Sex"];
                            [self.navigationController pushViewController:card animated:YES];
        
                                                                    [self ifPush];
        
                            } failure:^(NSError *error) {
                            NSLog(@"----图片-eeror is %@------图片------",error) ;
                            }];
        
        
    }else if([self.selectedStr isEqualToString:@"护照"]){
        
        NSData *data = UIImageJPEGRepresentation(self.photoImg.image, 1.0);
        NSString *imageStr = [data base64EncodedStringWithOptions:0];                [IWHttpTool postWithURL:@"file/uploadpassport" params:@{@"FileStreamData":imageStr,@"PictureType":@"4"}  success:^(id json) {
            NSLog(@"------图片--图片---json is %@----图片----",json);
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Customer" bundle:nil];
            CardTableViewController *card = [sb instantiateViewControllerWithIdentifier:@"customerCard"];
            
            card.nameLabStr = json[@"UserName"];
            card.sexLabStr = json[@"Sex"];
            card.countryLabStr = json[@"Nationality"];
            card.cardNumStr = json[@"PassportNum"];
            card.bornLabStr = json[@"BirthDay"];
            card.startDayLabStr = json[@"ValidStartDate"];
            card.startPointLabStr = json[@"ValidAddress"];
            card.effectiveLabStr = json[@"ValidEndDate"];
            
            [self.navigationController pushViewController:card animated:YES];
            
            
            
            [self ifPush];
            
        } failure:^(NSError *error) {
            NSLog(@"----图片-eeror is %@------图片------",error) ;
            
        }];
        
        
    }
    
  

}

-(void)ifPush
{
    self.camera.view.hidden = NO;
    [self.camera start];
    self.cameraInUse = NO;
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
//获取当前屏幕图片
- (UIImage *)getSnapshotImage {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)), NO, 1);
    [self.view drawViewHierarchyInRect:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) afterScreenUpdates:NO];
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshot;
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
