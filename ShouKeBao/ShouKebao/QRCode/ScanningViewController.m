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
@interface ScanningViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
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
@end

@implementation ScanningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pickerData = [NSArray arrayWithObjects:@"二维码",@"身份证",@"护照", nil];
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
  
    self.title = @"二维码扫描";
    [self.controlView addSubview:_pickerView];
    
    [self.view addSubview:self.QRCodevc.view];
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,20,20)];
    
    [leftBtn setImage:[UIImage imageNamed:@"backarrow"] forState:UIControlStateNormal];
    
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    self.navigationItem.leftBarButtonItem= leftItem;
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(hideButn:) userInfo:nil repeats:YES];
    self.timer = timer;
 [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
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
    
    //如果往左滑
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionLeft) {
       
       // NSLog(@"左划");
        //NSLog(@"滑动前selectIndex is  %ld---------",(long)_selectIndex);

        self.selectIndex += 1;
        if (_selectIndex>2) {
            self.selectIndex = 2;
        }
        [self.pickerView scrollToElement:_selectIndex animated:YES];
       
        //NSLog(@"滑动后selectIndex is  %ld---------",(long)_selectIndex);
    
    }else if (recognizer.direction==UISwipeGestureRecognizerDirectionRight)
    //往右划
    {
       // NSLog(@"滑动前selectIndex is  %ld---------",(long)_selectIndex);

        self.selectIndex -= 1;
        if (_selectIndex<0) {
            self.selectIndex = 0;
        }
  [self.pickerView scrollToElement:_selectIndex animated:YES];
       //  NSLog(@"滑动后selectIndex is  %ld---------",(long)_selectIndex);
       // NSLog(@"右划");
    }

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view bringSubviewToFront:self.controlView];
    [self.pickerView scrollToElement:0 animated:YES];
    self.selectIndex = 0;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.timer invalidate];
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
//-(PassPortViewController *)passPortVC
//{
//    if (_passPortVC == nil) {
//        self.passPortVC = [[PassPortViewController alloc] init];
//        
//        self.passPortVC.view.frame = self.audioView.frame;
//        [self addChildViewController:_passPortVC];
//    }
//    return _passPortVC;
//}

//打开本地相册
-(void)LocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentModalViewController:picker animated:YES];
    
}

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil)
        {
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        else
        {
            data = UIImagePNGRepresentation(image);
        }
        
        //图片保存的路径
        //这里将图片放在沙盒的documents文件夹中
        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        
        //文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:data attributes:nil];
        
        //得到选择后沙盒中图片的完整路径
     NSString    *filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];
        self.filePath = [NSMutableString stringWithString:filePath];
        //关闭相册界面
        [picker dismissModalViewControllerAnimated:YES];
        
        //创建一个选择后图片的小图标放在下方
        //类似微薄选择图后的效果
        UIImageView *smallimage = [[UIImageView alloc] initWithFrame:
                                    CGRectMake(50, 120, 40, 40)] ;
        
        smallimage.image = image;
        //加在视图中
        [self.view addSubview:smallimage];
        
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"您取消了选择图片");
    [picker dismissModalViewControllerAnimated:YES];
}

-(void)sendInfo
{
    NSLog(@"图片的路径是：%@", _filePath);
    
   
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)leftAction:(id)sender {
    if (_canClick == YES) {
        [self LocalPhoto];
    }
    
}

- (IBAction)rightAction:(id)sender {
    if (_canClick == YES) {
        
        [self.navigationController pushViewController:[[QRHistoryViewController alloc] init] animated:YES];
    }
  
}
- (IBAction)midAction:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Customer" bundle:nil];
    CardTableViewController *card = [sb instantiateViewControllerWithIdentifier:@"customerCard"];
    [self.navigationController pushViewController:card animated:YES];
}
@end
