//
//  HBannerFirstViewController.m
//  FaceKARE
//
//  Created by Anan on 2017/5/23.
//  Copyright © 2017年 Anan. All rights reserved.
//

#import "HBannerFirstViewController.h"
#import "AppUIModel.h"
#import "AppDelegate.h"
#import "HProgressView.h"
#import "HCircleStyleButton.h"
#import "MBProgressHUD+MJ.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

@interface HBannerFirstViewController ()<UICollectionViewDelegate>
{
    UIScrollView *bannerFirstScrollView;
    UIView *allView;
    NSMutableArray *dataTitleArray;
    UILabel *tipTopLabel;
    UILabel *tipLabel;
    
    UIView *progressBackgroundView;
    UIView *modelBackgroundView;
    
    // 切换模式 button
    UIButton *greenButton;
    UIButton *yellowButton;
    UIButton *blueButton;
    
    // 切换模式 label
    UILabel *greenLabel;
    UILabel *yellowLabel;
    UILabel *blueLabel;
    
}

// 主色调背景
@property (nonatomic, strong) UIView *bannerChartLineView;
// 减小 Button
@property (nonatomic, strong) HCircleStyleButton *homeReduceButton;
// 增大 Button
@property (nonatomic, strong) HCircleStyleButton *homeIncreaseButton;
// 进度条（表示电流强度）
@property (nonatomic, strong) HProgressView *progressView;

@end

@implementation HBannerFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(R0506NotificationAction) name:@"R0506Notification" object:nil];
    
    // 接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(R0508DifferentNotificationAction) name:@"R0508DifferentNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transformNotificationAction) name:@"transformNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isOnceConnectAction) name:@"isOnceConnectNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(R0509NotificationAction) name:@"R0509Notification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(R0106Action) name:@"R0106Notification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeProgressViewAction) name:@"changeProgressViewNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disconnectDeviceBannerAction) name:@"disconnectNotification" object:nil];
    
    // 设置页面 navigation 标题
    self.navigationItem.title = NSLocalizedString(@"bannerFirstNavigationTitle", nil);
    
    [self.view setBackgroundColor:[AppUIModel UIViewBackgroundColor]];
    
    // 设置返回按钮
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc] init];
    backbutton.title = @"";
    self.navigationItem.backBarButtonItem = backbutton;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    NSLog(@"status width - %f", rectStatus.size.width); // 宽度
    NSLog(@"status height - %f", rectStatus.size.height);  // 高度
    
    // 设置 view
    self.bannerChartLineView = [[UIView alloc] initWithFrame:CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT + rectStatus.size.height + 44)];
    self.bannerChartLineView.backgroundColor = [AppUIModel UIViewMainColorI];
    self.bannerChartLineView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.bannerChartLineView];
    
    // 1.创建UIScrollView
    bannerFirstScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, rectStatus.size.height + 44, SCREEN_WIDTH, SCREEN_HEIGHT - rectStatus.size.height + 44)];
    bannerFirstScrollView.backgroundColor = [AppUIModel UIViewBackgroundColor];
    bannerFirstScrollView.showsHorizontalScrollIndicator = NO;
    bannerFirstScrollView.showsVerticalScrollIndicator = NO;
    bannerFirstScrollView.pagingEnabled = NO;
    bannerFirstScrollView.bounces = NO;
    bannerFirstScrollView.delegate = self;
    
    tipTopLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 60, 30)];
    tipTopLabel.text = NSLocalizedString(@"bannerFirst", nil);
    tipTopLabel.textColor = [AppUIModel UIViewMainColorII];
    tipTopLabel.font = [AppUIModel UIViewNormalBoldFont];
    tipTopLabel.numberOfLines = 0;
    CGSize tipToplabelSize = [tipTopLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH - 60, MAXFLOAT)];
    CGRect tipTopLabelFrame = tipTopLabel.frame;
    tipTopLabelFrame.size.height = tipToplabelSize.height;
    [tipTopLabel setFrame:tipTopLabelFrame];
    tipTopLabel.center = CGPointMake(SCREEN_WIDTH * 0.5, 30 + tipToplabelSize.height * 0.5);
    
    dataTitleArray = [[NSMutableArray alloc] initWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59",@"60", nil];
    
    self.mylinechart = [[HBannerChartView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    CGPoint centerPoint = CGPointMake(SCREEN_WIDTH * 0.5, 130 + tipToplabelSize.height);
    self.mylinechart.center = centerPoint;
    self.mylinechart.backgroundColor = [UIColor clearColor];
    self.mylinechart.titleArray = dataTitleArray;
    self.mylinechart.valueArray = ApplicationDelegate.collagenArray;
    CGFloat w = (SCREEN_WIDTH - 100.0f) / [dataTitleArray count];
    self.mylinechart.lineBetweenWidth = w;    //点间隔宽度
    [self.mylinechart initWithView];
    
    tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 60, 30)];
    tipLabel.text = NSLocalizedString(@"bannerCollagenTip", nil);
    tipLabel.numberOfLines = 0;
    tipLabel.font = [AppUIModel UIViewNormalFont];
    tipLabel.textColor = [AppUIModel UIViewNormalColor];
    CGSize labelSize = [tipLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH - 60, MAXFLOAT)];
    CGRect labelFrame = tipLabel.frame;
    labelFrame.size.height = labelSize.height;
    [tipLabel setFrame:labelFrame];
    tipLabel.center = CGPointMake(SCREEN_WIDTH * 0.5, 250 + tipToplabelSize.height + labelSize.height * 0.5);
    
    UILabel *changeIntensityLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, SCREEN_WIDTH - 60, 30)];
