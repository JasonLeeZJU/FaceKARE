//
//  HHomeViewController.m
//  FaceKARE
//
//  Created by Anan on 2017/4/25.
//  Copyright © 2017年 Anan. All rights reserved.
//

#import "HHomeViewController.h"
#import "AppUIModel.h"
#import "HProgressView.h"
#import "HHomeFirstTableViewCell.h"
#import "HHomeSecondTableViewCell.h"
#import "HConnectViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD+MJ.h"
#import "HBannerDetailViewController.h"
#import "HBannerFirstViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "HCircleStyleButton.h"
#import "HHomeThirdTableViewCell.h"
#import "FeSpinnerTenDot.h"
#import "HBLECenterManager.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define TABBAR_WIDTH [self.tabBarController.tabBar bounds].size.height

@interface HHomeViewController ()<UITableViewDelegate, UITableViewDataSource, bannerDelegate, FeSpinnerTenDotDelegate>

// tableView
@property (nonatomic, strong) UITableView *homeTableView;
// 主色调背景
@property (nonatomic, strong) UIView *homeView;
// 悬浮在 tableView 上的 View
@property (nonatomic, strong) UIView *homeBottomView;
// 获取 Button
@property (nonatomic, strong) UIButton *homeGainButton;

@property (nonatomic, strong) HConnectViewController *connectVC;

@property (nonatomic, strong) HHomeFirstTableViewCell *homeFirstCell;

@property (nonatomic, strong) HHomeThirdTableViewCell *homeThirdCell;

//@property (nonatomic, strong) HBannerFirstViewController *bannerFirstVC;

// 提示
@property (nonatomic, strong) UIAlertController *stopAC;
@property (nonatomic, strong) UIAlertController *R0501Notification1AC;
@property (nonatomic, strong) UIAlertController *R0501Notification2AC;
@property (nonatomic, strong) UIAlertController *BatteryNotificationAC;

@property (strong, nonatomic) FeSpinnerTenDot *spinner;
@property (strong, nonatomic) NSTimer *timer;

// 提示
@property (nonatomic, strong) UIAlertController *R1007AC;
@property (nonatomic, strong) UIAlertController *nomoreDeviceAC;
//@property (nonatomic, strong) UIAlertController *noDeviceAC;

@end

