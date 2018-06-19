//
//  HWeChatViewController.m
//  FaceKARE
//
//  Created by Anan on 2017/5/4.
//  Copyright © 2017年 Anan. All rights reserved.
//

#import "HWeChatViewController.h"
#import "AppUIModel.h"
#import "AppDelegate.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

@interface HWeChatViewController ()
{
    UILabel *tipLabel;
    UIImageView *qrCodeImageView;
    UIImage *qrCodeImage;
    UIAlertController *alertController;
}

// 主色调背景
@property (nonatomic, strong) UIView *contactView;

@end

@implementation HWeChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置页面 navigation 标题
    self.navigationItem.title = NSLocalizedString(@"focusOnUsNavigationTitle", nil);
    
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
    
    tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 60, 30)];
    tipLabel.textColor = [AppUIModel UIViewNormalColor];
    tipLabel.font = [AppUIModel UIViewTitleFont];
    [tipLabel setTextAlignment:NSTextAlignmentLeft];
    tipLabel.text = NSLocalizedString(@"weChatTipLabel", nil);
    tipLabel.numberOfLines = 0;
    CGSize tipLabelSize = [tipLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH - 60, MAXFLOAT)];
    CGRect tipLabelFrame = tipLabel.frame;
    tipLabelFrame.size.height = tipLabelSize.height;
    [tipLabel setFrame:tipLabelFrame];
    CGPoint tipLabelCenterPoint = CGPointMake(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT * 0.5 + SCREEN_WIDTH * 0.25 + tipLabelSize.height * 0.5 + 20);
    tipLabel.center = tipLabelCenterPoint;
    [tipLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:tipLabel];
    
    qrCodeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH * 0.5, SCREEN_WIDTH * 0.5)];
    CGPoint centerPoint = CGPointMake(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT * 0.5);
    qrCodeImage = [UIImage imageNamed:@"weChatQrCode.png"];
    qrCodeImageView.image = qrCodeImage;
    [qrCodeImageView setUserInteractionEnabled:YES];
    qrCodeImageView.backgroundColor = [UIColor redColor];
    qrCodeImageView.center = centerPoint;
    [qrCodeImageView.layer setMasksToBounds:YES];
    [qrCodeImageView.layer setCornerRadius:20];
    [self.view addSubview:qrCodeImageView];
    
    UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPassAction:)];
    longPress.minimumPressDuration = 1.0;
    [qrCodeImageView addGestureRecognizer:longPress];
}

- (void)longPassAction:(UITapGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您要保存当前图片到相册中吗？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *yes = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImageWriteToSavedPhotosAlbum(self->qrCodeImage, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
        }];
        UIAlertAction *no = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:no];
        [alertController addAction:yes];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
}

#pragma mark - 页面将要打开
- (void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
