//
//  HSettingViewController.m
//  FaceKARE
//
//  Created by Anan on 2017/4/25.
//  Copyright © 2017年 Anan. All rights reserved.
//

#import "HSettingViewController.h"
#import "AppUIModel.h"
#import "AppDelegate.h"
#import "HVersionViewController.h"
#import "HFAQListViewController.h"
#import "HReplaceViewController.h"
#import "HContactUsViewController.h"
#import <MessageUI/MessageUI.h>
#import <MapKit/MapKit.h>

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define TABBAR_WIDTH [self.tabBarController.tabBar bounds].size.height

@interface HSettingViewController ()<UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate>

// tableView
@property (nonatomic, strong) UITableView *settingTableView;
// 主色调背景
@property (nonatomic, strong) UIView *settingView;

@end

@implementation HSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 设置页面 navigation 标题
    self.navigationItem.title = NSLocalizedString(@"settingViewNavigationTitle", nil);
    
    // 设置背景颜色
    self.view.backgroundColor = [AppUIModel UIViewBackgroundColor];
    
    // 设置返回按钮
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc] init];
    backbutton.title = @"";
    self.navigationItem.backBarButtonItem = backbutton;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    // 设置 tableview
    self.settingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TABBAR_WIDTH) style:UITableViewStylePlain];
    self.settingTableView.delegate = self;
    self.settingTableView.dataSource = self;
    [self.settingTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];   //取消 cell 之间的横线
    self.settingTableView.backgroundColor = [AppUIModel UIViewBackgroundColor];
    [self.settingTableView setShowsVerticalScrollIndicator:NO];    //取消滑条
    self.settingTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];  //不显示多余 cell
    [self.view addSubview:self.settingTableView];
    
    // 设置 view
    self.settingView = [[UIView alloc] initWithFrame:CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT + 64)];
    self.settingView.backgroundColor = [AppUIModel UIViewMainColorI];
    self.settingView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.settingView];
}

#pragma mark -tableview设置
// section 数量
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [ApplicationDelegate.settingArray count];
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
    UIImage *image = [UIImage imageNamed:[[ApplicationDelegate.settingArray objectAtIndex:indexPath.section] valueForKey:@"image"]];
    cell.imageView.image = image;
    [cell.imageView setBounds:CGRectMake(0, 0, 20, 20)];
    cell.textLabel.text = [[ApplicationDelegate.settingArray objectAtIndex:indexPath.section] valueForKey:@"name"];
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
    if (indexPath.section == 0)
    {
        HVersionViewController *versionVC = [[HVersionViewController alloc] init];
        [self.navigationController pushViewController:versionVC animated:YES];
    }
    else if (indexPath.section == 1)
    {
        HFAQListViewController *FAQListVC = [[HFAQListViewController alloc] init];
        [self.navigationController pushViewController:FAQListVC animated:YES];
    }
//    else if (indexPath.section == 2)
//    {
//        HReplaceViewController *replaceVC = [[HReplaceViewController alloc] init];
//        [self.navigationController pushViewController:replaceVC animated:YES];
//    }
    else if (indexPath.section == 2)
    {
        if ([AppUIModel UIViewIsChinese] == YES) {
            HContactUsViewController *contactUsVC = [[HContactUsViewController alloc] init];
            [self.navigationController pushViewController:contactUsVC animated:YES];
        }
        else
        {
            [self sendMailTo];
        }
    }
    
    // 取消选中效果
    [tableView cellForRowAtIndexPath:indexPath].selected = NO;
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

#pragma mark - tableview滑动事件
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // tableView 下位，根据偏移量计算出下位的高度
    CGFloat downHeight = -scrollView.contentOffset.y;
    // 根据下拉高度计算出 homeView 拉伸的高度
    CGRect settingViewframe = self.settingView.frame;
    settingViewframe.size.height = SCREEN_HEIGHT + downHeight;
    if (downHeight >= 64) {
        self.settingView.frame = settingViewframe;
    }
    else
    {
        self.settingView.frame = CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT + 64);
    }
}

#pragma mark - 页面将要打开
- (void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20],NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