@implementation HHomeViewController
{
    HHomeSecondTableViewCell *homeSecondCell;
    
    NSTimer *timer10s;
    
    UIView *connectView;
    UIView *batteryView;
    UIView *modelView;
    
    UILabel *connectLabel;
    UILabel *batteryLabel;
    UILabel *modelLabel;
    
    UIImageView *connectImageView;
    UIImageView *batteryImageView;
    UIImageView *modelImageView;
    
    BOOL isConnectInAction;
    BOOL isBatteryInAction;
    BOOL isModelInAction;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"SCREEN_WIDTH - %f",SCREEN_WIDTH);
    NSLog(@"SCREEN_HEIGHT - %f",SCREEN_HEIGHT);
    NSLog(@"TABBAR_WIDTH - %f",TABBAR_WIDTH);
    
    // 设置接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(R0506NotificationAction) name:@"R0506Notification" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(R0507NotificationAction) name:@"R0507Notification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(R0101IdleNotificationAction) name:@"R0101IdleNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(R0508DifferentNotificationAction) name:@"R0508DifferentNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(R0101StopNotificationAction) name:@"R0101StopNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(R0501Notification1Action) name:@"R0501Notification1" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(R0501Notification2Action) name:@"R0501Notification2" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BatteryNotificationAction) name:@"BatteryNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disconnectDeviceAction) name:@"disconnectNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(R1007NotificationAction) name:@"R1007Notification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(R1008NotificationAction) name:@"R1008Notification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectDeviceH) name:@"didConnectNotification" object:nil];
    
    // 设置页面 navigation 标题
    self.navigationItem.title = @"FaceKARE";
    
    // 设置返回按钮
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc] init];
    backbutton.title = @"";
    self.navigationItem.backBarButtonItem = backbutton;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    // 设置背景颜色
    self.view.backgroundColor = [AppUIModel UIViewBackgroundColor];
    
    // 设置 tableview
    self.homeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.homeTableView.delegate = self;
    self.homeTableView.dataSource = self;
    [self.homeTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];   //取消 cell 之间的横线
    self.homeTableView.backgroundColor = [AppUIModel UIViewBackgroundColor];
    [self.homeTableView setShowsVerticalScrollIndicator:NO];    //取消滑条
    [self.view addSubview:self.homeTableView];
    
    // 设置 view
    self.homeView = [[UIView alloc] initWithFrame:CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT + 64)];
    self.homeView.backgroundColor = [AppUIModel UIViewMainColorI];
    self.homeView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.homeView];
    
    // 设置安置 button 的 view
    self.homeBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - TABBAR_WIDTH - 80, SCREEN_WIDTH, 80)];
    self.homeBottomView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.homeBottomView];
    
    // 设置获取 button
    self.homeGainButton = [[UIButton alloc] initWithFrame:CGRectMake(60, 20, SCREEN_WIDTH * 0.8 - 80, 40)];
    self.homeGainButton.center = CGPointMake(SCREEN_WIDTH * 0.5, 40);
    [self.homeGainButton.layer setMasksToBounds:YES];
    [self.homeGainButton.layer setCornerRadius:10.0f];
    self.homeGainButton.backgroundColor = [AppUIModel UIViewMainColorII];
    [self.homeGainButton setTitle:NSLocalizedString(@"HomeGainButton", nil) forState:UIControlStateNormal];
    [self.homeGainButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.homeGainButton.titleLabel.font = [AppUIModel UIViewTitleFont];
    [self.homeGainButton setShowsTouchWhenHighlighted:YES];
    [self.homeGainButton.layer setBorderWidth:1.0f];
    [self.homeGainButton.layer setBorderColor:[AppUIModel UIUselessColor].CGColor];
    [self.homeGainButton addTarget:self action:@selector(homeGainButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.homeBottomView addSubview:self.homeGainButton];
    
    isConnectInAction = NO;
    isBatteryInAction = NO;
    isModelInAction = NO;
}

#pragma  mark - 按钮波纹效果（多种不同波纹）
// homeBottomView 点击方法
- (void)homeGainButtonAction:(UIButton *)sender
{
//    HConnectViewController *connectVC = [[HConnectViewController alloc] init];
//    [self.navigationController pushViewController:connectVC animated:YES];
    
    UIView *bView = [[UIView alloc] initWithFrame:sender.frame];
    bView.layer.borderWidth = 3.0f;
    bView.layer.borderColor = [AppUIModel UIViewMainColorII].CGColor;
    
    [bView setBackgroundColor:[UIColor clearColor]];
    bView.layer.cornerRadius = 10;
    [self.view insertSubview:bView atIndex:0];
    
    [UIView animateWithDuration:1.4f delay:0.2 options:0 animations:^{
        bView.transform = CGAffineTransformMakeScale(1.25, 1.5);
        bView.alpha = 0;
    } completion:^(BOOL finished) {
        [bView removeFromSuperview];
    }];
    
    [ApplicationDelegate.manager beginScanPeripherals];
    [self startWaitingView];
    [self start10sTimer];
}

- (void)reduceButtonAction:(UIButton *)sender
{
    UIView *bView = [[UIView alloc] initWithFrame:sender.frame];
    bView.layer.borderWidth = 3.0f;
    bView.layer.borderColor = [AppUIModel UIViewMainColorII].CGColor;
    
    [bView setBackgroundColor:[UIColor clearColor]];
    bView.layer.cornerRadius = 15;
    [self.homeBottomView insertSubview:bView atIndex:0];
    
    [UIView animateWithDuration:1.0f delay:0.2 options:0 animations:^{
        bView.transform = CGAffineTransformMakeScale(2.5, 2.5);
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
            int setElectricityPercent = 100 * (float)ApplicationDelegate.nowElectricity / (float)ApplicationDelegate.maxElectricity;
            if (setElectricityPercent > 100)
            {
                setElectricityPercent = 100;
            }
            else if (setElectricityPercent < 10)
            {
                setElectricityPercent = 10;
            }
            NSString *s = [NSString stringWithFormat:@"S0507,%@\r\n",[NSString stringWithFormat:@"%d", setElectricityPercent]];
            const char *code = [s UTF8String];
            NSData* data = [ApplicationDelegate.manager.dataProcessor encription:code];
            [ApplicationDelegate.manager writeWithoutResponceToSelectedCharacteristicWithData:data];
        }
    }
    else
    {
//        [MBProgressHUD showError:NSLocalizedString(@"homeMessage1", nil)];
    }
}

- (void)increaseButtonAction:(UIButton *)sender
{
    UIView *bView = [[UIView alloc] initWithFrame:sender.frame];
    bView.layer.borderWidth = 3.0f;
    bView.layer.borderColor = [AppUIModel UIViewMainColorII].CGColor;
    
    [bView setBackgroundColor:[UIColor clearColor]];
    bView.layer.cornerRadius = 15;
    [self.homeBottomView insertSubview:bView atIndex:0];
    
    [UIView animateWithDuration:1.0f delay:0.2 options:0 animations:^{
        bView.transform = CGAffineTransformMakeScale(2.5, 2.5);
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
            int setElectricityPercent = 100 * (float)ApplicationDelegate.nowElectricity / (float)ApplicationDelegate.maxElectricity;
            if (setElectricityPercent > 100)
            {
                setElectricityPercent = 100;
            }
            else if (setElectricityPercent < 10)
            {
                setElectricityPercent = 10;
            }
            NSString *s = [NSString stringWithFormat:@"S0507,%@\r\n",[NSString stringWithFormat:@"%d", setElectricityPercent]];
            const char *code = [s UTF8String];
            NSData* data = [ApplicationDelegate.manager.dataProcessor encription:code];
            [ApplicationDelegate.manager writeWithoutResponceToSelectedCharacteristicWithData:data];
        }
    }
    else
    {
//        [MBProgressHUD showError:NSLocalizedString(@"homeMessage1", nil)];
    }
}

#pragma mark -tableview设置
// section 数量
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// row 数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

// tableView 内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        self.homeFirstCell = [HHomeFirstTableViewCell cellWithTableView:self.homeTableView];
        self.homeFirstCell.bannerDelegate = self;
        [self.homeFirstCell addBannerImageView];
        return self.homeFirstCell;
    }
    else if (indexPath.section == 0 && indexPath.row == 1) {
        static NSString *identifiter = @"settingCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifiter];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifiter];
        }
        cell.backgroundColor = [AppUIModel UIViewBackgroundColor2];
        //不可选择cell
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [AppUIModel UIViewMainColorI];
        label.font = [AppUIModel UIViewTitleFont];
        [label setTextAlignment:NSTextAlignmentLeft];
        label.text = NSLocalizedString(@"beautyStateLabel", nil);
        NSDictionary *attrs = @{NSFontAttributeName : [AppUIModel UIViewTitleFont]};
        CGSize size = [label.text sizeWithAttributes:attrs];
        [label setFrame:CGRectMake(30, 20, size.width, 30)];
        [cell.contentView addSubview:label];
        
        UIImageView *chevronRightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 42, 20, 14, 24)];
        UIImage *chevronRightImage = [UIImage imageNamed:@"grayChevronRight24"];
        chevronRightImageView.image = chevronRightImage;
        [cell.contentView addSubview:chevronRightImageView];
        
        connectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 60)];
//        connectView.backgroundColor = [UIColor redColor];
        connectView.center = CGPointMake(size.width + 80, 35);
        [cell.contentView addSubview:connectView];
        
        batteryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 60)];
