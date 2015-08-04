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

#import "ImageCollectionViewCell.h"

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
    NSString *ID = [NSString stringWithFormat:@"reconmendcell%d",((arc4random() % 2500) + 1)];
    
    RecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[RecommendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    

    //    int row = (int)(number + 3 - 1)/3;
//        NSInteger number = 3;
    //判断屏幕的高度
    
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    double radious = screenH/667;
    
//    double radiousW = screenW/375;
//     NSLog(@"222   = %f", [UIScreen mainScreen].bounds.size.width);
    
    
    if ((number/3 == 0 && number != 1)||number == 3) {
        NSLog(@"1kkk");
        if (screenH == 480) {
            cell.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(picViewGap+gap, picViewGap*2-gap, ((180*radious+25)-2*picViewGap)*3, (180*radious+25)-2*picViewGap) collectionViewLayout:flowLayout];
        }
        cell.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(picViewGap+gap, picViewGap*2-gap, (180*radious-2*picViewGap)*3, 180*radious-2*picViewGap) collectionViewLayout:flowLayout];
        
    }else if (number == 4){
        
        if (screenH == 480) {
            
        cell.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(picViewGap+gap, picViewGap*2-gap, (260*radious+25)-2*picViewGap, (260*radious+25)-2*picViewGap)collectionViewLayout:flowLayout];
            
        }
        NSLog(@"2kkk");
        cell.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(picViewGap+gap, picViewGap*2-gap, 270*radious-2*picViewGap, 270*radious-2*picViewGap)collectionViewLayout:flowLayout];
        
    }else if (number == 1){
        if (screenH == 480) {
            
            cell.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(picViewGap+gap, picViewGap*2-gap, (270*radious+25)-2*picViewGap, (270*radious+25)-2*picViewGap)collectionViewLayout:flowLayout];
        }
        cell.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(picViewGap+gap, picViewGap*2-gap,  270*radious-2*picViewGap, 270*radious-2*picViewGap)collectionViewLayout:flowLayout];
        
    }else if (number == 5 || number == 6){
        if (screenH == 480) {
           
            cell.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(picViewGap+gap , picViewGap*2-gap, (((260*radious+25)-2*picViewGap)-gap)*3/2+2*gap, (260*radious+25)-2*picViewGap)collectionViewLayout:flowLayout];
        }
        
        cell.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(picViewGap+gap , picViewGap*2-gap, ((270*radious-2*picViewGap)-gap)*3/2+2*gap, 270*radious-2*picViewGap)collectionViewLayout:flowLayout];
    }else{
        NSLog(@"3kkk");
        if (screenH == 480) {
            cell.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(picViewGap+gap , picViewGap*2-gap, (400*radious+25)-2*picViewGap, (400*radious+25)-2*picViewGap)collectionViewLayout:flowLayout];
        }
        cell.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(picViewGap+gap, picViewGap*2-gap, 368*radious-2*picViewGap, 368*radious-2*picViewGap)collectionViewLayout:flowLayout];
        //        NSLog(@"aaa  %f", cell.bounds.size.height);
    }
    

    cell.collectionView.backgroundColor = [UIColor whiteColor];
    cell.collectionView.delegate = cell;
    cell.collectionView.dataSource = cell;
    cell.collectionView.scrollEnabled = NO;
    [cell.collectionView registerClass:[ImageCollectionCell class] forCellWithReuseIdentifier:@"reuse"];
    
    [cell addSubview:cell.collectionView];
    
    
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
        NSLog(@"%f",self.bounds.size.height);
        
    }
    return self;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"mm11 mm self.photosArr.count = %ld", self.photosArr.count);
    return self.photosArr.count;
//        return 3;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"mmm2 m");
    ImageCollectionCell *imageCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"reuse" forIndexPath:indexPath];
    //    Recommend *recommend = self.recommend;
    //    NSLog(@"%@", recommend);
    //    imageCell.recommend = recommend;
    
    Recommend *recommend = [self.photosArr objectAtIndex:indexPath.row];
    NSLog(@"recommend = %@", recommend);
    imageCell.recommend = recommend;
    
    return imageCell;
    
}

//item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat screenW = collectionView.bounds.size.width;
    CGFloat screenH = collectionView.bounds.size.height;
    //    CGFloat superiMGW = screenW-2*picViewGap;
    NSLog(@"nnnn %f", screenH);
    NSLog(@"nnnn %f", screenW);