//    CGPoint changeIntensityLabelPoint = CGPointMake(SCREEN_WIDTH * 0.5, 20);
//    changeIntensityLabel.center = changeIntensityLabelPoint;
    [changeIntensityLabel setTextAlignment:NSTextAlignmentLeft];
    changeIntensityLabel.textColor = [AppUIModel UIViewMainColorII];
    changeIntensityLabel.font = [AppUIModel UIViewNormalBoldFont];
    changeIntensityLabel.text = NSLocalizedString(@"bannerFirstChangeIntensityLabel", nil);
//    changeIntensityLabel.textAlignment = NSTextAlignmentCenter;
    
    // 设置进度条（表示电流强度）
    self.progressView = [[HProgressView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 0.34, 40 + 22, SCREEN_WIDTH * 0.32, 6)];
    self.progressView.progressBackgroundColor = [AppUIModel UIUselessColor];
    self.progressView.progressBarColor = [AppUIModel UIViewMainColorII];
//    [self.progressView setProgress:ApplicationDelegate.nowElectricity / ApplicationDelegate.maxElectricity];
    [self changeProgressViewAction];
    
    //设置减小 button
    self.homeReduceButton = [[HCircleStyleButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 0.34 - 50, 40 + 10, 30, 30)];
    [self.homeReduceButton.layer setMasksToBounds:YES];
    [self.homeReduceButton.layer setCornerRadius:15.0f];
    [self.homeReduceButton setImage:[UIImage imageNamed:@"reduce96.png"] forState:UIControlStateNormal];
    self.homeReduceButton.titleLabel.font = [AppUIModel UIViewTitleFont];
    [self.homeReduceButton setShowsTouchWhenHighlighted:YES];
    [self.homeReduceButton addTarget:self action:@selector(reduceButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //设置增大 button
    self.homeIncreaseButton = [[HCircleStyleButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 0.66 + 20, 40 + 10, 30, 30)];
    [self.homeIncreaseButton.layer setMasksToBounds:YES];
    [self.homeIncreaseButton.layer setCornerRadius:15.0f];
    [self.homeIncreaseButton setImage:[UIImage imageNamed:@"increase96.png"] forState:UIControlStateNormal];
    self.homeIncreaseButton.titleLabel.font = [AppUIModel UIViewTitleFont];
    [self.homeIncreaseButton setShowsTouchWhenHighlighted:YES];
    [self.homeIncreaseButton addTarget:self action:@selector(increaseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
//    UILabel *intensityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
//    CGPoint intensityLabelCenterPoint = CGPointMake(SCREEN_WIDTH * 0.5, 40 + 40);
//    intensityLabel.center = intensityLabelCenterPoint;
//    intensityLabel.textColor = [AppUIModel UIViewNormalColor];
//    intensityLabel.font = [AppUIModel UIViewSmallFont];
//    intensityLabel.text = NSLocalizedString(@"intensityLabel", nil);
//    intensityLabel.textAlignment = NSTextAlignmentCenter;
    
    progressBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, tipToplabelSize.height + 270 + labelSize.height, SCREEN_WIDTH, 40 + 60)];
    progressBackgroundView.backgroundColor = [AppUIModel UIViewBackgroundColor2];
    [progressBackgroundView addSubview:changeIntensityLabel];
    [progressBackgroundView addSubview:self.progressView];
    [progressBackgroundView addSubview:self.homeReduceButton];
    [progressBackgroundView addSubview:self.homeIncreaseButton];
//    [progressBackgroundView addSubview:intensityLabel];
    
    UILabel *changeModelLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, SCREEN_WIDTH - 60, 30)];
    changeModelLabel.textColor = [AppUIModel UIViewMainColorII];
    changeModelLabel.font = [AppUIModel UIViewNormalBoldFont];
    [changeModelLabel setTextAlignment:NSTextAlignmentLeft];
    changeModelLabel.text = NSLocalizedString(@"bannerFirstChangeModelLabel", nil);
