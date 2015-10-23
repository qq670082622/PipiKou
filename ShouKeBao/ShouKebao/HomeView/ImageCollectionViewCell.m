//
//  ImageCollectionCell.m
//  ShouKeBao
//
//  Created by 张正梅 on 15/7/16.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "ImageCollectionViewCell.h"
#import "UIImageView+WebCache.h"
@implementation ImageCollectionCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] init];
//        self.imageView.backgroundColor = [UIColor yellowColor];
        //        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [self.contentView addSubview:_imageView];
        
        self.shineView = [[UIView alloc]init];
        self.shineView.backgroundColor = [UIColor blackColor];
        self.shineView.alpha = 0.5;
        [self.contentView addSubview:_shineView];
        
        self.countryLable = [[UILabel alloc]init];
        self.countryLable.textColor = [UIColor whiteColor];
        self.countryLable.font = [UIFont systemFontOfSize:11];
        self.countryLable.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_countryLable];
        
        self.moneyLable = [[UILabel alloc]init];
        self.moneyLable.textColor = [UIColor orangeColor];
        self.moneyLable.font = [UIFont systemFontOfSize:11];
        self.moneyLable.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_moneyLable];
        
        
        
        
        
    }
    return self;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    //    [super applyLayoutAttributes:layoutAttributes];
//    NSLog(@"eeeee  2");
    CGFloat width = layoutAttributes.bounds.size.width;
    CGFloat height = layoutAttributes.bounds.size.height;
    
    self.imageView.frame = layoutAttributes.bounds;
    self.shineView.frame = CGRectMake(0, height*2/3, width, height/3);
    self.countryLable.frame = CGRectMake(0, width*2/3, width, height/6);
    self.moneyLable.frame = CGRectMake(0, height*5/6, width, height/6);
    
}


- (void)setRecommend:(Recommend *)recommend
{
    _recommend = recommend;
    
    //    NSArray *arr = self.recommend.RecommendIndexProductList;
    //    NSLog(@"arr = %@", arr);
    //    for (NSInteger i = 0; i < [arr count]; i++) {
    //      NSString *pic = [[arr objectAtIndex:i]objectForKey:@"PicUrl"];
    //        NSURL *url = [NSURL URLWithString:pic];
    //        [self.imageView sd_setImageWithURL:url];
    //
    //        self.countryLable.text = [[arr objectAtIndex:i]objectForKey:@"ThirdAreaName"];
    //        self.moneyLable.text = [[arr objectAtIndex:i]objectForKey:@"MinPeerPrice"];
    //
    //        NSLog(@"self.moneyLable.text= %@", self.moneyLable.text);
    //    }
    NSLog(@"%@", recommend);
    NSString *pic = [recommend valueForKey:@"PicUrl"];
    NSURL *url = [NSURL URLWithString:pic];
    [self.imageView sd_setImageWithURL:url];
    
    self.countryLable.text = [recommend valueForKey: @"ThirdAreaName"];
    NSString *money = [recommend valueForKey:@"MinPeerPrice"];
    self.moneyLable.text =  [NSString stringWithFormat:@"¥%@", money];
    NSLog(@"%@", money);
    
}









//- (void)setPhotoArr:(NSMutableArray *)photoArr
//{
//    NSLog(@"eee");
//    _photoArr = photoArr;
//    for (NSInteger i = 0; i < [_photoArr count]; i++) {
//        NSString *pic = [[_photoArr objectAtIndex:i]objectForKey:@"PicUrl"];
//        NSURL *url = [NSURL URLWithString:pic];
//        [self.imageView sd_setImageWithURL:url];
//
//        self.countryLable.text = [[_photoArr objectAtIndex:i]objectForKey:@"ThirdAreaName"];
//        self.moneyLable.text = [[_photoArr objectAtIndex:i]objectForKey:@"MinPeerPrice"];
//
//        NSLog(@"urlqq = %@", url);
//        NSLog(@"[[_photoArr objectAtIndex:i]objectForKe = %@", [[_photoArr objectAtIndex:i]objectForKey:@"ThirdAreaName"]);
//        NSLog(@"self.countryLable %@", self.countryLable.text);
//
//    }
//
//}
//






@end
