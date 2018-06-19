//
//  HContactUsViewController.m
//  FaceKARE
//
//  Created by Anan on 2017/5/2.
//  Copyright © 2017年 Anan. All rights reserved.
//

#import "HContactUsViewController.h"
#import <MessageUI/MessageUI.h>
#import <MapKit/MapKit.h>
#import "AppUIModel.h"
#import "AppDelegate.h"
#import "HWeChatViewController.h"
#import "HMapViewController.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

@interface HContactUsViewController ()<MFMailComposeViewControllerDelegate>
{
    UILabel *tipLabel;
    UIView *backgroundView;
    UIView *phoneView;
    UIView *emailView;
    UIView *wechatView;
    UIView *mapView;
    UIButton *phoneButton;
    UIButton *emailButton;
    UIButton *wechatButton;
    UIButton *mapButton;
    CLPlacemark *firstPlacemark;
}

// 主色调背景
@property (nonatomic, strong) UIView *contactView;

@end

@implementation HContactUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置页面 navigation 标题
    self.navigationItem.title = NSLocalizedString(@"contactUsViewNavigationTitle", nil);
    
    // 设置背景颜色
    self.view.backgroundColor = [AppUIModel UIViewBackgroundColor];
    
    // 设置返回按钮
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc] init];
    backbutton.title = @"";
    self.navigationItem.backBarButtonItem = backbutton;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    // 设置 view
    self.contactView = [[UIView alloc] initWithFrame:CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT + 64)];
    self.contactView.backgroundColor = [AppUIModel UIViewMainColorI];
    self.contactView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.contactView];
    
    tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 84, SCREEN_WIDTH - 60, 30)];
    tipLabel.textColor = [AppUIModel UIViewNormalColor];
    tipLabel.font = [AppUIModel UIViewNormalFont];
    [tipLabel setTextAlignment:NSTextAlignmentLeft];
    tipLabel.text = NSLocalizedString(@"contactTipLabel", nil);
    tipLabel.numberOfLines = 0;
    CGSize tipLabelSize = [tipLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH - 60, MAXFLOAT)];
    CGRect tipLabelFrame = tipLabel.frame;
    tipLabelFrame.size.height = tipLabelSize.height;
    [tipLabel setFrame:tipLabelFrame];
    [self.view addSubview:tipLabel];
    
    backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 0.5)];
    backgroundView.backgroundColor = [AppUIModel UIUselessColor];
    CGPoint backgroungViewCenterPoint = CGPointMake(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT * 0.5);
    backgroundView.center = backgroungViewCenterPoint;
    [self.view addSubview:backgroundView];
    
    CGFloat backgroundViewWidth = SCREEN_WIDTH - 1;
    CGFloat backgroundViewHeight = SCREEN_WIDTH * 0.5 - 3;
    
    // phoneView
    phoneView = [[UIView alloc] initWithFrame:CGRectMake(0, 1, backgroundViewWidth * 0.5, backgroundViewHeight * 0.5)];
    phoneView.backgroundColor = [AppUIModel UIViewBackgroundColor];
    [backgroundView addSubview:phoneView];
    phoneButton = [[UIButton alloc] initWithFrame:CGRectMake((backgroundViewWidth - backgroundViewHeight) * 0.25, 0, backgroundViewHeight * 0.5, backgroundViewHeight * 0.5)];
    [phoneButton setImage:[UIImage imageNamed:@"phone.png"] forState:UIControlStateNormal];
    [phoneButton addTarget:self action:@selector(phoneAction) forControlEvents:UIControlEventTouchUpInside];
    [phoneView addSubview:phoneButton];
    
    // emailView
    emailView = [[UIView alloc] initWithFrame:CGRectMake(backgroundViewWidth * 0.5 + 1, 1, backgroundViewWidth * 0.5, backgroundViewHeight * 0.5)];
    emailView.backgroundColor = [AppUIModel UIViewBackgroundColor];
    [backgroundView addSubview:emailView];
    emailButton = [[UIButton alloc] initWithFrame:CGRectMake((backgroundViewWidth - backgroundViewHeight) * 0.25, 0, backgroundViewHeight * 0.5, backgroundViewHeight * 0.5)];
    [emailButton setImage:[UIImage imageNamed:@"mail.png"] forState:UIControlStateNormal];
    [emailButton addTarget:self action:@selector(emailAction) forControlEvents:UIControlEventTouchUpInside];
    [emailView addSubview:emailButton];
    
    // wechatView
    wechatView = [[UIView alloc] initWithFrame:CGRectMake(0, backgroundViewHeight * 0.5 + 2, backgroundViewWidth * 0.5, backgroundViewHeight * 0.5)];
    wechatView.backgroundColor = [AppUIModel UIViewBackgroundColor];
    [backgroundView addSubview:wechatView];
    wechatButton = [[UIButton alloc] initWithFrame:CGRectMake((backgroundViewWidth - backgroundViewHeight) * 0.25, 0, backgroundViewHeight * 0.5, backgroundViewHeight * 0.5)];
    [wechatButton setImage:[UIImage imageNamed:@"wechat.png"] forState:UIControlStateNormal];
    [wechatButton addTarget:self action:@selector(wechatAction) forControlEvents:UIControlEventTouchUpInside];
    [wechatView addSubview:wechatButton];
    
    // mapView
    mapView = [[UIView alloc] initWithFrame:CGRectMake(backgroundViewWidth * 0.5 + 1, backgroundViewHeight * 0.5 + 2, backgroundViewWidth * 0.5, backgroundViewHeight * 0.5)];
    mapView.backgroundColor = [AppUIModel UIViewBackgroundColor];
    [backgroundView addSubview:mapView];
    mapButton = [[UIButton alloc] initWithFrame:CGRectMake((backgroundViewWidth - backgroundViewHeight) * 0.25, 0, backgroundViewHeight * 0.5, backgroundViewHeight * 0.5)];
    [mapButton setImage:[UIImage imageNamed:@"contact.png"] forState:UIControlStateNormal];
    [mapButton addTarget:self action:@selector(mapAction) forControlEvents:UIControlEventTouchUpInside];
    [mapView addSubview:mapButton];
}

