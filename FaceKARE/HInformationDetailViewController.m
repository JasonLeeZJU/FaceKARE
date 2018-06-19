//
//  HInformationDetailViewController.m
//  FaceKARE
//
//  Created by Anan on 2017/4/29.
//  Copyright © 2017年 Anan. All rights reserved.
//

#import "HInformationDetailViewController.h"
#import "AppUIModel.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

@interface HInformationDetailViewController ()

// wenView
@property (nonatomic, strong) UIWebView *informationDetailWebView;
// 主色调背景
@property (nonatomic, strong) UIView *informationDetailView;

@end

@implementation HInformationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置页面 navigation 标题
    self.navigationItem.title = NSLocalizedString(@"informationViewNavigationTitle", nil);
    
    [self.view setBackgroundColor:[AppUIModel UIViewBackgroundColor]];
    
    // 设置返回按钮
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc] init];
    backbutton.title = @"";
    self.navigationItem.backBarButtonItem = backbutton;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    // 设置 view
    self.informationDetailView = [[UIView alloc] initWithFrame:CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT + 64)];
    self.informationDetailView.backgroundColor = [AppUIModel UIViewMainColorI];
    self.informationDetailView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.informationDetailView];
    
    [self creatWebView];
}

- (void)creatWebView {
    self.informationDetailWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    self.informationDetailWebView.backgroundColor = [AppUIModel UIViewMainColorI];
    [self.view addSubview:self.informationDetailWebView];
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:self.informationContent ofType:@"html"];
    NSLog(@">>> informationContent %@", self.informationContent);
    NSString *htmlcont = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    [self.informationDetailWebView loadHTMLString:htmlcont baseURL:baseURL];
}

#pragma mark - tableview滑动事件
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // tableView 下位，根据偏移量计算出下位的高度
    CGFloat downHeight = -scrollView.contentOffset.y;
    // 根据下拉高度计算出 homeView 拉伸的高度
    CGRect homeViewframe = self.informationDetailView.frame;
    homeViewframe.size.height = SCREEN_HEIGHT + downHeight;
    if (downHeight >= 64) {
        self.informationDetailView.frame = homeViewframe;
    } else {
        self.informationDetailView.frame = CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT + 64);
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
