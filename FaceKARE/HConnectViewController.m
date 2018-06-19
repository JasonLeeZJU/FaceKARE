//
//  HConnectViewController.m
//  FaceKARE
//
//  Created by Anan on 2017/4/29.
//  Copyright © 2017年 Anan. All rights reserved.
//

#import "HConnectViewController.h"
#import "AppUIModel.h"
#import "AppDelegate.h"
#import "FeSpinnerTenDot.h"
#import "HBLECenterManager.h"
#import "MBProgressHUD+MJ.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

@interface HConnectViewController ()<FeSpinnerTenDotDelegate>
{
    CGAffineTransform *angle;
    UIButton *connectButton;
    NSTimer *timer10s;
    NSInvocationOperation *operation;
    CABasicAnimation* rotationAnimation;
    
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
@property (nonatomic, strong) UIView *connectView;
// 旋转 imageView
@property (nonatomic, strong) UIImageView *imageView;

@property (strong, nonatomic) FeSpinnerTenDot *spinner;
@property (strong, nonatomic) NSTimer *timer;

// 提示
@property (nonatomic, strong) UIAlertController *R1007AC;
@property (nonatomic, strong) UIAlertController *nomoreDeviceAC;
@property (nonatomic, strong) UIAlertController *noDeviceAC;

@end

@implementation HConnectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(R1007NotificationAction) name:@"R1007Notification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(R1008NotificationAction) name:@"R1008Notification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(R0101IdleNotificationAction) name:@"R0101IdleNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(R0101StopNotificationAction) name:@"R0101StopNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(R0508DifferentNotificationAction) name:@"R0508DifferentNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transformNotificationAction) name:@"transformNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disconnectDeviceAction) name:@"disconnectNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectDeviceC) name:@"didConnectNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(R0509NotificationAction) name:@"R0509Notification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(R0106Action) name:@"R0106Notification" object:nil];
    
    // 设置页面 navigation 标题
    self.navigationItem.title = NSLocalizedString(@"connectNavigationTitle", nil);
    
    [self.view setBackgroundColor:[AppUIModel UIViewBackgroundColor]];
    
    // 设置返回按钮
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc] init];
    backbutton.title = @"";
    self.navigationItem.backBarButtonItem = backbutton;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    // 设置 view
    self.connectView = [[UIView alloc] initWithFrame:CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT + 64)];
    self.connectView.backgroundColor = [AppUIModel UIViewMainColorI];
    self.connectView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.connectView];
    
    //设置旋转 imageView
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH * 0.5, SCREEN_WIDTH * 0.5)];
    [self.imageView.layer setMasksToBounds:YES];
    [self.imageView.layer setCornerRadius:SCREEN_WIDTH * 0.25];
    
    CGPoint point = CGPointMake(SCREEN_WIDTH * 0.5, SCREEN_WIDTH * 0.5 + 64);
    self.imageView.center = point;
    [self.view addSubview:self.imageView];
    
    //设置 button
    connectButton = [[UIButton alloc] initWithFrame:CGRectMake(60, SCREEN_WIDTH + 64, SCREEN_WIDTH * 0.8 - 80, 40)];
    [connectButton.layer setMasksToBounds:YES];
    [connectButton.layer setCornerRadius:10.0f];
    connectButton.center = CGPointMake(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT * 0.6);
    connectButton.backgroundColor = [AppUIModel UIViewMainColorII];
    [connectButton setTitle:NSLocalizedString(@"HomeConnectButton", nil) forState:UIControlStateNormal];
    [connectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    connectButton.titleLabel.font = [AppUIModel UIViewTitleFont];
    [connectButton setShowsTouchWhenHighlighted:YES];
    [connectButton.layer setBorderWidth:1.0f];
    [connectButton.layer setBorderColor:[AppUIModel UIUselessColor].CGColor];
    [connectButton addTarget:self action:@selector(connectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:connectButton];
    
    greenLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
//    greenLabel.backgroundColor = [UIColor greenColor];
    greenLabel.text = NSLocalizedString(@"connectGreenLabel", nil);
    greenLabel.font = [AppUIModel UIViewSmallFont];
    greenLabel.textColor = [AppUIModel UIViewNormalColor];
    [greenLabel setTextAlignment:NSTextAlignmentCenter];
    greenLabel.center = CGPointMake(SCREEN_WIDTH * 0.25, SCREEN_HEIGHT * 0.8 + 40);
    [self.view addSubview:greenLabel];
    
    yellowLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
//    yellowLabel.backgroundColor = [UIColor orangeColor];
    yellowLabel.text = NSLocalizedString(@"connectYellowLabel", nil);
    yellowLabel.font = [AppUIModel UIViewSmallFont];
    yellowLabel.textColor = [AppUIModel UIViewNormalColor];
    [yellowLabel setTextAlignment:NSTextAlignmentCenter];
    yellowLabel.center = CGPointMake(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT * 0.8 + 40);
    [self.view addSubview:yellowLabel];
    
    blueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
//    blueLabel.backgroundColor = [UIColor blueColor];
    blueLabel.text = NSLocalizedString(@"connectBlueLabel", nil);
    blueLabel.font = [AppUIModel UIViewSmallFont];
    blueLabel.textColor = [AppUIModel UIViewNormalColor];
    [blueLabel setTextAlignment:NSTextAlignmentCenter];
    blueLabel.center = CGPointMake(SCREEN_WIDTH * 0.75, SCREEN_HEIGHT * 0.8 + 40);
    [self.view addSubview:blueLabel];
    
    greenButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
//    greenButton.backgroundColor = [UIColor greenColor];
    [greenButton setBackgroundImage:[UIImage imageNamed:@"greenClickHand32.png"] forState:UIControlStateNormal];
    greenButton.center = CGPointMake(SCREEN_WIDTH * 0.25, SCREEN_HEIGHT * 0.8);
    [greenButton.layer setMasksToBounds:YES];
    [greenButton.layer setCornerRadius:25.0f];
    [greenButton.layer setBorderWidth:1.0f];
    [greenButton.layer setBorderColor:[AppUIModel UIUselessColor].CGColor];
    [greenButton addTarget:self action:@selector(greenButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:greenButton];
    
    yellowButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
//    yellowButton.backgroundColor = [UIColor orangeColor];
    [yellowButton setBackgroundImage:[UIImage imageNamed:@"orangeClickHand32.png"] forState:UIControlStateNormal];
    yellowButton.center = CGPointMake(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT * 0.8);
    [yellowButton.layer setMasksToBounds:YES];
    [yellowButton.layer setCornerRadius:25.0f];
    [yellowButton.layer setBorderWidth:1.0f];
    [yellowButton.layer setBorderColor:[AppUIModel UIUselessColor].CGColor];
    [yellowButton addTarget:self action:@selector(yellowButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:yellowButton];
    
    blueButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
//    blueButton.backgroundColor = [UIColor blueColor];
    [blueButton setBackgroundImage:[UIImage imageNamed:@"blueClickHand32.png"] forState:UIControlStateNormal];
    blueButton.center = CGPointMake(SCREEN_WIDTH * 0.75, SCREEN_HEIGHT * 0.8);
    [blueButton.layer setMasksToBounds:YES];
    [blueButton.layer setCornerRadius:25.0f];
    [blueButton.layer setBorderWidth:1.0f];
    [blueButton.layer setBorderColor:[AppUIModel UIUselessColor].CGColor];
    [blueButton addTarget:self action:@selector(blueButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:blueButton];
    
    greenLabel.hidden = YES;
    yellowLabel.hidden = YES;
    blueLabel.hidden = YES;
    greenButton.hidden = YES;
    yellowButton.hidden = YES;
    blueButton.hidden = YES;
    
    self.imageView.transform = ApplicationDelegate.angle;
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
        [MBProgressHUD showError:NSLocalizedString(@"您倒是歇一会儿啊", nil)];
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
        [MBProgressHUD showError:NSLocalizedString(@"您倒是歇一会儿啊", nil)];
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
        [MBProgressHUD showError:NSLocalizedString(@"您倒是歇一会儿啊", nil)];
    }
    

}

- (void)setButtonsEnableYes
{
    [greenButton setEnabled:YES];
    [yellowButton setEnabled:YES];
    [blueButton setEnabled:YES];
}

- (void)connectButtonAction:(UIButton *)sender
{
    ApplicationDelegate.isReplace = NO;
    
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

#pragma mark 开始旋转 / 暂停旋转 ／ 继续旋转图片方法
// 开始旋转图片
- (void)startAnimation
{
    ApplicationDelegate.isNeedTransform = NO;
    NSLog(@"isWorking 1 %d",ApplicationDelegate.isWorking);
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 25.0;
    rotationAnimation.repeatCount = HUGE_VALF;
    [self.imageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
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
    [self.view addSubview:_spinner];
    [_spinner showWhileExecutingSelector:@selector(longTask) onTarget:self withObject:nil completion:^{
        [self->_timer invalidate];
        self->_timer = nil;
    }];
}

- (void)longTask
{
    sleep(5);
}

//- (void)stopScanAction
//{
//    [ApplicationDelegate.manager stopScanPeripherals];
//    [self stop10sTimer];
//    [self stopWaitingView];
//}

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

// 设置蓝牙中心代理方法
- (void)connectDeviceC
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

- (void)R0106Action
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        NSLog(@"ApplicationDelegate.deviceIDString --->>> %@", ApplicationDelegate.deviceIDString);
        
        if ([ApplicationDelegate.deviceIDString isEqualToString:@"-"])
        {
            self->greenLabel.hidden = YES;
            self->yellowLabel.hidden = YES;
            self->blueLabel.hidden = YES;
            self->greenButton.hidden = YES;
            self->yellowButton.hidden = YES;
            self->blueButton.hidden = YES;
        }
        else
        {
            if ([[ApplicationDelegate.deviceIDString substringToIndex:3] isEqualToString:@"FK1"])
            {
                self->greenLabel.hidden = YES;
                self->yellowLabel.hidden = YES;
                self->blueLabel.hidden = YES;
                self->greenButton.hidden = YES;
                self->yellowButton.hidden = YES;
                self->blueButton.hidden = YES;
            }
            else
            {
                self->greenLabel.hidden = NO;
                self->yellowLabel.hidden = NO;
                self->blueLabel.hidden = NO;
                self->greenButton.hidden = NO;
                self->yellowButton.hidden = NO;
                self->blueButton.hidden = NO;
            }
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

- (void)R0101IdleNotificationAction
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if (!ApplicationDelegate.isReplace) {
            NSLog(@"isWorking 2 %d",ApplicationDelegate.isWorking);
            [self.imageView.layer removeAnimationForKey:@"rotationAnimation"];
            ApplicationDelegate.isNeedTransform = YES;
        }
    }];
}

- (void)R0101StopNotificationAction
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if (!ApplicationDelegate.isReplace) {
            NSLog(@"isWorking 3 %d",ApplicationDelegate.isWorking);
            [self.imageView.layer removeAnimationForKey:@"rotationAnimation"];
            ApplicationDelegate.isNeedTransform = YES;
        }
    }];
    
}

