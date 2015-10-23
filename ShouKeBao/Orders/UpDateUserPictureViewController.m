//
//  UpDateUserPictureViewController.m
//  ShouKeBao
//
//  Created by 冯坤 on 15/10/21.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "UpDateUserPictureViewController.h"
#import "UpDateUserPictureViewCell.h"
#import "UIImageView+WebCache.h"
#import "IWHttpTool.h"
#import "CustomerIdsModel.h"
#import "OrderDetailViewController.h"
#import "ButtonDetailViewController.h"
@interface UpDateUserPictureViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic, strong)NSMutableArray * selectedCustomerIDs;

@end

@implementation UpDateUserPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择客户附件";
    [self loadDate];
    [self setUpRightButton];
    // Do any additional setup after loading the view.
}
-(NSMutableArray *)selectedCustomerIDs{
    if (_selectedCustomerIDs == nil) {
        self.selectedCustomerIDs  = [NSMutableArray array];
    }
    return _selectedCustomerIDs;
}
-(NSMutableArray *)dateArray{
    if (_dateArray == nil) {
        self.dateArray  = [NSMutableArray array];
    }
    return _dateArray;
}

- (void)loadDate{
    NSDictionary * params = @{@"CustomerIds":self.customerIds};
    [IWHttpTool postWithURL:@"/Customer/GetCustomerPicList" params:params success:^(id json) {
        if (json) {
            NSArray * dic = json[@"CustomerList"];
            NSLog(@"%@",dic);
            for (NSDictionary * dict in dic) {
                NSLog(@"%@22",dict);
                CustomerIdsModel * model = [CustomerIdsModel modalWithDict:dict];
                NSLog(@"%@", model.Name);
                [self.dateArray addObject:model];
            }
            [self.collectionView reloadData];
        }
    } failure:^(NSError * error) {
        
    }];
}
-(void)setUpRightButton{
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelChoose)];
    self.navigationItem.rightBarButtonItem= barItem;
}
-(void)cancelChoose{
    [self.collectionView reloadData];
}
#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dateArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    CustomerIdsModel * model = self.dateArray[section];
    NSLog(@"%@", model.PictureList);
    return model.PictureList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UpDateUserPictureViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UpdateCell" forIndexPath:indexPath];
    CustomerIdsModel * model = self.dateArray[indexPath.section];
    cell.theUserImage.userInteractionEnabled = YES;
    [cell.theUserImage sd_setImageWithURL:model.PictureList[indexPath.row][@"MinPicUrl"] placeholderImage:nil];
    cell.cellPicUrl = model.PictureList[indexPath.row][@"MinPicUrl"];
    cell.cellCutomerID = model.ID;
    cell.cellState = UnCheckedState;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UpDateUserPictureViewCell *cell = (UpDateUserPictureViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.cellState == UnCheckedState) {
        cell.cellState = CheckedState;
        [self.selectedCustomerIDs addObject:@{@"CustomerId":cell.cellCutomerID,@"PicUrl":cell.cellPicUrl}];
        NSLog(@"%@%@",cell.cellCutomerID, self.customerIds);
        for (int i = 0;i<((CustomerIdsModel *)self.dateArray[indexPath.section]).PictureList.count;i++) {
            NSIndexPath * otherIndexPath = [NSIndexPath indexPathForRow:i inSection:indexPath.section];
            CustomerIdsModel * model = self.dateArray[otherIndexPath.section];
            NSString * picUrl = model.PictureList[otherIndexPath.row][@"MinPicUrl"];
            NSLog(@"%@", picUrl);
            if (![picUrl isEqualToString:cell.cellPicUrl]) {
                UpDateUserPictureViewCell *theCell = (UpDateUserPictureViewCell *)[collectionView cellForItemAtIndexPath:otherIndexPath];
                theCell.cellState = UnCheckedState;
            }
        }
    }else if(cell.cellState == CheckedState){
        cell.cellState = UnCheckedState;
        [self.selectedCustomerIDs removeObject:@{@"CustomerId":cell.cellCutomerID,@"PicUrl":cell.cellPicUrl}];
    }
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
   UICollectionReusableView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"HeaderSectionView" forIndexPath:indexPath];
    //添加视图之前将重用的headerview的子视图全部清除;
    for (UIView * view in headerView.subviews) {
        [view removeFromSuperview];
    }
    UILabel * nameLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, headerView.frame.size.width, headerView.frame.size.height)];
    nameLab.text = [NSString stringWithFormat:@"张%ld",(long)indexPath.section];
    [headerView addSubview:nameLab];
    headerView.backgroundColor = [UIColor lightGrayColor];
    return headerView;
}
#pragma mark - collectionViewFlawlayerout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(([UIScreen mainScreen].bounds.size.width-42)/4.0,([UIScreen mainScreen].bounds.size.width-42)/4.0);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

- (IBAction)ensureClick:(id)sender {
    
    [(OrderDetailViewController *)self.VC postCustomerToServer:self.selectedCustomerIDs];
    [self.navigationController popToViewController:self.VC animated:YES];
}
@end
