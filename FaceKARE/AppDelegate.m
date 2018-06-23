//
//  AppDelegate.m
//  FaceKARE
//
//  Created by Anan on 2017/4/25.
//  Copyright © 2017年 Anan. All rights reserved.
//

#import "AppDelegate.h"
#import "AppUIModel.h"
#import "HHomeViewController.h"
#import "HInformationViewController.h"
#import "HPicturesViewController.h"
#import "HSettingViewController.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

@interface AppDelegate ()<UIScrollViewDelegate>
{
    NSTimer *timer60s;
    
    // bigImageView
    UIImageView *bigImageView;
    CGRect oldFrame;
    CGRect largeFrame;
    
    // topPicturesScrollView
    UIScrollView *topPicturesScrollView;
    UIImageView *topImageView;
    CGFloat topImageViewWidth;
    CGFloat topImageViewHeight;
    
    CGFloat setTopImageViewWidth;
    CGFloat setTopImageViewHeight;
    
    CGRect topOldFrame;
    CGRect topLargeFrame;
    
    // bottomPicturesScrollView
    UIScrollView *bottomPicturesScrollView;
    UIImageView *bottomImageView;
    CGFloat bottomImageViewWidth;
    CGFloat bottomImageViewHeight;
    
    CGFloat setBottomImageViewWidth;
    CGFloat setBottomImageViewHeight;
    
    CGRect bottomOldFrame;
    CGRect bottomLargeFrame;
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [NSThread sleepForTimeInterval:3.0];
    
    //手机屏幕在打开App的时候持续亮屏（不熄屏）
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    // 设置接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disconnectDeviceAction) name:@"disconnectNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(R0106Action) name:@"R0106Notification" object:nil];
    
    // 创建窗口
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [AppUIModel UIViewBackgroundColor];
    [self.window makeKeyAndVisible];
    
    // 进入视图
    [self EnterHomeView];
    
    // 创建蓝牙
    self.manager = [[HBLECenterManager alloc] init];
    
    // 初始化数据
    self.isNeedTransform = YES;
    self.isQuickConnectDevice = YES;
    self.isConnectDevice = NO;
    self.isOnceConnectDevice = NO;
    self.angle = CGAffineTransformMakeRotation(0);
    self.deviceIDString = @"-";
    self.firmwareString = @"-";
    self.isWorking = NO;
    self.modelID = 0;
    self.subjectID = 0;
    self.maxElectricity = 100;
    self.nowElectricity = 0;
    self.electricityArray = [[NSMutableArray alloc] init];
    self.collagenArray = [[NSMutableArray alloc] init];
    self.isCheckProtocol = NO;
    self.isShake = NO;
    self.selectedPicturesArray = [[NSMutableArray alloc] init];
    self.setModelID = 0;
    self.isUseSetModelID = NO;
    self.isAbleSetModelID = YES;
    self.setElectricityPercent = 0;
    
    
    [self createMaskView];
    
    // 获取 plist 数据
    [self getSettingPlist];
    [self getInformationPlist];
    [self getPicturePlist];
    [self getFAQListPlist];
    
    return YES;
}

- (void)EnterHomeView
{
    // 设置状态栏为白色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    // 创建并初始化 UITabBarController
    UITabBarController *mainTabBarController = [[UITabBarController alloc] init];
    self.window.rootViewController = mainTabBarController;
    
    // 初始化 3 个视图控制器
    HHomeViewController *homeVC = [[HHomeViewController alloc] init];
    HInformationViewController *informationVC = [[HInformationViewController alloc] init];
    HPicturesViewController *picturesVC = [[HPicturesViewController alloc] init];
    HSettingViewController *settingVC = [[HSettingViewController alloc] init];
    
    // 为 3 个视图控制器添加导航栏控制器
    UINavigationController *navHome = [[UINavigationController alloc] initWithRootViewController:homeVC];
    UINavigationController *navInformation = [[UINavigationController alloc] initWithRootViewController:informationVC];
    UINavigationController *navPictures = [[UINavigationController alloc] initWithRootViewController:picturesVC];
    UINavigationController *navSetting = [[UINavigationController alloc] initWithRootViewController:settingVC];
    
    NSArray *controllerArr = [NSArray arrayWithObjects:navHome, navInformation, navPictures, navSetting, nil];
    
    // 将数组传输给 UITabBarController
    mainTabBarController.viewControllers = controllerArr;
    
    // 设置标题
    navHome.title = NSLocalizedString(@"tabbarHome", nil);
    navInformation.title = NSLocalizedString(@"tabbarInformation", nil);
    navPictures.title = NSLocalizedString(@"tabbarPictures", nil);
    navSetting.title = NSLocalizedString(@"tabbarSetting", nil);
    
    // 设置图片
    navHome.tabBarItem.image = [UIImage imageNamed:@"home16"];
    navInformation.tabBarItem.image = [UIImage imageNamed:@"list16"];
    navPictures.tabBarItem.image = [UIImage imageNamed:@"heart16"];
    navSetting.tabBarItem.image = [UIImage imageNamed:@"cogs16"];
    mainTabBarController.tabBar.tintColor = [AppUIModel UIViewMainColorI];
    
    //设置Home的navigation
    navHome.navigationBar.translucent = YES;
    UIColor *color = [UIColor clearColor];
    CGRect rect = CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, 64);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [navHome.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    navHome.navigationBar.clipsToBounds = YES;
    
    //设置Information的navigation
    navInformation.navigationBar.translucent = YES;
    UIGraphicsBeginImageContext(rect.size);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIGraphicsEndImageContext();
    [navInformation.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    navInformation.navigationBar.clipsToBounds = YES;
    
    //设置Picture的navigation
    navPictures.navigationBar.translucent = YES;
    UIGraphicsBeginImageContext(rect.size);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIGraphicsEndImageContext();
    [navPictures.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    navPictures.navigationBar.clipsToBounds = YES;
    
    //设置Setting的navigation
    navSetting.navigationBar.translucent = YES;
    UIGraphicsBeginImageContext(rect.size);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIGraphicsEndImageContext();
    [navSetting.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    navSetting.navigationBar.clipsToBounds = YES;
}

// 通知操作
- (void)disconnectDeviceAction
{
    NSLog(@"我知道断开连接了");
//    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"deviceIdentifier"]) {
//        [self.manager beginScanPeripherals];
//    }
    [self stop60sTimer];
}
- (void)R0106Action
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        NSLog(@"收到R0106通知");
        self.isConnectDevice = YES;
        if (self->timer60s.isValid == YES) {
            [self->timer60s invalidate];
        }
        self->timer60s = nil;
        [self start60sTimer];
    }];
}

