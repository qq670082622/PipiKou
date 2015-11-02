//
//  QRPhotoTableViewController.m
//  ShouKeBao
//
//  Created by 张正梅 on 15/10/15.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "QRPhotoTableViewController.h"
#import "QRSaveCustomerViewController.h"
#import "WriteFileManager.h"
#import "IWHttpTool.h"
#import "MBProgressHUD+MJ.h"
#import "MJRefresh.h"
#import "personIdModel.h"
#import "UIImageView+WebCache.h"

#define VIEW_WIDTH  self.view.bounds.size.width
#define VIEW_HEIGHT self.view.bounds.size.height
#define itemW (self.view.frame.size.width -9)/4
#define gap 3
#define pageSize 40

@interface QRPhotoTableViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UIActionSheetDelegate>

//@property (nonatomic, strong)UICollectionView *collectionV;
//@property (nonatomic, assign)BOOL PhotoFlag;

@property (nonatomic, copy)NSString *pageNum;
@property (nonatomic, strong)UIActionSheet *sheet;
@property(nonatomic, weak)UIImageView *MaxPhotoView;

@property (nonatomic,strong)NSMutableArray *minPicArr;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)NSMutableArray *editArr;

@property (nonatomic, assign)CGRect  currentCellPicRect;
//@property (weak, nonatomic) IBOutlet UIView *subViewPhoto;

@property (nonatomic,assign)int pageIndex;// 当前页
@property (nonatomic,assign) BOOL isRefresh;
@property (nonatomic,copy) NSString *totalNumber;
@property (nonatomic, strong)NSMutableDictionary * postDic;

- (IBAction)canclePhoto:(id)sender;
- (IBAction)savePhoto:(id)sender;

@end

@implementation QRPhotoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.view addSubview:self.collectionV];
    [self rightBarbutton];
    [self.view addSubview:self.subViewPhoto];
    [self initPull];
}

#pragma mark - 各种初始化
- (UICollectionView *)collectionV{
    if (!_collectionV) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.itemSize = CGSizeMake(itemW, itemW);
        flowLayout.minimumLineSpacing = 3;
        flowLayout.minimumInteritemSpacing = 3;
        _collectionV = [[UICollectionView alloc]initWithFrame:CGRectMake(0, gap, VIEW_WIDTH, VIEW_HEIGHT-gap-64) collectionViewLayout:flowLayout];
        _collectionV.backgroundColor = [UIColor whiteColor];
        _collectionV.dataSource = self;
        _collectionV.delegate = self;
       
        [_collectionV registerClass:[QRPhotoCollectionViewCell class] forCellWithReuseIdentifier:@"YY"];
           }
    return _collectionV;
}
-(NSMutableArray *)dataArr{
    if (_dataArr == nil) {
        self.dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
-(NSMutableArray *)editArr{
    if (_editArr == nil) {
        self.editArr = [NSMutableArray array];
    }
    return _editArr;
}
- (NSMutableDictionary *)postDic{
    if (!_postDic) {
        self.postDic = [NSMutableDictionary dictionary];
    }
    return _postDic;
}
#pragma mark - 刷新和分页
- (void)initPull{
    [self.collectionV addHeaderWithTarget:self action:@selector(headRefish)dateKey:nil];
    [self.collectionV headerBeginRefreshing];
    [self.collectionV addFooterWithTarget:self action:@selector(foodRefish)];
    self.collectionV.alwaysBounceVertical = YES;
    self.collectionV.headerPullToRefreshText = @"下拉刷新";
    self.collectionV.headerRefreshingText = @"正在刷新中";
    self.collectionV.footerPullToRefreshText = @"上拉刷新";
    self.collectionV.footerRefreshingText = @"正在刷新";

}
-(void)headRefish{
    self.isRefresh = YES;
    self.pageIndex = 1;
    [self loadData];
}
- (void)foodRefish{
    self.isRefresh = NO;
    self.pageIndex++;
    if (self.pageIndex  > [self getTotalPage]) {
        [self.collectionV footerEndRefreshing];
    }else{
        [self loadData];
    }
}
- (NSInteger)getTotalPage
{
    NSInteger cos = [self.totalNumber integerValue]%pageSize;
    if (cos == 0) {
        return [self.totalNumber integerValue]/pageSize;
    }else{
        return [self.totalNumber integerValue]/pageSize+1;
    }
}

#pragma mark- UICollectionView -delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    QRPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YY" forIndexPath:indexPath];
    personIdModel *model = self.dataArr[indexPath.row];
    if (self.PhotoFlag) {
        cell.cellState = UnChoosedState;
    }else{
        cell.cellState = 6;
    }
    cell.model = model;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    QRPhotoCollectionViewCell *cell = (QRPhotoCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if (self.PhotoFlag == NO) {
        [self changePicToMaxPic:cell indexPath:indexPath];
    }else{
        if (cell.cellState == ChoosedState) {
            [self.editArr removeObject:([self.dataArr objectAtIndex:indexPath.row])];
        }else if(cell.cellState == UnChoosedState){
            [self.editArr addObject:([self.dataArr objectAtIndex:indexPath.row])];
        }
        cell.cellState = cell.cellState == ChoosedState ? UnChoosedState : ChoosedState;
    }
}

#pragma mark = 点击大图返回之前大小
- (void)changePicToMaxPic:(UICollectionViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    
    CGRect cellCurrentRect = CGRectMake(cell.frame.origin.x,cell.frame.origin.y - self.collectionV.contentOffset.y, cell.frame.size.width, cell.frame.size.height);
    UIImageView *photoView = [[UIImageView alloc]initWithFrame:cellCurrentRect];
    photoView.userInteractionEnabled = YES;
    photoView.backgroundColor = [UIColor blackColor];
    photoView.contentMode = UIViewContentModeScaleAspectFit;
    
    NSString *picStr = ((personIdModel *)[self.dataArr objectAtIndex:indexPath.row]).PicUrl;
    NSLog(@"%@", picStr);
    NSURL *url = [NSURL URLWithString:picStr];
    [photoView sd_setImageWithURL:url];
    
    [self.view addSubview:photoView];
    self.MaxPhotoView = photoView;
    self.currentCellPicRect = cellCurrentRect;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.MaxPhotoView.frame = self.collectionV.frame;
        
    } completion:^(BOOL finished) {
        
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotBack:)];
    [photoView addGestureRecognizer:tap];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longGesture:)];
    [photoView addGestureRecognizer:longPress];
}