//    NSInteger number = 3;
    if (self.photosArr.count == 1) {
        CGFloat viewW = screenW;
        CGFloat viewH = screenH-gap;
        return CGSizeMake(viewW, viewH);
        
    }else if(self.photosArr.count == 2 || self.photosArr.count == 4){
        NSLog(@"ggg");
        //   collectonView的宽度，高度
        CGFloat superiMGW = screenW-gap;
        CGFloat superiMGH = screenH-gap;
        
        
        //    每排3张 每张的宽度，高度
        CGFloat imgW = superiMGW/2;
        CGFloat imgH = superiMGH/(self.photosArr.count/2);
        
        CGFloat viewW = imgW;
        CGFloat viewH = imgH;
        return CGSizeMake(viewW, viewH);
        
    }else if (self.photosArr.count == 5 || self.photosArr.count == 6){
        NSLog(@"iii");
        CGFloat superiMGW = screenW-2*gap;
//        CGFloat superiMGH = screenH-2*gap;
        CGFloat superiMGH = screenH-gap;
        
        CGFloat imgW = superiMGW/3;
        CGFloat imgH = superiMGH/2;
        
        CGFloat viewW = imgW;
        CGFloat viewH = imgH;
        return CGSizeMake(viewW, viewH);
    }else if (self.photosArr.count == 3){
        CGFloat superiMGW = screenW-2*gap;
//        CGFloat superiMGH = screenH-gap;
        CGFloat superiMGH = screenH;
        
        CGFloat imgW = superiMGW/3;
        CGFloat imgH = superiMGH;
        
        CGFloat viewW = imgW;
        CGFloat viewH = imgH;
        return CGSizeMake(viewW, viewH);
        
    }else{
        
        //   collectonView的宽度，高度
        CGFloat superiMGW = screenW-2*gap;
        CGFloat superiMGH = screenH-2*gap;
        
        
        //    每排3张 每张的宽度，高度
        CGFloat imgW = superiMGW/3;
        CGFloat imgH = superiMGH/3;
        
        CGFloat viewW = imgW;
        CGFloat viewH = imgH;
        NSLog(@"jj %f  %f", viewW, viewH);
        return CGSizeMake(viewW, viewH);
        
    }
    
    
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"fffff---");
    
    //    NSInteger selectTag  = indexPath.row;
    //    NSArray *arr =  self.imgSuperView.subviews;
    //    NSMutableArray *tagArr = [NSMutableArray array];
    //    for (UIImageView *view in arr) {
    //        [tagArr addObject:[NSString stringWithFormat:@"%ld",(long)view.tag]];
    //    }
    //    NSLog(@"tagArr si %@",tagArr);
    //    NSMutableArray *indexArr = [NSMutableArray array];
    //    for (int i = 0; i<tagArr.count; i++) {
    //        if (selectTag == [tagArr[i] integerValue]) {
    //            [indexArr addObject:[NSString stringWithFormat:@"%d",i] ];
    //
    //        }
    //    }
    
    //    int yesInt = [[indexArr firstObject]  intValue];
    
    NSString *markStr = [self.photosArr objectAtIndex:indexPath.row][@"PushId"];
    
    //取当前arr中的picUrl为标示
//        NSString *markStr = self.photosArr[yesInt][@"PushId"];//取单个产品的三级区域名称
//        NSLog(@"点击了排第%d个，它的PushId is %@",yesInt,markStr);
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:markStr forKey:@"markStr"];//标记pushId,在今日推荐中高亮该产品
    [def setObject:_recommend.CreatedDate forKey:@"redTip"];//标记createdate，下次该cell红点不显示

    NSString *num = [NSString stringWithFormat:@"%ld", indexPath.row];
    [def setObject:num forKey:@"num"];
    [def synchronize];
// ************************************
//    NSString *markYesterday = [self.photosArr objectAtIndex:indexPath.row][@"PushId"];
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:markYesterday forKey:@"markYesterday"];
//     [defaults synchronize];
  // ************************************
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter postNotificationName:@"notifiToPushToRecommed" object:nil];
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







//    self.imgSuperView.frame = (CGRect){{picViewGap,self.photoViewY}, [self viewFrameWithPhotoCount:self.photosArr.count]};