// timer60s 开始计时
- (void)start60sTimer
{
    [self timer60sAction];
    timer60s = [NSTimer timerWithTimeInterval:60.0f target:self selector:@selector(timer60sAction) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer60s forMode:NSDefaultRunLoopMode];
}

// timer60s 中断计时
- (void)stop60sTimer
{
    if (timer60s.isValid == YES) {
        [timer60s invalidate];
    }
    timer60s = nil;
}

- (void)timer60sAction
{
    ApplicationDelegate.isAbleSetModelID = NO;
    // 发送 S0101 获取设备运行状态
    NSData* data = [self.manager.dataProcessor encription:"S0101\r\n"];
    NSLog(@"data base - %@",data);
    [self.manager writeWithoutResponceToSelectedCharacteristicWithData:data];
}

#pragma mark -创建阴影
- (void)createMaskView
{
    self.maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    [self.window addSubview:self.maskView];
    self.maskView.hidden = YES;
    UITapGestureRecognizer *TapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteMaskView)];
    [TapGestureRecognizer setNumberOfTapsRequired:1];
    [self.maskView addGestureRecognizer:TapGestureRecognizer];
    
//    [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
//    [self.maskView bringSubviewToFront:self.window];
}

#pragma mark -阴影消失事件
- (void)deleteMaskView
{
    for(UIView *view in [self.maskView subviews])
    {
        [view removeFromSuperview];
    }
    self.maskView.hidden = YES;
}

- (void)addDisableConnectTips
{
    UILabel *tipLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(30, 94, SCREEN_WIDTH - 60, 30)];
    tipLabel1.textColor = [UIColor whiteColor];
    tipLabel1.font = [UIFont boldSystemFontOfSize:20];
    tipLabel1.text = NSLocalizedString(@"disableConnectTip", nil);
    tipLabel1.numberOfLines = 0;
    CGSize tipLabel1size = [tipLabel1 sizeThatFits:CGSizeMake(SCREEN_WIDTH - 60, MAXFLOAT)];
    CGRect tipLabel1Frame = tipLabel1.frame;
    tipLabel1Frame.size.height = tipLabel1size.height;
    [tipLabel1 setFrame:tipLabel1Frame];
    [self.maskView addSubview:tipLabel1];
    
    UILabel *tipLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(30, 114 + tipLabel1size.height, SCREEN_WIDTH - 60, 30)];
    tipLabel2.textColor = [UIColor whiteColor];
    tipLabel2.font = [UIFont boldSystemFontOfSize:20];
    tipLabel2.text = NSLocalizedString(@"disableConnectTip1", nil);
    tipLabel2.numberOfLines = 0;
    CGSize tipLabel2size = [tipLabel2 sizeThatFits:CGSizeMake(SCREEN_WIDTH - 60, MAXFLOAT)];
    CGRect tipLabel2Frame = tipLabel2.frame;
    tipLabel2Frame.size.height = tipLabel2size.height;
    [tipLabel2 setFrame:tipLabel2Frame];
    [self.maskView addSubview:tipLabel2];
    
    UILabel *tipLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(30, 134 + tipLabel1size.height + tipLabel2size.height, SCREEN_WIDTH - 60, 30)];
    tipLabel3.textColor = [UIColor whiteColor];
    tipLabel3.font = [UIFont boldSystemFontOfSize:20];
    tipLabel3.text = NSLocalizedString(@"disableConnectTip2", nil);
    tipLabel3.numberOfLines = 0;
    CGSize tipLabel3size = [tipLabel3 sizeThatFits:CGSizeMake(SCREEN_WIDTH - 60, MAXFLOAT)];
    CGRect tipLabel3Frame = tipLabel3.frame;
    tipLabel3Frame.size.height = tipLabel3size.height;
    [tipLabel3 setFrame:tipLabel3Frame];
    [self.maskView addSubview:tipLabel3];
    
    self.maskView.hidden = NO;
}

