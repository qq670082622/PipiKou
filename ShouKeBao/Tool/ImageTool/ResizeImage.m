//
//  ResizeImage.m
//  ShouKeBao
//
//  Created by David on 15/3/17.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "ResizeImage.h"

@implementation ResizeImage
+ (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize{
    
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return reSizeImage;
    
}
+(UIImage *)reSizeBadgeValueWithImageNmae:(NSString *)name BeWid:(CGFloat)wid andHeith:(CGFloat)heith
{
UIImage *normal = [UIImage imageNamed:name];

wid = normal.size.width * 0.5;

heith = normal.size.height * 0.5;

UIImage *new = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(heith, wid, heith, wid)];
    return new;
}
@end
