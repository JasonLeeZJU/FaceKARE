//
//  HBannerChartView.h
//  FaceKARE
//
//  Created by Anan on 2017/5/23.
//  Copyright © 2017年 Anan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBannerChartView : UIView <UIScrollViewDelegate>
{
    UIScrollView *scrollView;
}

@property (nonatomic,retain) CAShapeLayer *lineChart;
@property (nonatomic,retain) UIColor *lineChartBgColor;
@property (nonatomic,retain) NSMutableArray *valueArray;
@property (nonatomic,retain) NSMutableArray *titleArray;
@property (nonatomic) float lineWidth,lineTitleWidth,lineBetweenWidth,lineHeight;
@property (nonatomic,retain) UIColor *lineColor;

-(void)initWithView;

@end