- (void)addChartTips
{
    //green
    UIView *greenView = [[UIView alloc] initWithFrame:CGRectMake(10, 11, 16, 16)];
    greenView.backgroundColor = [AppUIModel UIViewGreenColor];
    [greenView.layer setMasksToBounds:YES];
    [greenView.layer setCornerRadius:4.0];
    UILabel *greenLabel = [[UILabel alloc] initWithFrame:CGRectMake(36, 10, 0.8 * SCREEN_WIDTH - 46, 30)];
    greenLabel.backgroundColor = [AppUIModel UIViewBackgroundColor];
    greenLabel.textColor = [AppUIModel UIViewNormalColor];
    greenLabel.font = [AppUIModel UIViewNormalFont];
    greenLabel.text = NSLocalizedString(@"chartGreenTip", nil);
    greenLabel.numberOfLines = 0;
    CGSize greenLabelsize = [greenLabel sizeThatFits:CGSizeMake(0.8 * SCREEN_WIDTH - 46, MAXFLOAT)];
    CGRect greenLabelframe = greenLabel.frame;
    greenLabelframe.size.height = greenLabelsize.height;
    [greenLabel setFrame:greenLabelframe];
    
    //yellow
    UIView *yellowView = [[UIView alloc] initWithFrame:CGRectMake(10, 22 + greenLabelsize.height, 16, 16)];
    yellowView.backgroundColor = [AppUIModel UIViewYellowColor];
    [yellowView.layer setMasksToBounds:YES];
    [yellowView.layer setCornerRadius:4.0];
    UILabel *yellowLabel = [[UILabel alloc] initWithFrame:CGRectMake(36, 20 + greenLabelsize.height, 0.8 * SCREEN_WIDTH - 46, 30)];
    yellowLabel.backgroundColor = [AppUIModel UIViewBackgroundColor];
    yellowLabel.textColor = [AppUIModel UIViewNormalColor];
    yellowLabel.font = [AppUIModel UIViewNormalFont];
    yellowLabel.text = NSLocalizedString(@"chartYellowTip", nil);;
    yellowLabel.numberOfLines = 0;
    CGSize yellowLabellsize = [yellowLabel sizeThatFits:CGSizeMake(0.8 * SCREEN_WIDTH - 46, MAXFLOAT)];
    CGRect yellowLabelframe = yellowLabel.frame;
    yellowLabelframe.size.height = yellowLabellsize.height;
    [yellowLabel setFrame:yellowLabelframe];
    
    //red
    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(10, 33 + greenLabelsize.height + yellowLabellsize.height, 16, 16)];
    redView.backgroundColor = [AppUIModel UIViewRedColor];
    [redView.layer setMasksToBounds:YES];
    [redView.layer setCornerRadius:4.0];
    UILabel *redLabel = [[UILabel alloc] initWithFrame:CGRectMake(36, 30 + greenLabelsize.height + yellowLabellsize.height, 0.8 * SCREEN_WIDTH - 46, 30)];
    redLabel.backgroundColor = [AppUIModel UIViewBackgroundColor];
    redLabel.textColor = [AppUIModel UIViewNormalColor];
    redLabel.font = [AppUIModel UIViewNormalFont];
    redLabel.text = NSLocalizedString(@"chartRedTip", nil);;
    redLabel.numberOfLines = 0;
    CGSize redLabelllsize = [redLabel sizeThatFits:CGSizeMake(0.8 * SCREEN_WIDTH - 46, MAXFLOAT)];
    CGRect redLabellframe = redLabel.frame;
    redLabellframe.size.height = redLabelllsize.height;
    [redLabel setFrame:redLabellframe];
    
    UIView *tipsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.8 * SCREEN_WIDTH, 40 + greenLabelsize.height + yellowLabellsize.height + redLabelllsize.height)];
    CGPoint tipsViewPoint = CGPointMake(0.5 * SCREEN_WIDTH, 0.5 * SCREEN_HEIGHT);
    tipsView.center = tipsViewPoint;
    tipsView.backgroundColor = [AppUIModel UIViewBackgroundColor];
    [tipsView.layer setMasksToBounds:YES];
    [tipsView.layer setCornerRadius:10.0];
    
    [tipsView addSubview:greenView];
    [tipsView addSubview:greenLabel];
    [tipsView addSubview:yellowView];
    [tipsView addSubview:yellowLabel];
    [tipsView addSubview:redView];
    [tipsView addSubview:redLabel];
    
    [self.maskView addSubview:tipsView];
    
    self.maskView.hidden = NO;
}

- (void)addBigPicture:(NSIndexPath *)indexPath
{
//    UIImage *image = [[UIImage alloc] initWithContentsOfFile:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[[ApplicationDelegate.picturesArray objectAtIndex:indexPath.row] valueForKey:@"Name"]]]; 改为👇
    if (indexPath.section == 0) {
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[[ApplicationDelegate.eyelidsPicturesArray objectAtIndex:indexPath.row] valueForKey:@"Name"]]];
        bigImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * image.size.height / image.size.width)];
        bigImageView.center = CGPointMake(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT * 0.5);
        bigImageView.image = image;
    }
    else if (indexPath.section == 1)
    {
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[[ApplicationDelegate.blemishPicturesArray objectAtIndex:indexPath.row] valueForKey:@"Name"]]];
        bigImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * image.size.height / image.size.width)];
        bigImageView.center = CGPointMake(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT * 0.5);
        bigImageView.image = image;
    }
    else if (indexPath.section == 2)
    {
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[[ApplicationDelegate.firmingPicturesArray objectAtIndex:indexPath.row] valueForKey:@"Name"]]];
        bigImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * image.size.height / image.size.width)];
        bigImageView.center = CGPointMake(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT * 0.5);
        bigImageView.image = image;
    }
    
    // 缩放手势
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    [bigImageView addGestureRecognizer:pinchGestureRecognizer];
    // 移动手势
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [bigImageView addGestureRecognizer:panGestureRecognizer];
    // 用户可以操作图片
    [bigImageView setUserInteractionEnabled:YES];
    [bigImageView setMultipleTouchEnabled:YES];
    oldFrame = bigImageView.frame;
    
    [self.maskView addSubview:bigImageView];
    
    self.maskView.hidden = NO;
}

