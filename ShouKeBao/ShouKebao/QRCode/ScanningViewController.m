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
#import "personIdModel.h"
#import "WriteFileManager.h"
#import "StrToDic.h"
#import "MobClick.h"
#import "BaseClickAttribute.h"
#import "ShouKeBao.h"
#import "UIViewController+MLTransition.h"
#import "IdentifyViewController.h"

@interface ScanningViewController ()<LLSimpleCameraDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,AVCaptureMetadataOutputObjectsDelegate,MBProgressHUDDelegate,toIfPush,toIfPush2>
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


@property(nonatomic,strong)NSMutableArray  *writeFilePersonIdArr;
//@property(nonatomic,strong)NSMutableArray *writeFilePassportArr;




@end

@implementation ScanningViewController


- (void)viewDidLoad {
    [super viewDidLoad];
//    [ScanningViewController removeGestureRecognizer];
    if (self.isFromOrder) {
        self.rightBtnOutlet.hidden = YES;
    }
    self.camera = [[LLSimpleCamera alloc] initWithQuality:CameraQualityPhoto];
//    for (UIGestureRecognizer * gesture in self.view.gestureRecognizers) {
//        if ([gesture isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
//            [self.view removeGestureRecognizer:gesture];
//        }
//    }
    // attach to the view and assign a delegate
    [self.camera attachToViewController:self withDelegate:self];
    
    CGFloat cameraW = [[UIScreen mainScreen] bounds].size.width;
    CGFloat cameraH = [[UIScreen mainScreen] bounds].size.height - 94;
    self.camera.view.frame = CGRectMake(0, 0, cameraW, cameraH);
    self.camera.fixOrientationAfterCapture = NO;
    
    //判断摄像头访问权限
    NSString * mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus  authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    
    if (authorizationStatus == AVAuthorizationStatusRestricted|| authorizationStatus == AVAuthorizationStatusDenied) {
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"无法访问相机" message:@"请在【设置->隐私->相机】下允许“旅游圈”访问相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }else{
    }

    
    //self.snapButton = self.midOutlet;
//    [self addObserver:self forKeyPath:@"selectIndex" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
  
    
    

    if (!self.isLogin || self.isFromOrder || self.isFromCostom) {
        
        
        self.pickerData = [NSArray arrayWithObjects:@"身份证",@"护照", nil];
        
          [self ifPush];
      //  [self getCamera];
         [self.camera start];
    

    }else if(self.isLogin && !self.isFromOrder && !self.isFromCostom){
        self.pickerData = [NSArray arrayWithObjects:@"二维码",@"身份证",@"护照", nil];
    }
 
    
//    CGFloat pickX = [[UIScreen mainScreen] bounds].size.width/2 - 125;
//    CGFloat pickW = 250;
//    CGFloat pickY = 0;
//    CGFloat pickH = 20;
    self.pickerView.delegate = self;
    self.pickerView = [[V8HorizontalPickerView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20) withDataSource:_pickerData];
    self.pickerView.backgroundColor   = [UIColor clearColor];
    self.pickerView.selectedTextColor = [UIColor whiteColor];//147 198 228
    self.pickerView.textColor   = [UIColor colorWithRed:147/255.f green:198/255.f blue:228/255.f alpha:1];
    self.pickerView.selectionPoint = CGPointMake(self.pickerView.frame.size.width/2, 0);
  
    if (!self.isLogin || self.isFromOrder || self.isFromCostom) {
            [self.view addSubview:self.personIDVC.view];
            [self setTreeBtnImagesWithYes];
    }

    
    [self.controlView addSubview:_pickerView];
    
   
    [self addGes];
    NSLog(@"%d, %d", self.isFromOrder, self.isLogin);
    if (self.isFromOrder || !self.isLogin || self.isFromCostom) {
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"huzhaoOrShenfenzheng"]isEqualToString:@"HZ"]) {
        self.title = @"护照扫描";
        [self.pickerView scrollToElement:1 animated:YES];
        self.selectIndex = 1;
    }else{
        self.title = @"身份证扫描";
        [self.pickerView scrollToElement:0 animated:YES];
        self.selectIndex = 0;

    }
    }else{
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"huzhaoOrShenfenzheng"]isEqualToString:@"HZ"]) {
            [self ifPush];
            [self.view addSubview:self.personIDVC.view];
            [self setTreeBtnImagesWithYes];
            self.title = @"护照扫描";
            self.selectIndex = 2;
            [self.pickerView scrollToElement:2 animated:YES];


        }else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"huzhaoOrShenfenzheng"]isEqualToString:@"SFZ"]){
            [self ifPush];
            [self.view addSubview:self.personIDVC.view];
            [self setTreeBtnImagesWithYes];
            self.title = @"身份证扫描";
            self.selectIndex = 1;
            [self.pickerView scrollToElement:1 animated:YES];

        }else{
        self.title = @"二维码扫描";
            
            [self.view addSubview:self.QRCodevc.view];

            [self.pickerView scrollToElement:0 animated:YES];
            self.selectIndex = 0;

        }
        
    
    }
}


