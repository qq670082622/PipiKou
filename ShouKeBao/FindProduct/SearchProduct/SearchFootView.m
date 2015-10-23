//
//  SearchFootView.m
//  ShouKeBao
//
//  Created by 吴铭 on 15/4/7.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "SearchFootView.h"

@implementation SearchFootView


- (IBAction)clear:(id)sender {
    if ([self.delegate respondsToSelector:@selector(searchFootViewDidClickedLoadBtn:)]) {
        [self.delegate searchFootViewDidClickedLoadBtn:self];
    }

}

+ (instancetype)footView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"SearchFootView" owner:nil options:nil] lastObject];
}

@end