//    changeModelLabel.textAlignment = NSTextAlignmentCenter;
    
    greenLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    //    greenLabel.backgroundColor = [UIColor greenColor];
    greenLabel.text = NSLocalizedString(@"connectGreenLabel", nil);
    greenLabel.font = [AppUIModel UIViewSmallFont];
    greenLabel.textColor = [AppUIModel UIViewNormalColor];
    [greenLabel setTextAlignment:NSTextAlignmentCenter];
    greenLabel.center = CGPointMake(SCREEN_WIDTH * 0.25, 40 + 70 + 20);
    
    
    yellowLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    //    yellowLabel.backgroundColor = [UIColor orangeColor];
    yellowLabel.text = NSLocalizedString(@"connectYellowLabel", nil);
    yellowLabel.font = [AppUIModel UIViewSmallFont];
    yellowLabel.textColor = [AppUIModel UIViewNormalColor];
    [yellowLabel setTextAlignment:NSTextAlignmentCenter];
    yellowLabel.center = CGPointMake(SCREEN_WIDTH * 0.5, 40 + 70 + 20);
    
    
    blueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    //    blueLabel.backgroundColor = [UIColor blueColor];
    blueLabel.text = NSLocalizedString(@"connectBlueLabel", nil);
    blueLabel.font = [AppUIModel UIViewSmallFont];
    blueLabel.textColor = [AppUIModel UIViewNormalColor];
    [blueLabel setTextAlignment:NSTextAlignmentCenter];
    blueLabel.center = CGPointMake(SCREEN_WIDTH * 0.75, 40 + 70 + 20);
    
    
    greenButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    //    greenButton.backgroundColor = [UIColor greenColor];
    [greenButton setBackgroundImage:[UIImage imageNamed:@"greenClickHand32.png"] forState:UIControlStateNormal];
    greenButton.center = CGPointMake(SCREEN_WIDTH * 0.25, 40 + 30 + 20);
    [greenButton.layer setMasksToBounds:YES];
    [greenButton.layer setCornerRadius:25.0f];
    [greenButton.layer setBorderWidth:1.0f];
    [greenButton.layer setBorderColor:[AppUIModel UIUselessColor].CGColor];
    [greenButton addTarget:self action:@selector(greenButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    yellowButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    //    yellowButton.backgroundColor = [UIColor orangeColor];
    [yellowButton setBackgroundImage:[UIImage imageNamed:@"orangeClickHand32.png"] forState:UIControlStateNormal];
    yellowButton.center = CGPointMake(SCREEN_WIDTH * 0.5, 40 + 30 + 20);
    [yellowButton.layer setMasksToBounds:YES];
    [yellowButton.layer setCornerRadius:25.0f];
    [yellowButton.layer setBorderWidth:1.0f];
    [yellowButton.layer setBorderColor:[AppUIModel UIUselessColor].CGColor];
    [yellowButton addTarget:self action:@selector(yellowButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    blueButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    //    blueButton.backgroundColor = [UIColor blueColor];
    [blueButton setBackgroundImage:[UIImage imageNamed:@"blueClickHand32.png"] forState:UIControlStateNormal];
    blueButton.center = CGPointMake(SCREEN_WIDTH * 0.75, 40 + 30 + 20);
    [blueButton.layer setMasksToBounds:YES];
    [blueButton.layer setCornerRadius:25.0f];
    [blueButton.layer setBorderWidth:1.0f];
    [blueButton.layer setBorderColor:[AppUIModel UIUselessColor].CGColor];
    [blueButton addTarget:self action:@selector(blueButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
//    modelBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 30 + tipToplabelSize.height + 200 + 20 + labelSize.height + 20 + 100, SCREEN_WIDTH, 120 + 20)];
//  2017-12-13 傻逼式修改
    modelBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 30 + tipToplabelSize.height + 200 + 20 + labelSize.height + 20, SCREEN_WIDTH, 120 + 20 + 20)];
    modelBackgroundView.backgroundColor = [AppUIModel UIViewBackgroundColor2];
    [modelBackgroundView addSubview:changeModelLabel];
    [modelBackgroundView addSubview:greenLabel];
    [modelBackgroundView addSubview:yellowLabel];
    [modelBackgroundView addSubview:blueLabel];
    [modelBackgroundView addSubview:greenButton];
    [modelBackgroundView addSubview:yellowButton];
    [modelBackgroundView addSubview:blueButton];
    
//    greenLabel.hidden = YES;
//    yellowLabel.hidden = YES;
//    blueLabel.hidden = YES;
//    greenButton.hidden = YES;
//    yellowButton.hidden = YES;
//    blueButton.hidden = YES;
    
    allView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30 + tipToplabelSize.height + 200 + 20 + labelSize.height + 20 + 100 + 120 + 20)];
    allView.backgroundColor = [AppUIModel UIViewBackgroundColor];
    
    [allView addSubview:tipTopLabel];
    [allView addSubview:self.mylinechart];
    [allView addSubview:tipLabel];
//    [allView addSubview:progressBackgroundView];
    [allView addSubview:modelBackgroundView];
    
    bannerFirstScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, tipToplabelSize.height + 460 + labelSize.height);
    [bannerFirstScrollView addSubview:allView];
    [self.view addSubview:bannerFirstScrollView];
    
    NSLog(@"electricity2Array - %@",ApplicationDelegate.collagenArray);
}

