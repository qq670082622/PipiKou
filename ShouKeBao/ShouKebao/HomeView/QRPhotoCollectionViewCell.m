//
//  QRPhotoCollectionViewCell.m
//  ShouKeBao
//
//  Created by 张正梅 on 15/10/14.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "QRPhotoCollectionViewCell.h"

@implementation QRPhotoCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] init];
        self.imageView.backgroundColor = [UIColor purpleColor];
        [self.contentView addSubview:self.imageView];
        
    }
    return self;
}
- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    [super applyLayoutAttributes:layoutAttributes];
     self.imageView.frame = layoutAttributes.bounds;
}

+(instancetype)relationXib{
  return [[[NSBundle mainBundle] loadNibNamed:@"QRPhotoSubview" owner:nil options:nil] lastObject];
}


@end
