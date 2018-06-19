//
//  HVersionViewController.m
//  FaceKARE
//
//  Created by Anan on 2017/5/2.
//  Copyright © 2017年 Anan. All rights reserved.
//

#import "HVersionViewController.h"
#import "AppUIModel.h"
#import "AppDelegate.h"
#import "HDeviceInformationTableViewCell.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

@interface HVersionViewController ()<UITableViewDelegate, UITableViewDataSource>

// tableView
@property (nonatomic, strong) UITableView *versionTableView;
// 主色调背景
@property (nonatomic, strong) UIView *versionView;

@end

@implementation HVersionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置页面 navigation 标题
    self.navigationItem.title = NSLocalizedString(@"VersionViewNavigationTitle", nil);
    
    // 设置背景颜色
    self.view.backgroundColor = [AppUIModel UIViewBackgroundColor];
    
    // 设置返回按钮
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc] init];
    backbutton.title = @"";
    self.navigationItem.backBarButtonItem = backbutton;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    // 设置 tableview
    self.versionTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.versionTableView.delegate = self;
    self.versionTableView.dataSource = self;
    [self.versionTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];   //取消 cell 之间的横线
    self.versionTableView.backgroundColor = [AppUIModel UIViewBackgroundColor];
    [self.versionTableView setShowsVerticalScrollIndicator:NO];    //取消滑条
    self.versionTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];  //不显示多余 cell
    [self.view addSubview:self.versionTableView];
    
    // 设置 view
    self.versionView = [[UIView alloc] initWithFrame:CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT + 64)];
    self.versionView.backgroundColor = [AppUIModel UIViewMainColorI];
    self.versionView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.versionView];
}

#pragma mark -tableview设置
// section 数量
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

// row 数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

// tableView 内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *identifiter = @"refreshCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifiter];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifiter];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.textColor = [AppUIModel UIViewNormalColor];
        cell.textLabel.font = [AppUIModel UIViewNormalFont];
        UIImage *image = [UIImage imageNamed:@"refresh32.png"];
        cell.imageView.image = image;
        cell.textLabel.text = NSLocalizedString(@"version", nil);
        cell.detailTextLabel.textColor = [AppUIModel UIUselessColor];
        cell.detailTextLabel.font = [AppUIModel UIViewNormalFont];
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        cell.detailTextLabel.text = version;
        return cell;
    }
    else
    {
        HDeviceInformationTableViewCell *informationCell = [HDeviceInformationTableViewCell cellWithTableView:self.versionTableView];
        informationCell.imageName = @"information32.png";
        informationCell.deviceIDString = ApplicationDelegate.deviceIDString;
        informationCell.firmwareString = ApplicationDelegate.firmwareString;
        return informationCell;
    }
}

// section 头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

// row高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 50;
    }
    else
    {
        return 150;
    }
}

// cell 点击操作
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 0 && indexPath.row == 0) {
//        NSLog(@"update");
//        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
//        NSString *appMuVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
//        NSLog(@"appMuVersion %@",appMuVersion);
//        NSString *appVersion = [appMuVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
//        NSLog(@"appVersion %@",appVersion);
//        
//        NSString *checkUrlString = [NSString stringWithFormat:@"https://itunes.apple.com/lookup?id=1240652054"];
//        NSURL *checkUrl = [NSURL URLWithString:checkUrlString];
//        NSString *appInfoString = [NSString stringWithContentsOfURL:checkUrl encoding:NSUTF8StringEncoding error:nil];
//        NSError *error = nil;
//        NSData *JSONData = [appInfoString dataUsingEncoding:NSUTF8StringEncoding];
//        if (JSONData == nil) {
//            NSLog(@"没有网络");
//        }
//        else
//        {
//            NSLog(@"有网络");
//            NSDictionary *appInfo = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:&error];
//            if (!error && appInfo) {
//                NSArray *resultsArr = appInfo[@"results"];
//                NSDictionary *resultsDic = resultsArr.firstObject;
//                NSString *muVersion = resultsDic[@"version"];
//                NSString *version = [muVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
//                
//                NSString *name = resultsDic[@"trackName"];
//                NSString *trackViewUrl = resultsDic[@"trackViewUrl"];
//                NSLog(@"version %@  name %@  trackViewUrl %@", version, name, trackViewUrl);
//                NSLog(@"version - %f, appVersion - %f", [version floatValue], [appVersion floatValue]);
//                if ([version floatValue] <= [appVersion floatValue]) {
//                    NSLog(@"不需要更新");
//                    UIAlertController *noNeedUpdate = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"updatePrompt", nil) message:NSLocalizedString(@"noNeedUpdateTip", nil) preferredStyle:UIAlertControllerStyleAlert];
//                    UIAlertAction *yes = [UIAlertAction actionWithTitle:NSLocalizedString(@"noNeedUpdateYes", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                    }];
//                    [noNeedUpdate addAction:yes];
//                    
//                    [self presentViewController:noNeedUpdate animated:YES completion:nil];
//                }
//                else
//                {
//                    NSLog(@"需要更新");
//                    [self updateAppOfVersion];
//                }
//            }
//            else
//            {
//                NSLog(@"出错了！！！");
//            }
//        }
//    }
    // 取消选中效果
    [tableView cellForRowAtIndexPath:indexPath].selected = NO;
}

//-(void)updateAppOfVersion{
//    UIAlertController *updateOrNot = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"updatePrompt", nil) message:NSLocalizedString(@"updateTip", nil) preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *yes = [UIAlertAction actionWithTitle:NSLocalizedString(@"updateYes", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/ch/app/painkare/id1240652054"]];
//    }];
//    
//    UIAlertAction *no = [UIAlertAction actionWithTitle:NSLocalizedString(@"updateNo", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
//    }];
//    [updateOrNot addAction:no];
//    [updateOrNot addAction:yes];
//    
//    [self presentViewController:updateOrNot animated:YES completion:nil];
//}

#pragma mark - tableview滑动事件
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // tableView 下位，根据偏移量计算出下位的高度
    CGFloat downHeight = -scrollView.contentOffset.y;
    // 根据下拉高度计算出 homeView 拉伸的高度
    CGRect settingViewframe = self.versionView.frame;
    settingViewframe.size.height = SCREEN_HEIGHT + downHeight;
    if (downHeight >= 64) {
        self.versionView.frame = settingViewframe;
    }
    else
    {
        self.versionView.frame = CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT + 64);
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