- (void)gotBack:(UITapGestureRecognizer *)tap{
    [UIView animateWithDuration:0.5 animations:^{
       self.MaxPhotoView.frame = self.currentCellPicRect;
    } completion:^(BOOL finished) {
        [self.MaxPhotoView removeFromSuperview];
    }];
}

#pragma mark = 对IdentifyVC通知的应答方法
- (void)rightBarbutton{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(editCustomerPhoto) name:@"edit1" object:nil];
}
- (void)editCustomerPhoto{
    if (self.PhotoFlag == 0) {
        self.subViewPhoto.hidden = NO;
        self.collectionV.frame = CGRectMake(0, gap, VIEW_WIDTH, VIEW_HEIGHT-gap-53);
    }else{
        self.subViewPhoto.hidden = YES;
        self.collectionV.frame = CGRectMake(0, gap, VIEW_WIDTH, VIEW_HEIGHT-gap);
    }
    self.PhotoFlag = !self.PhotoFlag;
    [self.collectionV reloadData];
}

#pragma mark = 删除图片
- (IBAction)canclePhoto:(id)sender {
    if (self.editArr.count == 0) {
        [self pointOut];
    }else{
        NSMutableArray *arr = [NSMutableArray array];
        
        for (int i = 0; i<self.editArr.count; i++) {

          [arr addObject: [self.editArr[i]RecordId]];
        }
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:arr forKey:@"RecordIds"];
        
        [IWHttpTool WMpostWithURL:@"Customer/DeleteCredentialsPicRecord" params:dic success:^(id json) {
            NSLog(@"批量删除客户图片 返回json is %@",json);
        } failure:^(NSError *error) {
            NSLog(@"批量删除客户图片失败，返回error is %@",error);
        }];
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.collectionV reloadData];
            [self loadData];
        });

      
        [self.IDVC editCustomerDetail];
        self.PhotoFlag = NO;
        [self.editArr removeAllObjects];
        [self.collectionV reloadData];
        [MBProgressHUD showSuccess:@"操作成功"];
    }
}

#pragma mark - 保存为客户
- (IBAction)savePhoto:(id)sender {
    if (self.editArr.count == 0) {
        [self pointOut];
    }else{

        [self pushToSaveVC];
        [self.IDVC editCustomerDetail];
        [self.editArr removeAllObjects];
        self.PhotoFlag = NO;
    }
}


- (void)pointOut{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您没有选中任何图片!" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
    [alert show];
}

