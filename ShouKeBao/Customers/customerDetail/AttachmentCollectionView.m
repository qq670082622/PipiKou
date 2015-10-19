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
@interface AttachmentCollectionView ()<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic ,strong) NSMutableArray *dataSource;
@property(nonatomic , assign) BOOL isEditing;
@property (nonatomic, strong) UIButton * deleteBtn;

@end

@implementation AttachmentCollectionView

static NSString * const reuseIdentifier = @"AttachmentCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"证件附件";
    [self loadData];
    [self baseSetUp];
    [self setUpRightButton];
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    // Do any additional setup after loading the view.
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
    NSArray * picArray = [self.picUrl componentsSeparatedByString:@","];
    for (NSString * str in picArray) {
        [self.dataSource addObject:str];
        [self.dataSource addObject:str];
        
    }
    [self.collectionView reloadData];
}
-(NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        self.dataSource = [NSMutableArray array];
    }
    return _dataSource;
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
-(void)deletePic{
    if (self.isEditing) {
        
    }else{
    
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
        [cell.theUserImage sd_setImageWithURL:[NSURL URLWithString:self.dataSource[indexPath.row]]];

    }else{
        cell.cellState = NormalState;
        if (indexPath.row == 0) {
            cell.theUserImage.image = [UIImage imageNamed:@""];
        }else{
            [cell.theUserImage sd_setImageWithURL:[NSURL URLWithString:self.dataSource[indexPath.row-1]]];
        }

    }
    // Configure the cell
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    AttachmentCollectionCell *cell = (AttachmentCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (self.isEditing) {
        if (cell.cellState == NormalState) {
            NSLog(@"%@", NSStringFromCGSize(cell.theUserImage.image.size));
        }else{
            cell.cellState = cell.cellState == UnCheckedState ? CheckedState : UnCheckedState;
        }
    }else{
    if (indexPath.row == 0) {
        [self addCustomPic];
    }else{
        if (cell.cellState == NormalState) {
            NSLog(@"%@", NSStringFromCGSize(cell.theUserImage.image.size));
            }else{
                cell.cellState = cell.cellState == UnCheckedState ? CheckedState : UnCheckedState;
            }
    }
    }
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
//    UIImage * newImage = [ResizeImage reSizeImage:image toSize:CGSizeMake(120, 120)];
    NSData *data = UIImageJPEGRepresentation(imageNew, 1.0);
    NSString *imageStr = [data base64EncodedStringWithOptions:0];
    
    [IWHttpTool postWithURL:@"File/UploadPicture" params:@{@"FileStreamData":imageStr,@"PictureType":@"7"} success:^(id json) {
        NSLog(@"%@*******", json);

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

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
