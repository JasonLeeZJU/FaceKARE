//
//  HHomeChartView.h
//  PainKARE
//
//  Created by Honey on 16/9/30.
//  Copyright © 2016年 Honey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHomeChartView : UIView <UIScrollViewDelegate>
{
    UIScrollView *scrollView;
}

@property (nonatomic, retain) CAShapeLayer *lineChart;
@property (nonatomic, retain) UIColor *lineChartBgColor;
@property (nonatomic, retain) NSMutableArray *valueArray;
@property (nonatomic,  retain) NSMutableArray *titleArray;
@property (nonatomic) float lineWidth,lineTitleWidth,lineBetweenWidth,lineHeight;
@property (nonatomic, retain) UIColor *lineColor;

@property (nonatomic, strong) UILabel *chartLineXLable;

-(void)initWithView;

@end
