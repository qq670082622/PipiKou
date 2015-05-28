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
#define picViewGap 45
@interface RecommendCell()
@property (nonatomic,strong) NSArray *photosArr;
@end

@implementation RecommendCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"recommendcell";
    RecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[RecommendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
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
        redTip.backgroundColor = [UIColor redColor];
        redTip.hidden = YES;
        redTip.layer.cornerRadius = 5;
        redTip.layer.masksToBounds = YES;
        [self.contentView addSubview:redTip];
        self.redTip = redTip;

        UIView *imgSuperView = [[UIView alloc] init];
        imgSuperView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:imgSuperView];
        self.imgSuperView = imgSuperView;
        

    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (![_redTip isHidden]) {
        _redTip.backgroundColor = [UIColor redColor];
    }
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    if (![_redTip isHidden]) {
        _redTip.backgroundColor = [UIColor redColor];
    }
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
    
    //图片
    
    CGFloat photoViewY = CGRectGetMaxY(self.goDate.frame) + 10;
    
    
    self.imgSuperView.frame = (CGRect){{picViewGap,photoViewY}, [self viewFrameWithPhotoCount:self.photosArr.count]};
    
    CGFloat imgW = (self.imgSuperView.frame.size.width- gap*4)/3;

    int arrCount = (int)self.photosArr.count;
  
    if ((arrCount != 1) && (arrCount != 4)) {
        for (int i = 0; i<arrCount; i++) {
            int row = i/3;
            int col = i%3;
            CGFloat imgvX = gap + col*(gap + imgW);
            CGFloat imgvY = gap + row*(gap + imgW);
            
            UIImageView *imgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.photosArr[i]]];
            imgv.frame = CGRectMake(imgvX, imgvY, imgW, imgW);
            [self.imgSuperView addSubview:imgv];
        }

    }else if (arrCount == 1){
        CGFloat IMGw = self.imgSuperView.frame.size.height - 2*gap;
         UIImageView *imgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[self.photosArr firstObject]]];
        imgv.frame = CGRectMake(gap, gap, IMGw, IMGw);
        [self.imgSuperView addSubview:imgv];
    }else if (arrCount == 4){
        for (int i = 0; i<arrCount; i++) {
            int row = i/2;
            int col = i%2;
            CGFloat imgvX = gap + col*(gap + imgW);
            CGFloat imgvY = gap + row*(gap + imgW);
            
            UIImageView *imgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.photosArr[i]]];
            imgv.frame = CGRectMake(imgvX, imgvY, imgW, imgW);
            [self.imgSuperView addSubview:imgv];

            
        }
    }
   
    
}

- (void)setRecommend:(Recommend *)recommend
{
    _recommend = recommend;
    
    self.photosArr = recommend.photosArr;
    
    self.iconView.image = [UIImage imageNamed:@"jinxuan"];
    
    self.titleLab.text = @"今日推荐";
    
    self.titleLab.textColor = [UIColor colorWithRed:202/255.f green:118/255.f blue:252/255.f alpha:1];
    
    NSDate *createDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:[recommend.CreatedDate doubleValue]];
    self.timeLab.text = [createDate formattedTime];
    
    self.goDate.text = [NSString stringWithFormat:@"本次共向您推荐%@条精品线路",recommend.Count];
  
  
}


-(CGSize)viewFrameWithPhotoCount:(NSUInteger)count
{
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    
    CGFloat imgW = (self.imgSuperView.frame.size.width- gap*4)/3;
      int row = (int)(count + 3 - 1)/3;
   
    if ((count != 1) && (count !=4)) {
        CGFloat viewW = screenW - picViewGap*2 ;
        CGFloat viewH = row*imgW + gap*(row+1);
        return CGSizeMake(viewW, viewH);
    
    }else if (count == 1){
        CGFloat viewH = 3*imgW + 4*gap;
        return CGSizeMake(screenW - picViewGap*2, viewH);
    
    }else {//==4
        CGFloat viewH = 2*imgW + 3*gap;
        return CGSizeMake(screenW - picViewGap*2, viewH);
    }
   
    
    
}
@end