- (void)reduceButtonAction:(UIButton *)sender
{
    UIView *bView = [[UIView alloc] initWithFrame:sender.frame];
    bView.layer.borderWidth = 3.0f;
    bView.layer.borderColor = [AppUIModel UIViewMainColorII].CGColor;
    
    [bView setBackgroundColor:[UIColor clearColor]];
    bView.layer.cornerRadius = 15;
    [progressBackgroundView insertSubview:bView atIndex:0];
    
    [UIView animateWithDuration:1.0f delay:0.2 options:0 animations:^{
        bView.transform = CGAffineTransformMakeScale(1.5, 1.5);
        bView.alpha = 0;
    } completion:^(BOOL finished) {
        [bView removeFromSuperview];
    }];
    
    if (ApplicationDelegate.isWorking)
    {
        if (ApplicationDelegate.nowElectricity <= ApplicationDelegate.maxElectricity * 0.1)
        {
            //            [MBProgressHUD showError:NSLocalizedString(@"homeMessage2", nil)];
        }
        else
        {
            ApplicationDelegate.nowElectricity = ApplicationDelegate.nowElectricity - ApplicationDelegate.maxElectricity * 0.1;
            if (ApplicationDelegate.nowElectricity < ApplicationDelegate.maxElectricity * 0.1) {
                ApplicationDelegate.nowElectricity = ApplicationDelegate.maxElectricity * 0.1;
            }
            float setElectricity = 100 * (float)ApplicationDelegate.nowElectricity / (float)ApplicationDelegate.maxElectricity;
            NSLog(@"setElectricity %f",setElectricity);
            if (setElectricity > 100)
            {
                setElectricity = 100;
            }
            else if (setElectricity < 10)
            {
                setElectricity = 10;
            }
            NSString *s = [NSString stringWithFormat:@"S0507,%@\r\n",[NSString stringWithFormat:@"%f", setElectricity]];
            const char *code = [s UTF8String];
            NSData* data = [ApplicationDelegate.manager.dataProcessor encription:code];
            [ApplicationDelegate.manager writeWithoutResponceToSelectedCharacteristicWithData:data];
            
            ApplicationDelegate.setElectricityPercent = setElectricity / 100;
            [self.progressView setProgress:ApplicationDelegate.setElectricityPercent];
        }
    }
    else
    {
//                [MBProgressHUD showError:NSLocalizedString(@"homeMessage1", nil)];
    }

}

- (void)increaseButtonAction:(UIButton *)sender
{
    UIView *bView = [[UIView alloc] initWithFrame:sender.frame];
    bView.layer.borderWidth = 3.0f;
    bView.layer.borderColor = [AppUIModel UIViewMainColorII].CGColor;
    
    [bView setBackgroundColor:[UIColor clearColor]];
    bView.layer.cornerRadius = 15;
    [progressBackgroundView insertSubview:bView atIndex:0];
    
    [UIView animateWithDuration:1.0f delay:0.2 options:0 animations:^{
        bView.transform = CGAffineTransformMakeScale(1.5, 1.5);
        bView.alpha = 0;
    } completion:^(BOOL finished) {
        [bView removeFromSuperview];
    }];
    
    if (ApplicationDelegate.isWorking)
    {
        
        if (ApplicationDelegate.nowElectricity >= ApplicationDelegate.maxElectricity)
        {
            //            [MBProgressHUD showError:NSLocalizedString(@"homeMessage3", nil)];
        }
        else
        {
            ApplicationDelegate.nowElectricity = ApplicationDelegate.nowElectricity + ApplicationDelegate.maxElectricity * 0.1;
            if (ApplicationDelegate.nowElectricity > ApplicationDelegate.maxElectricity) {
                ApplicationDelegate.nowElectricity = ApplicationDelegate.maxElectricity;
            }
            float setElectricity = 100 * (float)ApplicationDelegate.nowElectricity / (float)ApplicationDelegate.maxElectricity;
            NSLog(@"setElectricity %f",setElectricity);
            if (setElectricity > 100)
            {
                setElectricity = 100;
            }
            else if (setElectricity < 10)
            {
                setElectricity = 10;
            }
            NSString *s = [NSString stringWithFormat:@"S0507,%@\r\n",[NSString stringWithFormat:@"%f", setElectricity]];
            const char *code = [s UTF8String];
            NSData* data = [ApplicationDelegate.manager.dataProcessor encription:code];
            [ApplicationDelegate.manager writeWithoutResponceToSelectedCharacteristicWithData:data];
            
            ApplicationDelegate.setElectricityPercent = setElectricity / 100;
            [self.progressView setProgress:ApplicationDelegate.setElectricityPercent];
        }
    }
    else
    {
//                [MBProgressHUD showError:NSLocalizedString(@"homeMessage1", nil)];
    }
    
}

