//
//  HProgressView.h
//  FaceKARE
//
//  Created by Anan on 2017/4/28.
//  Copyright © 2017年 Anan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HProgressView : UIView

// 设置进度
@property (nonatomic, assign) CGFloat progress;

// 设置进度条颜色
@property (nonatomic, strong) UIColor *progressBarColor;

// 设置进度条背景色
@property (nonatomic, strong) UIColor *progressBackgroundColor;

@end