- (void)pushToSaveVC{
    NSMutableArray * picArray = [NSMutableArray array];
    for (personIdModel * model in self.editArr) {
        [picArray addObject:model.PicUrl];
    }
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"QR" bundle:nil];
    QRSaveCustomerViewController *QRSaveCustomerVC = [sb instantiateViewControllerWithIdentifier:@"saveboard"];
    QRSaveCustomerVC.picArray = picArray;
    [self.IDVC.navigationController pushViewController:QRSaveCustomerVC animated:YES];
}

#pragma mark - 长按保存到相册
- (void)longGesture:(UILongPressGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        if (!self.sheet) {
            self.sheet = [[UIActionSheet alloc] initWithTitle:@"提示" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"保存到相册" otherButtonTitles:nil, nil];
        }
        [self.sheet showInView:self.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
                UIImageWriteToSavedPhotosAlbum(_MaxPhotoView.image, nil, nil, nil);
                if (_MaxPhotoView.image) {
                    [self showMessageWithText:@"保存成功"];
                }
            }
}
- (void)showMessageWithText:(NSString *)text{
    UILabel *alertLabel = [[UILabel alloc] init];
    alertLabel.font = [UIFont systemFontOfSize:15];
    alertLabel.text = text;
    alertLabel.textAlignment = NSTextAlignmentCenter;
    alertLabel.layer.masksToBounds = YES;
    alertLabel.textColor = [UIColor whiteColor];
    alertLabel.bounds = CGRectMake(0, 0, 100, 80);
    alertLabel.center = CGPointMake(self.view.frame.size.width * 0.5, self.view.frame.size.height * 0.5);
    alertLabel.backgroundColor = [UIColor colorWithRed:25/255.0 green:25/255.0 blue:25/255.0 alpha:1.0];
    alertLabel.layer.cornerRadius = 10.0f;
    [[UIApplication sharedApplication].keyWindow addSubview:alertLabel];
    
    [UIView animateWithDuration:.5 animations:^{
        alertLabel.alpha = 0.0;
    } completion:^(BOOL finished) {
        [alertLabel removeFromSuperview];
    }];
}

#pragma mark - 数据加载
- (void)loadData{
//    if (!_isLogin) {  //注record是未登录时的识别纪录，而record2是未登录时添加的客户
//        
//        [self.dataArr removeAllObjects];
//        NSArray *arr = [NSArray arrayWithArray:[WriteFileManager readData:@"record"]] ;
//        NSLog(@"dataArr is %@ - --- arr is %@",_dataArr,arr);
//        for(NSDictionary *dic in arr) {
//            personIdModel *model = [personIdModel modelWithDict:dic];
//            [self.dataArr addObject:model];
//        }
//        [self ifArrIsNull:_dataArr];
//        [self.collectionV reloadData];
//        NSLog(@"1 dataArr = %@", self.dataArr);
//    }else if (_isLogin){
    
    NSLog(@"page = %d", self.pageIndex);
    NSString *pageNum = [NSString stringWithFormat:@"%d", self.pageIndex];
        [IWHttpTool postWithURL:@"Customer/GetCredentialsPicRecordList" params:@{@"RecordType":@"0",@"SortType":@"2",@"PageIndex":pageNum,@"PageSize":@"40"}  success:^(id json) {
      
            if (self.isRefresh) {
                [self.dataArr removeAllObjects];
                [self.editArr removeAllObjects];
            }
             NSLog(@"json =  %@", json);
//             NSLog(@",,,,, total = %@", json[@"TotalCount"]);
            
            self.totalNumber = json[@"TotalCount"];
            for (NSDictionary *dic in json[@"CredentialsPicRecordList"]) {
                personIdModel *model = [personIdModel modelWithDict:dic];
                if (![model.PicUrl isEqualToString:@""]) {
                  [self.dataArr addObject:model] ;
                }
            }
//              NSLog(@"self.dataArr.count = %d", self.dataArr.count);
            [self ifArrIsNull:_dataArr];
            [self.collectionV reloadData];
            [self.collectionV headerEndRefreshing];
            [self.collectionV footerEndRefreshing];
        } failure:^(NSError *error) {
            NSLog(@" error history");
        }];
}

//没有纪录时调用
-(void)ifArrIsNull:(NSMutableArray *)arr{
    if (arr.count == 0) {
        self.navigationItem.rightBarButtonItem = nil;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"没有历史纪录" message:@"您还没有通过证件神器进行扫描" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
    }
    
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];;
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
