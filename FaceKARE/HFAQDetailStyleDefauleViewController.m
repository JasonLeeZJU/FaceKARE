//
//  HFAQDetailStyleDefauleViewController.m
//  FaceKARE
//
//  Created by Anan on 2017/5/3.
//  Copyright © 2017年 Anan. All rights reserved.
//

#import "HFAQDetailStyleDefauleViewController.h"
#import "AppUIModel.h"
#import "AppDelegate.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

@interface HFAQDetailStyleDefauleViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UILabel *questionLabel;
    UILabel *answerLabel;
}

// tableView
@property (nonatomic, strong) UITableView *FAQDetailStyleDefauleTableView;
// 主色调背景
@property (nonatomic, strong) UIView *FAQDetailStyleDefauleView;

@end

@implementation HFAQDetailStyleDefauleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置页面 navigation 标题
    self.navigationItem.title = NSLocalizedString(@"FAQListViewNavigationTitle", nil);
    
    // 设置返回按钮
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc] init];
    backbutton.title = @"";
    self.navigationItem.backBarButtonItem = backbutton;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    // 设置背景颜色
    self.view.backgroundColor = [AppUIModel UIViewBackgroundColor];
    
    // 设置 tableview
    self.FAQDetailStyleDefauleTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.FAQDetailStyleDefauleTableView.delegate = self;
    self.FAQDetailStyleDefauleTableView.dataSource = self;
    [self.FAQDetailStyleDefauleTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];   //取消 cell 之间的横线
    self.FAQDetailStyleDefauleTableView.backgroundColor = [AppUIModel UIViewBackgroundColor];
    [self.FAQDetailStyleDefauleTableView setShowsVerticalScrollIndicator:NO];    //取消滑条
    [self.view addSubview:self.FAQDetailStyleDefauleTableView];
    
    // 设置 view
    self.FAQDetailStyleDefauleView = [[UIView alloc] initWithFrame:CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT + 64)];
    self.FAQDetailStyleDefauleView.backgroundColor = [AppUIModel UIViewMainColorI];
    self.FAQDetailStyleDefauleView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.FAQDetailStyleDefauleView];

}

#pragma mark -tableview设置
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// row数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

// tableView内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifiter = @"settingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifiter];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifiter];
    }
    cell.backgroundColor = [AppUIModel UIViewBackgroundColor];
    //不可选择cell
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    questionLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 20, SCREEN_WIDTH - 60, 30)];
    questionLabel.textColor = [AppUIModel UIViewNormalColor];
    questionLabel.font = [AppUIModel UIViewTitleFont];
    [questionLabel setTextAlignment:NSTextAlignmentLeft];
    questionLabel.text = self.questionString;
    questionLabel.numberOfLines = 0;
    CGSize questionLabelSize = [questionLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH - 60, MAXFLOAT)];
    CGRect questionLabelFrame = questionLabel.frame;
    questionLabelFrame.size.height = questionLabelSize.height;
    [questionLabel setFrame:questionLabelFrame];
    [cell.contentView addSubview:questionLabel];
    
    answerLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, questionLabelSize.height + 50, SCREEN_WIDTH - 80, 30)];
    answerLabel.textColor = [AppUIModel UIViewNormalColor];
    answerLabel.font = [AppUIModel UIViewNormalFont];
    [answerLabel setTextAlignment:NSTextAlignmentLeft];
    answerLabel.text = self.answerString;
    answerLabel.numberOfLines = 0;
    CGSize answerLabelSize = [answerLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH - 80, MAXFLOAT)];
    CGRect answerLabelFrame = answerLabel.frame;
    answerLabelFrame.size.height = answerLabelSize.height;
    [answerLabel setFrame:answerLabelFrame];
    [cell.contentView addSubview:answerLabel];
    
    return cell;
}

// row高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return questionLabel.bounds.size.height + answerLabel.bounds.size.height + 60;
}

#pragma mark - tableview滑动事件
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // tableView 下位，根据偏移量计算出下位的高度
    CGFloat downHeight = -scrollView.contentOffset.y;
    // 根据下拉高度计算出 homeView 拉伸的高度
    CGRect homeViewframe = self.FAQDetailStyleDefauleView.frame;
    homeViewframe.size.height = SCREEN_HEIGHT + downHeight;
    if (downHeight >= 64) {
        self.FAQDetailStyleDefauleView.frame = homeViewframe;
    }
    else
    {
        self.FAQDetailStyleDefauleView.frame = CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT + 64);
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