//        batteryView.backgroundColor = [UIColor yellowColor];
        batteryView.center = CGPointMake(size.width + 120, 35);
        [cell.contentView addSubview:batteryView];
        
        modelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 60)];
//        modelView.backgroundColor = [UIColor blueColor];
        modelView.center = CGPointMake(size.width + 160, 35);
        [cell.contentView addSubview:modelView];
        
        connectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
        CGPoint connectImagePoint = CGPointMake(20, 30);
        connectImageView.center = connectImagePoint;
        connectImageView.image = [UIImage imageNamed:@"grayLink.png"];
        [connectView addSubview:connectImageView];
        
        batteryImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0 , 0, 18, 9)];
        CGPoint batteryImagePoint = CGPointMake(20, 30);
        batteryImageView.center = batteryImagePoint;
        batteryImageView.image = [UIImage imageNamed:@"grayfullbattery32.ong"];
        [batteryView addSubview:batteryImageView];
        
        modelImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
        CGPoint modelImagePoint = CGPointMake(20, 30);
        modelImageView.center = modelImagePoint;
        modelImageView.image = [UIImage imageNamed:@"grayStars96.png"];
        [modelView addSubview:modelImageView];
        
        connectLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        connectLabel.center = CGPointMake(20, 50);
        connectLabel.textColor = [AppUIModel UIViewNormalColor];
        connectLabel.font = [AppUIModel UIViewSmallFont];
        [connectLabel setTextAlignment:NSTextAlignmentCenter];
        [connectView addSubview:connectLabel];
        connectLabel.hidden = YES;
        
        batteryLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        batteryLabel.center = CGPointMake(20, 50);
        batteryLabel.textColor = [AppUIModel UIViewNormalColor];
        batteryLabel.font = [AppUIModel UIViewSmallFont];
        [batteryLabel setTextAlignment:NSTextAlignmentCenter];
        [batteryView addSubview:batteryLabel];
        batteryLabel.hidden = YES;
        
        modelLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        modelLabel.center = CGPointMake(20, 50);
        modelLabel.textColor = [AppUIModel UIViewNormalColor];
        modelLabel.font = [AppUIModel UIViewSmallFont];
        [modelLabel setTextAlignment:NSTextAlignmentCenter];
        [modelView addSubview:modelLabel];
        modelLabel.hidden = YES;
        
        UITapGestureRecognizer *connectTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(connectTapAction:)];
        connectTap.numberOfTapsRequired = 1;  // 单击
        connectTap.numberOfTouchesRequired = 1;   // 单个手指
        [connectView addGestureRecognizer:connectTap];
        
        UITapGestureRecognizer *batteryTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(batteryTapAction:)];
        batteryTap.numberOfTapsRequired = 1;  // 单击
        batteryTap.numberOfTouchesRequired = 1;   // 单个手指
        [batteryView addGestureRecognizer:batteryTap];
        
        UITapGestureRecognizer *modelTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(modelTapAction:)];
        modelTap.numberOfTapsRequired = 1;  // 单击
        modelTap.numberOfTouchesRequired = 1;   // 单个手指
        [modelView addGestureRecognizer:modelTap];
        
        UISwipeGestureRecognizer *leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftHandleSwipe:)];
        leftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
        [cell.contentView addGestureRecognizer:leftRecognizer];
        
        return cell;
    }
    else if (indexPath.section == 0 && indexPath.row == 2)
    {
        homeSecondCell = [HHomeSecondTableViewCell cellWithTableView:self.homeTableView];
        
        UISwipeGestureRecognizer *leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftHandleSwipe:)];
        leftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
        [homeSecondCell.contentView addGestureRecognizer:leftRecognizer];
        
        return homeSecondCell;
    }
//    else if (indexPath.section == 0 && indexPath.row == 3)
//    {
//        // 进入胶原蛋白界面
//        static NSString *identify = @"identify";
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
//        if (!cell) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
//        }
//        cell.backgroundColor = [AppUIModel UIViewBackgroundColor];
//        //不可选择cell
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        
//        UISwipeGestureRecognizer *leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftHandleSwipe:)];
//        leftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
//        [cell.contentView addGestureRecognizer:leftRecognizer];
//        
//        UIView *cv = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 110, 0, 110, 40)];
//        
//        UIImageView *dragLeftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 40, 5, 30, 30)];
//        dragLeftImageView.image = [UIImage imageNamed:@"pinkDragLeft32.png"];
//        [cell.contentView addSubview:dragLeftImageView];
//        
//        UILabel *dragLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 5, 60, 30)];
//        dragLeftLabel.text = NSLocalizedString(@"dragLeftLabel", nil);
//        dragLeftLabel.font = [AppUIModel UIViewSmallFont];
//        dragLeftLabel.textColor = [AppUIModel UIViewNormalColor];
//        [dragLeftLabel setTextAlignment:NSTextAlignmentRight];
//        [cell.contentView addSubview:dragLeftLabel];
//        
//        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(collagenTapAction:)];
//        tapGestureRecognizer.numberOfTapsRequired = 1;  // 单击
//        tapGestureRecognizer.numberOfTouchesRequired = 1;   // 单个手指
//        [cv setUserInteractionEnabled:YES];
//        [cv setMultipleTouchEnabled:YES];
//        [cv addGestureRecognizer:tapGestureRecognizer];
//        
//        [cell.contentView addSubview:cv];
//        return cell;
//        
//        // 电流强度
//        self.homeThirdCell = [HHomeThirdTableViewCell cellWithTableView:self.homeTableView];
//        return self.homeThirdCell;
//    }
    else
    {
        static NSString *identify = @"identify";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        }
        cell.backgroundColor = [AppUIModel UIViewBackgroundColor];
        //不可选择cell
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UISwipeGestureRecognizer *leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftHandleSwipe:)];
        leftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
        [cell.contentView addGestureRecognizer:leftRecognizer];
        
        return cell;
    }

    /*
     空 cell
     
     static NSString *identify = @"identify";
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
     if (!cell) {
     cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
     }
     return cell;
     */
}

