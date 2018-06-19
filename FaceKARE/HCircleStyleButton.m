//
//  HCircleStyleButton.m
//  FaceKARE
//
//  Created by Anan on 2017/5/26.
//  Copyright © 2017年 Anan. All rights reserved.
//

#import "HCircleStyleButton.h"

@implementation HCircleStyleButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageH = contentRect.size.height * 0.6;
    CGFloat imageW = contentRect.size.width * 0.6;
    CGFloat imageX = contentRect.size.height * 0.2;
    CGFloat imageY = contentRect.size.width * 0.2;
    return CGRectMake(imageX, imageY, imageW, imageH);
}

@end