- (void)greenButtonAction:(UIButton *)sender
{
    NSLog(@"greenButton");
    if (ApplicationDelegate.isAbleSetModelID == YES) {
        if (ApplicationDelegate.isConnectDevice == YES) {
            if (ApplicationDelegate.setModelID == 1) {
                [MBProgressHUD showError:NSLocalizedString(@"connectPromptDetail6", nil)];
            }
            else
            {
                ApplicationDelegate.setModelID = 1;
                NSData* data = [ApplicationDelegate.manager.dataProcessor encription:"S0509,0\r\n"];
                NSLog(@"data base - %@",data);
                [ApplicationDelegate.manager writeWithoutResponceToSelectedCharacteristicWithData:data];
                [greenButton setEnabled:NO];
                [yellowButton setEnabled:NO];
                [blueButton setEnabled:NO];
                //                [greenButton.layer setBorderWidth:4.0f];
                //                [greenButton.layer setBorderColor:[AppUIModel UIViewGreenColor].CGColor];
                //                [yellowButton.layer setBorderWidth:1.0f];
                //                [yellowButton.layer setBorderColor:[AppUIModel UIUselessColor].CGColor];
                //                [blueButton.layer setBorderWidth:1.0f];
                //                [blueButton.layer setBorderColor:[AppUIModel UIUselessColor].CGColor];
                ApplicationDelegate.isCheckProtocol = YES;
                ApplicationDelegate.isAbleSetModelID = NO;
            }
        }
        else
        {
            [MBProgressHUD showError:NSLocalizedString(@"connectPromptDetail5", nil)];
        }
    }
    else
    {
//        [MBProgressHUD showError:NSLocalizedString(@"您倒是歇一会儿啊", nil)];
    }
    
    
}

- (void)yellowButtonAction:(UIButton *)sender
{
    NSLog(@"yellowButton");
    if (ApplicationDelegate.isAbleSetModelID == YES) {
        if (ApplicationDelegate.isConnectDevice == YES) {
            if (ApplicationDelegate.setModelID == 2) {
                [MBProgressHUD showError:NSLocalizedString(@"connectPromptDetail6", nil)];
            }
            else
            {
                ApplicationDelegate.setModelID = 2;
                NSData* data = [ApplicationDelegate.manager.dataProcessor encription:"S0509,1\r\n"];
                NSLog(@"data base - %@",data);
                [ApplicationDelegate.manager writeWithoutResponceToSelectedCharacteristicWithData:data];
                [greenButton setEnabled:NO];
                [yellowButton setEnabled:NO];
                [blueButton setEnabled:NO];
                //                [greenButton.layer setBorderWidth:1.0f];
                //                [greenButton.layer setBorderColor:[AppUIModel UIUselessColor].CGColor];
                //                [yellowButton.layer setBorderWidth:4.0f];
                //                [yellowButton.layer setBorderColor:[UIColor orangeColor].CGColor];
                //                [blueButton.layer setBorderWidth:1.0f];
                //                [blueButton.layer setBorderColor:[AppUIModel UIUselessColor].CGColor];
                ApplicationDelegate.isCheckProtocol = YES;
                ApplicationDelegate.isAbleSetModelID = NO;
            }
        }
        else
        {
            [MBProgressHUD showError:NSLocalizedString(@"connectPromptDetail5", nil)];
        }
    }
    else
    {
//        [MBProgressHUD showError:NSLocalizedString(@"您倒是歇一会儿啊", nil)];
    }
    
}

- (void)blueButtonAction:(UIButton *)sender
{
    NSLog(@"blueButton");
    
    if (ApplicationDelegate.isAbleSetModelID == YES) {
        if (ApplicationDelegate.isConnectDevice == YES) {
            if (ApplicationDelegate.setModelID == 3) {
                [MBProgressHUD showError:NSLocalizedString(@"connectPromptDetail6", nil)];
            }
            else
            {
                ApplicationDelegate.setModelID = 3;
                NSData* data = [ApplicationDelegate.manager.dataProcessor encription:"S0509,2\r\n"];
                NSLog(@"data base - %@",data);
                [ApplicationDelegate.manager writeWithoutResponceToSelectedCharacteristicWithData:data];
                [greenButton setEnabled:NO];
                [yellowButton setEnabled:NO];
                [blueButton setEnabled:NO];
                //                [greenButton.layer setBorderWidth:1.0f];
                //                [greenButton.layer setBorderColor:[AppUIModel UIUselessColor].CGColor];
                //                [yellowButton.layer setBorderWidth:1.0f];
                //                [yellowButton.layer setBorderColor:[AppUIModel UIUselessColor].CGColor];
                //                [blueButton.layer setBorderWidth:4.0f];
                //                [blueButton.layer setBorderColor:[UIColor blueColor].CGColor];
                ApplicationDelegate.isCheckProtocol = YES;
                ApplicationDelegate.isAbleSetModelID = NO;
            }
        }
        else
        {
            [MBProgressHUD showError:NSLocalizedString(@"connectPromptDetail5", nil)];
        }
    }
    else
    {
//        [MBProgressHUD showError:NSLocalizedString(@"您倒是歇一会儿啊", nil)];
    }
    
    
}

