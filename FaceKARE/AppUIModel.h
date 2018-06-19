//
//  AppUIModel.h
//  FaceKARE
//
//  Created by Anan on 2017/4/25.
//  Copyright © 2017年 Anan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AppUIModel : NSObject

#pragma mark - 颜色
// 主题色调：（RGB： 255， 64， 129） ：导航，链接，点缀
+ (UIColor *)UIViewMainColorI;

// 主题色调2：（RGB： 255， 96， 145） ：按钮
+ (UIColor *)UIViewMainColorII;

// 背景：（RGB： 243， 243， 243） ：背景
+ (UIColor *)UIViewBackgroundColor;

// 背景：（RGB： 233， 233， 233） ：背景
+ (UIColor *)UIViewBackgroundColor2;

// 普通内容：（136， 136， 136） ：内容描述，介绍性文字
+ (UIColor *)UIViewNormalColor;

// 失效文字：（191， 191， 191） ：失效文字
+ (UIColor *)UIUselessColor;

// 绿：(RGB：35, 176 , 74  #23B04A)
+ (UIColor *)UIViewGreenColor;

// 黄：(RGB：240, 230, 90  #F0E65A)
+ (UIColor *)UIViewYellowColor;

// 红：(RGB：226, 61, 70  #E23D46)
+ (UIColor *)UIViewRedColor;

#pragma mark - 字体
// 标题： System 24 Bold
+ (UIFont *)UIViewTitleFont;

// 普通文本：System 16
+ (UIFont *)UIViewNormalFont;

//普通文本：System 16 Bold
+ (UIFont *)UIViewNormalBoldFont;

// 小文本：System 12
+ (UIFont *)UIViewSmallFont;

//判断语言是否为中文
+ (BOOL)UIViewIsChinese;

@end