- (void)R0508DifferentNotificationAction
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if (!ApplicationDelegate.isReplace) {
            [UIView animateWithDuration:1.5 animations:^{
                self.imageView.alpha = 0;
            } completion:^(BOOL finished) {
                NSString *imageName = [[@"model" stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)ApplicationDelegate.modelID]] stringByAppendingString:@".png"];
                ApplicationDelegate.setModelID = (int)ApplicationDelegate.modelID;
                self.image = [UIImage imageNamed:imageName];
                self.imageView.image = self.image;
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
                [UIView animateWithDuration:1.5 animations:^{
                    self.imageView.alpha = 1;
                } completion:^(BOOL finished) {
                    NSLog(@"变换图片结束");
                    if (ApplicationDelegate.isWorking == YES)
                    {
                        [self startAnimation];
                    }
                }];
            }];
        }
    }];
}

- (void)R0509NotificationAction
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        NSLog(@"更换模式成功！");
        [UIView animateWithDuration:1.5 animations:^{
            self.imageView.alpha = 0;
        } completion:^(BOOL finished) {
            NSString *imageName = [[@"model" stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)ApplicationDelegate.setModelID]] stringByAppendingString:@".png"];
            self.image = [UIImage imageNamed:imageName];
            self.imageView.image = self.image;
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
            [UIView animateWithDuration:1.5 animations:^{
                self.imageView.alpha = 1;
            } completion:^(BOOL finished) {
                NSLog(@"变换图片结束");
                if (ApplicationDelegate.isNeedTransform && ApplicationDelegate.isConnectDevice == YES) {
                    ApplicationDelegate.isNeedTransform =  NO;
                    [self startAnimation];
                }
                ApplicationDelegate.isUseSetModelID = YES;
                ApplicationDelegate.isAbleSetModelID = YES;
                [self setButtonsEnableYes];
            }];
        }];
        
    }];
}

