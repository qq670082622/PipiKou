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
#import "rightModal2.h"
#import "NormalCollectionCell.h"
#import "SpecialLineCollectionCell.h"
#import "WMAnimations.h"
#import "ProduceDetailViewController.h"
#import "ProductList.h" 
@interface FindProductNew ()<UITableViewDataSource, UITableViewDelegate, notifi, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) IBOutlet LeftTableView *leftTableView;
@property (strong, nonatomic) IBOutlet RightCollectionView *RightCollection;
@property (strong, nonatomic) IBOutlet UIButton *ProductSearch;
@property (strong, nonatomic) IBOutlet UIButton *selectStation;
@property (nonatomic, strong) NSMutableArray * leftDataArray;
@property (nonatomic, strong) NSMutableArray * hottDataArray;
@property (strong, nonatomic) NSMutableArray *hotSectionArr;
@property (nonatomic, strong)NSMutableArray * NomalDataArray;
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
}
- (void)firstSetView{
    self.leftTableView.delegate = self;
    self.leftTableView.dataSource = self;
    self.leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.RightCollection.delegate = self;
    self.RightCollection.dataSource = self;
    self.navigationItem.leftBarButtonItem = nil;
    self.leftSelectType = SelectTypeHot;
    self.title = @"找产品";
}
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

-(NSMutableArray *)NomalDataArray{
    if (!_NomalDataArray) {
        _NomalDataArray  = [NSMutableArray arrayWithCapacity:1];
    }
    return _NomalDataArray;
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
    [hudView show:YES];
    [IWHttpTool WMpostWithURL:@"/Product/GetNavigationType" params:nil success:^(id json) {
        [self.leftDataArray removeAllObjects];
        leftModal * model = [[leftModal alloc]init];
        [self.leftDataArray addObject:model];
        NSLog(@"%@", json[@"NavigationTypeList"]);
        for(NSDictionary *dic in json[@"NavigationTypeList"]){
            leftModal *modal = [leftModal modalWithDict:dic];
            [self.leftDataArray addObject:modal];
        }
        
        [hudView hide:YES];
        [self.leftTableView reloadData];
        //默认选中第一个cell
        [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
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
        [self.RightCollection reloadData];
        
        [hudView hide:YES];
    } failure:^(NSError *error) {
        NSLog(@"-----------hot json 请求失败，原因：%@",error);
    }];
    
    
}
- (void)loadNomalDataSourceWithType:(NSString *)type
{
    MBProgressHUD *hudView = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    hudView.labelText = @"加载中...";
    [hudView show:YES];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:type forKey:@"NavigationType"];
        [IWHttpTool WMpostWithURL:@"/Product/GetNavigationMain" params:dic success:^(id json) {
            [self.NomalDataArray removeAllObjects];
            NSMutableArray *searchKeyArr = [NSMutableArray array];
            for(NSDictionary *dic in json[@"NavigationMainList"] ){
                rightModal2 *modal = [rightModal2 modalWithDict:dic];
                [searchKeyArr addObject:dic[@"ID"]];
                [self.NomalDataArray addObject:modal];
                [hudView hide:YES];
            }
            [self.RightCollection reloadData];
        
            
        } failure:^(NSError *error) {
            NSLog(@"左侧栏请求错误！～～～error is ~~~~~~~~~%@",error);
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LeftTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ProductLeftCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    leftModal * model = self.leftDataArray[indexPath.row];
    if (indexPath.row == 0) {
       cell.leftName.text = @"热门推荐";
        cell.iconImage.image = [UIImage imageNamed:@"APPhot2"];
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.SelectNum) {
        return;
    }
    self.SelectNum = indexPath.row;
    LeftTableCell * cell = (LeftTableCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == 0) {
        self.leftSelectType = SelectTypeHot;
        cell.iconImage.image = [UIImage imageNamed:@"APPhot2"];
        [self loadHotData];
    }else{
        leftModal * model = self.leftDataArray[indexPath.row];
        [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:model.MaxIconFocus] placeholderImage:nil];
        if ([model.Name isEqualToString:@"邮轮"]) {
            self.leftSelectType = SelectTypeShip;
        }else{
            self.leftSelectType = SelectTypeNomal;
        }
        [self loadNomalDataSourceWithType:model.Type];
    }

}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    LeftTableCell * cell = (LeftTableCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row==0) {
        cell.iconImage.image = [UIImage imageNamed:@"APPhot"];
    }else{
        leftModal * model = self.leftDataArray[indexPath.row];
        [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:model.MaxIcon] placeholderImage:nil];
    }
}

