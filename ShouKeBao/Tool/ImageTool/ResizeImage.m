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
+ (UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

+ (UIImage *)colorControlWithImage:(UIImage *)image brightness:(CGFloat)bright contrast:(CGFloat)contrast saturation:(CGFloat)saturation
{
    if (!image) return nil;
    
    CIImage *input = [CIImage imageWithCGImage:image.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIColorControls"];
    [filter setValue:input forKey:kCIInputImageKey];
    //[filter setValue:@(bright) forKey:@"inputBrightness"];
    //[filter setValue:@(contrast) forKey:@"inputContrast"];
    [filter setValue:@(saturation) forKey:@"inputSaturation"];
    
    
    CIImage *newCIImage = [filter outputImage];
    EAGLContext *glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    if (!glContext) {
        NSLog(@"Failed to create ES context");
    }
    CIContext  *context = [CIContext contextWithEAGLContext:glContext];
    CGImageRef cgimg = [context createCGImage:newCIImage fromRect:[newCIImage extent]];
    UIImage *uiimage = [UIImage imageWithCGImage:cgimg];
    CGImageRelease(cgimg);
    
    return uiimage;
    
}

@end