-(void)back
{
    [self.timer invalidate];

    [self.navigationController popViewControllerAnimated:NO];
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
               
            }else{
                
                _selectIndex = 0;
            }
            NSLog(@"----index is %ld------",(long)_selectIndex);
            
            [self.pickerView scrollToElement:_selectIndex animated:YES];
            
        }

 
    
    }else if (self.isLogin){
    //如果往左滑
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionLeft) {
        if (_selectIndex == 0) {
        
            // [self.camera start];
            
             _selectIndex +=1;
            self.title = @"身份证扫描";
            [[NSUserDefaults standardUserDefaults]setValue:@"SFZ" forKey:@"huzhaoOrShenfenzheng"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        
      
       else if(_selectIndex == 1){
            
            _selectIndex +=1;
           
           self.title = @"护照扫描";
           [[NSUserDefaults standardUserDefaults]setValue:@"HZ" forKey:@"huzhaoOrShenfenzheng"];
           [[NSUserDefaults standardUserDefaults]synchronize];

        }

        NSLog(@"----index is %ld------",(long)_selectIndex);
        
        [self.pickerView scrollToElement:_selectIndex animated:YES];
       
       
    
    }else if (recognizer.direction==UISwipeGestureRecognizerDirectionRight)
    //往右划
    {
       
         if (_selectIndex == 1) {
             
            
             //[self.camera stop];
             _selectIndex -=1;
         }else if(_selectIndex == 2){
             

            _selectIndex -=1;
             self.title = @"身份证扫描";
             [[NSUserDefaults standardUserDefaults]setValue:@"SFZ" forKey:@"huzhaoOrShenfenzheng"];
             [[NSUserDefaults standardUserDefaults]synchronize];


        }
        
        NSLog(@"----index is %ld------",(long)_selectIndex);

  [self.pickerView scrollToElement:_selectIndex animated:YES];
       
    }
    }
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   // [self defaultToNotifiQRDStartRunning];

    
////    我们可以通过
//    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
////    获取对摄像头的访问权限。AVAuthorizationStatus
//    
//    NSLog(@"%ld ------999", authStatus);
//    if(authStatus != AVAuthorizationStatusRestricted || authStatus != AVAuthorizationStatusDenied){
//        UIAlertView *theAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"相机权限受限！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [theAlertView show];
//        
//        
//        return;
//    
//    }
   

    
    self.navigationController.navigationBarHidden = NO;
    [MobClick beginLogPageView:@"ShouKeBaoScanningView"];

   [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(hideButn:) userInfo:nil repeats:YES];
    // [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    self.timer = timer;

    [self.view bringSubviewToFront:self.controlView];
    
   
}



-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"ShouKeBaoScanningView"];

}



-(void)switchQRCodeAndCamera:(NSString *)camera  andQRD:(NSString *)qrd
{
    
}


-(void)horizontalPickerView:(V8HorizontalPickerView *)picker didSelectElementAtIndex:(NSInteger)index
{

}





