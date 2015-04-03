//
//  FootView.m
//  CustomTableView
//
//  Created by David on 15/1/29.
//  Copyright (c) 2015年 Wm. All rights reserved.
//

#import "FootView.h"

@implementation FootView
- (IBAction)btn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(footViewDidClickedLoadBtn:)]) {
        [self.delegate footViewDidClickedLoadBtn:self];
    }
}

+(instancetype)footView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"FootView" owner:nil options:nil] lastObject];
}
-(void)awakeFromNib
{
    
}
@end