- (void)addComparePictures
{
    // topPicturesScrollView
    topPicturesScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(20, 20, SCREEN_WIDTH - 40, (SCREEN_HEIGHT - 60) * 0.5)];
    topPicturesScrollView.backgroundColor = [UIColor clearColor];
    topPicturesScrollView.showsHorizontalScrollIndicator = NO;
    topPicturesScrollView.showsVerticalScrollIndicator = NO;
    topPicturesScrollView.pagingEnabled = NO;
    topPicturesScrollView.bounces = NO;
    topPicturesScrollView.delegate = self;
    
    [self.maskView addSubview:topPicturesScrollView];
    
    topImageViewWidth = SCREEN_WIDTH - 40;
    topImageViewHeight = (SCREEN_HEIGHT - 60) * 0.5;

//    UIImage *topImage = [[UIImage alloc] initWithContentsOfFile:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[[ApplicationDelegate.picturesArray objectAtIndex:[[self.selectedPicturesArray firstObject] intValue]] valueForKey:@"Name"]]];
//    CGFloat topImageWidth = topImage.size.width;
//    CGFloat topImageHeight = topImage.size.height;
//    if (topImageWidth / topImageHeight > topImageViewWidth / topImageViewHeight)
//    {
//        setTopImageViewWidth = topImageViewWidth;
//        setTopImageViewHeight = topImageViewWidth * topImageHeight / topImageWidth;
//    }
//    else if (topImageWidth / topImageHeight < topImageViewWidth / topImageViewHeight)
//    {
//        setTopImageViewWidth = topImageViewHeight * topImageWidth / topImageHeight;
//        setTopImageViewHeight = topImageViewHeight;
//    }
//    else
//    {
//        setTopImageViewWidth = topImageViewWidth;
//        setTopImageViewHeight = topImageViewHeight;
//    }
//    
//    topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, setTopImageViewWidth, setTopImageViewHeight)];
//    topImageView.backgroundColor = [UIColor clearColor];
//    topImageView.image = topImage;
//    topImageView.center = CGPointMake((SCREEN_WIDTH - 40) * 0.5, ((SCREEN_HEIGHT - 60) * 0.5) * 0.5);
//    [topPicturesScrollView addSubview:topImageView];
//    
//    [topImageView setUserInteractionEnabled:YES];
//    [topImageView setMultipleTouchEnabled:YES];   改为👇
    
    
    NSIndexPath *topIndexPath = [self.selectedPicturesArray firstObject];
    if (topIndexPath.section == 0) {
        UIImage *topImage = [[UIImage alloc] initWithContentsOfFile:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[[ApplicationDelegate.eyelidsPicturesArray objectAtIndex:topIndexPath.row] valueForKey:@"Name"]]];
        CGFloat topImageWidth = topImage.size.width;
        CGFloat topImageHeight = topImage.size.height;
        if (topImageWidth / topImageHeight > topImageViewWidth / topImageViewHeight)
        {
            setTopImageViewWidth = topImageViewWidth;
            setTopImageViewHeight = topImageViewWidth * topImageHeight / topImageWidth;
        }
        else if (topImageWidth / topImageHeight < topImageViewWidth / topImageViewHeight)
        {
            setTopImageViewWidth = topImageViewHeight * topImageWidth / topImageHeight;
            setTopImageViewHeight = topImageViewHeight;
        }
        else
        {
            setTopImageViewWidth = topImageViewWidth;
            setTopImageViewHeight = topImageViewHeight;
        }
        
        topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, setTopImageViewWidth, setTopImageViewHeight)];
        topImageView.backgroundColor = [UIColor clearColor];
        topImageView.image = topImage;
        topImageView.center = CGPointMake((SCREEN_WIDTH - 40) * 0.5, ((SCREEN_HEIGHT - 60) * 0.5) * 0.5);
        [topPicturesScrollView addSubview:topImageView];
        
        [topImageView setUserInteractionEnabled:YES];
        [topImageView setMultipleTouchEnabled:YES];
    }
    else if (topIndexPath.section == 1)
    {
        UIImage *topImage = [[UIImage alloc] initWithContentsOfFile:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[[ApplicationDelegate.blemishPicturesArray objectAtIndex:topIndexPath.row] valueForKey:@"Name"]]];
        CGFloat topImageWidth = topImage.size.width;
        CGFloat topImageHeight = topImage.size.height;
        if (topImageWidth / topImageHeight > topImageViewWidth / topImageViewHeight)
        {
            setTopImageViewWidth = topImageViewWidth;
            setTopImageViewHeight = topImageViewWidth * topImageHeight / topImageWidth;
        }
        else if (topImageWidth / topImageHeight < topImageViewWidth / topImageViewHeight)
        {
            setTopImageViewWidth = topImageViewHeight * topImageWidth / topImageHeight;
            setTopImageViewHeight = topImageViewHeight;
        }
        else
        {
            setTopImageViewWidth = topImageViewWidth;
            setTopImageViewHeight = topImageViewHeight;
        }
        
        topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, setTopImageViewWidth, setTopImageViewHeight)];
        topImageView.backgroundColor = [UIColor clearColor];
        topImageView.image = topImage;
        topImageView.center = CGPointMake((SCREEN_WIDTH - 40) * 0.5, ((SCREEN_HEIGHT - 60) * 0.5) * 0.5);
        [topPicturesScrollView addSubview:topImageView];
        
        [topImageView setUserInteractionEnabled:YES];
        [topImageView setMultipleTouchEnabled:YES];
    }
    else if (topIndexPath.section == 2)
    {
        UIImage *topImage = [[UIImage alloc] initWithContentsOfFile:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[[ApplicationDelegate.firmingPicturesArray objectAtIndex:topIndexPath.row] valueForKey:@"Name"]]];
        CGFloat topImageWidth = topImage.size.width;
        CGFloat topImageHeight = topImage.size.height;
        if (topImageWidth / topImageHeight > topImageViewWidth / topImageViewHeight)
        {
            setTopImageViewWidth = topImageViewWidth;
            setTopImageViewHeight = topImageViewWidth * topImageHeight / topImageWidth;
        }
        else if (topImageWidth / topImageHeight < topImageViewWidth / topImageViewHeight)
        {
            setTopImageViewWidth = topImageViewHeight * topImageWidth / topImageHeight;
            setTopImageViewHeight = topImageViewHeight;
        }
        else
        {
            setTopImageViewWidth = topImageViewWidth;
            setTopImageViewHeight = topImageViewHeight;
        }
        
        topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, setTopImageViewWidth, setTopImageViewHeight)];
        topImageView.backgroundColor = [UIColor clearColor];
        topImageView.image = topImage;
        topImageView.center = CGPointMake((SCREEN_WIDTH - 40) * 0.5, ((SCREEN_HEIGHT - 60) * 0.5) * 0.5);
        [topPicturesScrollView addSubview:topImageView];
        
        [topImageView setUserInteractionEnabled:YES];
        [topImageView setMultipleTouchEnabled:YES];
    }
    
    // 缩放手势
    UIPinchGestureRecognizer *topPinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinkTopView:)];
    [topImageView addGestureRecognizer:topPinchGestureRecognizer];
    topOldFrame = topImageView.frame;
    
    // bottomPicturesScrollView
    bottomPicturesScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(20, (SCREEN_HEIGHT - 60) * 0.5 + 40, SCREEN_WIDTH - 40, (SCREEN_HEIGHT - 60) * 0.5)];
    bottomPicturesScrollView.backgroundColor = [UIColor clearColor];
    bottomPicturesScrollView.showsHorizontalScrollIndicator = NO;
    bottomPicturesScrollView.showsVerticalScrollIndicator = NO;
    bottomPicturesScrollView.pagingEnabled = NO;
    bottomPicturesScrollView.bounces = NO;
    bottomPicturesScrollView.delegate = self;
    
    [self.maskView addSubview:bottomPicturesScrollView];
    
    bottomImageViewWidth = SCREEN_WIDTH - 40;
    bottomImageViewHeight = (SCREEN_HEIGHT - 60) * 0.5;
    