#pragma -mark pickerViewDelegate
-(void)hideButn:(NSTimer*)timer
{
    NSInteger selectIndex = (long)self.pickerView.currentSelectedIndex;
    
     self.selectIndex = selectIndex;
    
    self.selectedStr = [NSMutableString stringWithFormat:@"%@", self.pickerData[selectIndex]];
    if (_isLogin) {
        if ([_selectedStr  isEqual: @"二维码"]) {
            
            if (self.camera.isStart == YES || self.cameraInUse == YES) {
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
               // [self defaultToNotifiQRDStartRunning];
                [UIView animateWithDuration:1 animations:^{
                    self.personIDVC.view.alpha = 0;
                    self.QRCodevc.view.alpha = 0;
                    
                    [self.camera stop];
                    self.cameraInUse = NO;
                    
                    [self.personIDVC.view removeFromSuperview];
                    [self.view addSubview:self.QRCodevc.view];
                    self.personIDVC.view.alpha = 1;
                    self.QRCodevc.view.alpha = 1;
                }];
               
                
               
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [self.view bringSubviewToFront:self.controlView];
                self.title = @"二维码扫描";
                [[NSUserDefaults standardUserDefaults]setValue:@"EWM" forKey:@"huzhaoOrShenfenzheng"];
                [[NSUserDefaults standardUserDefaults]synchronize];

                [self setTreeBtnImagesWithNo];
                
            }
          

        }else if ([_selectedStr isEqualToString:@"身份证"]){
            
            if (self.camera.isStart == NO && _cameraInUse == NO) {
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
               
                [UIView animateWithDuration:0.5 animations:^{
                    self.personIDVC.view.alpha = 0;
                    self.QRCodevc.view.alpha = 0;
                    
                    
                    [self.QRCodevc.view removeFromSuperview];
                    [self.view addSubview:self.personIDVC.view];
                    
                    self.personIDVC.view.alpha = 1;
                    self.QRCodevc.view.alpha = 1;
                }];
               
                [self.camera start];
                self.cameraInUse = YES;
                
                
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                
                self.title = @"身份证扫描";
                [[NSUserDefaults standardUserDefaults]setValue:@"SFZ" forKey:@"huzhaoOrShenfenzheng"];
                [[NSUserDefaults standardUserDefaults]synchronize];

                [self setTreeBtnImagesWithYes];
                
            }
         
             self.title = @"身份证扫描";
            [[NSUserDefaults standardUserDefaults]setValue:@"SFZ" forKey:@"huzhaoOrShenfenzheng"];
            [[NSUserDefaults standardUserDefaults]synchronize];

        }else{
            
            if (self.camera.isStart == NO && _cameraInUse == NO) {
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
               [UIView animateWithDuration:1 animations:^{
                    self.personIDVC.view.alpha = 0;
                    self.QRCodevc.view.alpha = 0;
                    [self.QRCodevc.view removeFromSuperview];
                    [self.view addSubview:self.personIDVC.view];
                    self.personIDVC.view.alpha = 1;
                    self.QRCodevc.view.alpha = 1;
                }];
                [self.camera start];
                self.cameraInUse = YES;
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                
                
                self.title = @"护照扫描";
                [[NSUserDefaults standardUserDefaults]setValue:@"HZ" forKey:@"huzhaoOrShenfenzheng"];
                [[NSUserDefaults standardUserDefaults]synchronize];

                [self setTreeBtnImagesWithYes];
                
            }
              //[self ifPush];
             self.title = @"护照扫描";
            [[NSUserDefaults standardUserDefaults]setValue:@"HZ" forKey:@"huzhaoOrShenfenzheng"];
            [[NSUserDefaults standardUserDefaults]synchronize];


        }
  
    }else if (!_isLogin){
        if ([_selectedStr isEqualToString:@"身份证"]) {
            self.title = @"身份证扫描";
        }else if ([_selectedStr isEqualToString:@"护照"]){
        self.title = @"护照扫描";
        }
        
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

//-(NSMutableArray *)writeFilePassportArr
//{
//    if (_writeFilePassportArr == nil) {
//        self.writeFilePassportArr = [NSMutableArray array];
//    }
//    return _writeFilePassportArr;
//}
-(NSMutableArray *)writeFilePersonIdArr
{
    if (_writeFilePersonIdArr == nil) {
        self.writeFilePersonIdArr = [NSMutableArray array];
    }
    return _writeFilePersonIdArr;
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
-(void)getImage:(UIImage *)normalImage
{
    UIImage *normal = [ResizeImage colorControlWithImage:normalImage brightness:0.3 contrast:0.3 saturation:0.0];//将图片变黑白
    
    double wideRadious = 500/normal.size.width;//只定500宽，不定高
  UIImage *resizeImage = [ResizeImage reSizeImage:normal toSize:CGSizeMake(500, normal.size.height*wideRadious)];//裁减尺寸
    
     NSData *imageData = UIImageJPEGRepresentation(resizeImage,1);
    long kb = [imageData length]/1024;//计算大小
    if (kb<280) {
        self.photoImg.image = resizeImage;
    }else{
         double radious = kb/280;
        NSData *imageDataNew = UIImageJPEGRepresentation(resizeImage, radious);//改变大小
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
//        QRHistoryViewController *hi = [[QRHistoryViewController alloc] init];
//        hi.isLogin = _isLogin;
//        [self.navigationController pushViewController:hi animated:YES];
        
        IdentifyViewController *IdentifyVC = [[IdentifyViewController alloc] init];
        IdentifyVC.isLogin = _isLogin;
        [self.navigationController pushViewController:IdentifyVC animated:YES];
        
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

     
        
     //在相机出load   [self loadData];
        // 2. 删除预览图层
        
        
        
        

    }
    }

-(void)loadData
{
      NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:@"1" forKey:@"needLoad"];
    [def synchronize];
//    if (self.photoImg.image == nil) {
//        self.photoImg.image = [UIImage imageNamed:@"testCaed"];
//    }
    if([self.selectedStr isEqualToString:@"身份证"]){
        if (self.isLogin) {
            BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
            [MobClick event:@"ShouKeBaoUserIdScan" attributes:dict];
        }

                                       NSData *data = UIImageJPEGRepresentation(self.photoImg.image, 1.0);
                        NSString *imageStr = [data base64EncodedStringWithOptions:0];                [IWHttpTool postWithURL:@"File/UploadIDCard" params:@{@"FileStreamData":imageStr,@"PictureType":@3}  success:^(id json) {
                            NSLog(@"------图片--图片---json is %@----图片----",json);
                            
                          //  [self getTestLabWithJson:json];
                            
                            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Customer" bundle:nil];
                userIDTableviewController *card = [sb instantiateViewControllerWithIdentifier:@"userID"];
                                card.UserName = json[@"CredentialsPicRecord"][@"UserName"];
                                card.address = json[@"CredentialsPicRecord"][@"Address"];
                                card.birthDay = json[@"CredentialsPicRecord"][@"BirthDay"];
                                card.cardNumber = (NSString *)json[@"CredentialsPicRecord"][@"CardNum"];
                                card.Nationality = json[@"CredentialsPicRecord"][@"Nationality"];
                                card.sex = json[@"CredentialsPicRecord"][@"Sex"];
                            card.RecordId = json[@"CredentialsPicRecord"][@"RecordId"];
                           card.ModifyDate = json[@"CredentialsPicRecord"][@"ModifyDate"];
                            card.PicUrl = json[@"CredentialsPicRecord"][@"PicUrl"];
                            card.isLogin = _isLogin;
                            card.delegate = self;
                            card.isFromOrder = self.isFromOrder;
                            card.isFromCamer = self.isFromCostom;
                            card.isIDCard = YES;
                            card.VC = self.VC;
                            if (!_isLogin) {//未登录时保存记录
                               // [self saveRecordWithJson:json];
                            }
                                [self.navigationController pushViewController:card animated:YES];
                            
                        } failure:^(NSError *error) {
                        
                            NSLog(@"----图片-eeror is %@------图片------",error) ;
                            }];
        
        
    }else if([self.selectedStr isEqualToString:@"护照"]){
        if (self.isLogin) {
            BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
            [MobClick event:@"ShouKeBaoPersonIdScan" attributes:dict];
        }

        NSData *data = UIImageJPEGRepresentation(self.photoImg.image, 1.0);
        NSString *imageStr = [data base64EncodedStringWithOptions:0];                [IWHttpTool postWithURL:@"file/uploadpassport" params:@{@"FileStreamData":imageStr,@"PictureType":@"4"}  success:^(id json) {
            NSLog(@"------图片--图片---json is %@----图片----",json);

           // [self getTestLabWithJson:json];
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Customer" bundle:nil];
            CardTableViewController *card = [sb instantiateViewControllerWithIdentifier:@"customerCard"];
            NSLog(@"%@", json);
            card.nameLabStr = json[@"CredentialsPicRecord"][@"UserName"];
            card.sexLabStr = json[@"CredentialsPicRecord"][@"Sex"];
            card.countryLabStr = json[@"CredentialsPicRecord"][@"Country"];//后面接口更新后要把国籍还回来
//            card.countryLabStr = json[@"CredentialsPicRecord"][@"Nationality"];

            card.cardNumStr = json[@"CredentialsPicRecord"][@"PassportNum"];
            card.bornLabStr = json[@"CredentialsPicRecord"][@"BirthDay"];
            card.startDayLabStr = json[@"CredentialsPicRecord"][@"ValidStartDate"];
            card.startPointLabStr = json[@"CredentialsPicRecord"][@"ValidAddress"];
            card.effectiveLabStr = json[@"CredentialsPicRecord"][@"ValidEndDate"];
            card.RecordId = json[@"CredentialsPicRecord"][@"RecordId"];
            card.ModifyDate = json[@"CredentialsPicRecord"][@"ModifyDate"];
            card.PicUrl = json[@"CredentialsPicRecord"][@"PicUrl"];
            card.isFromOrder = self.isFromOrder;
            card.isFromeCamer = self.isFromCostom;
            card.isIDCard = YES;
            card.VC = self.VC;
            card.isLogin = _isLogin;

            card.delegate = self;
            
            if (!_isLogin) {//未登录时保存记录
               // [self saveRecordWithJson:json];
            }
            [self.navigationController pushViewController:card animated:YES];
            
        } failure:^(NSError *error) {
            NSLog(@"----图片-eeror is %@------图片------",error) ;
            
        }];
        
        
    }
    
  

}
//未登录时候保存记录，登录后同步
-(void)saveRecordWithJson:(NSDictionary *)diction
{
    [self.writeFilePersonIdArr addObjectsFromArray:[WriteFileManager readData:@"record2"]];
          NSMutableDictionary *dic = [NSMutableDictionary dictionary];
   
    NSDictionary *json = diction[@"CredentialsPicRecord"];
    [StrToDic setValueWhenIsNull:dic andValue:json[@"UserName"] forKey:@"UserName"];
    
   [StrToDic setValueWhenIsNull:dic andValue:json[@"Address"] forKey:@"Address"];
    
    [StrToDic setValueWhenIsNull:dic andValue:json[@"BirthDay"] forKey:@"BirthDay"];
    
    [StrToDic setValueWhenIsNull:dic andValue:json[@"CardNum"] forKey:@"CardNum"];
    
    [StrToDic setValueWhenIsNull:dic andValue:json[@"Nationality"] forKey:@"Nationality"];
   
    [StrToDic setValueWhenIsNull:dic andValue:json[@"Sex"] forKey:@"Sex"];
    
    [StrToDic setValueWhenIsNull:dic andValue:json[@"Country"] forKey:@"Country"];
  
    [StrToDic setValueWhenIsNull:dic andValue:json[@"PassportNum"] forKey:@"PassportNum"];
    
    [StrToDic setValueWhenIsNull:dic andValue:json[@"ValidStartDate"] forKey:@"ValidStartDate"];
   
    [StrToDic setValueWhenIsNull:dic andValue:json[@"ValidAddress"] forKey:@"ValidAddress"];
    
    [StrToDic setValueWhenIsNull:dic andValue:json[@"ValidEndDate"] forKey:@"ValidEndDate"];
    
    [StrToDic setValueWhenIsNull:dic andValue:json[@"PicUrl"] forKey:@"PicUrl"];
   
    [StrToDic setValueWhenIsNull:dic andValue:json[@"ModifyDate"] forKey:@"ModifyDate"];
  
    [StrToDic setValueWhenIsNull:dic andValue:json[@"RecordId"] forKey:@"RecordId"];
    
    [StrToDic setValueWhenIsNull:dic andValue:json[@"RecordType"] forKey:@"RecordType"];
    
    [self.writeFilePersonIdArr addObject:dic];
    
    [WriteFileManager saveData:_writeFilePersonIdArr name:@"record"];
 


}
//测试后台返回用
-(void)getTestLabWithJson:(id)json
{
    UILabel *testLab = [[UILabel alloc] initWithFrame:self.view.frame];
    testLab.backgroundColor = [UIColor whiteColor];
    testLab.text = [NSString stringWithFormat:@"(用来测试后台返回的数据，8秒后自动删除)\n\njson is %@-",json];
    testLab.numberOfLines = 0;
    testLab.font = [UIFont systemFontOfSize:8];
    [self.view.window addSubview:testLab];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(200.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 2.0s后执行block里面的代码
        [testLab removeFromSuperview];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    });
}






-(void)ifPush
{
    self.camera.view.hidden = NO;
        self.camera.isStart = YES;
    self.cameraInUse = YES;
    [self.camera start];

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
#pragma -mark回调刷新，让相机跑动起来
-(void)toIfPush
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 2.0s后执行block里面的代码
        [self ifPush];
    });
   
}

-(void)toIfPush2
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 2.0s后执行block里面的代码
        [self ifPush];
    });
}

@end
