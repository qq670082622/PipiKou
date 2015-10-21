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
@interface UpDateUserPictureViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@end

@implementation UpDateUserPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择客户附件";
    [self loadDate];
    [self setUpRightButton];
    // Do any additional setup after loading the view.
}
-(NSMutableArray *)dateArray{
    if (!_dateArray) {
        self.dateArray  = [NSMutableArray array];
    }
    return _dateArray;
}
- (void)loadDate{
    NSString * pic = @"http://r.lvyouquan.cn/lyqfile/hold/upload/idcard/2015-10-15/e154b2b5-d3f9-493d-b9a7-63688b47afb1.jpg";
    NSArray * array = @[pic,pic,pic];
    [self.dateArray addObject:array];
    [self.dateArray addObject:array];
    [self.dateArray addObject:array];    
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
    return ((NSArray*)self.dateArray[section]).count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UpDateUserPictureViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UpdateCell" forIndexPath:indexPath];
    cell.theUserImage.userInteractionEnabled = YES;
    [cell.theUserImage sd_setImageWithURL:self.dateArray[indexPath.section][indexPath.row] placeholderImage:nil];
    cell.cellPicUrl = [NSString stringWithFormat:@"%@%lu",self.dateArray[indexPath.section][indexPath.row], (long)indexPath.row];
    cell.cellState = UnCheckedState;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UpDateUserPictureViewCell *cell = (UpDateUserPictureViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.cellState == UnCheckedState) {
        cell.cellState = CheckedState;
        for (int i = 0;i<((NSArray *)self.dateArray[indexPath.section]).count;i++) {
            NSIndexPath * otherIndexPath = [NSIndexPath indexPathForRow:i inSection:indexPath.section];
            NSString * picUrl = [NSString stringWithFormat:@"%@%lu",self.dateArray[otherIndexPath.section][otherIndexPath.row], (long)otherIndexPath.row];
            if (![picUrl isEqualToString:cell.cellPicUrl]) {
                UpDateUserPictureViewCell *theCell = (UpDateUserPictureViewCell *)[collectionView cellForItemAtIndexPath:otherIndexPath];
                theCell.cellState = UnCheckedState;
            }
        }
    }else if(cell.cellState == CheckedState){
        cell.cellState = UnCheckedState;
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
    
}
@end