//    UIImage *bottomImage = [[UIImage alloc] initWithContentsOfFile:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[[ApplicationDelegate.picturesArray objectAtIndex:[[self.selectedPicturesArray lastObject] intValue]] valueForKey:@"Name"]]];
//    CGFloat bottomImageWidth = bottomImage.size.width;
//    CGFloat bottomImageHeight = bottomImage.size.height;
//    
//    if (bottomImageWidth / bottomImageHeight > bottomImageViewWidth / bottomImageViewHeight)
//    {
//        setBottomImageViewWidth = bottomImageViewWidth;
//        setBottomImageViewHeight = bottomImageViewWidth * bottomImageHeight / bottomImageWidth;
//    }
//    else if (bottomImageWidth / bottomImageHeight < bottomImageViewWidth / bottomImageViewHeight)
//    {
//        setBottomImageViewWidth = bottomImageViewHeight * bottomImageWidth / bottomImageHeight;
//        setBottomImageViewHeight = bottomImageViewHeight;
//    }
//    else
//    {
//        setBottomImageViewWidth = bottomImageViewWidth;
//        setBottomImageViewHeight = bottomImageViewHeight;
//    }
//    
//    bottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, setBottomImageViewWidth, setBottomImageViewHeight)];
//    bottomImageView.backgroundColor = [UIColor clearColor];
//    bottomImageView.image = bottomImage;
//    bottomImageView.center = CGPointMake((SCREEN_WIDTH - 40) * 0.5, ((SCREEN_HEIGHT - 60) * 0.5) * 0.5);
//    [bottomPicturesScrollView addSubview:bottomImageView];
//    
//    [bottomImageView setUserInteractionEnabled:YES];
//    [bottomImageView setMultipleTouchEnabled:YES];
    
    
    
    NSIndexPath *bottomIndexPath = [self.selectedPicturesArray lastObject];
    if (bottomIndexPath.section == 0) {
        UIImage *bottomImage = [[UIImage alloc] initWithContentsOfFile:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[[ApplicationDelegate.eyelidsPicturesArray objectAtIndex:bottomIndexPath.row] valueForKey:@"Name"]]];
        CGFloat bottomImageWidth = bottomImage.size.width;
        CGFloat bottomImageHeight = bottomImage.size.height;
        
        if (bottomImageWidth / bottomImageHeight > bottomImageViewWidth / bottomImageViewHeight)
        {
            setBottomImageViewWidth = bottomImageViewWidth;
            setBottomImageViewHeight = bottomImageViewWidth * bottomImageHeight / bottomImageWidth;
        }
        else if (bottomImageWidth / bottomImageHeight < bottomImageViewWidth / bottomImageViewHeight)
        {
            setBottomImageViewWidth = bottomImageViewHeight * bottomImageWidth / bottomImageHeight;
            setBottomImageViewHeight = bottomImageViewHeight;
        }
        else
        {
            setBottomImageViewWidth = bottomImageViewWidth;
            setBottomImageViewHeight = bottomImageViewHeight;
        }
        
        bottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, setBottomImageViewWidth, setBottomImageViewHeight)];
        bottomImageView.backgroundColor = [UIColor clearColor];
        bottomImageView.image = bottomImage;
        bottomImageView.center = CGPointMake((SCREEN_WIDTH - 40) * 0.5, ((SCREEN_HEIGHT - 60) * 0.5) * 0.5);
        [bottomPicturesScrollView addSubview:bottomImageView];
        
        [bottomImageView setUserInteractionEnabled:YES];
        [bottomImageView setMultipleTouchEnabled:YES];
    }
    else if (bottomIndexPath.section == 1)
    {
        UIImage *bottomImage = [[UIImage alloc] initWithContentsOfFile:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[[ApplicationDelegate.blemishPicturesArray objectAtIndex:bottomIndexPath.row] valueForKey:@"Name"]]];
        CGFloat bottomImageWidth = bottomImage.size.width;
        CGFloat bottomImageHeight = bottomImage.size.height;
        
        if (bottomImageWidth / bottomImageHeight > bottomImageViewWidth / bottomImageViewHeight)
        {
            setBottomImageViewWidth = bottomImageViewWidth;
            setBottomImageViewHeight = bottomImageViewWidth * bottomImageHeight / bottomImageWidth;
        }
        else if (bottomImageWidth / bottomImageHeight < bottomImageViewWidth / bottomImageViewHeight)
        {
            setBottomImageViewWidth = bottomImageViewHeight * bottomImageWidth / bottomImageHeight;
            setBottomImageViewHeight = bottomImageViewHeight;
        }
        else
        {
            setBottomImageViewWidth = bottomImageViewWidth;
            setBottomImageViewHeight = bottomImageViewHeight;
        }
        
        bottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, setBottomImageViewWidth, setBottomImageViewHeight)];
        bottomImageView.backgroundColor = [UIColor clearColor];
        bottomImageView.image = bottomImage;
        bottomImageView.center = CGPointMake((SCREEN_WIDTH - 40) * 0.5, ((SCREEN_HEIGHT - 60) * 0.5) * 0.5);
        [bottomPicturesScrollView addSubview:bottomImageView];
        
        [bottomImageView setUserInteractionEnabled:YES];
        [bottomImageView setMultipleTouchEnabled:YES];
    }
    else if (bottomIndexPath.section == 2)
    {
        UIImage *bottomImage = [[UIImage alloc] initWithContentsOfFile:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[[ApplicationDelegate.firmingPicturesArray objectAtIndex:bottomIndexPath.row] valueForKey:@"Name"]]];
        CGFloat bottomImageWidth = bottomImage.size.width;
        CGFloat bottomImageHeight = bottomImage.size.height;
        
        if (bottomImageWidth / bottomImageHeight > bottomImageViewWidth / bottomImageViewHeight)
        {
            setBottomImageViewWidth = bottomImageViewWidth;
            setBottomImageViewHeight = bottomImageViewWidth * bottomImageHeight / bottomImageWidth;
        }
        else if (bottomImageWidth / bottomImageHeight < bottomImageViewWidth / bottomImageViewHeight)
        {
            setBottomImageViewWidth = bottomImageViewHeight * bottomImageWidth / bottomImageHeight;
            setBottomImageViewHeight = bottomImageViewHeight;
        }
        else
        {
            setBottomImageViewWidth = bottomImageViewWidth;
            setBottomImageViewHeight = bottomImageViewHeight;
        }
        
        bottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, setBottomImageViewWidth, setBottomImageViewHeight)];
        bottomImageView.backgroundColor = [UIColor clearColor];
        bottomImageView.image = bottomImage;
        bottomImageView.center = CGPointMake((SCREEN_WIDTH - 40) * 0.5, ((SCREEN_HEIGHT - 60) * 0.5) * 0.5);
        [bottomPicturesScrollView addSubview:bottomImageView];
        
        [bottomImageView setUserInteractionEnabled:YES];
        [bottomImageView setMultipleTouchEnabled:YES];
    }
    
    
    
    // 缩放手势
    UIPinchGestureRecognizer *bottomPinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinkBottomView:)];
    [bottomImageView addGestureRecognizer:bottomPinchGestureRecognizer];
    bottomOldFrame = bottomImageView.frame;
    
    self.maskView.hidden = NO;
    
