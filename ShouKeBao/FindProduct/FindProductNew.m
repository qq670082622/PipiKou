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

#define Color(R, G, B) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1]

/**
 **找产品主导航页
 **/

@interface FindProductNew ()<UITableViewDataSource, UITableViewDelegate, notifi, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) IBOutlet LeftTableView *leftTableView;
@property (strong, nonatomic) IBOutlet RightCollectionView *RightCollection;
@property (strong, nonatomic) IBOutlet UIButton *ProductSearch;
@property (strong, nonatomic) IBOutlet UIButton *selectStation;
@property (nonatomic, strong) NSMutableArray * leftDataArray;
@property (nonatomic, strong) NSMutableArray * hottDataArray;
@property (strong, nonatomic) NSMutableArray *hotSectionArr;
@property (nonatomic, strong)NSMutableArray * NomalDataArray;
//@property (strong, nonatomic) IBOutlet UIButton *stationName;
@property (nonatomic, strong)UIView * selectBackGroundView;
@property (nonatomic, strong)NSMutableDictionary * cacheDic;
- (IBAction)ProductSearch:(id)sender;
- (IBAction)selectStaion:(id)sender;

@end

@implementation FindProductNew

- (void)viewDidLoad {
    [super viewDidLoad];
//    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
//        // For insetting with a navigation bar
//        UIEdgeInsets insets = UIEdgeInsetsMake(64, 0, 0, 0);
//        self.tableView.contentInset = insets;
//        self.tableView.scrollIndicatorInsets = insets;
//    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self firstSetView];
    [self loadDataSourceLeft];
    [self loadHotData];
    self.leftTableView.frame = CGRectMake(5, 100, 10, 123);
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"FindProduct"];
    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
    [MobClick event:@"FindProductNum" attributes:dict];
    [MobClick event:@"ShouKeBaoAndFindproductNum" attributes:dict];
    NSUserDefaults *udf = [NSUserDefaults standardUserDefaults];
    NSString *subStationName = [udf stringForKey:@"SubstationName"];
    if (subStationName) {
        [self.selectStation setTitle:subStationName forState:UIControlStateNormal];
        self.selectStation.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 10);
    }else if (!subStationName){
        [self.selectStation setTitle:@"上海" forState:UIControlStateNormal];
        self.selectStation.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 10);
    }
    //[self.selectStation addTarget:self action:@selector(certaindown) forControlEvents:UIControlEventTouchDown];
    [self.selectStation addTarget:self action:@selector(selectout) forControlEvents:UIControlEventTouchUpOutside];
}
//只要点击分站，就会调用下面的方法
//-(void)certaindown{
//    NSLog(@"已经点击");
//    self.selectStation.selected = YES;
//    [self.selectStation setBackgroundImage:[UIImage imageNamed:@"selestatioinbg"] forState:UIControlStateSelected];
//}
//点击分站之后向外滑动，分站选中效果取消
-(void)selectout{
    self.selectStation.selected = NO;
    NSLog(@"已经向外滑动");
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"FindProduct"];
}