// cell 点击操作
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 1) {
        
        HBannerFirstViewController *bannerFirstVC = [[HBannerFirstViewController alloc] init];
        [self.navigationController pushViewController:bannerFirstVC animated:YES];
        
    }
    
    // 取消选中效果
    [tableView cellForRowAtIndexPath:indexPath].selected = NO;
}

// row 高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        return SCREEN_HEIGHT * 0.25;
    }
    if (indexPath.section == 0 && indexPath.row == 1)
    {
        return 60;
    }
    else if (indexPath.section == 0 && indexPath.row == 2)
    {
        return 200;
    }
//    else if (indexPath.section == 0 && indexPath.row == 3)
//    {
//        return 40;
//    }
    else
    {
        if (SCREEN_HEIGHT * 0.75 - 60 - 200 - 64 - TABBAR_WIDTH <= 0) {
            return 80;
        }
        else
        {
            return  SCREEN_HEIGHT * 0.75 - 60 - 200 - 64 - TABBAR_WIDTH;
        }
    }
}

#pragma mark - tableview滑动事件
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // tableView 下位，根据偏移量计算出下位的高度
    CGFloat downHeight = -scrollView.contentOffset.y;
    // 根据下拉高度计算出 homeView 拉伸的高度
    CGRect homeViewframe = self.homeView.frame;
    homeViewframe.size.height = SCREEN_HEIGHT + downHeight;
    if (downHeight >= 64) {
        self.homeView.frame = homeViewframe;
    }
    else
    {
        self.homeView.frame = CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT + 64);
    }
}

#pragma mark - homeBottomView 点击方法
- (void)homeBottomViewAction
{
    if (!self.connectVC) {
        self.connectVC = [[HConnectViewController alloc] init];
    }
    [self presentViewController:self.connectVC animated:YES completion:nil];
    
}

- (IBAction)start:(id)sender
{
    _spinner = [[FeSpinnerTenDot alloc] initWithView:self.view withBlur:NO];
    _spinner.delegate = self;
    //    UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    //    CGPoint cp = CGPointMake(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT * 0.5 + 100);
    //    bt.center = cp;
    //    [bt setTitle:@"Stop" forState:UIControlStateNormal];
    //    //    [bt setBackgroundColor:[UIColor blueColor]];
    //    [bt.layer setMasksToBounds:YES];
    //    [bt.layer setCornerRadius:10.0];
    //    [bt setShowsTouchWhenHighlighted:YES];
    //    [bt.layer setBorderWidth:1.0];
    //    [bt.layer setBorderColor:[AppUIModel UIUselessColor].CGColor];
    //    [bt addTarget:self action:@selector(stopScanAction) forControlEvents:UIControlEventTouchUpInside];
    //    [_spinner addSubview:bt];
    [[UIApplication sharedApplication].keyWindow addSubview:_spinner];
    [_spinner showWhileExecutingSelector:@selector(longTask) onTarget:self withObject:nil completion:^{
        [self->_timer invalidate];
        self->_timer = nil;
    }];
}

- (void)longTask
{
    sleep(5);
}

//开始等待画面
- (void)startWaitingView
{
    self.navigationItem.hidesBackButton = YES;
    [self start:self];
    
//    self.tabBarController.tabBar.hidden = YES;
}

//结束等待画面
- (void)stopWaitingView
{
    [self.spinner removeFromSuperview];
    self.navigationItem.hidesBackButton = NO;
    
//    self.tabBarController.tabBar.hidden = NO;
}

// timer10s 开始计时
- (void)start10sTimer
{
    timer10s = [NSTimer timerWithTimeInterval:10.0f target:self selector:@selector(timer10sAction) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:timer10s forMode:NSDefaultRunLoopMode];
}

// timer10s 中断计时
- (void)stop10sTimer
{
    if (timer10s.isValid == YES)
    {
        [timer10s invalidate];
        timer10s = nil;
    }
}

- (void)timer10sAction
{
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"deviceIdentifier"]) {
        [ApplicationDelegate.manager stopScanPeripherals];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"deviceIdentifier"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [ApplicationDelegate.manager.discoverPeripheralsArray removeAllObjects];
        ApplicationDelegate.isQuickConnectDevice = YES;
        [self start10sTimer];
        [ApplicationDelegate.manager beginScanPeripherals];
    }
    else
    {
        [ApplicationDelegate.manager stopScanPeripherals];
        [self stopWaitingView];
        [ApplicationDelegate addDisableConnectTips];
    }
}

