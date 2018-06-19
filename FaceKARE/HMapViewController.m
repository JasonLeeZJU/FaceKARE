//
//  HMapViewController.m
//  FaceKARE
//
//  Created by Anan on 2017/5/10.
//  Copyright © 2017年 Anan. All rights reserved.
//

#import "HMapViewController.h"
#import "AppUIModel.h"
#import "AppDelegate.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

@interface HMapViewController ()<UIScrollViewDelegate>
{
    UIImageView *MapImageView;
    UILabel *label;
    UIButton *copyButton;
}

// 主色调背景
@property (nonatomic, strong) UIView *mapView;

@property (nonatomic, strong) UIPasteboard *pasteBoard;

// 提示
@property (nonatomic, strong) UIAlertController *companyAddressAC;

@end

@implementation HMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置页面 navigation 标题
    self.navigationItem.title = NSLocalizedString(@"companyAddressNavigationTitle", nil);
    
    // 设置背景颜色
    self.view.backgroundColor = [AppUIModel UIViewBackgroundColor];
    
    // 设置返回按钮
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc] init];
    backbutton.title = @"";
    self.navigationItem.backBarButtonItem = backbutton;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    // 设置 view
    self.mapView = [[UIView alloc] initWithFrame:CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT + 64)];
    self.mapView.backgroundColor = [AppUIModel UIViewMainColorI];
    self.mapView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.mapView];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(30, 0, SCREEN_WIDTH - 60, SCREEN_HEIGHT * 0.5)];
    scrollView.backgroundColor = [AppUIModel UIViewBackgroundColor];
    CGPoint centerPoint = CGPointMake(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT * 0.5);
    scrollView.center = centerPoint;
    [scrollView.layer setMasksToBounds:YES];
    [scrollView.layer setCornerRadius:20];
    [self.view addSubview:scrollView];
    
    // 裁剪 image
    MapImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 60, SCREEN_HEIGHT * 0.5)];
    UIImage *image = [UIImage imageNamed:@"map.png"];
    if (image.size.height > image.size.width) {
        CGImageRef cgRef = image.CGImage;
        CGImageRef imageRef = CGImageCreateWithImageInRect(cgRef, CGRectMake(0, (image.size.height - image.size.width) * 0.5, image.size.width, image.size.width * (SCREEN_HEIGHT * 0.5) / (SCREEN_WIDTH - 60)));
        UIImage *thumbScale = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
        image = thumbScale;
    }
    else if (image.size.height < image.size.width)
    {
        CGImageRef cgRef = image.CGImage;
        CGImageRef imageRef = CGImageCreateWithImageInRect(cgRef, CGRectMake((image.size.width - image.size.height) * 0.5, 0, image.size.height * (SCREEN_WIDTH - 60) / (SCREEN_HEIGHT * 0.5), image.size.height));
        UIImage *thumbScale = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
        image = thumbScale;
    }
    [MapImageView.layer setMasksToBounds:YES];
    [MapImageView.layer setCornerRadius:20];
    MapImageView.image = image;
    [scrollView addSubview:MapImageView];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(30, SCREEN_HEIGHT * 0.75 + 20, SCREEN_WIDTH - 60, 30)];
    label.textColor = [AppUIModel UIViewNormalColor];
    label.font = [AppUIModel UIViewNormalFont];
    [label setTextAlignment:NSTextAlignmentLeft];
    label.text = [NSLocalizedString(@"companyAddress", nil) stringByAppendingString:NSLocalizedString(@"companyAddressDetail", nil)];
    label.numberOfLines = 0;
    CGSize labelSize = [label sizeThatFits:CGSizeMake(SCREEN_WIDTH - 60, MAXFLOAT)];
    CGRect labelFrame = label.frame;
    labelFrame.size.height = labelSize.height;
    [label setFrame:labelFrame];
    label.userInteractionEnabled = YES;
    // 添加点击事件
    UILongPressGestureRecognizer *longPress =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
    // 最短长按时间
    longPress.minimumPressDuration = 2;
    // 允许移动最大距离
    longPress.allowableMovement = 100;
    // 添加到指定视图
    [label addGestureRecognizer:longPress];
    [self.view addSubview:label];
    
    [self pinchGestureRecognizer];
    
}

//长按事件
-(void)longPressAction:(UILongPressGestureRecognizer *)longPress
{
    //对于长安有开始和结束状态
    if (longPress.state == UIGestureRecognizerStateBegan) {
        self.companyAddressAC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"connectPrompt", nil) message:NSLocalizedString(@"isCopy", nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *left = [UIAlertAction actionWithTitle:NSLocalizedString(@"copyCancel", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *right = [UIAlertAction actionWithTitle:NSLocalizedString(@"copyConfirm", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIPasteboard *pboard = [UIPasteboard generalPasteboard];
            pboard.string = NSLocalizedString(@"companyAddressDetail", nil);
        }];
        [self.companyAddressAC addAction:left];
        [self.companyAddressAC addAction:right];
        [self presentViewController:self.companyAddressAC animated:YES completion:nil];
    }
}

#pragma 捏合手势
-(void)pinchGestureRecognizer
{
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchAction:)];
    //添加到指定视图
    MapImageView.userInteractionEnabled = YES;
    [MapImageView addGestureRecognizer:pinch];
    
}
//添加捏合事件
-(void)pinchAction:(UIPinchGestureRecognizer *)pinch
{
    //通过 transform(改变) 进行视图的视图的捏合
    if (MapImageView.transform.a <= 2 && MapImageView.transform.a >= 0.5) {
        MapImageView.transform = CGAffineTransformScale(MapImageView.transform, pinch.scale, pinch.scale);
    }
    if (MapImageView.transform.a > 2 && pinch.scale < 1) {
        MapImageView.transform = CGAffineTransformScale(MapImageView.transform, pinch.scale, pinch.scale);
    }
    if (MapImageView.transform.a < 0.5 && pinch.scale > 1) {
        MapImageView.transform = CGAffineTransformScale(MapImageView.transform, pinch.scale, pinch.scale);
    }
    //设置比例 为 1
    pinch.scale = 1;
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