////    每张小图片的宽度
//    CGFloat imgW = (self.imgSuperView.frame.size.width- gap*4)/3;
////图片张数
//    int arrCount = (int)self.photosArr.count;
//
//    if ((arrCount != 1) && (arrCount != 4)) {
//        for (int i = 0; i<arrCount; i++) {
//            int row = i/3;
//            int col = i%3;
//            CGFloat imgvX = gap + col*(gap + imgW);
//            CGFloat imgvY = gap + row*(gap + imgW);
//
////
//            UIImageView *imgv = [[UIImageView alloc] init];
//            [imgv sd_setImageWithURL:[NSURL URLWithString:self.photosArr[i][@"PicUrl"]]];
//            imgv.frame = CGRectMake(imgvX, imgvY, imgW, imgW);
//            [imgv setTag:i];
//            imgv.userInteractionEnabled = YES;
//            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapIMG:)];
//            [imgv addGestureRecognizer:tap];
//
//            UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, imgW*2/3, imgW, imgW/3)];
//           backView.backgroundColor = [UIColor blackColor];
//            backView.alpha = 0.5;
//
////            显示图片上的文字地区
//            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, imgW*2/3, imgW, imgW/6)];
//            lab.text = self.photosArr[i][@"ThirdAreaName"];
////            NSLog(@"lab.text = %@", lab.text);
//            lab.textColor = [UIColor whiteColor];
//            lab.font = [UIFont systemFontOfSize:11];
//            lab.textAlignment = NSTextAlignmentLeft;
//
////            价格
//            UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(0, imgW*5/6, imgW, imgW/6)];
//            lab2.text = [NSString stringWithFormat:@"¥%@",self.photosArr[i][@"MinPeerPrice"]];
//            lab2.textColor = [UIColor orangeColor];
//            lab2.font = [UIFont systemFontOfSize:11];
//            lab2.textAlignment = NSTextAlignmentLeft;
//
////                NSArray *subViews  = self.imgSuperView.subviews;
////                NSLog(@"!%@ ",subViews);
//
//            [imgv addSubview:backView];
//            [imgv addSubview:lab];
//            [imgv addSubview:lab2];
//            [self.imgSuperView addSubview:imgv];
//        }

//    }else if (arrCount == 1){
//        NSLog(@"--------IMGV'ssuper is %@------------",NSStringFromCGRect(self.imgSuperView.frame) );
//        CGFloat IMGw = self.imgSuperView.frame.size.width - 2*gap;
//        CGFloat IMGH = self.imgSuperView.frame.size.height  ;
//
//        UIImageView *imgv = [[UIImageView alloc] init];
//    [imgv sd_setImageWithURL:[NSURL URLWithString:self.photosArr[0][@"PicUrl"]]];
//               imgv.userInteractionEnabled = YES;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapIMG:)];
//        [imgv addGestureRecognizer:tap];
//
//        imgv.frame = CGRectMake(0, 0, IMGw, IMGH);
//        [imgv setTag:0];
//
//        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, IMGH-(imgW/3), IMGw, imgW/3)];
//        backView.backgroundColor = [UIColor blackColor];
//        backView.alpha = 0.5;
//
//        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, IMGH-(imgW/3), IMGw, imgW/6)];
//        lab.text = [self.photosArr firstObject][@"ThirdAreaName"];
//        lab.textColor = [UIColor whiteColor];
//        lab.font = [UIFont systemFontOfSize:11];
//        lab.textAlignment = NSTextAlignmentLeft;
//
//
//        UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(0, IMGH-(imgW/6), IMGw, imgW/6)];
//        lab2.text = [NSString stringWithFormat:@"¥%@",[self.photosArr firstObject][@"MinPeerPrice"]];
//        lab2.textColor = [UIColor orangeColor];
//        lab2.font = [UIFont systemFontOfSize:11];
//        lab2.textAlignment = NSTextAlignmentLeft;
//
//
//        [imgv addSubview:backView];
//        [imgv addSubview:lab];
//        [imgv addSubview:lab2];
//
//       // imgv.frame = CGRectMake(gap, gap, IMGw, IMGw);
//        [self.imgSuperView addSubview:imgv];
//
//    }else if (arrCount == 4){
//        for (int i = 0; i<arrCount; i++) {
//            int row = i/2;
//            int col = i%2;
//            CGFloat imgvX = gap + col*(gap + imgW);
//            CGFloat imgvY = gap + row*(gap + imgW);
//
//            UIImageView *imgv = [[UIImageView alloc] init];
//            [ imgv sd_setImageWithURL:[NSURL URLWithString:self.photosArr[i][@"PicUrl"]]];
//            imgv.frame = CGRectMake(imgvX, imgvY, imgW, imgW);
//            imgv.userInteractionEnabled = YES;
//
//            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapIMG:)];
//            [imgv addGestureRecognizer:tap];
//            [imgv setTag:i];
//
//            UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, imgW*2/3, imgW, imgW/3)];
//            backView.backgroundColor = [UIColor blackColor];
//            backView.alpha = 0.5;
//
//            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, imgW*2/3, imgW, imgW/6)];
//            lab.text = self.photosArr[i][@"ThirdAreaName"];
//            lab.textColor = [UIColor whiteColor];
//            lab.font = [UIFont systemFontOfSize:11];
//            lab.textAlignment = NSTextAlignmentLeft;
//
//
//            UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(0, imgW*5/6, imgW, imgW/6)];
//            lab2.text = [NSString stringWithFormat:@"¥%@",self.photosArr[i][@"MinPeerPrice"]];
//            lab2.textColor = [UIColor orangeColor];
//            lab2.font = [UIFont systemFontOfSize:11];
//            lab2.textAlignment = NSTextAlignmentLeft;
//
//
//            [imgv addSubview:backView];
//            [imgv addSubview:lab];
//            [imgv addSubview:lab2];
//
//            [self.imgSuperView addSubview:imgv];
//
//
//        }
//    }
//
//