- (void)bannerWebName:(NSString *)str
{
    NSLog(@"%@",str);
    if ([str isEqualToString:NSLocalizedString(@"banner1", nil)])
    {
        HBannerDetailViewController *bannerDetailVC = [[HBannerDetailViewController alloc] init];
        bannerDetailVC.bannerContent = @"banner1";
        bannerDetailVC.bannerNavigationTitle = NSLocalizedString(@"banner1", nil);
        [self.navigationController pushViewController:bannerDetailVC animated:YES];
    }
    else if ([str isEqualToString:NSLocalizedString(@"banner2", nil)])
    {
        HBannerDetailViewController *bannerDetailVC = [[HBannerDetailViewController alloc] init];
        bannerDetailVC.bannerContent = @"banner2";
        bannerDetailVC.bannerNavigationTitle = NSLocalizedString(@"banner2", nil);
        [self.navigationController pushViewController:bannerDetailVC animated:YES];
    }
    else if ([str isEqualToString:NSLocalizedString(@"banner3", nil)])
    {
        HBannerDetailViewController *bannerDetailVC = [[HBannerDetailViewController alloc] init];
        bannerDetailVC.bannerContent = @"banner3";
        bannerDetailVC.bannerNavigationTitle = NSLocalizedString(@"banner3", nil);
        [self.navigationController pushViewController:bannerDetailVC animated:YES];
    }
    else if ([str isEqualToString:NSLocalizedString(@"banner4", nil)])
    {
        HBannerDetailViewController *bannerDetailVC = [[HBannerDetailViewController alloc] init];
        bannerDetailVC.bannerContent = @"banner4";
        bannerDetailVC.bannerNavigationTitle = NSLocalizedString(@"banner4", nil);
        [self.navigationController pushViewController:bannerDetailVC animated:YES];
    }
    else if ([str isEqualToString:NSLocalizedString(@"banner5", nil)])
    {
        HBannerDetailViewController *bannerDetailVC = [[HBannerDetailViewController alloc] init];
        bannerDetailVC.bannerContent = @"banner5";
        bannerDetailVC.bannerNavigationTitle = NSLocalizedString(@"banner5", nil);
        [self.navigationController pushViewController:bannerDetailVC animated:YES];
    }
    else if ([str isEqualToString:NSLocalizedString(@"banner6", nil)])
    {
        HBannerDetailViewController *bannerDetailVC = [[HBannerDetailViewController alloc] init];
        bannerDetailVC.bannerContent = @"banner6";
        bannerDetailVC.bannerNavigationTitle = NSLocalizedString(@"banner6", nil);
        [self.navigationController pushViewController:bannerDetailVC animated:YES];
    }
    else if ([str isEqualToString:NSLocalizedString(@"bannerB1", nil)])
    {
        HBannerDetailViewController *bannerDetailVC = [[HBannerDetailViewController alloc] init];
        bannerDetailVC.bannerContent = @"bannerB1";
        bannerDetailVC.bannerNavigationTitle = NSLocalizedString(@"bannerB1", nil);
        [self.navigationController pushViewController:bannerDetailVC animated:YES];
    }
    else if ([str isEqualToString:NSLocalizedString(@"bannerB2", nil)])
    {
        HBannerDetailViewController *bannerDetailVC = [[HBannerDetailViewController alloc] init];
        bannerDetailVC.bannerContent = @"bannerB2";
        bannerDetailVC.bannerNavigationTitle = NSLocalizedString(@"bannerB2", nil);
        [self.navigationController pushViewController:bannerDetailVC animated:YES];
    }
    else if ([str isEqualToString:NSLocalizedString(@"bannerB3", nil)])
    {
        HBannerDetailViewController *bannerDetailVC = [[HBannerDetailViewController alloc] init];
        bannerDetailVC.bannerContent = @"bannerB3";
        bannerDetailVC.bannerNavigationTitle = NSLocalizedString(@"bannerB3", nil);
        [self.navigationController pushViewController:bannerDetailVC animated:YES];
    }
    else if ([str isEqualToString:NSLocalizedString(@"bannerB4", nil)])
    {
        HBannerDetailViewController *bannerDetailVC = [[HBannerDetailViewController alloc] init];
        bannerDetailVC.bannerContent = @"bannerB4";
        bannerDetailVC.bannerNavigationTitle = NSLocalizedString(@"bannerB4", nil);
        [self.navigationController pushViewController:bannerDetailVC animated:YES];
    }
    else if ([str isEqualToString:NSLocalizedString(@"bannerFirst", nil)])
    {
        HBannerFirstViewController *bannerFirstVC = [[HBannerFirstViewController alloc] init];
        [self.navigationController pushViewController:bannerFirstVC animated:YES];
    }
}

// 通知操作
- (void)R0506NotificationAction
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//        if ((int)self.homeFirstCell.imagesArray.count < 5) {
//            [self.homeFirstCell.bannerView removeFromSuperview];
//            [self.homeFirstCell addBannerImageView];
//        }
        
        ApplicationDelegate.setElectricityPercent = (float)ApplicationDelegate.nowElectricity / (float)ApplicationDelegate.maxElectricity;
        NSNotification *notification = [NSNotification notificationWithName:@"changeProgressViewNotification" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
        NSLog(@"0506 array %@",ApplicationDelegate.electricityArray);
        [self->homeSecondCell changeChart];
        if ([[ApplicationDelegate.electricityArray lastObject] intValue] <= 5) {
            NSData* data = [ApplicationDelegate.manager.dataProcessor encription:"S0501\r\n"];
            NSLog(@"data base - %@",data);
            [ApplicationDelegate.manager writeWithoutResponceToSelectedCharacteristicWithData:data];
        }
        ApplicationDelegate.isUseSetModelID = NO;
    }];
}
//- (void)R0507NotificationAction
//{
//    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//        [self.homeThirdCell.progressView setProgress:(float)ApplicationDelegate.nowElectricity / (float)ApplicationDelegate.maxElectricity];
//    }];
//}
- (void)R0101IdleNotificationAction
{
//    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//        if ((int)self.homeFirstCell.imagesArray.count > 4) {
//            [self.homeFirstCell.bannerView removeFromSuperview];
//            [self.homeFirstCell cancelBannerImageView];
//        }
//    }];
}
- (void)R0101StopNotificationAction
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        ApplicationDelegate.isShake = YES;
        [self shakeAction];
        
        self.stopAC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"homePrompt", nil) message:NSLocalizedString(@"homePromptDetail1", nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *middle = [UIAlertAction actionWithTitle:NSLocalizedString(@"homeConfirm", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // 确认
            ApplicationDelegate.isShake = NO;
            ApplicationDelegate.setModelID = 0;
            ApplicationDelegate.isCheckProtocol = YES;
//            if ((int)self.homeFirstCell.imagesArray.count > 4) {
//                [self.homeFirstCell.bannerView removeFromSuperview];
//                [self.homeFirstCell cancelBannerImageView];
//            }
            ApplicationDelegate.isAbleSetModelID = YES;
            ApplicationDelegate.modelID = 0;
            [self R0508DifferentNotificationAction];
        }];
        [self.stopAC addAction:middle];
        [self presentViewController:self.stopAC animated:YES completion:nil];
    }];
}
- (void)R0501Notification1Action
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if (ApplicationDelegate.isConnectDevice) {
            self.R0501Notification1AC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"homePrompt", nil) message:NSLocalizedString(@"homePromptDetail2", nil) preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *middle = [UIAlertAction actionWithTitle:NSLocalizedString(@"homeConfirm", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                // 确认
            }];
            [self.R0501Notification1AC addAction:middle];
            [self presentViewController:self.R0501Notification1AC animated:YES completion:nil];
        }
    }];
}
- (void)R0501Notification2Action
{
    self.R0501Notification2AC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"homePrompt", nil) message:NSLocalizedString(@"homePromptDetail3", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *middle = [UIAlertAction actionWithTitle:NSLocalizedString(@"homeConfirm", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 确认
    }];
    [self.R0501Notification2AC addAction:middle];
    [self presentViewController:self.R0501Notification2AC animated:YES completion:nil];
}
- (void)R0508DifferentNotificationAction
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if (ApplicationDelegate.modelID == 0)
        {
            self->modelImageView.image = [UIImage imageNamed:@"grayStars96.png"];
        }
        else if (ApplicationDelegate.modelID == 1)
        {
            self->modelImageView.image = [UIImage imageNamed:@"greenStars96.png"];
        }
        else if (ApplicationDelegate.modelID == 2)
        {
            self->modelImageView.image = [UIImage imageNamed:@"orangeStars96.png"];
        }
        else if (ApplicationDelegate.modelID == 3)
        {
            self->modelImageView.image = [UIImage imageNamed:@"blueStars96.png"];
        }
    }];
}
- (void)BatteryNotificationAction
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self changeBatteryImage];
        
        if (ApplicationDelegate.battery <= 5 && ApplicationDelegate.isConnectDevice == YES) {
            self.BatteryNotificationAC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"homePrompt", nil) message:NSLocalizedString(@"homePromptDetail3", nil) preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *middle = [UIAlertAction actionWithTitle:NSLocalizedString(@"homeConfirm", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                // 确认
            }];
            [self.BatteryNotificationAC addAction:middle];
            [self presentViewController:self.BatteryNotificationAC animated:YES completion:nil];
        }
    }];
}

