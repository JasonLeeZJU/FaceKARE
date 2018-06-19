//
//  HHomeChartView.m
//  PainKARE
//
//  Created by Honey on 16/9/30.
//  Copyright © 2016年 Honey. All rights reserved.
//

#import "HHomeChartView.h"
#import "AppUIModel.h"
#import "HCircleStyleButton.h"
#import "AppDelegate.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

@implementation HHomeChartView

@synthesize lineChart;
@synthesize lineChartBgColor;
@synthesize valueArray;
@synthesize titleArray;
@synthesize lineWidth,lineTitleWidth,lineBetweenWidth,lineHeight;
@synthesize lineColor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        lineTitleWidth = 24.0f;    //Lable宽度
        lineWidth = 1.0f;    //折现宽度
        lineHeight = 160.0f;    //折线最大高度
        lineChartBgColor = [AppUIModel UIViewBackgroundColor];    //折线图背景色
        lineColor = [AppUIModel UIViewNormalColor];
        lineChart = [[CAShapeLayer alloc] init];
        lineChart.lineCap = kCALineCapRound;
        lineChart.fillColor = nil;
        lineChart.lineWidth = lineWidth;
    }
    return self;
}

-(void)initWithView
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(R0506NotificationAction) name:@"R0506Notification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(R0101StopNotificationAction) name:@"R0101StopNotification" object:nil];
    
    float scrollViewWidth = self.frame.size.width;
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height)];
    scrollView.directionalLockEnabled = YES;
    scrollView.pagingEnabled = NO;
    scrollView.backgroundColor = lineChartBgColor;
    scrollView.showsHorizontalScrollIndicator = YES;
    scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.delegate = self;
    scrollView.bounces = YES;
    scrollView.contentSize = CGSizeMake(scrollViewWidth, self.frame.size.height);
    scrollView.contentOffset = CGPointMake(0, 0);
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [self addSubview:scrollView];

    UIBezierPath *progressline = [UIBezierPath bezierPath];
    [progressline setLineWidth:lineWidth];
    [progressline setLineCapStyle:kCGLineCapRound];
    lineChart.strokeColor = [lineColor CGColor];
    [scrollView.layer addSublayer:lineChart];
    // titleArray添加Lable
    for (int i = 0; i < [titleArray count]; i++) {
        if (i == 0 || i == 15 || i == 30 || i == 45 || i == 60) {
            UILabel *title=[[UILabel alloc] initWithFrame:CGRectMake(50 + i * lineBetweenWidth, self.frame.size.height - 30, lineTitleWidth, 14)];
            title.text = [titleArray objectAtIndex:i];
            title.textColor = [AppUIModel UIViewNormalColor];
            title.font = [AppUIModel UIViewSmallFont];
            title.textAlignment = NSTextAlignmentCenter;
            [scrollView addSubview:title];
        }
    }
    // valueArray画线
    for(int i = 0; i < [valueArray count]; i++)
    {
        
        float pointHeight = [[valueArray objectAtIndex:i] floatValue];
        
        if(i==0)
        {
            if (pointHeight >= 0 && pointHeight <= 2) {
                [progressline moveToPoint:CGPointMake(62,  168 - 14 * (pointHeight / 2))];
            }
            else if (pointHeight > 2 && pointHeight <= 10) {
                [progressline moveToPoint:CGPointMake(62,  154 - 28 * ((pointHeight - 2) / 8))];
            }
            else{
                [progressline moveToPoint:CGPointMake(62,  126 - 98 * ((pointHeight - 10) / 190))];
            }
        }
        else
        {
            if (pointHeight >= 0 && pointHeight <= 2) {
                [progressline addLineToPoint:CGPointMake(62 + i * lineBetweenWidth,  168 - 14 * (pointHeight / 2))];
            }
            else if (pointHeight > 2 && pointHeight <= 10) {
                [progressline addLineToPoint:CGPointMake(62 + i * lineBetweenWidth,  154 - 28 * ((pointHeight - 2) / 8))];
            }
            else{
                [progressline addLineToPoint:CGPointMake(62 + i * lineBetweenWidth,  126 - 98 * ((pointHeight - 10) / 190))];
            }
        }
        lineChart.path = progressline.CGPath;
        [UIView beginAnimations:nil context:nil];    //标记动画的开始
        // 持续时间
        [UIView setAnimationDuration:2.0f];    //动画的持续时间
        [UIView commitAnimations];    //标记动画的结束
    }
    
    // x轴
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(62, self.frame.size.height - 32, self.frame.size.width - 100, 2)];
    line.backgroundColor = [AppUIModel UIViewNormalColor];
    [scrollView addSubview:line];
    
