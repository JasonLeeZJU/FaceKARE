//
//  HDynamicLabel.h
//  FaceKARE
//
//  Created by Anan on 2017/5/2.
//  Copyright © 2017年 Anan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDynamicLabel : UIView

// 文本内容
@property (nonatomic, copy) NSString *text;

// 文本颜色
@property (nonatomic, strong) UIColor *textColor;

// 文本字体
@property (nonatomic, strong) UIFont *textFont;

// 滚动速度
@property (nonatomic, assign) CGFloat speed;

@end