- (void)phoneAction
{
    NSMutableString * str = [[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"0571-56660086"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{UIApplicationOpenURLOptionsSourceApplicationKey : @YES} completionHandler:^(BOOL success) {
        if (success)
        {
            NSLog(@"成功");
        }
        else
        {
            NSLog(@"失败");
        }
    }];
}

- (void)emailAction
{
    [self sendMailTo];
}

- (void)wechatAction
{
    HWeChatViewController *weChatVC = [[HWeChatViewController alloc] init];
    [self.navigationController pushViewController:weChatVC animated:YES];
}

- (void)mapAction
{
    HMapViewController *mapVC = [[HMapViewController alloc] init];
    [self.navigationController pushViewController:mapVC animated:YES];
//    NSString *oreillyAddress = @"中国浙江省杭州市西湖区三墩镇西湖科技园金蓬街368号同硕科技园";
//    CLGeocoder *myGeocoder = [[CLGeocoder alloc] init];
//    [myGeocoder geocodeAddressString:oreillyAddress completionHandler:^(NSArray *placemarks, NSError *error) {
//        if ([placemarks count] > 0 && error == nil) {
//            NSLog(@"Found %lu placemark(s).", (unsigned long)[placemarks count]);
//            firstPlacemark = [placemarks objectAtIndex:0];
//            NSLog(@"Longitude = %f", firstPlacemark.location.coordinate.longitude);
//            NSLog(@"Latitude = %f", firstPlacemark.location.coordinate.latitude);
//        }
//        else if ([placemarks count] == 0 && error == nil) {
//            NSLog(@"Found no placemarks.");
//        } else if (error != nil) {
//            NSLog(@"An error occurred = %@", error);
//        }
//    }];
//    CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(firstPlacemark.location.coordinate.latitude, firstPlacemark.location.coordinate.longitude);
//    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
//    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:loc addressDictionary:nil]];
//    [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
//                   launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
//                                   MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
}

#pragma mark - 发送邮件
- (void)sendMailTo
{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil)
    {
        if ([mailClass canSendMail])
        {
            [self displayComposerSheet];
            return;
        }
    }
    [self launchMailAppOnDevice];
}

-(void)launchMailAppOnDevice
{
    NSString *recipients = @"mailto:support@triowave.co";
    NSString *body = @"";
    NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
    email = [email stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email] options:@{UIApplicationOpenURLOptionsSourceApplicationKey : @YES} completionHandler:^(BOOL success) {
        if (success)
        {
            NSLog(@"成功");
        }
        else
        {
            NSLog(@"失败");
        }
    }];
}

-(void)displayComposerSheet
{
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[AppUIModel UIViewMainColorI]}];
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];/*MFMailComposeViewController邮件发送选择器*/
    picker.mailComposeDelegate = self;
    [picker setSubject:NSLocalizedString(@"emailTitle", nil)];    //emailpicker标题主题行
    picker.navigationBar.tintColor = [AppUIModel UIViewMainColorI];
    NSArray *toRecipients = [NSArray arrayWithObject:@"support@triowave.co"];
    [picker setToRecipients:toRecipients];
    [picker setMessageBody:@"" isHTML:NO];
    [self.navigationController presentViewController:picker animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled: // 用户取消编辑
            NSLog(@"用户取消编辑...");
            break;
        case MFMailComposeResultSaved: // 用户保存邮件
            NSLog(@"用户保存邮件...");
            break;
        case MFMailComposeResultSent: // 用户点击发送
            NSLog(@"用户点击发送...");
            break;
        case MFMailComposeResultFailed: // 用户尝试保存或发送邮件失败
            NSLog(@"用户尝试保存或发送邮件失败: %@...", [error localizedDescription]);
            break;
    }
    // 关闭邮件发送视图
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 页面将要打开
- (void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20],NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