- (void)R1007NotificationAction
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if (!ApplicationDelegate.isReplace) {
            self.R1007AC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"connectPrompt", nil) message:NSLocalizedString(@"connectPromptDetail1", nil) preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *left = [UIAlertAction actionWithTitle:NSLocalizedString(@"connectNext", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                // 下一个
                NSLog(@"1007 下一个 R");
                [ApplicationDelegate.manager stopScanPeripherals];
                NSData* data = [ApplicationDelegate.manager.dataProcessor encription:"S1008\r\n"];
                NSLog(@"data base - %@",data);
                [ApplicationDelegate.manager writeWithoutResponceToSelectedCharacteristicWithData:data];
                [self startWaitingView];
            }];
            UIAlertAction *right = [UIAlertAction actionWithTitle:NSLocalizedString(@"connectConfirm", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                // 确认
                NSLog(@"1007 确认 R");
                [ApplicationDelegate.manager stopScanPeripherals];
                NSLog(@"ApplicationDelegate.manager.selectedDeviceIdentifier - %@", ApplicationDelegate.manager.selectedDeviceIdentifier);
                [[NSUserDefaults standardUserDefaults] setObject:ApplicationDelegate.manager.selectedDeviceIdentifier forKey:@"deviceIdentifier"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                NSLog(@"defaults C - %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"deviceIdentifier"]);
                
                NSData* data = [ApplicationDelegate.manager.dataProcessor encription:"S1008\r\n"];
                NSLog(@"data base - %@",data);
                [ApplicationDelegate.manager writeWithoutResponceToSelectedCharacteristicWithData:data];
            }];
            [self.R1007AC addAction:left];
            [self.R1007AC addAction:right];
            [self presentViewController:self.R1007AC animated:YES completion:nil];
        }
    }];
}

- (void)R1008NotificationAction
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if (!ApplicationDelegate.isReplace) {
            if ([[NSUserDefaults standardUserDefaults] valueForKey:@"deviceIdentifier"]) {
                ApplicationDelegate.isOnceConnectDevice = YES;
                [self isOnceConnectDevice];
                [MBProgressHUD showSuccess:NSLocalizedString(@"connectConnectPrompt", nil)];
                // 发送 S0105 获取产品ID
                NSData* data = [ApplicationDelegate.manager.dataProcessor encription:"S0105\r\n"];
                NSLog(@"data base - %@",data);
                [ApplicationDelegate.manager writeWithoutResponceToSelectedCharacteristicWithData:data];
            }
            else
            {
                [ApplicationDelegate.manager disconnectSelectedPeripheral];
                
                [ApplicationDelegate.manager.discoverPeripheralsArray removeObjectAtIndex:0];
                NSLog(@"剩余的可连接设备 - %@",ApplicationDelegate.manager.discoverPeripheralsArray);
                if (ApplicationDelegate.manager.discoverPeripheralsArray.count == 0)
                {
                    self.nomoreDeviceAC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"connectPrompt", nil) message:NSLocalizedString(@"connectPromptDetail2", nil) preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *middle = [UIAlertAction actionWithTitle:NSLocalizedString(@"connectConfirm", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        ApplicationDelegate.isQuickConnectDevice = YES;
                    }];
                    [self.nomoreDeviceAC addAction:middle];
                    [self presentViewController:self.nomoreDeviceAC animated:YES completion:nil];
                    [self stopWaitingView];
                }
                else
                {
                    ApplicationDelegate.selectedPeripheral = [[ApplicationDelegate.manager.discoverPeripheralsArray firstObject] valueForKey:@"peripheral"];
                    [ApplicationDelegate.manager connectSelectedPeripheral];
                }
            }
        }
    }];
}

