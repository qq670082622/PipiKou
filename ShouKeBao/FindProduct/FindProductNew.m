//
//  FindProductNew.m
//  ShouKeBao
//
//  Created by 冯坤 on 15/8/10.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "FindProductNew.h"
#import "LeftTableView.h"
#import "RightCollectionView.h"
#import "LeftTableCell.h"
#import "UIImageView+WebCache.h"   
#import "leftModal.h"
#import "SearchProductViewController.h"
#import "BaseClickAttribute.h"
#import "MobClick.h"
#import "StationSelect.h"
#import "IWHttpTool.h"
#import "MBProgressHUD.h"
#import "HotProductCollectionCell.h"
#import "rightModal.h"
#import "HeaderSectionView.h"
#import "WMAnimations.h"
@interface FindProductNew ()<UITableViewDataSource, UITableViewDelegate, notifi, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) IBOutlet LeftTableView *leftTableView;
@property (strong, nonatomic) IBOutlet RightCollectionView *RightCollection;
@property (strong, nonatomic) IBOutlet UIButton *ProductSearch;
@property (strong, nonatomic) IBOutlet UIButton *selectStation;
@property (nonatomic, strong) NSMutableArray * leftDataArray;
@property (nonatomic, strong) NSMutableArray * hottDataArray;
@property (strong, nonatomic) NSMutableArray *hotSectionArr;

@property (nonatomic, strong)UIView * selectBackGroundView;
- (IBAction)ProductSearch:(id)sender;
- (IBAction)selectStaion:(id)sender;

@end

@implementation FindProductNew

- (void)viewDidLoad {
    [super viewDidLoad];
    [self firstSetView];
    [self loadDataSourceLeft];
    [self loadHotData];
    
    // Do any additional setup after loading the view.
}
- (void)firstSetView{
    self.leftTableView.delegate = self;
    self.leftTableView.dataSource = self;
    self.leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.RightCollection.delegate = self;
    self.RightCollection.dataSource = self;
    self.navigationItem.leftBarButtonItem = nil;

    self.title = @"找产品";
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
#pragma mark - lazyLoad
-(NSMutableArray *)leftDataArray{
    if (!_leftDataArray) {
        _leftDataArray = [NSMutableArray arrayWithCapacity:1];
   }
    return _leftDataArray;
}
-(NSMutableArray *)hottDataArray{
    if (!_hottDataArray) {
        _hottDataArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _hottDataArray;
}
-(NSMutableArray *)hotSectionArr{
    if (!_hotSectionArr) {
        _hotSectionArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _hotSectionArr;
}


-(UIView *)selectBackGroundView{
    if (!_selectBackGroundView) {
        _selectBackGroundView = [[UIView alloc]init];
    }
    return _selectBackGroundView;
}
#pragma mark - LoadDataSource
- (void)loadDataSourceLeft
{
    MBProgressHUD *hudView = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    hudView.labelText = @"加载中...";
    [IWHttpTool WMpostWithURL:@"/Product/GetNavigationType" params:nil success:^(id json) {
        [self.leftDataArray removeAllObjects];
        leftModal * model = [[leftModal alloc]init];
        [self.leftDataArray addObject:model];
        NSLog(@"%@", json[@"NavigationTypeList"]);
        for(NSDictionary *dic in json[@"NavigationTypeList"]){
            leftModal *modal = [leftModal modalWithDict:dic];
            [self.leftDataArray addObject:modal];
        }
        [hudView show:YES];
        [hudView hide:YES afterDelay:0.5];
        [self.leftTableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"左侧栏请求错误！～～～error is ~~~~~~~~~%@",error);
    }];
}
-(void)loadHotData
{
    
    MBProgressHUD *hudView = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    
    hudView.labelText = @"加载中...";
    
    [hudView show:YES];
    
    [IWHttpTool WMpostWithURL:@"/Product/GetRankingProduct" params:nil success:^(id json) {
//         NSLog(@"---------热卖返回json is %@--------",json);
        [self.hottDataArray removeAllObjects];
         [self.hotSectionArr removeAllObjects];
        NSMutableArray *hotDicNameArr = [NSMutableArray array];
        for (NSDictionary *dic in json[@"RankingProdctList"]) {
            [hotDicNameArr addObject:dic[@"Name"]];
        }
        self.hotSectionArr = hotDicNameArr;   //获取section数组
        for (NSDictionary *dic in json[@"RankingProdctList"]) {
            NSMutableArray *tmp = [NSMutableArray array];
            for (NSDictionary *dict in dic[@"ProductList"]) {
                rightModal *modal = [rightModal modalWithDict:dict];
                [tmp addObject:modal];
            }
            [self.hottDataArray addObject:tmp];
        }//获得热卖总数组
        
         NSLog(@"------------hotarr------------------%@",self.hottDataArray);
        
        [self.RightCollection reloadData];
        [hudView hide:YES];
    } failure:^(NSError *error) {
        NSLog(@"-----------hot json 请求失败，原因：%@",error);
    }];
    
    
}

#pragma mark - 找产品按钮和分站选择按钮点击
- (IBAction)ProductSearch:(id)sender {
    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
    [MobClick event:@"FindProductSearchList" attributes:dict];
    
    SearchProductViewController *SPVC = [[SearchProductViewController alloc] init];
    SPVC.isFromFindProduct = YES;
    [self.navigationController pushViewController:SPVC animated:NO];

}

- (IBAction)selectStaion:(id)sender {
    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
    [MobClick event:@"FindProductStationClick" attributes:dict];
    
    StationSelect *station = [[StationSelect alloc] init];
    station.delegate = self;
    [self.navigationController pushViewController:station animated:YES];

}

#pragma mark - tableViewDatasourceDelegate、
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.leftDataArray.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LeftTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ProductLeftCell" forIndexPath:indexPath];
    cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
    leftModal * model = self.leftDataArray[indexPath.row];
    if (indexPath.row == 0) {
       cell.leftName.text = @"热门推荐";
        cell.iconImage.image = [UIImage imageNamed:@"APPhot"];
    }else{
    cell.model = model;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    leftModal * model = self.leftDataArray[indexPath.row];
    if (model.Name.length > 6) {
        return 75;
    }else{
    return 55;
    }
}

#pragma mark - collectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.hottDataArray[section]count];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.hotSectionArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HotProductCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RighthotCell" forIndexPath:indexPath];
    rightModal * model = self.hottDataArray[indexPath.section][indexPath.row];
    cell.modal = model;
    return cell;
}
#pragma mark - collectionViewFlawlayerout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.leftDataArray) {
        return CGSizeMake(collectionView.frame.size.width, 77);
        
    }else{
        return CGSizeMake(50, 50);
    }
}
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//
//}
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
//
//}
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
//
//}
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
//
//}
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
//
//}




- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    HeaderSectionView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"HeaderSectionView" forIndexPath:indexPath];
    headerView.nameLab.text = self.hotSectionArr[indexPath.section];
    headerView.spotView.layer.cornerRadius = 7.5;
    headerView.spotView.backgroundColor = [UIColor redColor];

    return headerView;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    HealthCollectionViewCell * cell = (HealthCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    UIStoryboard * SB = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//    HealthDetailViewController * HDVC = [SB instantiateViewControllerWithIdentifier:@"sb_healthDetail"];
//    HDVC.searchStr = cell.nameLabel.text;
//    [self.navigationController pushViewController:HDVC animated:YES];
}



@end