- (void)firstSetView{
    self.leftTableView.delegate = self;
    self.leftTableView.dataSource = self;
    self.leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.RightCollection.delegate = self;
    self.RightCollection.dataSource = self;
    self.navigationItem.leftBarButtonItem = nil;
    [WMAnimations WMAnimationMakeBoarderWithLayer:self.ProductSearch.layer andBorderColor:[UIColor lightGrayColor] andBorderWidth:0.5 andNeedShadow:NO andCornerRadius:4];
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
-(NSMutableDictionary *)cacheDic{
    if (!_cacheDic) {
        _cacheDic = [NSMutableDictionary  dictionaryWithCapacity:1];
    }
    return _cacheDic;
}

#pragma mark - LoadDataSource
- (void)loadDataSourceLeft
{
    [IWHttpTool WMpostWithURL:@"/Product/GetNavigationType" params:nil success:^(id json) {
        [self.leftDataArray removeAllObjects];
        leftModal * model = [[leftModal alloc]init];
        [self.leftDataArray addObject:model];
        NSLog(@"%@", json[@"NavigationTypeList"]);
        for(NSDictionary *dic in json[@"NavigationTypeList"]){
            leftModal *modal = [leftModal modalWithDict:dic];
            [self.leftDataArray addObject:modal];
        }
        [self.leftTableView reloadData];
        //默认选中第一个cell
        [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    } failure:^(NSError *error) {
        NSLog(@"左侧栏请求错误！～～～error is ~~~~~~~~~%@",error);
    }];
}
-(void)loadHotData
{
    MBProgressHUD *hudView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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
                NSLog(@"%@", dic[@"ProductList"]);
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
            NSMutableArray * arraytemp = [NSMutableArray array];
            for(NSDictionary *dic in json[@"NavigationMainList"] ){
                rightModal2 *modal = [rightModal2 modalWithDict:dic];
                [searchKeyArr addObject:dic[@"ID"]];
                [self.NomalDataArray addObject:modal];
                [arraytemp addObject:modal];
                [hudView hide:YES];
            }
            //将每一个数据源放入缓存字典中，
            [self.cacheDic setObject:arraytemp forKey:[NSString stringWithFormat:@"%ld", (long)self.SelectNum]];
            [self.RightCollection reloadData];
            NSLog(@"%@新加载%@", arraytemp, self.cacheDic);
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
    //打开app设置，iOS8新特性
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
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
        if (cell.selected) {
        cell.iconImage.image = [UIImage imageNamed:@"APPhot2"];
        }else{
        cell.iconImage.image = [UIImage imageNamed:@"APPhot"];
        }
    }else{
    cell.model = model;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return 75;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    leftModal * model = self.leftDataArray[indexPath.row];
    //左边栏点击事件统计
    NSDictionary * dic;
    if (indexPath.row == 0) {
        dic = @{@"SubName":@"热门推荐"};
    }else{
        dic = @{@"SubName":model.Name};
    }
    NSLog(@"%@", dic);
    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:dic];
    [MobClick event:@"FindProductSubNameClick" attributes:dict];
    if (indexPath.row == self.SelectNum) {
        return;
    }

    self.SelectNum = indexPath.row;
    LeftTableCell * cell = (LeftTableCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == 0) {
        self.leftSelectType = SelectTypeHot;
        cell.iconImage.image = [UIImage imageNamed:@"APPhot2"];
        //添加一个缓存机制，只要有数据，就不用重新加载；
        if (self.hottDataArray) {
            [self.RightCollection reloadData];
        }else{
        [self loadHotData];
        }
    }else{
        [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:model.MaxIconFocus] placeholderImage:nil];
        if ([model.Name isEqualToString:@"邮轮"]) {
            self.leftSelectType = SelectTypeShip;
        }else{
            self.leftSelectType = SelectTypeNomal;
        }
        //每一次点击的时候，判断此数据源是否已经加载， 如果已存在，直接给数据元赋值，如果不存在，请求接口， 将数据源放入缓存字典中
        if ([self.cacheDic objectForKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]]) {
            //[self.NomalDataArray removeAllObjects];
            //添加缓存机制
            self.NomalDataArray = [[self.cacheDic objectForKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]] mutableCopy];
            NSLog(@"%@", self.cacheDic);
            [self.RightCollection reloadData];
        }else{
        [self loadNomalDataSourceWithType:model.Type];
        }
        
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
    }else{
        NormalCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NormalCollectionCell" forIndexPath:indexPath];
        rightModal2 * model = self.NomalDataArray[indexPath.section];
        cell.subTatilLab.text = model.subNameArray[indexPath.row];
        [WMAnimations WMAnimationMakeBoarderWithLayer:cell.subTatilLab.layer andBorderColor:Color(0xdd, 0xdd, 0xdd) andBorderWidth:0.5 andNeedShadow:NO andCornerRadius:2];
        return cell;
    }
}
#pragma mark - collectionViewFlawlayerout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.leftSelectType == SelectTypeHot) {
        return CGSizeMake(collectionView.frame.size.width, 77);
    }else{
        rightModal2 * model = self.NomalDataArray[indexPath.section];
        if ([model.title isEqualToString:@"特价线路"]) {
            return CGSizeMake(collectionView.frame.size.width - 28, 45);
        }else{
            if ([UIScreen mainScreen].bounds.size.width == 320) {
                return CGSizeMake(108.8, 45);
            }else if([UIScreen mainScreen].bounds.size.width == 414){
                return CGSizeMake(99.8, 45);
            }else{
                return CGSizeMake(89, 45);
            }
        }
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 0, 10);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    HeaderSectionView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"HeaderSectionView" forIndexPath:indexPath];
    headerView.spotView.layer.cornerRadius = 5;
    //给圆点以及文字设置颜色
    NSArray * colorArray = @[Color(26, 153, 218), Color(0xff, 0x99, 0x00), Color(0xcc, 0x66, 0xff), Color(0x00, 0xcc, 0x00), Color(0xff, 0x33, 0x33)];
    headerView.spotView.backgroundColor = colorArray[indexPath.section%5];
    headerView.allBtn.titleLabel.textColor = colorArray[indexPath.section%5];
    [headerView.allBtn setTitleColor:colorArray[indexPath.section%5] forState:UIControlStateNormal];
    [headerView.allBtn setTitleColor:colorArray[indexPath.section%5] forState:UIControlStateHighlighted];
    headerView.FindProductNav = self.navigationController;
    if (self.leftSelectType == SelectTypeHot) {
        headerView.nameLab.text = self.hotSectionArr[indexPath.section];
        headerView.seperateLine.hidden = YES;
        headerView.allBtn.hidden = YES;
    }else{
        rightModal2 * model = self.NomalDataArray[indexPath.section];
        headerView.nameLab.text = model.title;
        headerView.seperateLine.hidden = NO;
        headerView.allBtn.hidden = NO;
    }
    return headerView;

}
//设置选中状态
//cell点击高亮状态
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView cellForItemAtIndexPath:indexPath].selected = YES;
    return YES;
}
//cell取消高亮状态
- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView cellForItemAtIndexPath:indexPath].selected = NO;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    //当前列表是热门推荐点击事件
    if (self.leftSelectType == SelectTypeHot) {
        ProduceDetailViewController *detail = [[ProduceDetailViewController alloc] init];
        rightModal *model =  self.hottDataArray[indexPath.section][indexPath.row];
        NSString *productUrl = model.productUrl;
        detail.produceUrl = productUrl;
        detail.shareInfo = model.ShareInfo;
        NSLog(@"%@.... %@", model.ShareInfo, productUrl);
        detail.fromType = FromHotProduct;
        //判断下个页面能否有关闭按钮
        detail.m = 1;
        [self.navigationController pushViewController:detail animated:YES];
    }else{
        //当前列表页非热门推荐
        rightModal2 * model = self.NomalDataArray[indexPath.section];
        ProductList *list = [[ProductList alloc] init];
        list.productListFrom = FromKeyWord;
        
        list.pushedSearchK = model.searchKeyArray[indexPath.row];
        list.title = model.subNameArray[indexPath.row];
//        list.pushedArr = _pushArr;
        NSDictionary * dic = @{@"TwoSubName":model.searchKeyArray[indexPath.row]};
        BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:dic];
        [MobClick event:@"FindProductList" attributes:dict];
        [self.navigationController pushViewController:list animated:YES];

    }
}

//设置行间距；
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if(self.leftSelectType == SelectTypeHot)
    {
        return 0.0;
    }
    else
    {
        return 6.0;
    }
}
////设置左右最小间距
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
//    return 0.f;
//}

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