- (void)connectDeviceH
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if (!ApplicationDelegate.isReplace) {
            NSLog(@"连接设备传过来了C");
            [self stop10sTimer];
            [self stopWaitingView];
            
            if (![[NSUserDefaults standardUserDefaults] valueForKey:@"deviceIdentifier"])
            {
                ApplicationDelegate.manager.selectedDeviceIdentifier = ApplicationDelegate.selectedPeripheral.identifier.UUIDString;
                NSData* data = [ApplicationDelegate.manager.dataProcessor encription:"S1007\r\n"];
                NSLog(@"data base - %@",data);
                [ApplicationDelegate.manager writeWithoutResponceToSelectedCharacteristicWithData:data];
            }
            else
            {
                [ApplicationDelegate.manager stopScanPeripherals];
                ApplicationDelegate.isOnceConnectDevice = YES;
                [self isOnceConnectDevice];
                [MBProgressHUD showSuccess:NSLocalizedString(@"connectConnectPrompt", nil)];
                // 发送 S0105 获取产品ID
                NSData* data = [ApplicationDelegate.manager.dataProcessor encription:"S0105\r\n"];
                NSLog(@"data base - %@",data);
                [ApplicationDelegate.manager writeWithoutResponceToSelectedCharacteristicWithData:data];
            }
        }
    }];
}

- (void) disconnectDeviceAction
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self changeBatteryImage];
//        modelImageView.image = [UIImage imageNamed:@"grayStars96.png"];
        ApplicationDelegate.modelID = 0;
        [self R0508DifferentNotificationAction];
    }];
}

- (void)shakeAction
{
    if (ApplicationDelegate.isShake == YES) {
        AudioServicesPlaySystemSoundWithCompletion(kSystemSoundID_Vibrate, ^{
            [self shakeAction];
        });
    }
}

- (void)changeBatteryImage
{
    if (ApplicationDelegate.isConnectDevice) {
        if (ApplicationDelegate.battery >= 0 && ApplicationDelegate.battery <= 5 ) {
            batteryImageView.image = [UIImage imageNamed:@"redemptybattery32.ong"];
        }
        else if (ApplicationDelegate.battery > 5 && ApplicationDelegate.battery <= 20)
        {
            batteryImageView.image = [UIImage imageNamed:@"redonebattery32.ong"];
        }
        else if (ApplicationDelegate.battery > 20 && ApplicationDelegate.battery <= 40)
        {
            batteryImageView.image = [UIImage imageNamed:@"yellowhalfbattery32.ong"];
        }
        else if (ApplicationDelegate.battery > 40 && ApplicationDelegate.battery <= 90)
        {
            batteryImageView.image = [UIImage imageNamed:@"greenthreebattery32.ong"];
        }
        else if (ApplicationDelegate.battery > 90 && ApplicationDelegate.battery <= 100)
        {
            batteryImageView.image = [UIImage imageNamed:@"greenfullbattery32.ong"];
        }
        else{
            batteryImageView.image = nil;
        }
        [self changeConnectImage];
    }
    else
    {
        if (ApplicationDelegate.battery >= 0 && ApplicationDelegate.battery <= 5 ) {
            batteryImageView.image = [UIImage imageNamed:@"grayemptybattery32.ong"];
        }
        else if (ApplicationDelegate.battery > 5 && ApplicationDelegate.battery <= 20)
        {
            batteryImageView.image = [UIImage imageNamed:@"grayonebattery32.ong"];
        }
        else if (ApplicationDelegate.battery > 20 && ApplicationDelegate.battery <= 40)
        {
            batteryImageView.image = [UIImage imageNamed:@"grayhalfbattery32.ong"];
        }
        else if (ApplicationDelegate.battery > 40 && ApplicationDelegate.battery <= 90)
        {
            batteryImageView.image = [UIImage imageNamed:@"graythreebattery32.ong"];
        }
        else if (ApplicationDelegate.battery > 90 && ApplicationDelegate.battery <= 100)
        {
            batteryImageView.image = [UIImage imageNamed:@"grayfullbattery32.ong"];
        }
        else{
            batteryImageView.image = nil;
        }
        [self changeConnectImage];
    }
}

- (void)changeConnectImage
{
    if (ApplicationDelegate.isConnectDevice) {
        connectImageView.image = [UIImage imageNamed:@"pinkLink128.png"];
    }
    else
    {
        connectImageView.image = [UIImage imageNamed:@"grayLink.png"];
    }
}

// connect 点击事件
-(void)connectTapAction:(UITapGestureRecognizer *)tapGestureRecognizer
{
    if (isConnectInAction) {
        ;
    }
    else
    {
        NSLog(@"connect");
        connectLabel.hidden = NO;
        batteryLabel.hidden = YES;
        modelLabel.hidden = YES;
        
        isConnectInAction = YES;
        
        //    [batteryLabel removeFromSuperview];
        //    [modelLabel removeFromSuperview];
        
        connectLabel.alpha = 0;
        
        if (ApplicationDelegate.isConnectDevice)
        {
            connectLabel.text = NSLocalizedString(@"honeConnectLabel1", nil);
        }
        else
        {
            connectLabel.text = NSLocalizedString(@"honeConnectLabel2", nil);
        }
        
        [UIView animateWithDuration:1.5 animations:^{
            self->connectLabel.alpha = 1;
        } completion:^(BOOL finished) {
            self->connectLabel.alpha = 1;
            [UIView animateWithDuration:2.0 animations:^{
                self->connectLabel.alpha = 1;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:1.5 animations:^{
                    self->connectLabel.alpha = 0;
                } completion:^(BOOL finished) {
                    NSLog(@"变换图片结束");
                    self->connectLabel.hidden = YES;
                    self->isConnectInAction = NO;
                }];
            }];
        }];
    }
}

