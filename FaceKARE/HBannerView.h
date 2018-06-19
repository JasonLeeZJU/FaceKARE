//
//  HBannerView.h
//  FaceKARE
//
//  Created by Anan on 2017/4/27.
//  Copyright © 2017年 Anan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^clickCallBack) (NSInteger index);
@interface HBannerView : UIView

/*
 点击图片回调的block
 */
@property (nonatomic, copy) clickCallBack clickBlcok;

/*
 创建轮播图的构造方法
 @param frame           轮播器的frame
 @param playTime        轮播器图片的切换时间
 @param imagesArray     轮播器图片的数据源
 @param clickCallBack   点击轮播器imageView回调的block
 
 @return 返回一个轮播器组件
 */
- (instancetype)initViewWithFrame:(CGRect)frame
                     autoPlayTime:(NSTimeInterval)playTime
                      imagesArray:(NSArray *)imagesArray
                       textsArray:(NSArray *)textsArray
                    clickCallBack:(clickCallBack)clickCallBack;

@end