- (void)transformNotificationAction
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        // 旋转图片
        [UIView animateWithDuration:1.5 animations:^{
            self.imageView.alpha = 0;
        } completion:^(BOOL finished) {
            NSString *imageName = [[@"model" stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)ApplicationDelegate.modelID]] stringByAppendingString:@".png"];
            self.image = [UIImage imageNamed:imageName];
            self.imageView.image = self.image;
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
            [UIView animateWithDuration:1.5 animations:^{
                self.imageView.alpha = 1;
            } completion:^(BOOL finished) {
                NSLog(@"变换图片结束");
                if (ApplicationDelegate.isNeedTransform && ApplicationDelegate.isConnectDevice == YES) {
                    ApplicationDelegate.isNeedTransform =  NO;
                    [self startAnimation];
                }
            }];
        }];
    }];
}

- (void)disconnectDeviceAction
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if (!ApplicationDelegate.isReplace) {
            NSLog(@"isWorking 4 %d",ApplicationDelegate.isWorking);
            [self.imageView.layer removeAnimationForKey:@"rotationAnimation"];
            ApplicationDelegate.isNeedTransform = YES;
        }
    }];
    
}

- (void)isOnceConnectDevice
{
    if (ApplicationDelegate.isOnceConnectDevice == YES)
    {
        connectButton.userInteractionEnabled = NO;
        connectButton.backgroundColor = [AppUIModel UIUselessColor];
    }
    else
    {
        connectButton.userInteractionEnabled = YES;
        connectButton.backgroundColor = [AppUIModel UIViewMainColorI];
        greenLabel.hidden = YES;
        yellowLabel.hidden = YES;
        blueLabel.hidden = YES;
        greenButton.hidden = YES;
        yellowButton.hidden = YES;
        blueButton.hidden = YES;
    }
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

- (void)viewWillAppear:(BOOL)animated
{
    ApplicationDelegate.isReplace = NO;
    NSLog(@"isWorking 5 %d",ApplicationDelegate.isWorking);
    
    self.tabBarController.tabBar.hidden = YES;
    [self isOnceConnectDevice];
    [self R0106Action];
    
    if (ApplicationDelegate.isUseSetModelID)
    {
        NSString *imageName = [[@"model" stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)ApplicationDelegate.setModelID]] stringByAppendingString:@".png"];
        self.image = [UIImage imageNamed:imageName];
        self.imageView.image = self.image;
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
        NSString *imageName = [[@"model" stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)ApplicationDelegate.modelID]] stringByAppendingString:@".png"];
        self.image = [UIImage imageNamed:imageName];
        self.imageView.image = self.image;
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
    
    
    operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(startAnimation) object:nil];
    if (ApplicationDelegate.isWorking == YES)
    {
        [operation start];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"isWorking 6 %d",ApplicationDelegate.isWorking);
    [self.imageView.layer removeAnimationForKey:@"rotationAnimation"];
    ApplicationDelegate.isNeedTransform = YES;
    ApplicationDelegate.angle = self.imageView.transform;
    [operation cancel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
