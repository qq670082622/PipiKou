//
//  RecommendCell.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/10.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "RecommendCell.h"
#import "Recommend.h"
#import "NSDate+Category.h"
#import "UIImageView+WebCache.h"
#import "ProductRecommendViewController.h"
#import "ImageCollectionViewCell.h"
static NSString * cellid = @"reuse";
NSInteger theNumbe;
#define picViewGap 45

@interface RecommendCell()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) NSArray *photosArr;
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, assign)CGFloat photoViewY;

@end

@implementation RecommendCell


//+(instancetype)cellWithTableView:(UITableView *)tableView

+ (instancetype)cellWithTableView:(UITableView *)tableView number:(NSInteger)number
{
//    NSString *ID = [NSString stringWithFormat:@"reconmendcell%d",((arc4random() % 2500) + 1)];
    theNumbe = number;
    static NSString *cellID = @"RecommendCell";
    RecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[RecommendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.leftLab.font = [UIFont systemFontOfSize:13];
        self.leftLab.textColor = [UIColor lightGrayColor];
        
        UIImageView *redTip = [[UIImageView alloc] init];
        redTip.layer.cornerRadius = 5;
        redTip.layer.masksToBounds = YES;
        [self.contentView addSubview:redTip];
        self.redTip = redTip;
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        
        CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
        double radious = screenH/667;
        if (theNumbe/3 == 0||theNumbe == 3) {
            NSLog(@"1kkk");
            if (screenH == 480) {
                self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(picViewGap+gap, picViewGap*2-gap, ((180*radious+25)-2*picViewGap)*3, (180*radious+25)-2*picViewGap) collectionViewLayout:flowLayout];
            }else{
            self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(picViewGap+gap, picViewGap*2-gap, (180*radious-2*picViewGap)*3, 180*radious-2*picViewGap) collectionViewLayout:flowLayout];
            }
        }else if (theNumbe==4 || theNumbe == 5 || theNumbe == 6){
            if (screenH == 480) {
                
                self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(picViewGap+gap , picViewGap*2-gap, (((260*radious+25)-2*picViewGap)-gap)*3/2+2*gap, (260*radious+25)-2*picViewGap)collectionViewLayout:flowLayout];
            }else{
            
            self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(picViewGap+gap , picViewGap*2-gap, ((270*radious-2*picViewGap)-gap)*3/2+2*gap, 270*radious-2*picViewGap)collectionViewLayout:flowLayout];
            }
        }else{
            if (screenH == 480) {
                self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(picViewGap+gap , picViewGap*2-gap, (400*radious+25)-2*picViewGap, (400*radious+25)-2*picViewGap)collectionViewLayout:flowLayout];
            }else{
                self.collectionView = [[UICollectionView
                    alloc]initWithFrame:CGRectMake(picViewGap+gap, picViewGap*2-gap, 368*radious-2*picViewGap, 368*radious-2*picViewGap)collectionViewLayout:flowLayout];
            }
        }
        
        self.collectionView.backgroundColor = [UIColor whiteColor];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.scrollEnabled = NO;
        [self.collectionView registerClass:[ImageCollectionCell class] forCellWithReuseIdentifier:cellid];
        [self addSubview:self.collectionView];
        
    }
    return self;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photosArr.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCollectionCell *imageCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellid forIndexPath:indexPath];
    Recommend *recommend = [self.photosArr objectAtIndex:indexPath.row];
    imageCell.recommend = recommend;
    
    return imageCell;
    
}

//item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat screenW = collectionView.bounds.size.width;
    CGFloat superiMGW = screenW-2*gap;
    //    每排3张 每张的宽度，高度
    CGFloat imgW = superiMGW/3;
    return CGSizeMake(imgW, imgW);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *markStr = [self.photosArr objectAtIndex:indexPath.row][@"PushId"];
    NSLog(@"mark = %@", markStr);
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:markStr forKey:@"markStr"];//标记pushId,在今日推荐中高亮该产品
    [def setObject:_recommend.CreatedDate forKey:@"redTip"];//标记createdate，下次该cell红点不显示

    
    UIStoryboard * SB = [UIStoryboard storyboardWithName:@"ProductRecommend" bundle:[NSBundle mainBundle]];
    ProductRecommendViewController * PRVC = (ProductRecommendViewController *)[SB instantiateViewControllerWithIdentifier:@"eeee"];
    PRVC.pushId = markStr;

    [self.ShouKeBaoNav pushViewController:PRVC animated:YES];

}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    //    if (![_redTip isHidden]) {
    //        _redTip.backgroundColor = [UIColor redColor];
    //    }
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    //    if (![_redTip isHidden]) {
    //        _redTip.backgroundColor = [UIColor redColor];
    //    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGRect rect = self.leftLab.frame;
    rect.size.width = screenW - 35 - 30;
    self.leftLab.frame = rect;
    
    CGFloat detailY = CGRectGetMaxY(self.leftLab.frame) + gap;
    CGFloat detailW = screenW - gap * 3 - self.iconView.frame.size.width;
    self.detailLab.frame = CGRectMake(self.leftLab.frame.origin.x, detailY, detailW, 20);
    
    CGFloat tipX = CGRectGetMaxX(self.iconView.frame) - 5;
    CGFloat tipY = self.iconView.frame.origin.y - 5;
    self.redTip.frame = CGRectMake(tipX, tipY, 10, 10);
    
    CGFloat goDateH = 45;
    self.goDate.frame = CGRectMake(self.titleLab.frame.origin.x, CGRectGetMaxY(self.titleLab.frame), screenW*2/3, goDateH);
    
    //图片
    //    self.photoViewY = CGRectGetMaxY(self.goDate.frame);
    
    
}