//    UIImage *image1 = [[UIImage alloc] initWithContentsOfFile:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[[ApplicationDelegate.picturesArray objectAtIndex:[[self.selectedPicturesArray firstObject] intValue]] valueForKey:@"Name"]]];
//    UIImage *image2 = [[UIImage alloc] initWithContentsOfFile:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[[ApplicationDelegate.picturesArray objectAtIndex:[[self.selectedPicturesArray lastObject] intValue]] valueForKey:@"Name"]]];
//    
//    UIImage *topImage = [UIImage imageWithCGImage:image1.CGImage scale:1 orientation:UIImageOrientationRight];
//    UIImage *buttomImage = [UIImage imageWithCGImage:image2.CGImage scale:1 orientation:UIImageOrientationRight];
//    
//    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT * 0.5)];
//    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT * 0.5, SCREEN_WIDTH, SCREEN_HEIGHT * 0.5)];
//    UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT * 0.5 * topImage.size.width / topImage.size.height, SCREEN_HEIGHT * 0.5)];
//    UIImageView *buttomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT * 0.5 * topImage.size.width / topImage.size.height, SCREEN_HEIGHT * 0.5)];
//    [topView addSubview:topImageView];
//    [bottomView addSubview:buttomImageView];
//    topImageView.image = topImage;
//    buttomImageView.image = buttomImage;
//    topImageView.center = CGPointMake(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT * 0.25);
//    buttomImageView.center = CGPointMake(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT * 0.25);
//    
//    [self.maskView addSubview:topView];
//    [self.maskView addSubview:bottomView];
//    self.maskView.hidden = NO;
}

