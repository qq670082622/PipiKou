//
//  QRPhotoCollectionViewCell.m
//  ShouKeBao
//
//  Created by 张正梅 on 15/10/14.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "QRPhotoCollectionViewCell.h"
#import "UIImageView+WebCache.h"
@implementation QRPhotoCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.imageView];
        
        UIImageView *chooseBtn = [[UIImageView alloc]init];
        chooseBtn.layer.cornerRadius = 3.0f;
        chooseBtn.layer.masksToBounds = YES;
        self.cancle = chooseBtn;
        [self.imageView addSubview:self.cancle];
        
    }
    return self;
}
- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    [super applyLayoutAttributes:layoutAttributes];
     self.imageView.frame = layoutAttributes.bounds;
     CGFloat w = layoutAttributes.bounds.size.width;
     CGFloat h = layoutAttributes.bounds.size.height;
    self.cancle.frame = CGRectMake(w*3/4, 5, w/4, h/4);
}

- (void)setCellState:(cellState)cellState{
    _cellState = cellState;
   
    if (cellState == ChoosedState){
        self.cancle.image = [UIImage imageNamed:@"choose"];
    }else if(cellState == UnChoosedState){
        self.cancle.image = [UIImage imageNamed:@"unchoose"];
    }else{
        self.cancle.image = [UIImage imageNamed:@""];
    }
}


- (void)setModel:(personIdModel *)model{
    _model = model;
    NSString *pic = self.model.MinPicUrl;
//    NSLog(@"pic..... = %@", pic);
    NSURL *url = [NSURL URLWithString:pic];
    [self.imageView sd_setImageWithURL:url];
    
}

- (void)switchChoosePhoto{
    if (self.chooseFlag == NO) {
        self.chooseFlag = !self.chooseFlag;
        self.cancle.image = [UIImage imageNamed:@"unchoose"];
    }else{
        self.chooseFlag = !self.chooseFlag;
         self.cancle.image = [UIImage imageNamed:@""];
    }
    
}



- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