- (void)setRecommend:(Recommend *)recommend
{
    _recommend = recommend;
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *redStr = [def objectForKey:@"redTip"];
    if ([redStr isEqualToString:recommend.CreatedDate]) {
        self.redTip.backgroundColor = [UIColor clearColor];
    }else{
        self.redTip.backgroundColor = [UIColor redColor];
    }
    
    
    //    ThirdAreaName 三级区域
    //    String  PicUrl 产品图片
    //    String
    //    MinPeerPrice 最小同行价格  decimal
    self.photosArr = recommend.RecommendIndexProductList;//photoArr 其实是数组
    [self.collectionView reloadData];
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    double radious = screenH/667;
    if (theNumbe/3 == 0||theNumbe == 3) {
        if (screenH == 480) {
            self.collectionView.frame = CGRectMake(picViewGap+gap, picViewGap*2-gap, ((180*radious+25)-2*picViewGap)*3, (180*radious+25)-2*picViewGap);        }else{
            self.collectionView.frame = CGRectMake(picViewGap+gap, picViewGap*2-gap, (180*radious-2*picViewGap)*3, 180*radious-2*picViewGap);
        }
    }else if (theNumbe == 4 || theNumbe == 5 || theNumbe == 6){
        if (screenH == 480) {
            self.collectionView.frame = CGRectMake(picViewGap+gap , picViewGap*2-gap, (((260*radious+25)-2*picViewGap)-gap)*3/2+2*gap, (260*radious+25)-2*picViewGap);
        }else{
            self.collectionView.frame = CGRectMake(picViewGap+gap , picViewGap*2-gap, ((270*radious-2*picViewGap)-gap)*3/2+2*gap, 270*radious-2*picViewGap);
        }
    }else{
        if (screenH == 480) {
            self.collectionView.frame = CGRectMake(picViewGap+gap , picViewGap*2-gap, (400*radious+25)-2*picViewGap, (400*radious+25)-2*picViewGap);
        }else{
            self.collectionView.frame = CGRectMake(picViewGap+gap, picViewGap*2-gap, 368*radious-2*picViewGap, 368*radious-2*picViewGap);
        }
    }
    self.iconView.image = [UIImage imageNamed:@"jinxuan"];
    self.titleLab.text = @"今日推荐";
    self.titleLab.textColor = [UIColor blackColor];
    NSDate *createDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:[recommend.CreatedDate doubleValue]];
    self.timeLab.text = [createDate formattedTime];
    
    
    //self.goDate.text = [NSString stringWithFormat:@"本次共向您推荐%@条精品线路\n最低价%@起",recommend.Count,recommend.Price];
    self.goDate.numberOfLines = 0;
    self.goDate.textAlignment = NSTextAlignmentLeft;
    
   
    
    
//改写方式
    NSString *newTitleText = [recommend.TitleText stringByReplacingOccurrencesOfString:@"{0}" withString:recommend.Count];
    NSString *newPriceText = [recommend.PriceText stringByReplacingOccurrencesOfString:@"{0}" withString:recommend.StaticPrice];
    NSLog(@"recommend.PriceText = %@", recommend.PriceText);
    NSMutableAttributedString *newStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@", newTitleText, newPriceText]];
  
    NSString *visitors = [NSString stringWithFormat:@"%@",recommend.StaticPrice];
    
    NSRange startIndex2;
        NSLog(@"包含{0}");
         startIndex2 = [newPriceText rangeOfString:recommend.StaticPrice];
    NSInteger num = newTitleText.length + (NSInteger)startIndex2.location;
    int startIndex = (int)num;
    [newStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(startIndex,visitors.length+1)];
    self.goDate.attributedText = newStr;
}

@end
