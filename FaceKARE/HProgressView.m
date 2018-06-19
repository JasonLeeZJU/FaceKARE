//
//  HProgressView.m
//  FaceKARE
//
//  Created by Anan on 2017/4/28.
//  Copyright © 2017年 Anan. All rights reserved.
//

#import "HProgressView.h"

@implementation HProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.progressBarColor = [UIColor orangeColor];
        self.progressBackgroundColor = [UIColor colorWithRed:240.0/255.0 green:220.0/255.0 blue:200.0/255.0 alpha:1];
    }
    return self;
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawProgressBackground:context inRect:rect];
    if (self.progress > 0) {
        [self drawProgress:context withFrame:rect];
    }
}

- (void)drawProgressBackground:(CGContextRef)context inRect:(CGRect)rect
{
    CGContextSaveGState(context);
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:rect.size.height * 0.5];
    CGContextSetFillColorWithColor(context, self.progressBackgroundColor.CGColor);
    [roundedRect fill];
    
    UIBezierPath *roundedClipPath = [UIBezierPath bezierPathWithRect:rect];
    [roundedClipPath appendPath:roundedRect];
    [roundedRect addClip];
}

- (void)drawProgress:(CGContextRef)context withFrame:(CGRect)frame
{
    CGRect drawRect = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width * self.progress, frame.size.height);
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:drawRect byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(drawRect.size.height * 0.5, drawRect.size.height * 0.5)];
    CGContextSetFillColorWithColor(context, self.progressBarColor.CGColor);
    [roundedRect fill];
}

@end
