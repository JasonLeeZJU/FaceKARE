//
//  HInformationViewController.m
//  FaceKARE
//
//  Created by Anan on 2017/4/25.
//  Copyright © 2017年 Anan. All rights reserved.
//

#import "HInformationViewController.h"
#import "AppDelegate.h"
#import "AppUIModel.h"
#import "HInformationTableViewCell.h"
#import "HInformationDetailViewController.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define TABBAR_WIDTH [self.tabBarController.tabBar bounds].size.height

@interface HInformationViewController ()<UITableViewDelegate, UITableViewDataSource>

// tableView
@property (nonatomic, strong) UITableView *informationTableView;
// 主色调背景
@property (nonatomic, strong) UIView *informationView;

@end

@implementation HInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置页面 navigation 标题
    self.navigationItem.title = NSLocalizedString(@"informationViewNavigationTitle", nil);
    
    // 设置背景颜色
    self.view.backgroundColor = [AppUIModel UIViewBackgroundColor];
    
    // 设置返回按钮
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc] init];
    backbutton.title = @"";
    self.navigationItem.backBarButtonItem = backbutton;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    // 设置 tableview
    self.informationTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TABBAR_WIDTH) style:UITableViewStylePlain];
    self.informationTableView.delegate = self;
    self.informationTableView.dataSource = self;
    [self.informationTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];   //取消 cell 之间的横线
    self.informationTableView.backgroundColor = [AppUIModel UIViewBackgroundColor];
    [self.informationTableView setShowsVerticalScrollIndicator:NO];    //取消滑条
    [self.view addSubview:self.informationTableView];
    
    // 设置 view
    self.informationView = [[UIView alloc] initWithFrame:CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT + 64)];
    self.informationView.backgroundColor = [AppUIModel UIViewMainColorI];
    self.informationView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.informationView];
}

#pragma mark -tableview设置
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [ApplicationDelegate.informationArray count];
}

// row数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

// tableView内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HInformationTableViewCell *informationCell = [HInformationTableViewCell cellWithTableView:self.informationTableView];
    informationCell.informationNumber = indexPath.section;
    return informationCell;

}

// section 头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 6;
}

// row高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

// cell 点击操作
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HInformationDetailViewController *informationDetailVC = [[HInformationDetailViewController alloc] init];
    informationDetailVC.informationContent = [[ApplicationDelegate.informationArray objectAtIndex:indexPath.section] valueForKey:@"content"];
    [self.navigationController pushViewController:informationDetailVC animated:YES];
    
    // 取消选中效果
    [tableView cellForRowAtIndexPath:indexPath].selected = NO;
}

#pragma mark - tableview滑动事件
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // tableView 下位，根据偏移量计算出下位的高度
    CGFloat downHeight = -scrollView.contentOffset.y;
    // 根据下拉高度计算出 homeView 拉伸的高度
    CGRect informationViewframe = self.informationView.frame;
    informationViewframe.size.height = SCREEN_HEIGHT + downHeight;
    if (downHeight >= 64) {
        self.informationView.frame = informationViewframe;
    }
    else
    {
        self.informationView.frame = CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT + 64);
    }
}

#pragma mark - 页面将要打开
- (void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