- (void)R0506NotificationAction
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self changeChart];
    }];
}

- (void)R0508DifferentNotificationAction
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if (!ApplicationDelegate.isReplace) {
            [UIView animateWithDuration:1.5 animations:^{
                if (ApplicationDelegate.modelID == 1) {
                    [self->greenButton.layer setBorderWidth:4.0f];
                    [self->greenButton.layer setBorderColor:[AppUIModel UIViewGreenColor].CGColor];
                    [self->yellowButton.layer setBorderWidth:1.0f];
                    [self->yellowButton.layer setBorderColor:[AppUIModel UIUselessColor].CGColor];
                    [self->blueButton.layer setBorderWidth:1.0f];
                    [self->blueButton.layer setBorderColor:[AppUIModel UIUselessColor].CGColor];
                }
                if (ApplicationDelegate.modelID == 2) {
                    [self->greenButton.layer setBorderWidth:1.0f];
                    [self->greenButton.layer setBorderColor:[AppUIModel UIUselessColor].CGColor];
                    [self->yellowButton.layer setBorderWidth:4.0f];
                    [self->yellowButton.layer setBorderColor:[UIColor orangeColor].CGColor];
                    [self->blueButton.layer setBorderWidth:1.0f];
                    [self->blueButton.layer setBorderColor:[AppUIModel UIUselessColor].CGColor];
                }
                if (ApplicationDelegate.modelID == 3) {
                    [self->greenButton.layer setBorderWidth:1.0f];
                    [self->greenButton.layer setBorderColor:[AppUIModel UIUselessColor].CGColor];
                    [self->yellowButton.layer setBorderWidth:1.0f];
                    [self->yellowButton.layer setBorderColor:[AppUIModel UIUselessColor].CGColor];
                    [self->blueButton.layer setBorderWidth:4.0f];
                    [self->blueButton.layer setBorderColor:[UIColor blueColor].CGColor];
                }
            } completion:^(BOOL finished) {
                NSLog(@"变换图片结束");
            }];
        }
    }];
}

- (void)transformNotificationAction
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        // 旋转图片
        [UIView animateWithDuration:1.5 animations:^{
            if (ApplicationDelegate.isUseSetModelID) {
                if (ApplicationDelegate.setModelID == 1) {
                    [self->greenButton.layer setBorderWidth:4.0f];
                    [self->greenButton.layer setBorderColor:[AppUIModel UIViewGreenColor].CGColor];
                    [self->yellowButton.layer setBorderWidth:1.0f];
                    [self->yellowButton.layer setBorderColor:[AppUIModel UIUselessColor].CGColor];
                    [self->blueButton.layer setBorderWidth:1.0f];
                    [self->blueButton.layer setBorderColor:[AppUIModel UIUselessColor].CGColor];
                }
                if (ApplicationDelegate.setModelID == 2) {
                    [self->greenButton.layer setBorderWidth:1.0f];
                    [self->greenButton.layer setBorderColor:[AppUIModel UIUselessColor].CGColor];
                    [self->yellowButton.layer setBorderWidth:4.0f];
                    [self->yellowButton.layer setBorderColor:[UIColor orangeColor].CGColor];
                    [self->blueButton.layer setBorderWidth:1.0f];
                    [self->blueButton.layer setBorderColor:[AppUIModel UIUselessColor].CGColor];
                }
                if (ApplicationDelegate.setModelID == 3) {
                    [self->greenButton.layer setBorderWidth:1.0f];
                    [self->greenButton.layer setBorderColor:[AppUIModel UIUselessColor].CGColor];
                    [self->yellowButton.layer setBorderWidth:1.0f];
                    [self->yellowButton.layer setBorderColor:[AppUIModel UIUselessColor].CGColor];
                    [self->blueButton.layer setBorderWidth:4.0f];
                    [self->blueButton.layer setBorderColor:[UIColor blueColor].CGColor];
                }
            }
            else
            {
                if (ApplicationDelegate.modelID == 1) {
                    [self->greenButton.layer setBorderWidth:4.0f];
                    [self->greenButton.layer setBorderColor:[AppUIModel UIViewGreenColor].CGColor];
                    [self->yellowButton.layer setBorderWidth:1.0f];
                    [self->yellowButton.layer setBorderColor:[AppUIModel UIUselessColor].CGColor];
                    [self->blueButton.layer setBorderWidth:1.0f];
                    [self->blueButton.layer setBorderColor:[AppUIModel UIUselessColor].CGColor];
                }
                if (ApplicationDelegate.modelID == 2) {
                    [self->greenButton.layer setBorderWidth:1.0f];
                    [self->greenButton.layer setBorderColor:[AppUIModel UIUselessColor].CGColor];
                    [self->yellowButton.layer setBorderWidth:4.0f];
                    [self->yellowButton.layer setBorderColor:[UIColor orangeColor].CGColor];
                    [self->blueButton.layer setBorderWidth:1.0f];
                    [self->blueButton.layer setBorderColor:[AppUIModel UIUselessColor].CGColor];
                }
                if (ApplicationDelegate.modelID == 3) {
                    [self->greenButton.layer setBorderWidth:1.0f];
                    [self->greenButton.layer setBorderColor:[AppUIModel UIUselessColor].CGColor];
                    [self->yellowButton.layer setBorderWidth:1.0f];
                    [self->yellowButton.layer setBorderColor:[AppUIModel UIUselessColor].CGColor];
                    [self->blueButton.layer setBorderWidth:4.0f];
                    [self->blueButton.layer setBorderColor:[UIColor blueColor].CGColor];
                }
            }
        } completion:^(BOOL finished) {
            NSLog(@"变换图片结束");
        }];
    }];
}

