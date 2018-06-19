//
//  HReplaceViewController.m
//  FaceKARE
//
//  Created by Anan on 2017/5/2.
//  Copyright © 2017年 Anan. All rights reserved.
//

#import "HReplaceViewController.h"
#import "AppUIModel.h"
#import "AppDelegate.h"
#import "FeSpinnerTenDot.h"
#import "HBLECenterManager.h"
#import "MBProgressHUD+MJ.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

@interface HReplaceViewController ()<FeSpinnerTenDotDelegate>
{
    NSTimer *timer30s;
}

// 主色调背景
@property (nonatomic, strong) UIView *replaceView;
// 连接其他设备按钮
@property (nonatomic, strong) UIButton *replaceButton;

@property (strong, nonatomic) FeSpinnerTenDot *spinner;
@property (strong, nonatomic) NSTimer *timer;

// 提示
@property (nonatomic, strong) UIAlertController *R1007AC;
@property (nonatomic, strong) UIAlertController *nomoreDeviceAC;

@end

@implementation HReplaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(R1007NotificationAction) name:@"R1007Notification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(R1008NotificationAction) name:@"R1008Notification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectDeviceR) name:@"didConnectNotification" object:nil];
    
    // 设置页面 navigation 标题
    self.navigationItem.title = NSLocalizedString(@"replaceViewNavigationTitle", nil);
    
    // 设置背景颜色
    self.view.backgroundColor = [AppUIModel UIViewBackgroundColor];
    
    // 设置返回按钮
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc] init];
    backbutton.title = @"";
    self.navigationItem.backBarButtonItem = backbutton;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    // 设置 view
    self.replaceView = [[UIView alloc] initWithFrame:CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT + 64)];
    self.replaceView.backgroundColor = [AppUIModel UIViewMainColorI];
    self.replaceView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.replaceView];
    
    // tipLabel1
    UILabel *tipLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(30, 94, SCREEN_WIDTH - 60, 30)];
    tipLabel1.textColor = [AppUIModel UIViewNormalColor];
    tipLabel1.font = [AppUIModel UIViewNormalFont];
    [tipLabel1 setTextAlignment:NSTextAlignmentLeft];
    tipLabel1.text = NSLocalizedString(@"replaceTipLabel1", nil);
    tipLabel1.numberOfLines = 0;
    CGSize tipLabel1Size = [tipLabel1 sizeThatFits:CGSizeMake(SCREEN_WIDTH - 60, MAXFLOAT)];
    CGRect tipLabel1Frame = tipLabel1.frame;
    tipLabel1Frame.size.height = tipLabel1Size.height;
    [tipLabel1 setFrame:tipLabel1Frame];
    [self.view addSubview:tipLabel1];
    
    // tipLabel2
    UILabel *tipLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(30, 114 + tipLabel1Size.height, SCREEN_WIDTH - 60, 30)];
    tipLabel2.textColor = [AppUIModel UIViewNormalColor];
    tipLabel2.font = [AppUIModel UIViewNormalFont];
    [tipLabel2 setTextAlignment:NSTextAlignmentLeft];
    tipLabel2.text = NSLocalizedString(@"replaceTipLabel2", nil);
    tipLabel2.numberOfLines = 0;
    CGSize tipLabel2Size = [tipLabel2 sizeThatFits:CGSizeMake(SCREEN_WIDTH - 60, MAXFLOAT)];
    CGRect tipLabel2Frame = tipLabel2.frame;
    tipLabel2Frame.size.height = tipLabel2Size.height;
    [tipLabel2 setFrame:tipLabel2Frame];
    [self.view addSubview:tipLabel2];
    
    // 设置连接其他设备按钮
    self.replaceButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 120, 40)];
    CGPoint point = CGPointMake(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT * 0.4);
    self.replaceButton.center = point;
    [self.replaceButton.layer setMasksToBounds:YES];
    [self.replaceButton.layer setCornerRadius:10.0f];
    self.replaceButton.backgroundColor = [AppUIModel UIViewMainColorII];
    [self.replaceButton setTitle:NSLocalizedString(@"replaceButton", nil) forState:UIControlStateNormal];
    [self.replaceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.replaceButton.titleLabel.font = [AppUIModel UIViewTitleFont];
    [self.replaceButton setShowsTouchWhenHighlighted:YES];
    [self.replaceButton.layer setBorderWidth:1.0f];
    [self.replaceButton.layer setBorderColor:[AppUIModel UIUselessColor].CGColor];
    [self.replaceButton addTarget:self action:@selector(replaceButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.replaceButton];
    
}

// 连接其他设备按钮动作
- (void)replaceButtonAction:(UIButton *)sender
{
    ApplicationDelegate.isReplace = YES;
    
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
    
    if (ApplicationDelegate.isConnectDevice == YES) {
        [ApplicationDelegate.manager stopScanPeripherals];
        [ApplicationDelegate.manager disconnectSelectedPeripheral];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"deviceIdentifier"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [ApplicationDelegate.manager.discoverPeripheralsArray removeAllObjects];
        ApplicationDelegate.isQuickConnectDevice = YES;
        [ApplicationDelegate.manager beginScanPeripherals];
    }
    else
    {
        [ApplicationDelegate.manager stopScanPeripherals];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"deviceIdentifier"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [ApplicationDelegate.manager.discoverPeripheralsArray removeAllObjects];
        ApplicationDelegate.isQuickConnectDevice = YES;
        [ApplicationDelegate.manager beginScanPeripherals];
    }
    [self startWaitingView];
    [self start30sTimer];
}

// timer30s 开始计时
- (void)start30sTimer
{
    timer30s = [NSTimer timerWithTimeInterval:30.0f target:self selector:@selector(timer30sAction) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:timer30s forMode:NSDefaultRunLoopMode];
}

// timer30s 中断计时
- (void)stop30sTimer
{
    if (timer30s.isValid == YES)
    {
        [timer30s invalidate];
    }
    timer30s = nil;
}

- (void)timer30sAction
{
    [ApplicationDelegate.manager stopScanPeripherals];
    [self stopWaitingView];
    [ApplicationDelegate addDisableConnectTips];
}

- (IBAction)start:(id)sender
{
    _spinner = [[FeSpinnerTenDot alloc] initWithView:self.view withBlur:NO];
    _spinner.delegate = self;
    [self.view addSubview:_spinner];
    [_spinner showWhileExecutingSelector:@selector(longTask) onTarget:self withObject:nil completion:^{
        [self->_timer invalidate];
        self->_timer = nil;
    }];
}

-(void) longTask
{
    sleep(5);
}

//开始等待画面
- (void)startWaitingView
{
    self.navigationItem.hidesBackButton = YES;
    [self start:self];
}

//结束等待画面
- (void)stopWaitingView
{
    [self.spinner removeFromSuperview];
    self.navigationItem.hidesBackButton = NO;
}

- (void)R1007NotificationAction
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if (ApplicationDelegate.isReplace) {
            self.R1007AC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"connectPrompt", nil) message:NSLocalizedString(@"connectPromptDetail1", nil) preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *left = [UIAlertAction actionWithTitle:NSLocalizedString(@"connectNext", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                // 下一个
                [ApplicationDelegate.manager stopScanPeripherals];
                NSData* data = [ApplicationDelegate.manager.dataProcessor encription:"S1008\r\n"];
                NSLog(@"data base - %@",data);
                [ApplicationDelegate.manager writeWithoutResponceToSelectedCharacteristicWithData:data];
                
            }];
            UIAlertAction *right = [UIAlertAction actionWithTitle:NSLocalizedString(@"connectConfirm", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                // 确认
                [[NSUserDefaults standardUserDefaults] setObject:ApplicationDelegate.manager.selectedDeviceIdentifier forKey:@"deviceIdentifier"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                NSLog(@"defaults R - %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"deviceIdentifier"]);
                [ApplicationDelegate.manager.discoverPeripheralsArray removeAllObjects];
                [ApplicationDelegate.manager stopScanPeripherals];
                NSData* data = [ApplicationDelegate.manager.dataProcessor encription:"S1008\r\n"];
                NSLog(@"data base - %@",data);
                [ApplicationDelegate.manager writeWithoutResponceToSelectedCharacteristicWithData:data];
                //            [self.navigationController popViewControllerAnimated:YES];
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
        if (ApplicationDelegate.isReplace) {
            if ([[NSUserDefaults standardUserDefaults] valueForKey:@"deviceIdentifier"]) {
                ApplicationDelegate.isOnceConnectDevice = YES;
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

- (void)connectDeviceR
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if (ApplicationDelegate.isReplace) {
            NSLog(@"连接设备传过来了R");
            [self stop30sTimer];
            [self stopWaitingView];
            
            ApplicationDelegate.manager.selectedDeviceIdentifier = ApplicationDelegate.selectedPeripheral.identifier.UUIDString;
            NSData* data = [ApplicationDelegate.manager.dataProcessor encription:"S1007\r\n"];
            NSLog(@"data base - %@",data);
            [ApplicationDelegate.manager writeWithoutResponceToSelectedCharacteristicWithData:data];
        }
    }];
}

#pragma mark - 页面将要打开
- (void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    ApplicationDelegate.isReplace = NO;
    if (timer30s.isValid == YES)
    {
        [timer30s invalidate];
    }
    self.timer = nil;
    if (self.timer.isValid == YES)
    {
        [self.timer invalidate];
    }
    self.timer = nil;
    self.spinner = nil;
    self.R1007AC = nil;
    self.nomoreDeviceAC = nil;
    [self removeFromParentViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
