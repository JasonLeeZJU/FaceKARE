//
//  HBannerDetailViewController.m
//  FaceKARE
//
//  Created by Anan on 2017/5/18.
//  Copyright © 2017年 Anan. All rights reserved.
//

#import "HBannerDetailViewController.h"
#import "AppUIModel.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

@interface HBannerDetailViewController ()

// wenView
@property (nonatomic, strong) UIWebView *bannerDetailWebView;
// 主色调背景
@property (nonatomic, strong) UIView *bannerDetailView;

@end

@implementation HBannerDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置页面 navigation 标题
    self.navigationItem.title = self.bannerNavigationTitle;
    
    [self.view setBackgroundColor:[AppUIModel UIViewBackgroundColor]];
    
    // 设置返回按钮
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc] init];
    backbutton.title = @"";
    self.navigationItem.backBarButtonItem = backbutton;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    // 设置 view
    self.bannerDetailView = [[UIView alloc] initWithFrame:CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT + 64)];
    self.bannerDetailView.backgroundColor = [AppUIModel UIViewMainColorI];
    self.bannerDetailView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.bannerDetailView];
    
    [self creatWebView];
    
}

- (void)creatWebView
{
    self.bannerDetailWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    self.bannerDetailWebView.backgroundColor = [AppUIModel UIViewMainColorI];
    [self.view addSubview:self.bannerDetailWebView];
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:self.bannerContent ofType:@"html"];
    NSString *htmlcont = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    [self.bannerDetailWebView loadHTMLString:htmlcont baseURL:baseURL];
}

#pragma mark - tableview滑动事件
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // tableView 下位，根据偏移量计算出下位的高度
    CGFloat downHeight = -scrollView.contentOffset.y;
    // 根据下拉高度计算出 homeView 拉伸的高度
    CGRect homeViewframe = self.bannerDetailView.frame;
    homeViewframe.size.height = SCREEN_HEIGHT + downHeight;
    if (downHeight >= 64) {
        self.bannerDetailView.frame = homeViewframe;
    }
    else
    {
        self.bannerDetailView.frame = CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT + 64);
    }
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