//-(void)tapIMG:(UIGestureRecognizer *)sender
//{

//    int selectTag  = (int)sender.view.tag;
//    NSArray *arr =  self.imgSuperView.subviews;
//    NSMutableArray *tagArr = [NSMutableArray array];
//    for (UIImageView *view in arr) {
//        [tagArr addObject:[NSString stringWithFormat:@"%ld",(long)view.tag]];
//
//    }
//    NSLog(@"tagArr si %@",tagArr);
//    NSMutableArray *indexArr = [NSMutableArray array];
//    for (int i = 0; i<tagArr.count; i++) {
//        if (selectTag == [tagArr[i] integerValue]) {
//           [indexArr addObject:[NSString stringWithFormat:@"%d",i] ];
//
//        }
//    }
//
//    int yesInt = [[indexArr firstObject]  intValue];
//
//    //取当前arr中的picUrl为标示
//    NSString *markStr = self.photosArr[yesInt][@"PushId"];//取单个产品的三级区域名称
//     NSLog(@"点击了排第%d个，它的PushId is %@",yesInt,markStr);
//
//
//    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
//    [def setObject:markStr forKey:@"markStr"];//标记pushId,在今日推荐中高亮该产品
//    [def setObject:_recommend.CreatedDate forKey:@"redTip"];//标记createdate，下次该cell红点不显示
//
//    [def synchronize];
//    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
//    [defaultCenter postNotificationName:@"notifiToPushToRecommed" object:nil];
//}




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
    
    self.iconView.image = [UIImage imageNamed:@"jinxuan"];
    
    self.titleLab.text = @"今日推荐";
    
    //self.titleLab.textColor = [UIColor colorWithRed:202/255.f green:118/255.f blue:252/255.f alpha:1];
    self.titleLab.textColor = [UIColor blackColor];
    
    NSDate *createDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:[recommend.CreatedDate doubleValue]];
    self.timeLab.text = [createDate formattedTime];
    
    
    //self.goDate.text = [NSString stringWithFormat:@"本次共向您推荐%@条精品线路\n最低价%@起",recommend.Count,recommend.Price];
    self.goDate.numberOfLines = 0;
    self.goDate.textAlignment = NSTextAlignmentLeft;
    NSMutableAttributedString *newStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"本次共向您推荐%@条精品线路\n最低价%@起",recommend.Count,recommend.Price]];
    NSString *visitors = [NSString stringWithFormat:@"%@",recommend.Price];
    
    NSInteger startIndex = [recommend.Count integerValue]>9?18:17;
    [newStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(startIndex,visitors.length)];
    self.goDate.attributedText = newStr;
    
    
    //为自定义的CollectionView照片墙赋值
    //    for (NSInteger i = 0; i < [_photosArr count]; i++) {
    //
    //        NSString *pic = [[_photosArr objectAtIndex:i]objectForKey:@"PicUrl"];
    //
    //        NSURL *url = [NSURL URLWithString:pic];
    //        [self.imageCollectionCell.imageView sd_setImageWithURL:url];
    //
    //        self.imageCollectionCell.countryLable.text = [[_photosArr objectAtIndex:i]objectForKey:@"ThirdAreaName"];
    //
    //        self.imageCollectionCell.moneyLable.text = [[_photosArr objectAtIndex:i]objectForKey:@"MinPeerPrice"];
    //
    //        NSLog(@"pic = %@",pic);
    //        NSLog(@"self.imageCollectionCell.countryLable.text = %@", [[_photosArr objectAtIndex:i]objectForKey:@"ThirdAreaName"]);
    //        
    //    }
    
    
    
    
}

@end