//右面的collection代理方法
#pragma mark - collectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.leftSelectType == SelectTypeHot) {
        NSLog(@"%@", self.hottDataArray);
        return [self.hottDataArray[section]count];
    }else{
        rightModal2 * model = self.NomalDataArray[section];
        return model.subNameArray.count;
    }
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (self.leftSelectType == SelectTypeHot) {
        return self.hotSectionArr.count;
    }else{
        return self.NomalDataArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    if (self.leftSelectType == SelectTypeHot) {
        HotProductCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RighthotCell" forIndexPath:indexPath];
        rightModal * model = self.hottDataArray[indexPath.section][indexPath.row];
        cell.modal = model;
        return cell;
    }else if(self.leftSelectType == SelectTypeNomal){
        NormalCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NormalCollectionCell" forIndexPath:indexPath];
        rightModal2 * model = self.NomalDataArray[indexPath.section];
        cell.subTatilLab.text = model.subNameArray[indexPath.row];
        [WMAnimations WMAnimationMakeBoarderWithLayer:cell.subTatilLab.layer andBorderColor:[UIColor lightGrayColor] andBorderWidth:0.5 andNeedShadow:YES andCornerRadius:2];
        return cell;
    }else{
        SpecialLineCollectionCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"SpecialLineCell" forIndexPath:indexPath];
        rightModal2 * model = self.NomalDataArray[indexPath.section];
        [WMAnimations WMAnimationMakeBoarderWithLayer:cell.lineDetail.layer andBorderColor:[UIColor lightGrayColor] andBorderWidth:0.5 andNeedShadow:YES andCornerRadius:2];
        cell.lineDetail.text = model.subNameArray[indexPath.row];
        return cell;
    }

}
#pragma mark - collectionViewFlawlayerout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.leftSelectType == SelectTypeHot) {
        return CGSizeMake(collectionView.frame.size.width, 77);
    }else if(self.leftSelectType == SelectTypeNomal){
        return CGSizeMake(80, 50);
    }else{
        rightModal2 * model = self.NomalDataArray[indexPath.section];
        if ([model.title isEqualToString:@"特价线路"]) {
            return CGSizeMake(collectionView.frame.size.width - 28, 50);
        }else{
            return CGSizeMake(80, 50);
        }
    }
}



- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    HeaderSectionView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"HeaderSectionView" forIndexPath:indexPath];
    headerView.spotView.layer.cornerRadius = 7.5;
    //给圆点以及文字设置颜色
    NSArray * colorArray = @[[UIColor blueColor], [UIColor orangeColor], [UIColor greenColor], [UIColor purpleColor], [UIColor redColor]];
    headerView.spotView.backgroundColor = colorArray[indexPath.section%5];
    headerView.allBtn.titleLabel.textColor = colorArray[indexPath.section%5];
    [headerView.allBtn setTitleColor:colorArray[indexPath.section%5] forState:UIControlStateNormal];
    [headerView.allBtn setTitleColor:colorArray[indexPath.section%5] forState:UIControlStateHighlighted];
    if (self.leftSelectType == SelectTypeHot) {
        headerView.nameLab.text = self.hotSectionArr[indexPath.section];
    }else{
        rightModal2 * model = self.NomalDataArray[indexPath.section];
        headerView.nameLab.text = model.title;
    }
    return headerView;

}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.leftSelectType == SelectTypeHot) {
        ProduceDetailViewController *detail = [[ProduceDetailViewController alloc] init];
        rightModal *model =  self.hottDataArray[indexPath.section][indexPath.row];
        NSString *productUrl = model.productUrl;
        detail.produceUrl = productUrl;
        detail.fromType = FromHotProduct;
        detail.m = 1;
        [self.navigationController pushViewController:detail animated:YES];
    }else{
        rightModal2 * model = self.NomalDataArray[indexPath.section];
        ProductList *list = [[ProductList alloc] init];
        list.pushedSearchK = model.searchKeyArray[indexPath.row];
        list.title = model.subNameArray[indexPath.row];;
//        list.pushedArr = _pushArr;
        NSDictionary * dic = @{@"TwoSubName":model.searchKeyArray[indexPath.row]};
        BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:dic];
        [MobClick event:@"FindProductList" attributes:dict];
        
        [self.navigationController pushViewController:list animated:YES];

    }
}


#pragma  mark - stationSelect delegate
-(void)notifiToReloadData
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *str = [def objectForKey:@"stationSelect"];
    if ([str isEqualToString:@"yes"]) {
        [self loadDataSourceLeft];
        [self loadHotData];
        [def setObject:@"no" forKey:@"stationSelect"];
        [def synchronize];
    }
}

@end
