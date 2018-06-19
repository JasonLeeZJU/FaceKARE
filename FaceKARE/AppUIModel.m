//
//  AppUIModel.m
//  FaceKARE
//
//  Created by Anan on 2017/4/25.
//  Copyright © 2017年 Anan. All rights reserved.
//

#import "AppUIModel.h"
#import <sys/utsname.h>

@implementation AppUIModel

#pragma mark - 颜色
// 主题色调1：（RGB： 255， 64， 129） ：导航，链接，点缀
+ (UIColor *)UIViewMainColorI
{
    UIColor *color = [[UIColor alloc] initWithRed:255.0f/255.0f green:64.0f/255.0f blue:129.0f/255.0f alpha:1.0f];
    return color;
}

// 主题色调2：（RGB： 255， 96， 145） ：按钮
+ (UIColor *)UIViewMainColorII
{
    UIColor *color = [[UIColor alloc] initWithRed:255.0f/255.0f green:96.0f/255.0f blue:145.0f/255.0f alpha:1.0f];
    return color;
}

// 背景：（RGB： 243， 243， 243） ：背景
+ (UIColor *)UIViewBackgroundColor
{
    UIColor *color = [[UIColor alloc] initWithRed:243.0f/255.0f green:243.0f/255.0f blue:243.0f/255.0f alpha:1.0f];
    return color;
}

// 背景：（RGB： 233， 233， 233） ：背景
+ (UIColor *)UIViewBackgroundColor2
{
    UIColor *color = [[UIColor alloc] initWithRed:233.0f/255.0f green:233.0f/255.0f blue:233.0f/255.0f alpha:1.0f];
    return color;
}

// 普通内容：（136， 136， 136） ：内容描述，介绍性文字
+ (UIColor *)UIViewNormalColor
{
    UIColor *color = [[UIColor alloc] initWithRed:136.0f/255.0f green:136.0f/255.0f blue:136.0f/255.0f alpha:1.0f];
    return color;
}

// 失效文字：（191， 191， 191） ：失效文字
+ (UIColor *)UIUselessColor
{
    UIColor *color = [[UIColor alloc] initWithRed:191.0f/255.0f green:191.0f/255.0f blue:191.0f/255.0f alpha:1.0f];
    return color;
}

// 绿：(RGB：35, 176 , 74  #23B04A)
+ (UIColor *)UIViewGreenColor
{
    UIColor *color = [[UIColor alloc] initWithRed:35.0f/255.0f green:176.0f/255.0f blue:74.0f/255.0f alpha:1.0f];
    return color;
}

// 黄：(RGB：240, 230, 90  #F0E65A)
+ (UIColor *)UIViewYellowColor
{
    UIColor *color = [[UIColor alloc] initWithRed:240.0f/255.0f green:230.0f/255.0f blue:90.0f/255.0f alpha:1.0f];
    return color;
}

// 红：(RGB：226, 61, 70  #E23D46)
+ (UIColor *)UIViewRedColor
{
    UIColor *color = [[UIColor alloc] initWithRed:226.0f/255.0f green:61.0f/255.0f blue:70.0f/255.0f alpha:1.0f];
    return color;
}

#pragma mark - 字体
//标题文本：System 24 Bold
+ (UIFont *)UIViewTitleFont
{
    UIFont *font = [UIFont boldSystemFontOfSize:24];
    return font;
}

//普通文本：System 16
+ (UIFont *)UIViewNormalFont
{
    UIFont *font = [UIFont systemFontOfSize:16];
    return font;
}

//普通文本：System 16 Bold
+ (UIFont *)UIViewNormalBoldFont
{
    UIFont *font = [UIFont boldSystemFontOfSize:16];
    return font;
}

//小文本：System 12
+ (UIFont *)UIViewSmallFont
{
    UIFont *font = [UIFont systemFontOfSize:12];
    return font;
}

//判断语言是否为中文
+ (BOOL)UIViewIsChinese{
    //系统语言
    NSString *appLanguage = [[NSString alloc] initWithString:[NSLocale preferredLanguages].firstObject];
    if ([appLanguage containsString:@"zh-Hans"]) {
        return YES;
    }
    return NO;
}

@end