// 处理缩放手势（TOP）
- (void)pinkTopView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    UIView *view = pinchGestureRecognizer.view;
    topLargeFrame = CGRectMake(topImageView.frame.origin.x, topImageView.frame.origin.y, 3 * topOldFrame.size.width, 3 * topOldFrame.size.height);
    
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        if (topImageView.frame.size.width < topOldFrame.size.width) {
            topImageView.frame = topOldFrame;
            //让图片无法缩得比原图小
        }
        if (topImageView.frame.size.width > 3 * topOldFrame.size.width) {
            topImageView.frame = topLargeFrame;
        }
        pinchGestureRecognizer.scale = 1;
        
        NSLog(@"width - %f", topImageView.frame.size.width);
        NSLog(@"height- %f", topImageView.frame.size.height);
        
        
        if (topPicturesScrollView.frame.size.width < topImageView.frame.size.width && topPicturesScrollView.frame.size.height < topImageView.frame.size.height)
        {
            topPicturesScrollView.contentSize = CGSizeMake(topImageView.frame.size.width, topImageView.frame.size.height);
            topImageView.center = CGPointMake((topImageView.frame.size.width) * 0.5, (topImageView.frame.size.height) * 0.5);
        }
        else if (topPicturesScrollView.frame.size.width > topImageView.frame.size.width && topPicturesScrollView.frame.size.height < topImageView.frame.size.height)
        {
            topPicturesScrollView.contentSize = CGSizeMake(topImageView.frame.size.width, topImageView.frame.size.height);
            topImageView.center = CGPointMake((SCREEN_WIDTH - 40) * 0.5, (topImageView.frame.size.height) * 0.5);
        }
        else if (topPicturesScrollView.frame.size.width < topImageView.frame.size.width && topPicturesScrollView.frame.size.height > topImageView.frame.size.height)
        {
            topPicturesScrollView.contentSize = CGSizeMake(topImageView.frame.size.width, topImageView.frame.size.height);
            topImageView.center = CGPointMake((topImageView.frame.size.width) * 0.5, ((SCREEN_HEIGHT - 60) * 0.5) * 0.5);
        }
        else
        {
            topPicturesScrollView.contentSize = CGSizeMake(topImageView.frame.size.width, topImageView.frame.size.height);
            topImageView.center = CGPointMake((SCREEN_WIDTH - 40) * 0.5, ((SCREEN_HEIGHT - 60) * 0.5) * 0.5);
        }
        
    }
}

// 处理缩放手势（BOTTOM）
- (void)pinkBottomView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    UIView *view = pinchGestureRecognizer.view;
    bottomLargeFrame = CGRectMake(bottomImageView.frame.origin.x, bottomImageView.frame.origin.y, 3 * bottomOldFrame.size.width, 3 * bottomOldFrame.size.height);
    
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        if (bottomImageView.frame.size.width < bottomOldFrame.size.width) {
            bottomImageView.frame = bottomOldFrame;
            //让图片无法缩得比原图小
        }
        if (bottomImageView.frame.size.width > 3 * bottomOldFrame.size.width) {
            bottomImageView.frame = bottomLargeFrame;
        }
        pinchGestureRecognizer.scale = 1;
        
        NSLog(@"width - %f", bottomImageView.frame.size.width);
        NSLog(@"height- %f", bottomImageView.frame.size.height);
        
        
        if (bottomPicturesScrollView.frame.size.width < bottomImageView.frame.size.width && bottomPicturesScrollView.frame.size.height < bottomImageView.frame.size.height)
        {
            bottomPicturesScrollView.contentSize = CGSizeMake(bottomImageView.frame.size.width, bottomImageView.frame.size.height);
            bottomImageView.center = CGPointMake((bottomImageView.frame.size.width) * 0.5, (bottomImageView.frame.size.height) * 0.5);
        }
        else if (bottomPicturesScrollView.frame.size.width > bottomImageView.frame.size.width && bottomPicturesScrollView.frame.size.height < bottomImageView.frame.size.height)
        {
            bottomPicturesScrollView.contentSize = CGSizeMake(bottomImageView.frame.size.width, bottomImageView.frame.size.height);
            bottomImageView.center = CGPointMake((SCREEN_WIDTH - 40) * 0.5, (bottomImageView.frame.size.height) * 0.5);
        }
        else if (bottomPicturesScrollView.frame.size.width < bottomImageView.frame.size.width && bottomPicturesScrollView.frame.size.height > bottomImageView.frame.size.height)
        {
            bottomPicturesScrollView.contentSize = CGSizeMake(bottomImageView.frame.size.width, bottomImageView.frame.size.height);
            bottomImageView.center = CGPointMake((bottomImageView.frame.size.width) * 0.5, ((SCREEN_HEIGHT - 60) * 0.5) * 0.5);
        }
        else
        {
            bottomPicturesScrollView.contentSize = CGSizeMake(bottomImageView.frame.size.width, bottomImageView.frame.size.height);
            bottomImageView.center = CGPointMake((SCREEN_WIDTH - 40) * 0.5, ((SCREEN_HEIGHT - 60) * 0.5) * 0.5);
        }
        
    }
}

