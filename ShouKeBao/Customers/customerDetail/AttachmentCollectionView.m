//
//  AttachmentCollectionView.m
//  ShouKeBao
//
//  Created by 冯坤 on 15/10/16.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "AttachmentCollectionView.h"
#import "AttachmentCollectionCell.h"
#import "UIImageView+WebCache.h"
#import "ResizeImage.h"
#import "IWHttpTool.h"
#import "NSString+FKTools.h"
#import "Customers.h"
#import "MBProgressHUD+MJ.h"
@interface AttachmentCollectionView ()<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic ,strong) NSMutableArray *dataSource;
@property (nonatomic, strong)NSMutableArray *bigPicUrlArray;
@property(nonatomic , assign) BOOL isEditing;
@property (nonatomic, strong) UIButton * deleteBtn;
@property (nonatomic, strong) NSMutableArray *choosedPicArray;
@property (nonatomic, strong) NSMutableArray *choosedBigPicArray;

@property (nonatomic, assign)CGRect  currentCellPicRect;
@property(nonatomic, weak)UIImageView *MaxPhotoView;
@end

@implementation AttachmentCollectionView

static NSString * const reuseIdentifier = @"AttachmentCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"证件附件";
    [self loadData];
    [self baseSetUp];
    [self setUpRightButton];
}
- (void)baseSetUp{
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    [self setNav];
    [self addGest];

}
- (void)addGest{
    UIScreenEdgePanGestureRecognizer *screenEdge = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleScreen:)];
    screenEdge.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:screenEdge];
}
- (void)setNav{
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,55,15)];
    [leftBtn setImage:[UIImage imageNamed:@"fanhuian"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"fanhuian"] forState:UIControlStateHighlighted];
    
    leftBtn.imageEdgeInsets = UIEdgeInsetsMake(-1, -10, 0, 50);
    [leftBtn setTitle:@"返回" forState:UIControlStateNormal];
    leftBtn.titleEdgeInsets = UIEdgeInsetsMake(0,-40, 0, 0);
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)handleScreen:(UIScreenEdgePanGestureRecognizer *)sender{
    CGPoint sliderdistance = [sender translationInView:self.view];
    if (sliderdistance.x>self.view.bounds.size.width/3) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void)loadData
{
    MBProgressHUD *hudView = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    hudView.labelText = @"加载中...";
    [hudView show:YES];

    NSDictionary * params = @{@"CustomerIds":@[self.customerId]};
    [IWHttpTool postWithURL:@"/Customer/GetCustomerPicList" params:params success:^(id json) {
        NSLog(@"%@", json);
        NSArray * array = json[@"CustomerList"];
        if (array.count) {
            NSArray *productss = array[0][@"PictureList"];
        for (NSDictionary * dic in productss) {
            [self.dataSource addObject:dic[@"MinPicUrl"]];
            [self.bigPicUrlArray addObject:dic[@"PicUrl"]];
        }
        }
        [self.collectionView reloadData];
        [hudView hide:YES];
    } failure:^(NSError * error) {
        
    }];
        
//    for (NSDictionary * dic in self.pictureList) {
//        [self.dataSource addObject:dic[@"MinPicUrl"]];
//        [self.bigPicUrlArray addObject:dic[@"PicUrl"]];
//    }
//    [self.collectionView reloadData];
}
-(NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        self.dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
-(NSMutableArray *)bigPicUrlArray{
    if (!_bigPicUrlArray) {
        self.bigPicUrlArray = [NSMutableArray array];
    }
    return _bigPicUrlArray;
}
-(NSMutableArray *)choosedPicArray
{
    if (_choosedPicArray == nil) {
        self.choosedPicArray = [NSMutableArray array];
    }
    return _choosedPicArray;
}
-(NSMutableArray *)choosedBigPicArray
{
    if (_choosedBigPicArray == nil) {
        self.choosedBigPicArray = [NSMutableArray array];
    }
    return _choosedBigPicArray;
}

- (UIButton * )deleteBtn{
    if (_deleteBtn == nil) {
        self.deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];
        self.deleteBtn.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2.0, [UIScreen mainScreen].bounds.size.height - 64-25);
        self.deleteBtn.backgroundColor = [UIColor colorWithRed:241/255.0 green:99/255.0 blue:32/255.0 alpha:1.0];
        [self.deleteBtn setTitle:@"确定" forState:UIControlStateNormal];
        [self.deleteBtn addTarget:self action:@selector(deletePic) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}
//点击底部按钮的响应
-(void)deletePic{
    if (self.isEditing) {
        for (NSString * picUrl in self.choosedPicArray) {
            [self.dataSource removeObject:picUrl];
        }
        for (NSString * picUrl in self.choosedBigPicArray) {
            [self.bigPicUrlArray removeObject:picUrl];
        }
        [self.collectionView reloadData];
        [self EditCustomerDetail];
    }else{
        NSLog(@"%@", self.customerId);
        [IWHttpTool postWithURL:@"/Customer/SavePicToCustomer" params:@{@"PicUrls":self.bigPicUrlArray,@"CustomerId":self.customerId} success:^(id json) {
            [MBProgressHUD showSuccess:@"保存成功"];
            NSLog(@"%@", json);
        } failure:^(NSError *error) {
        }];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setUpRightButton{
    self.isEditing = NO;
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStyleBordered target:self action:@selector(EditCustomerDetail)];
    [self.view addSubview:self.deleteBtn];
    [self.view bringSubviewToFront:self.deleteBtn];
    self.navigationItem.rightBarButtonItem= barItem;
}
-(void)EditCustomerDetail
{
    if (!_isEditing) {
        self.isEditing = YES;
        self.navigationItem.rightBarButtonItem.title = @"取消";
        [self.collectionView reloadData];
        [self showDelete];

    }else if (self.isEditing){
        self.isEditing = NO;
        self.navigationItem.rightBarButtonItem.title = @"编辑";
        [self.collectionView reloadData];
        [self hidDelete];
    }
}
- (void)showDelete{
    [self.view bringSubviewToFront:self.deleteBtn];
    [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
}

-(void)hidDelete{
    [self.deleteBtn setTitle:@"确定" forState:UIControlStateNormal];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.isEditing) {
        return self.dataSource.count;
    }
    return (self.dataSource.count +1);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AttachmentCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AttachmentCell" forIndexPath:indexPath];
    if (self.isEditing) {
        cell.cellState = UnCheckedState;
        cell.cellPicUrl = self.dataSource[indexPath.row];
        cell.cellBigPicUrl = self.bigPicUrlArray[indexPath.row];
        [cell.theUserImage sd_setImageWithURL:[NSURL URLWithString:self.bigPicUrlArray[indexPath.row]]];

    }else{
        cell.cellState = NormalState;
        if (indexPath.row == 0) {
            cell.theUserImage.image = [UIImage imageNamed:@"addPic"];
        }else{
            [cell.theUserImage sd_setImageWithURL:[NSURL URLWithString:self.bigPicUrlArray[indexPath.row-1]]];
            cell.cellPicUrl = self.dataSource[indexPath.row-1];
            cell.cellBigPicUrl = self.bigPicUrlArray[indexPath.row-1];


        }
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    AttachmentCollectionCell *cell = (AttachmentCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (self.isEditing) {
        if (cell.cellState == CheckedState) {
            cell.cellState = UnCheckedState;
            [self.choosedPicArray removeObject:cell.cellPicUrl];
            [self.choosedBigPicArray removeObject:cell.cellBigPicUrl];
        }else if(cell.cellState == UnCheckedState){
            cell.cellState = CheckedState;
            [self.choosedPicArray addObject:cell.cellPicUrl];
            [self.choosedBigPicArray addObject:cell.cellBigPicUrl];
        }
    }else{
    if (indexPath.row == 0) {
        [self addCustomPic];
    }else{
        NSLog(@"%@", NSStringFromCGSize(cell.theUserImage.image.size));
        [self changePicToMaxPic:cell indexPath:indexPath];
      }
    }
}

- (void)changePicToMaxPic:(UICollectionViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    
    CGRect cellCurrentRect = CGRectMake(cell.frame.origin.x,cell.frame.origin.y - self.collectionView.contentOffset.y, cell.frame.size.width, cell.frame.size.height);
    
    UIImageView *photoView = [[UIImageView alloc]initWithFrame:cellCurrentRect];
    photoView.userInteractionEnabled = YES;
    photoView.backgroundColor = [UIColor blackColor];
    photoView.contentMode = UIViewContentModeScaleAspectFit;
    
    NSString *picStr = self.bigPicUrlArray[indexPath.row-1];
    NSLog(@"%@", picStr);
    NSURL *url = [NSURL URLWithString:picStr];
    [photoView sd_setImageWithURL:url];
    
    [self.view addSubview:photoView];
    self.MaxPhotoView = photoView;
    self.currentCellPicRect = cellCurrentRect;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.MaxPhotoView.frame = self.collectionView.frame;
        
    } completion:^(BOOL finished) {
        
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotBack:)];
    [photoView addGestureRecognizer:tap];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(addCustomPic)];
    [photoView addGestureRecognizer:longPress];

    
}

- (void)gotBack:(UITapGestureRecognizer *)tap{
    [UIView animateWithDuration:0.5 animations:^{
        self.MaxPhotoView.frame = self.currentCellPicRect;
    } completion:^(BOOL finished) {
        [self.MaxPhotoView removeFromSuperview];
    }];
}

- (void)addCustomPic
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"选择相册照片",@"拍照", nil];
    [sheet showInView:self.view.window];
    
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    
    UIImagePickerControllerSourceType sourceType = 0;
    switch (buttonIndex) {
        case 0:
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            break;
        case 1:
            sourceType = UIImagePickerControllerSourceTypeCamera;
            break;
        default:
            break;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = sourceType;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker animated:YES completion:nil];
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        //        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    NSLog(@"----%@",info);
    UIImage *image = info[@"UIImagePickerControllerEditedImage"];
    UIImage *imageNew = [self getImage:image];
    NSData *data = UIImageJPEGRepresentation(imageNew, 1.0);
    NSString *imageStr = [data base64EncodedStringWithOptions:0];
    [IWHttpTool postWithURL:@"File/UploadPicture" params:@{@"FileStreamData":imageStr,@"PictureType":@"7"} success:^(id json) {
        NSLog(@"json = %@", json);
        
        [self.dataSource addObject:json[@"PicUrl"]];
        [self.bigPicUrlArray addObject:json[@"PicUrl"]];
        [self.collectionView reloadData];
    } failure:^(NSError * error) {
        
    }];    
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//图片上传之前的处理
-(UIImage *)getImage:(UIImage *)normalImage
{
    UIImage *normal = [ResizeImage colorControlWithImage:normalImage brightness:0.3 contrast:0.3 saturation:0.0];//将图片变黑白
    
    double wideRadious = 500/normal.size.width;//只定500宽，不定高
    UIImage *resizeImage = [ResizeImage reSizeImage:normal toSize:CGSizeMake(500, normal.size.height*wideRadious)];//裁减尺寸
    
    NSData *imageData = UIImageJPEGRepresentation(resizeImage,1);
    long kb = [imageData length]/1024;//计算大小
    if (kb<280) {
        return resizeImage;
    }else{
        double radious = kb/280;
        NSData *imageDataNew = UIImageJPEGRepresentation(resizeImage, radious);//改变大小
        UIImage *imageNew = [UIImage imageWithData:imageDataNew];
        return imageNew;
    }
    
}


#pragma mark <UICollectionViewDelegate>
#pragma mark - collectionViewFlawlayerout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(([UIScreen mainScreen].bounds.size.width-46)/4.0,([UIScreen mainScreen].bounds.size.width-46)/4.0);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 8, 0, 8);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 8;
}
@end