- (void)R0509NotificationAction
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        NSLog(@"更换模式成功！");
        [UIView animateWithDuration:1.5 animations:^{
            if (ApplicationDelegate.setModelID == 1) {
                [self->greenButton.layer setBorderWidth:4.0f];
                [self->greenButton.layer setBorderColor:[AppUIModel UIViewGreenColor].CGColor];
                [self->yellowButton.layer setBorderWidth:1.0f];
                [self->yellowButton.layer setBorderColor:[AppUIModel UIUselessColor].CGColor];
                [self->blueButton.layer setBorderWidth:1.0f];
                [self->blueButton.layer setBorderColor:[AppUIModel UIUselessColor].CGColor];
            }
            if (ApplicationDelegate.setModelID == 2) {
                [self->greenButton.layer setBorderWidth:1.0f];
                [self->greenButton.layer setBorderColor:[AppUIModel UIUselessColor].CGColor];
                [self->yellowButton.layer setBorderWidth:4.0f];
                [self->yellowButton.layer setBorderColor:[UIColor orangeColor].CGColor];
                [self->blueButton.layer setBorderWidth:1.0f];
                [self->blueButton.layer setBorderColor:[AppUIModel UIUselessColor].CGColor];
            }
            if (ApplicationDelegate.setModelID == 3) {
                [self->greenButton.layer setBorderWidth:1.0f];
                [self->greenButton.layer setBorderColor:[AppUIModel UIUselessColor].CGColor];
                [self->yellowButton.layer setBorderWidth:1.0f];
                [self->yellowButton.layer setBorderColor:[AppUIModel UIUselessColor].CGColor];
                [self->blueButton.layer setBorderWidth:4.0f];
                [self->blueButton.layer setBorderColor:[UIColor blueColor].CGColor];
            }
        } completion:^(BOOL finished) {
            ApplicationDelegate.isUseSetModelID = YES;
            ApplicationDelegate.isAbleSetModelID = YES;
            [self setButtonsEnableYes];
            NSLog(@"变换图片结束");
        }];
        
    }];
}

- (void)R0106Action
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        NSLog(@"ApplicationDelegate.deviceIDString --->>> %@", ApplicationDelegate.deviceIDString);
        
        if ([ApplicationDelegate.deviceIDString isEqualToString:@"-"])
        {
            self->modelBackgroundView.hidden = YES;
//            greenLabel.hidden = YES;
//            yellowLabel.hidden = YES;
//            blueLabel.hidden = YES;
//            greenButton.hidden = YES;
//            yellowButton.hidden = YES;
//            blueButton.hidden = YES;
        }
        else
        {
            if ([[ApplicationDelegate.deviceIDString substringToIndex:3] isEqualToString:@"FK1"])
            {
                self->modelBackgroundView.hidden = YES;
//                greenLabel.hidden = YES;
//                yellowLabel.hidden = YES;
//                blueLabel.hidden = YES;
//                greenButton.hidden = YES;
//                yellowButton.hidden = YES;
//                blueButton.hidden = YES;
            }
            else
            {
                self->modelBackgroundView.hidden = NO;
//                greenLabel.hidden = NO;
//                yellowLabel.hidden = NO;
//                blueLabel.hidden = NO;
//                greenButton.hidden = NO;
//                yellowButton.hidden = NO;
//                blueButton.hidden = NO;
            }
        }
    }];
}

- (void)disconnectDeviceBannerAction
{
   [self R0106Action];
}