// 处理缩放手势
- (void)pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    UIView *view = pinchGestureRecognizer.view;
    largeFrame = CGRectMake(bigImageView.frame.origin.x, bigImageView.frame.origin.y, 3 * oldFrame.size.width, 3 * oldFrame.size.height);
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        if (bigImageView.frame.size.width < oldFrame.size.width) {
            bigImageView.frame = oldFrame;
            //让图片无法缩得比原图小
        }
        if (bigImageView.frame.size.width > 3 * oldFrame.size.width) {
            bigImageView.frame = largeFrame;
        }
        pinchGestureRecognizer.scale = 1;
    }
}

// 处理拖拉手势
- (void)panView:(UIPanGestureRecognizer *)panGestureRecognizer
{
    UIView *view = panGestureRecognizer.view;
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGestureRecognizer translationInView:view.superview];
        [view setCenter:(CGPoint){view.center.x + translation.x, view.center.y + translation.y}];
        [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
    }
}

#pragma mark - 获取plist数据（多个）
// 获取 setting.plist 数据
- (void)getSettingPlist
{
    NSString *settingPlistPath = [[NSBundle mainBundle] pathForResource:@"setting" ofType:@"plist"];
    self.settingArray = [[NSArray alloc] initWithContentsOfFile:settingPlistPath];
}

// 获取 information.plist 数据
- (void)getInformationPlist
{
    NSString *informationPlistPath = [[NSBundle mainBundle] pathForResource:@"information" ofType:@"plist"];
    self.informationArray = [[NSArray alloc] initWithContentsOfFile:informationPlistPath];
}

// 获取 FAQList.plist 数据
- (void)getFAQListPlist
{
    NSString *FAQListPlistPath = [[NSBundle mainBundle] pathForResource:@"FAQList" ofType:@"plist"];
    self.FAQListArray = [[NSArray alloc] initWithContentsOfFile:FAQListPlistPath];
}

// 获取 Pictures.plist 数据
- (void)getPicturePlist
{
//    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsPath = [path objectAtIndex:0];
//    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"pictures.plist"];
//    self.picturesArray = [NSMutableArray arrayWithContentsOfFile:plistPath];
//    if (self.picturesArray == nil) {
//        self.picturesArray = [[NSMutableArray alloc] init];
//    } 改为👇
    
    NSArray *path1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath1 = [path1 objectAtIndex:0];
    NSString *plistPath1 = [documentsPath1 stringByAppendingPathComponent:@"eyelidsPictures.plist"];
    self.eyelidsPicturesArray = [NSMutableArray arrayWithContentsOfFile:plistPath1];
    if (self.eyelidsPicturesArray == nil) {
        self.eyelidsPicturesArray = [[NSMutableArray alloc] init];
    }
    
    NSArray *path2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath2 = [path2 objectAtIndex:0];
    NSString *plistPath2 = [documentsPath2 stringByAppendingPathComponent:@"blemishPictures.plist"];
    self.blemishPicturesArray = [NSMutableArray arrayWithContentsOfFile:plistPath2];
    if (self.blemishPicturesArray == nil) {
        self.blemishPicturesArray = [[NSMutableArray alloc] init];
    }
    
    NSArray *path3 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath3 = [path3 objectAtIndex:0];
    NSString *plistPath3 = [documentsPath3 stringByAppendingPathComponent:@"firmingPictures.plist"];
    self.firmingPicturesArray = [NSMutableArray arrayWithContentsOfFile:plistPath3];
    if (self.firmingPicturesArray == nil) {
        self.firmingPicturesArray = [[NSMutableArray alloc] init];
    }
    
    NSLog(@"self.eyelidsPicturesArray >>> %@",self.eyelidsPicturesArray);
    NSLog(@"self.blemishPicturesArray >>> %@",self.blemishPicturesArray);
    NSLog(@"self.firmingPicturesArray >>> %@",self.firmingPicturesArray);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    self.isCheckProtocol = YES;
//    timer60s = [NSTimer timerWithTimeInterval:60.0f target:self selector:@selector(timer60sAction) userInfo:nil repeats:YES];
//    [[NSRunLoop currentRunLoop] addTimer:timer60s forMode:NSDefaultRunLoopMode];
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
