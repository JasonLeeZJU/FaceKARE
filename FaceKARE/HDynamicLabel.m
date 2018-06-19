//
//  HDynamicLabel.m
//  FaceKARE
//
//  Created by Anan on 2017/5/2.
//  Copyright © 2017年 Anan. All rights reserved.
//

#import "HDynamicLabel.h"

@interface HDynamicLabel()<CAAnimationDelegate>
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, assign) BOOL animationBreak;
@end
@implementation HDynamicLabel

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        UILabel* contentLabel = [[UILabel alloc] init];
        [contentLabel sizeToFit];
        contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel = contentLabel;
    }
    return _contentLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self setup];
    }
    return self;
}

- (void)setup
{
    [self addSubview:self.contentLabel];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(layoutSubviews) name:UIApplicationWillEnterForegroundNotification object:[UIApplication sharedApplication]];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    CAShapeLayer* maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    self.layer.mask = maskLayer;
}

- (void)setText:(NSString *)text
{
    self.contentLabel.text = text;
    [self.contentLabel sizeToFit];
}

- (void)setFont:(UIFont *)font
{
    self.contentLabel.font = font;
    [self.contentLabel sizeToFit];
    
    CGRect frame = self.frame;
    if (frame.size.height < font.lineHeight) {
        frame.size.height = font.lineHeight;
        self.frame = frame;
    }
}

- (void)setTextColor:(UIColor *)textColor
{
    self.contentLabel.textColor = textColor;
}

- (void)willMoveToWindow:(UIWindow *)newWindow
{
    [super willMoveToWindow:newWindow];
    if (newWindow)
    {
        [self addAnimation];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.animationBreak) {
        [self addAnimation];
    }
}

- (void)addAnimation
{
    if (self.frame.size.width >= self.contentLabel.frame.size.width) {
        [self.contentLabel setFrame:CGRectMake(self.frame.size.width - self.contentLabel.frame.size.width, 0, self.contentLabel.frame.size.width, 30)];
        [self.contentLabel sizeToFit];
        return;
    }
    [self.contentLabel.layer removeAllAnimations];
    CGFloat space = self.contentLabel.frame.size.width - self.frame.size.width;
    CAKeyframeAnimation* keyFrame = [CAKeyframeAnimation animation];
    keyFrame.keyPath = @"transform.translation.x";
    keyFrame.values = @[@(0), @(-space), @(0)];
    keyFrame.repeatCount = NSIntegerMax;
    keyFrame.duration = self.speed * self.contentLabel.text.length;
    keyFrame.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut], [CAMediaTimingFunction functionWithControlPoints:0 :0 :0.5 :0.5]];
    __weak typeof(self) weakSelf = self;
    keyFrame.delegate = weakSelf;
    [self.contentLabel.layer addAnimation:keyFrame forKey:nil];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    self.animationBreak = !flag;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