//    // 治疗进度lable
//    UILabel *chartLineXLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 14)];
//    CGPoint chartLineXPoint =  CGPointMake(0.5 * SCREEN_WIDTH, 190);
//    chartLineXLable.center = chartLineXPoint;
//    chartLineXLable.text = NSLocalizedString(@"homeChartLineX", nil);
//    chartLineXLable.font = [AppUIModel UIViewSmallFont];
//    chartLineXLable.textColor = [AppUIModel UIViewNormalColor];
//    chartLineXLable.textAlignment = NSTextAlignmentCenter;
//    [scrollView addSubview:chartLineXLable];
//    
//    // 生物电流lable
//    UILabel *chartLineYLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 14)];
//    CGPoint chartLineYPoint =  CGPointMake(37, 0.5 * self.frame.size.height);
//    chartLineYLable.center = chartLineYPoint;
//    chartLineYLable.text = NSLocalizedString(@"homeChartLineY", nil);
//    chartLineYLable.font = [AppUIModel UIViewSmallFont];
//    chartLineYLable.textColor = [AppUIModel UIViewNormalColor];
//    chartLineYLable.textAlignment = NSTextAlignmentCenter;
//    chartLineYLable.transform = CGAffineTransformMakeRotation(M_PI * 0.5);
//    [scrollView addSubview:chartLineYLable];
    
    // 治疗进度lable
    self.chartLineXLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 14)];
    CGPoint chartLineXPoint =  CGPointMake(0.5 * SCREEN_WIDTH, 15);
    self.chartLineXLable.center = chartLineXPoint;
    self.chartLineXLable.text = NSLocalizedString(@"homeChartLineYX", nil);
    self.chartLineXLable.font = [AppUIModel UIViewSmallFont];
    self.chartLineXLable.textColor = [AppUIModel UIViewNormalColor];
    self.chartLineXLable.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:self.chartLineXLable];
    
    // Y轴-绿View
    UIView *greenLineYView = [[UIView alloc] initWithFrame:CGRectMake(54, 28, 8, 98)];
    greenLineYView.backgroundColor = [AppUIModel UIViewGreenColor];
    [scrollView addSubview:greenLineYView];
    
    // Y轴-黄View
    UIView *yellowLineYView = [[UIView alloc] initWithFrame:CGRectMake(54, 126, 8, 28)];
    yellowLineYView.backgroundColor = [AppUIModel UIViewYellowColor];
    [scrollView addSubview:yellowLineYView];
    
    // Y轴-红View
    UIView *redLineYView = [[UIView alloc] initWithFrame:CGRectMake(54, 154, 8, 16)];
    redLineYView.backgroundColor = [AppUIModel UIViewRedColor];
    [scrollView addSubview:redLineYView];
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 2.0;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    pathAnimation.autoreverses = NO;
    [lineChart addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    lineChart.strokeEnd = 1.0;
    
    UIButton *chartQuestionButton = [[HCircleStyleButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60, 0, 30, 30)];
    [chartQuestionButton.layer setMasksToBounds:YES];
    [chartQuestionButton.layer setCornerRadius:15.0f];
    [chartQuestionButton setImage:[UIImage imageNamed:@"question96.png"] forState:UIControlStateNormal];
    chartQuestionButton.titleLabel.font = [AppUIModel UIViewTitleFont];
    [chartQuestionButton setShowsTouchWhenHighlighted:YES];
    [chartQuestionButton addTarget:self action:@selector(questionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:chartQuestionButton];
}

- (void)R0506NotificationAction
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if ([ApplicationDelegate.electricityArray count] <= ApplicationDelegate.totalProgress) {
            self.chartLineXLable.text = [[[[[[NSLocalizedString(@"homeChartLineYX2", nil) stringByAppendingString:@"("] stringByAppendingString:[NSString stringWithFormat:@"%lu",(unsigned long)[ApplicationDelegate.electricityArray count]]] stringByAppendingString:@"/"] stringByAppendingString:[NSString stringWithFormat:@"%d",ApplicationDelegate.totalProgress]] stringByAppendingString:NSLocalizedString(@"homeMinite", nil)] stringByAppendingString:@")"];
        }
        else
        {
            self.chartLineXLable.text = [[[[[[NSLocalizedString(@"homeChartLineYX2", nil) stringByAppendingString:@"("] stringByAppendingString:[NSString stringWithFormat:@"%d",ApplicationDelegate.totalProgress]] stringByAppendingString:@"/"] stringByAppendingString:[NSString stringWithFormat:@"%d",ApplicationDelegate.totalProgress]] stringByAppendingString:NSLocalizedString(@"homeMinite", nil)] stringByAppendingString:@")"];
        }
    }];
}

- (void)R0101StopNotificationAction
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self.chartLineXLable.text = [[[[[[NSLocalizedString(@"homeChartLineYX2", nil) stringByAppendingString:@"("] stringByAppendingString:[NSString stringWithFormat:@"%d",ApplicationDelegate.totalProgress]] stringByAppendingString:@" / "] stringByAppendingString:[NSString stringWithFormat:@"%d",ApplicationDelegate.totalProgress]] stringByAppendingString:NSLocalizedString(@"homeMinite", nil)] stringByAppendingString:@")"];
    }];
}

- (void)questionButtonAction:(UIButton *)sender
{
//    UIView *bView = [[UIView alloc] initWithFrame:sender.frame];
//    bView.layer.borderWidth = 3.0f;
//    bView.layer.borderColor = [AppUIModel UIViewMainColorII].CGColor;
//    
//    [bView setBackgroundColor:[UIColor clearColor]];
//    bView.layer.cornerRadius = 15;
//    [scrollView insertSubview:bView atIndex:0];
//    
//    [UIView animateWithDuration:1.0f delay:0.2 options:0 animations:^{
//        bView.transform = CGAffineTransformMakeScale(1.5, 1.5);
//        bView.alpha = 0;
//    } completion:^(BOOL finished) {
//        [bView removeFromSuperview];
//    }];
    
    [ApplicationDelegate addChartTips];
}


@end
