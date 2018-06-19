//
//  HFAQListViewController.m
//  FaceKARE
//
//  Created by Anan on 2017/5/2.
//  Copyright © 2017年 Anan. All rights reserved.
//

#import "HFAQListViewController.h"
#import "AppUIModel.h"
#import "AppDelegate.h"
#import "HFAQDetailStyleDefauleViewController.h"
#import "HFAQDetailStyle1ViewController.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

@interface HFAQListViewController ()<UITableViewDelegate, UITableViewDataSource>

// tableView
@property (nonatomic, strong) UITableView *FAQListTableView;
// 主色调背景
@property (nonatomic, strong) UIView *FAQListView;

@end

@implementation HFAQListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置页面 navigation 标题
    self.navigationItem.title = NSLocalizedString(@"FAQListViewNavigationTitle", nil);
    
    // 设置背景颜色
    self.view.backgroundColor = [AppUIModel UIViewBackgroundColor];
    
    // 设置返回按钮
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc] init];
    backbutton.title = @"";
    self.navigationItem.backBarButtonItem = backbutton;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    // 设置 tableview
    self.FAQListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.FAQListTableView.delegate = self;
    self.FAQListTableView.dataSource = self;
    [self.FAQListTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];   //取消 cell 之间的横线
    self.FAQListTableView.backgroundColor = [AppUIModel UIViewBackgroundColor];
    [self.FAQListTableView setShowsVerticalScrollIndicator:NO];    //取消滑条
    self.FAQListTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];  //不显示多余 cell
    [self.view addSubview:self.FAQListTableView];
    
    // 设置 view
    self.FAQListView = [[UIView alloc] initWithFrame:CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT + 64)];
    self.FAQListView.backgroundColor = [AppUIModel UIViewMainColorI];
    self.FAQListView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.FAQListView];
}

#pragma mark -tableview设置
// section 数量
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [ApplicationDelegate.FAQListArray count];
}

// row 数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

// tableView 内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifiter = @"settingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifiter];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifiter];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.textColor = [AppUIModel UIViewNormalColor];
    cell.textLabel.font = [AppUIModel UIViewNormalFont];
    cell.textLabel.text = [[ApplicationDelegate.FAQListArray objectAtIndex:indexPath.section] valueForKey:@"question"];
    return cell;
}

// section 头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 6;
}

// row 高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

// cell 点击操作
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        HFAQDetailStyle1ViewController *FAQDetailStyle1VC = [[HFAQDetailStyle1ViewController alloc] init];
        FAQDetailStyle1VC.questionString = [[ApplicationDelegate.FAQListArray objectAtIndex:indexPath.section] valueForKey:@"question"];
//        FAQDetailStyle1VC.answerString = [[ApplicationDelegate.FAQListArray objectAtIndex:indexPath.section] valueForKey:@"answer"];
        [self.navigationController pushViewController:FAQDetailStyle1VC animated:YES];
    }
    else
    {
        HFAQDetailStyleDefauleViewController *FAQDetailStyleDafauleVC = [[HFAQDetailStyleDefauleViewController alloc] init];
        FAQDetailStyleDafauleVC.questionString = [[ApplicationDelegate.FAQListArray objectAtIndex:indexPath.section] valueForKey:@"question"];
        FAQDetailStyleDafauleVC.answerString = [[ApplicationDelegate.FAQListArray objectAtIndex:indexPath.section] valueForKey:@"answer"];
        [self.navigationController pushViewController:FAQDetailStyleDafauleVC animated:YES];
    }
    
    // 取消选中效果
    [tableView cellForRowAtIndexPath:indexPath].selected = NO;
}

#pragma mark - tableview滑动事件
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // tableView 下位，根据偏移量计算出下位的高度
    CGFloat downHeight = -scrollView.contentOffset.y;
    // 根据下拉高度计算出 homeView 拉伸的高度
    CGRect settingViewframe = self.FAQListView.frame;
    settingViewframe.size.height = SCREEN_HEIGHT + downHeight;
    if (downHeight >= 64) {
        self.FAQListView.frame = settingViewframe;
    }
    else
    {
        self.FAQListView.frame = CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT + 64);
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