- (void)changeProgressViewAction
{
    
    if (ApplicationDelegate.setElectricityPercent <= 0.1 && ApplicationDelegate.setElectricityPercent != 0) {
        ApplicationDelegate.setElectricityPercent = 0.1;
        [self.progressView setProgress:ApplicationDelegate.setElectricityPercent];
    }
    else if (ApplicationDelegate.setElectricityPercent >= 1)
    {
        ApplicationDelegate.setElectricityPercent = 1;
        [self.progressView setProgress:ApplicationDelegate.setElectricityPercent];
    }
    else
    {
        [self.progressView setProgress:ApplicationDelegate.setElectricityPercent];
    }
    
    NSLog(@"self.progressView.progress >>> %f", self.progressView.progress);
    
}

- (void)changeChart
{
    [self.mylinechart.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.mylinechart.valueArray = ApplicationDelegate.collagenArray;
    CGFloat w = (SCREEN_WIDTH - 100.0f) / [dataTitleArray count];
    self.mylinechart.lineBetweenWidth = w;    //点间隔宽度
    [self.mylinechart initWithView];
}

#pragma mark - 页面将要打开
- (void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
    
    [self R0106Action];
//    [self changeProgressViewAction];
    
    if (ApplicationDelegate.isUseSetModelID)
    {
        if (ApplicationDelegate.setModelID == 1) {
            [greenButton.layer setBorderWidth:4.0f];
            [greenButton.layer setBorderColor:[AppUIModel UIViewGreenColor].CGColor];
            [yellowButton.layer setBorderWidth:1.0f];
            [yellowButton.layer setBorderColor:[AppUIModel UIUselessColor].CGColor];
            [blueButton.layer setBorderWidth:1.0f];
            [blueButton.layer setBorderColor:[AppUIModel UIUselessColor].CGColor];
        }
        if (ApplicationDelegate.setModelID == 2) {
            [greenButton.layer setBorderWidth:1.0f];
            [greenButton.layer setBorderColor:[AppUIModel UIUselessColor].CGColor];
            [yellowButton.layer setBorderWidth:4.0f];
            [yellowButton.layer setBorderColor:[UIColor orangeColor].CGColor];
            [blueButton.layer setBorderWidth:1.0f];
            [blueButton.layer setBorderColor:[AppUIModel UIUselessColor].CGColor];
        }
        if (ApplicationDelegate.setModelID == 3) {
            [greenButton.layer setBorderWidth:1.0f];
            [greenButton.layer setBorderColor:[AppUIModel UIUselessColor].CGColor];
            [yellowButton.layer setBorderWidth:1.0f];
            [yellowButton.layer setBorderColor:[AppUIModel UIUselessColor].CGColor];
            [blueButton.layer setBorderWidth:4.0f];
            [blueButton.layer setBorderColor:[UIColor blueColor].CGColor];
        }
    }
    else
    {
        if (ApplicationDelegate.modelID == 1) {
            [greenButton.layer setBorderWidth:4.0f];
            [greenButton.layer setBorderColor:[AppUIModel UIViewGreenColor].CGColor];
            [yellowButton.layer setBorderWidth:1.0f];
            [yellowButton.layer setBorderColor:[AppUIModel UIUselessColor].CGColor];
            [blueButton.layer setBorderWidth:1.0f];
            [blueButton.layer setBorderColor:[AppUIModel UIUselessColor].CGColor];
        }
        if (ApplicationDelegate.modelID == 2) {
            [greenButton.layer setBorderWidth:1.0f];
            [greenButton.layer setBorderColor:[AppUIModel UIUselessColor].CGColor];
            [yellowButton.layer setBorderWidth:4.0f];
            [yellowButton.layer setBorderColor:[UIColor orangeColor].CGColor];
            [blueButton.layer setBorderWidth:1.0f];
            [blueButton.layer setBorderColor:[AppUIModel UIUselessColor].CGColor];
        }
        if (ApplicationDelegate.modelID == 3) {
            [greenButton.layer setBorderWidth:1.0f];
            [greenButton.layer setBorderColor:[AppUIModel UIUselessColor].CGColor];
            [yellowButton.layer setBorderWidth:1.0f];
            [yellowButton.layer setBorderColor:[AppUIModel UIUselessColor].CGColor];
            [blueButton.layer setBorderWidth:4.0f];
            [blueButton.layer setBorderColor:[UIColor blueColor].CGColor];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    ApplicationDelegate.setElectricityPercent = self.progressView.progress;
}

- (void)isOnceConnectAction
{
    if (ApplicationDelegate.isOnceConnectDevice == YES)
    {
        ;
    }
    else
    {
        modelBackgroundView.hidden = YES;
//        greenLabel.hidden = YES;
//        yellowLabel.hidden = YES;
//        blueLabel.hidden = YES;
//        greenButton.hidden = YES;
//        yellowButton.hidden = YES;
//        blueButton.hidden = YES;
    }

}

- (void)setButtonsEnableYes
{
    [greenButton setEnabled:YES];
    [yellowButton setEnabled:YES];
    [blueButton setEnabled:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