// battery 点击事件
-(void)batteryTapAction:(UITapGestureRecognizer *)tapGestureRecognizer
{
    if (isBatteryInAction) {
        ;
    }
    else
    {
        NSLog(@"battery");
        connectLabel.hidden = YES;
        batteryLabel.hidden = NO;
        modelLabel.hidden = YES;
        
        isBatteryInAction = YES;
        
        //    [connectLabel removeFromSuperview];
        //    [modelLabel removeFromSuperview];
        
        batteryLabel.alpha = 0;
        
        if (ApplicationDelegate.isConnectDevice) {
            batteryLabel.text = [[NSString stringWithFormat:@"%d",ApplicationDelegate.battery] stringByAppendingString:@"%"];
        }
        else
        {
            batteryLabel.text = NSLocalizedString(@"honeConnectLabel2", nil);
        }
        
        [UIView animateWithDuration:1.5 animations:^{
            self->batteryLabel.alpha = 1;
        } completion:^(BOOL finished) {
            self->batteryLabel.alpha = 1;
            [UIView animateWithDuration:2.0 animations:^{
                self->batteryLabel.alpha = 1;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:1.5 animations:^{
                    self->batteryLabel.alpha = 0;
                } completion:^(BOOL finished) {
                    NSLog(@"变换图片结束");
                    self->batteryLabel.hidden = YES;
                    self->isBatteryInAction = NO;
                }];
            }];
        }];
    }
}

// model 点击事件
-(void)modelTapAction:(UITapGestureRecognizer *)tapGestureRecognizer
{
    if (isModelInAction) {
        ;
    }
    else
    {
        NSLog(@"model");
        connectLabel.hidden = YES;
        batteryLabel.hidden = YES;
        modelLabel.hidden = NO;
        
        isModelInAction = YES;
        
        //    [connectLabel removeFromSuperview];
        //    [batteryLabel removeFromSuperview];
        
        modelLabel.alpha = 0;
        
        if (ApplicationDelegate.isUseSetModelID) {
            if (ApplicationDelegate.setModelID == 0)
            {
                modelLabel.text = NSLocalizedString(@"honeModelLabel0", nil);
            }
            else if (ApplicationDelegate.setModelID == 1)
            {
                modelLabel.text = NSLocalizedString(@"honeModelLabel1", nil);
            }
            else if (ApplicationDelegate.setModelID == 2)
            {
                modelLabel.text = NSLocalizedString(@"honeModelLabel2", nil);
            }
            else if (ApplicationDelegate.setModelID == 3)
            {
                modelLabel.text = NSLocalizedString(@"honeModelLabel3", nil);
            }
        }
        else
        {
            if (ApplicationDelegate.modelID == 0)
            {
                modelLabel.text = NSLocalizedString(@"honeModelLabel0", nil);
            }
            else if (ApplicationDelegate.modelID == 1)
            {
                modelLabel.text = NSLocalizedString(@"honeModelLabel1", nil);
            }
            else if (ApplicationDelegate.modelID == 2)
            {
                modelLabel.text = NSLocalizedString(@"honeModelLabel2", nil);
            }
            else if (ApplicationDelegate.modelID == 3)
            {
                modelLabel.text = NSLocalizedString(@"honeModelLabel3", nil);
            }
        }
        
        [UIView animateWithDuration:1.5 animations:^{
            self->modelLabel.alpha = 1;
        } completion:^(BOOL finished) {
            self->modelLabel.alpha = 1;
            [UIView animateWithDuration:2.0 animations:^{
                self->modelLabel.alpha = 1;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:1.5 animations:^{
                    self->modelLabel.alpha = 0;
                } completion:^(BOOL finished) {
                    NSLog(@"变换图片结束");
                    self->modelLabel.hidden = YES;
                    self->isModelInAction = NO;
                }];
            }];
        }];
    }
}

// 胶原蛋白cell 点击事件
-(void)collagenTapAction:(UITapGestureRecognizer *)tapGestureRecognizer
{
    HBannerFirstViewController *bannerFirstVC = [[HBannerFirstViewController alloc] init];
    [self.navigationController pushViewController:bannerFirstVC animated:YES];
}

// 左滑事件
- (void)leftHandleSwipe:(UISwipeGestureRecognizer *)recognizer
{
    HBannerFirstViewController *bannerFirstVC = [[HBannerFirstViewController alloc] init];
    [self.navigationController pushViewController:bannerFirstVC animated:YES];
}

#pragma mark - 页面将要打开
- (void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
    
    if (ApplicationDelegate.isUseSetModelID) {
        if (ApplicationDelegate.setModelID == 0)
        {
            modelImageView.image = [UIImage imageNamed:@"grayStars96.png"];
        }
        else if (ApplicationDelegate.setModelID == 1)
        {
            modelImageView.image = [UIImage imageNamed:@"greenStars96.png"];
        }
        else if (ApplicationDelegate.setModelID == 2)
        {
            modelImageView.image = [UIImage imageNamed:@"orangeStars96.png"];
        }
        else if (ApplicationDelegate.setModelID == 3)
        {
            modelImageView.image = [UIImage imageNamed:@"blueStars96.png"];
        }
    }
    else
    {
        if (ApplicationDelegate.modelID == 0)
        {
            modelImageView.image = [UIImage imageNamed:@"grayStars96.png"];
        }
        else if (ApplicationDelegate.modelID == 1)
        {
            modelImageView.image = [UIImage imageNamed:@"greenStars96.png"];
        }
        else if (ApplicationDelegate.modelID == 2)
        {
            modelImageView.image = [UIImage imageNamed:@"orangeStars96.png"];
        }
        else if (ApplicationDelegate.modelID == 3)
        {
            modelImageView.image = [UIImage imageNamed:@"blueStars96.png"];
        }
    }
}

- (void)isOnceConnectDevice
{
    if (ApplicationDelegate.isOnceConnectDevice == YES)
    {
        self.homeGainButton.userInteractionEnabled = NO;
        self.homeGainButton.backgroundColor = [AppUIModel UIUselessColor];
    }
    else
    {
        self.homeGainButton.userInteractionEnabled = YES;
        self.homeGainButton.backgroundColor = [AppUIModel UIViewMainColorI];
        
        
        NSNotification *notification = [NSNotification notificationWithName:@"isOnceConnectNotification" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
