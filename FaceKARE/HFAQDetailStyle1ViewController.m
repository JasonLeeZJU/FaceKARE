//
//  HFAQDetailStyle1ViewController.m
//  FaceKARE
//
//  Created by Anan on 2017/5/3.
//  Copyright © 2017年 Anan. All rights reserved.
//

#import "HFAQDetailStyle1ViewController.h"
#import "AppUIModel.h"
#import "AppDelegate.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

@interface HFAQDetailStyle1ViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UILabel *questionLabel;
    UILabel *answerLabel;
    UIView *listView;
}

// tableView
@property (nonatomic, strong) UITableView *FAQDetailStyle1TableView;
// 主色调背景
@property (nonatomic, strong) UIView *FAQDetailStyle1View;

@end

@implementation HFAQDetailStyle1ViewController

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
    self.FAQDetailStyle1TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.FAQDetailStyle1TableView.delegate = self;
    self.FAQDetailStyle1TableView.dataSource = self;
    [self.FAQDetailStyle1TableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];   //取消 cell 之间的横线
    self.FAQDetailStyle1TableView.backgroundColor = [AppUIModel UIViewBackgroundColor];
    [self.FAQDetailStyle1TableView setShowsVerticalScrollIndicator:NO];    //取消滑条
    [self.view addSubview:self.FAQDetailStyle1TableView];
    
    // 设置 view
    self.FAQDetailStyle1View = [[UIView alloc] initWithFrame:CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT + 64)];
    self.FAQDetailStyle1View.backgroundColor = [AppUIModel UIViewMainColorI];
    self.FAQDetailStyle1View.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.FAQDetailStyle1View];
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
    
//    answerLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, questionLabelSize.height + 50, SCREEN_WIDTH - 80, 30)];
//    answerLabel.textColor = [AppUIModel UIViewNormalColor];
//    answerLabel.font = [AppUIModel UIViewNormalFont];
//    [answerLabel setTextAlignment:NSTextAlignmentLeft];
//    answerLabel.text = self.answerString;
//    answerLabel.numberOfLines = 0;
//    CGSize answerLabelSize = [answerLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH - 80, MAXFLOAT)];
//    CGRect answerLabelFrame = answerLabel.frame;
//    answerLabelFrame.size.height = answerLabelSize.height;
//    [answerLabel setFrame:answerLabelFrame];
//    [cell.contentView addSubview:answerLabel];
    
    CGFloat listViewWeight = SCREEN_WIDTH - 65;
    
    // label11
    UILabel *label11 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, listViewWeight * 0.15, 30)];
    label11.textColor = [AppUIModel UIViewNormalColor];
    [label11 setTextAlignment:NSTextAlignmentCenter];
    label11.font = [AppUIModel UIViewSmallFont];
    label11.text = NSLocalizedString(@"FAQLabel11", nil);
    label11.numberOfLines = 0;
    CGSize label11Size = [label11 sizeThatFits:CGSizeMake(listViewWeight * 0.15, MAXFLOAT)];
    CGRect label11Frame = label11.frame;
    label11Frame.size.height = label11Size.height;
    [label11 setFrame:label11Frame];
    // label12
    UILabel *label12 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, listViewWeight * 0.15, 30)];
    label12.textColor = [AppUIModel UIViewNormalColor];
    [label12 setTextAlignment:NSTextAlignmentCenter];
    label12.font = [AppUIModel UIViewSmallFont];
    label12.text = NSLocalizedString(@"FAQLabel12", nil);
    label12.numberOfLines = 0;
    CGSize label12Size = [label12 sizeThatFits:CGSizeMake(listViewWeight * 0.15, MAXFLOAT)];
    CGRect label12Frame = label12.frame;
    label12Frame.size.height = label12Size.height;
    [label12 setFrame:label12Frame];
    // label13
    UILabel *label13 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, listViewWeight * 0.15, 30)];
    label13.textColor = [AppUIModel UIViewNormalColor];
    [label13 setTextAlignment:NSTextAlignmentCenter];
    label13.font = [AppUIModel UIViewSmallFont];
    label13.text = NSLocalizedString(@"FAQLabel13", nil);
    label13.numberOfLines = 0;
    CGSize label13Size = [label13 sizeThatFits:CGSizeMake(listViewWeight * 0.15, MAXFLOAT)];
    CGRect label13Frame = label13.frame;
    label13Frame.size.height = label13Size.height;
    [label13 setFrame:label13Frame];
    // label14
    UILabel *label14 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, listViewWeight * 0.15, 30)];
    label14.textColor = [AppUIModel UIViewNormalColor];
    [label14 setTextAlignment:NSTextAlignmentCenter];
    label14.font = [AppUIModel UIViewSmallFont];
    label14.text = NSLocalizedString(@"FAQLabel14", nil);
    label14.numberOfLines = 0;
    CGSize label14Size = [label14 sizeThatFits:CGSizeMake(listViewWeight * 0.15, MAXFLOAT)];
    CGRect label14Frame = label14.frame;
    label14Frame.size.height = label14Size.height;
    [label14 setFrame:label14Frame];
    
    // label21
    UILabel *label21 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, listViewWeight * 0.2, 30)];
    label21.textColor = [AppUIModel UIViewNormalColor];
    [label21 setTextAlignment:NSTextAlignmentCenter];
    label21.font = [AppUIModel UIViewSmallFont];
    label21.text = NSLocalizedString(@"FAQLabel21", nil);
    label21.numberOfLines = 0;
    CGSize label21Size = [label21 sizeThatFits:CGSizeMake(listViewWeight * 0.2, MAXFLOAT)];
    CGRect label21Frame = label21.frame;
    label21Frame.size.height = label21Size.height;
    [label21 setFrame:label21Frame];
    // label22
    UILabel *label22 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, listViewWeight * 0.2, 30)];
    label22.textColor = [AppUIModel UIViewNormalColor];
    [label22 setTextAlignment:NSTextAlignmentCenter];
    label22.font = [AppUIModel UIViewSmallFont];
    label22.text = NSLocalizedString(@"FAQLabel22", nil);
    label22.numberOfLines = 0;
    CGSize label22Size = [label22 sizeThatFits:CGSizeMake(listViewWeight * 0.2, MAXFLOAT)];
    CGRect label22Frame = label22.frame;
    label22Frame.size.height = label22Size.height;
    [label22 setFrame:label22Frame];
    // label23
    UILabel *label23 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, listViewWeight * 0.2, 30)];
    label23.textColor = [AppUIModel UIViewNormalColor];
    [label23 setTextAlignment:NSTextAlignmentCenter];
    label23.font = [AppUIModel UIViewSmallFont];
    label23.text = NSLocalizedString(@"FAQLabel23", nil);
    label23.numberOfLines = 0;
    CGSize label23Size = [label23 sizeThatFits:CGSizeMake(listViewWeight * 0.2, MAXFLOAT)];
    CGRect label23Frame = label23.frame;
    label23Frame.size.height = label23Size.height;
    [label23 setFrame:label23Frame];
    // label24
    UILabel *label24 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, listViewWeight * 0.2, 30)];
    label24.textColor = [AppUIModel UIViewNormalColor];
    [label24 setTextAlignment:NSTextAlignmentCenter];
    label24.font = [AppUIModel UIViewSmallFont];
    label24.text = NSLocalizedString(@"FAQLabel24", nil);
    label24.numberOfLines = 0;
    CGSize label24Size = [label24 sizeThatFits:CGSizeMake(listViewWeight * 0.2, MAXFLOAT)];
    CGRect label24Frame = label24.frame;
    label24Frame.size.height = label24Size.height;
    [label24 setFrame:label24Frame];
    
    // label31
    UILabel *label31 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, listViewWeight * 0.4, 30)];
    label31.textColor = [AppUIModel UIViewNormalColor];
    [label31 setTextAlignment:NSTextAlignmentCenter];
    label31.font = [AppUIModel UIViewSmallFont];
    label31.text = NSLocalizedString(@"FAQLabel31", nil);
    label31.numberOfLines = 0;
    CGSize label31Size = [label31 sizeThatFits:CGSizeMake(listViewWeight * 0.4, MAXFLOAT)];
    CGRect label31Frame = label31.frame;
    label31Frame.size.height = label31Size.height;
    [label31 setFrame:label31Frame];
    // label32
    UILabel *label32 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, listViewWeight * 0.4, 30)];
    label32.textColor = [AppUIModel UIViewNormalColor];
    [label32 setTextAlignment:NSTextAlignmentCenter];
    label32.font = [AppUIModel UIViewSmallFont];
    label32.text = NSLocalizedString(@"FAQLabel32", nil);
    label32.numberOfLines = 0;
    CGSize label32Size = [label32 sizeThatFits:CGSizeMake(listViewWeight * 0.4, MAXFLOAT)];
    CGRect label32Frame = label32.frame;
    label32Frame.size.height = label32Size.height;
    [label32 setFrame:label32Frame];
    // label33
    UILabel *label33 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, listViewWeight * 0.4, 30)];
    label33.textColor = [AppUIModel UIViewNormalColor];
    [label33 setTextAlignment:NSTextAlignmentCenter];
    label33.font = [AppUIModel UIViewSmallFont];
    label33.text = NSLocalizedString(@"FAQLabel33", nil);
    label33.numberOfLines = 0;
    CGSize label33Size = [label33 sizeThatFits:CGSizeMake(listViewWeight * 0.4, MAXFLOAT)];
    CGRect label33Frame = label33.frame;
    label33Frame.size.height = label33Size.height;
    [label33 setFrame:label33Frame];
    // label34
    UILabel *label34 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, listViewWeight * 0.4, 30)];
    label34.textColor = [AppUIModel UIViewNormalColor];
    [label34 setTextAlignment:NSTextAlignmentCenter];
    label34.font = [AppUIModel UIViewSmallFont];
    label34.text = NSLocalizedString(@"FAQLabel34", nil);
    label34.numberOfLines = 0;
    CGSize label34Size = [label34 sizeThatFits:CGSizeMake(listViewWeight * 0.4, MAXFLOAT)];
    CGRect label34Frame = label34.frame;
    label34Frame.size.height = label34Size.height;
    [label34 setFrame:label34Frame];
    
    // label41
    UILabel *label41 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, listViewWeight * 0.25, 30)];
    label41.textColor = [AppUIModel UIViewNormalColor];
    [label41 setTextAlignment:NSTextAlignmentCenter];
    label41.font = [AppUIModel UIViewSmallFont];
    label41.text = NSLocalizedString(@"FAQLabel41", nil);
    label41.numberOfLines = 0;
    CGSize label41Size = [label41 sizeThatFits:CGSizeMake(listViewWeight * 0.25, MAXFLOAT)];
    CGRect label41Frame = label41.frame;
    label41Frame.size.height = label41Size.height;
    [label41 setFrame:label41Frame];
    // label42
    UILabel *label42 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, listViewWeight * 0.25, 30)];
    label42.textColor = [AppUIModel UIViewNormalColor];
    [label42 setTextAlignment:NSTextAlignmentCenter];
    label42.font = [AppUIModel UIViewSmallFont];
    label42.text = NSLocalizedString(@"FAQLabel42", nil);
    label42.numberOfLines = 0;
    CGSize label42Size = [label42 sizeThatFits:CGSizeMake(listViewWeight * 0.25, MAXFLOAT)];
    CGRect label42Frame = label42.frame;
    label42Frame.size.height = label42Size.height;
    [label42 setFrame:label42Frame];
    // label43
    UILabel *label43 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, listViewWeight * 0.25, 30)];
    label43.textColor = [AppUIModel UIViewNormalColor];
    [label43 setTextAlignment:NSTextAlignmentCenter];
    label43.font = [AppUIModel UIViewSmallFont];
    label43.text = NSLocalizedString(@"FAQLabel43", nil);
    label43.numberOfLines = 0;
    CGSize label43Size = [label43 sizeThatFits:CGSizeMake(listViewWeight * 0.25, MAXFLOAT)];
    CGRect label43Frame = label43.frame;
    label43Frame.size.height = label43Size.height;
    [label43 setFrame:label43Frame];
    // label44
    UILabel *label44 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, listViewWeight * 0.25, 30)];
    label44.textColor = [AppUIModel UIViewNormalColor];
    [label44 setTextAlignment:NSTextAlignmentCenter];
    label44.font = [AppUIModel UIViewSmallFont];
    label44.text = NSLocalizedString(@"FAQLabel44", nil);
    label44.numberOfLines = 0;
    CGSize label44Size = [label44 sizeThatFits:CGSizeMake(listViewWeight * 0.25, MAXFLOAT)];
    CGRect label44Frame = label44.frame;
    label44Frame.size.height = label44Size.height;
    [label44 setFrame:label44Frame];
    
    NSArray *height1Array = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%f",label11Size.height], [NSString stringWithFormat:@"%f",label21Size.height], [NSString stringWithFormat:@"%f",label31Size.height], [NSString stringWithFormat:@"%f",label41Size.height], nil];
    NSNumber *maxHeight1 = [height1Array valueForKeyPath:@"@max.floatValue"];
    NSArray *height2Array = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%f",label12Size.height], [NSString stringWithFormat:@"%f",label22Size.height], [NSString stringWithFormat:@"%f",label32Size.height], [NSString stringWithFormat:@"%f",label42Size.height], nil];
    NSNumber *maxHeight2 = [height2Array valueForKeyPath:@"@max.floatValue"];
    NSArray *height3Array = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%f",label13Size.height], [NSString stringWithFormat:@"%f",label23Size.height], [NSString stringWithFormat:@"%f",label33Size.height], [NSString stringWithFormat:@"%f",label43Size.height], nil];
    NSNumber *maxHeight3 = [height3Array valueForKeyPath:@"@max.floatValue"];
    NSArray *height4Array = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%f",label14Size.height], [NSString stringWithFormat:@"%f",label24Size.height], [NSString stringWithFormat:@"%f",label34Size.height], [NSString stringWithFormat:@"%f",label44Size.height], nil];
    NSNumber *maxHeight4 = [height4Array valueForKeyPath:@"@max.floatValue"];
    
    listView = [[UIView alloc] initWithFrame:CGRectMake(30, questionLabelSize.height + 50,  SCREEN_WIDTH - 60, 5 + [maxHeight1 intValue] + [maxHeight2 intValue] + [maxHeight3 intValue] + [maxHeight4 intValue])];
    listView.backgroundColor = [AppUIModel UIViewMainColorI];
    
    UIView *view11 = [[UIView alloc] initWithFrame:CGRectMake(1, 1, listViewWeight * 0.15, [maxHeight1 intValue])];
    view11.backgroundColor = [UIColor whiteColor];
    [listView addSubview:view11];
    UIView *view12 = [[UIView alloc] initWithFrame:CGRectMake(1, 2 + [maxHeight1 intValue], listViewWeight * 0.15, [maxHeight2 intValue])];
    view12.backgroundColor = [UIColor whiteColor];
    [listView addSubview:view12];
    UIView *view13 = [[UIView alloc] initWithFrame:CGRectMake(1, 3 + [maxHeight1 intValue] + [maxHeight2 intValue], listViewWeight * 0.15, [maxHeight3 intValue])];
    view13.backgroundColor = [UIColor whiteColor];
    [listView addSubview:view13];
    UIView *view14 = [[UIView alloc] initWithFrame:CGRectMake(1, 4 + [maxHeight1 intValue] + [maxHeight2 intValue] + [maxHeight3 intValue], listViewWeight * 0.15, [maxHeight4 intValue])];
    view14.backgroundColor = [UIColor whiteColor];
    [listView addSubview:view14];
    
    UIView *view21 = [[UIView alloc] initWithFrame:CGRectMake(2 + listViewWeight * 0.15, 1, listViewWeight * 0.2, [maxHeight1 intValue])];
    view21.backgroundColor = [UIColor whiteColor];
    [listView addSubview:view21];
    UIView *view22 = [[UIView alloc] initWithFrame:CGRectMake(2 + listViewWeight * 0.15, 2 + [maxHeight1 intValue], listViewWeight * 0.2, [maxHeight2 intValue])];
    view22.backgroundColor = [UIColor whiteColor];
    [listView addSubview:view22];
    UIView *view23 = [[UIView alloc] initWithFrame:CGRectMake(2 + listViewWeight * 0.15, 3 + [maxHeight1 intValue] + [maxHeight2 intValue], listViewWeight * 0.2, [maxHeight3 intValue])];
    view23.backgroundColor = [UIColor whiteColor];
    [listView addSubview:view23];
    UIView *view24 = [[UIView alloc] initWithFrame:CGRectMake(2 + listViewWeight * 0.15, 4 + [maxHeight1 intValue] + [maxHeight2 intValue] + [maxHeight3 intValue], listViewWeight * 0.2, [maxHeight4 intValue])];
    view24.backgroundColor = [UIColor whiteColor];
    [listView addSubview:view24];
    
    UIView *view31 = [[UIView alloc] initWithFrame:CGRectMake(3 + listViewWeight * 0.35, 1, listViewWeight * 0.4, [maxHeight1 intValue])];
    view31.backgroundColor = [UIColor whiteColor];
    [listView addSubview:view31];
    UIView *view32 = [[UIView alloc] initWithFrame:CGRectMake(3 + listViewWeight * 0.35, 2 + [maxHeight1 intValue], listViewWeight * 0.4, [maxHeight2 intValue])];
    view32.backgroundColor = [UIColor whiteColor];
    [listView addSubview:view32];
    UIView *view33 = [[UIView alloc] initWithFrame:CGRectMake(3 + listViewWeight * 0.35, 3 + [maxHeight1 intValue] + [maxHeight2 intValue], listViewWeight * 0.4, [maxHeight3 intValue])];
    view33.backgroundColor = [UIColor whiteColor];
    [listView addSubview:view33];
    UIView *view34 = [[UIView alloc] initWithFrame:CGRectMake(3 + listViewWeight * 0.35, 4 + [maxHeight1 intValue] + [maxHeight2 intValue] + [maxHeight3 intValue], listViewWeight * 0.4, [maxHeight4 intValue])];
    view34.backgroundColor = [UIColor whiteColor];
    [listView addSubview:view34];
    
    UIView *view41 = [[UIView alloc] initWithFrame:CGRectMake(4 + listViewWeight * 0.75, 1, listViewWeight * 0.25, [maxHeight1 intValue])];
    view41.backgroundColor = [UIColor whiteColor];
    [listView addSubview:view41];
    UIView *view42 = [[UIView alloc] initWithFrame:CGRectMake(4 + listViewWeight * 0.75, 2 + [maxHeight1 intValue], listViewWeight * 0.25, [maxHeight2 intValue])];
    view42.backgroundColor = [UIColor whiteColor];
    [listView addSubview:view42];
    UIView *view43 = [[UIView alloc] initWithFrame:CGRectMake(4 + listViewWeight * 0.75, 3 + [maxHeight1 intValue] + [maxHeight2 intValue], listViewWeight * 0.25, [maxHeight3 intValue])];
    view43.backgroundColor = [UIColor whiteColor];
    [listView addSubview:view43];
    UIView *view44 = [[UIView alloc] initWithFrame:CGRectMake(4 + listViewWeight * 0.75, 4 + [maxHeight1 intValue] + [maxHeight2 intValue] + [maxHeight3 intValue], listViewWeight * 0.25, [maxHeight4 intValue])];
    view44.backgroundColor = [UIColor whiteColor];
    [listView addSubview:view44];
    
    CGPoint point11 = CGPointMake(listViewWeight * 0.15 * 0.5, [maxHeight1 intValue] * 0.5);
    label11.center = point11;
    [view11 addSubview:label11];
    CGPoint point12 = CGPointMake(listViewWeight * 0.15 * 0.5, [maxHeight2 intValue] * 0.5);
    label12.center = point12;
    [view12 addSubview:label12];
    CGPoint point13 = CGPointMake(listViewWeight * 0.15 * 0.5, [maxHeight3 intValue] * 0.5);
    label13.center = point13;
    [view13 addSubview:label13];
    CGPoint point14 = CGPointMake(listViewWeight * 0.15 * 0.5, [maxHeight4 intValue] * 0.5);
    label14.center = point14;
    [view14 addSubview:label14];
    CGPoint point21 = CGPointMake(listViewWeight * 0.2 * 0.5, [maxHeight1 intValue] * 0.5);
    label21.center = point21;
    [view21 addSubview:label21];
    CGPoint point22 = CGPointMake(listViewWeight * 0.2 * 0.5, [maxHeight2 intValue] * 0.5);
    label22.center = point22;
    [view22 addSubview:label22];
    CGPoint point23 = CGPointMake(listViewWeight * 0.2 * 0.5, [maxHeight3 intValue] * 0.5);
    label23.center = point23;
    [view23 addSubview:label23];
    CGPoint point24 = CGPointMake(listViewWeight * 0.2 * 0.5, [maxHeight4 intValue] * 0.5);
    label24.center = point24;
    [view24 addSubview:label24];
    CGPoint point31 = CGPointMake(listViewWeight * 0.4 * 0.5, [maxHeight1 intValue] * 0.5);
    label31.center = point31;
    [view31 addSubview:label31];
    CGPoint point32 = CGPointMake(listViewWeight * 0.4 * 0.5, [maxHeight2 intValue] * 0.5);
    label32.center = point32;
    [view32 addSubview:label32];
    CGPoint point33 = CGPointMake(listViewWeight * 0.4 * 0.5, [maxHeight3 intValue] * 0.5);
    label33.center = point33;
    [view33 addSubview:label33];
    CGPoint point34 = CGPointMake(listViewWeight * 0.4 * 0.5, [maxHeight4 intValue] * 0.5);
    label34.center = point34;
    [view34 addSubview:label34];
    CGPoint point41 = CGPointMake(listViewWeight * 0.25 * 0.5, [maxHeight1 intValue] * 0.5);
    label41.center = point41;
    [view41 addSubview:label41];
    CGPoint point42 = CGPointMake(listViewWeight * 0.25 * 0.5, [maxHeight2 intValue] * 0.5);
    label42.center = point42;
    [view42 addSubview:label42];
    CGPoint point43 = CGPointMake(listViewWeight * 0.25 * 0.5, [maxHeight3 intValue] * 0.5);
    label43.center = point43;
    [view43 addSubview:label43];
    CGPoint point44 = CGPointMake(listViewWeight * 0.25 * 0.5, [maxHeight4 intValue] * 0.5);
    label44.center = point44;
    [view44 addSubview:label44];
    
    [cell.contentView addSubview:listView];
    
    /*
    CGFloat listViewWeight = SCREEN_WIDTH - 64;
    listView = [[UIView alloc] initWithFrame:CGRectMake(30, questionLabelSize.height + answerLabelSize.height + 70,  SCREEN_WIDTH - 60, 215)];
    listView.backgroundColor = [AppUIModel UIViewMainColorI];
    
    // left
    UIView *leftView1 = [[UIView alloc] initWithFrame:CGRectMake(1, 1, listViewWeight * 0.2, 30)];
    leftView1.backgroundColor = [UIColor whiteColor];
    [listView addSubview:leftView1];
    UIView *leftView2 = [[UIView alloc] initWithFrame:CGRectMake(1, 32, listViewWeight * 0.2, 60)];
    leftView2.backgroundColor = [UIColor whiteColor];
    [listView addSubview:leftView2];
    UIView *leftView3 = [[UIView alloc] initWithFrame:CGRectMake(1, 93, listViewWeight * 0.2, 60)];
    leftView3.backgroundColor = [UIColor whiteColor];
    [listView addSubview:leftView3];
    UIView *leftView4 = [[UIView alloc] initWithFrame:CGRectMake(1, 154, listViewWeight * 0.2, 60)];
    leftView4.backgroundColor = [UIColor whiteColor];
    [listView addSubview:leftView4];
    
    UILabel *leftLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, listViewWeight * 0.2, 30)];
    leftLabel1.textColor = [AppUIModel UIViewNormalColor];
    [leftLabel1 setTextAlignment:NSTextAlignmentCenter];
    leftLabel1.font = [AppUIModel UIViewSmallFont];
    leftLabel1.text = NSLocalizedString(@"leftLabel1", nil);
    [leftView1 addSubview:leftLabel1];
    
    UILabel *leftLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, listViewWeight * 0.2, 30)];
    leftLabel2.textColor = [AppUIModel UIViewNormalColor];
    [leftLabel2 setTextAlignment:NSTextAlignmentCenter];
    leftLabel2.font = [AppUIModel UIViewSmallFont];
    leftLabel2.text = NSLocalizedString(@"leftLabel2", nil);
    leftLabel2.numberOfLines = 0;
    CGSize leftLabel2Size = [leftLabel2 sizeThatFits:CGSizeMake(listViewWeight * 0.2, MAXFLOAT)];
    CGRect leftLabel2Frame = leftLabel2.frame;
    leftLabel2Frame.size.height = leftLabel2Size.height;
    leftLabel2Frame.origin.y = (60 - leftLabel2Size.height) * 0.5;
    [leftLabel2 setFrame:leftLabel2Frame];
    [leftView2 addSubview:leftLabel2];
    
    UILabel *leftLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, listViewWeight * 0.2, 30)];
    leftLabel3.textColor = [AppUIModel UIViewNormalColor];
    [leftLabel3 setTextAlignment:NSTextAlignmentCenter];
    leftLabel3.font = [AppUIModel UIViewSmallFont];
    leftLabel3.text = NSLocalizedString(@"leftLabel3", nil);
    leftLabel3.numberOfLines = 0;
    CGSize leftLabel3Size = [leftLabel3 sizeThatFits:CGSizeMake(listViewWeight * 0.2, MAXFLOAT)];
    CGRect leftLabel3Frame = leftLabel3.frame;
    leftLabel3Frame.size.height = leftLabel3Size.height;
    leftLabel3Frame.origin.y = (60 - leftLabel3Size.height) * 0.5;
    [leftLabel3 setFrame:leftLabel3Frame];
    [leftView3 addSubview:leftLabel3];
    
    UILabel *leftLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, listViewWeight * 0.2, 30)];
    leftLabel4.textColor = [AppUIModel UIViewNormalColor];
    [leftLabel4 setTextAlignment:NSTextAlignmentCenter];
    leftLabel4.font = [AppUIModel UIViewSmallFont];
    leftLabel4.text = NSLocalizedString(@"leftLabel4", nil);
    leftLabel4.numberOfLines = 0;
    CGSize leftLabel4Size = [leftLabel4 sizeThatFits:CGSizeMake(listViewWeight * 0.2, MAXFLOAT)];
    CGRect leftLabel4Frame = leftLabel4.frame;
    leftLabel4Frame.size.height = leftLabel4Size.height;
    leftLabel4Frame.origin.y = (60 - leftLabel4Size.height) * 0.5;
    [leftLabel4 setFrame:leftLabel4Frame];
    [leftView4 addSubview:leftLabel4];
    
    // middle
    UIView *middleView1 = [[UIView alloc] initWithFrame:CGRectMake(listViewWeight * 0.2 + 2, 1, listViewWeight * 0.5, 30)];
    middleView1.backgroundColor = [UIColor whiteColor];
    [listView addSubview:middleView1];
    UIView *middleView2 = [[UIView alloc] initWithFrame:CGRectMake(listViewWeight * 0.2 + 2, 32, listViewWeight * 0.5, 60)];
    middleView2.backgroundColor = [UIColor whiteColor];
    [listView addSubview:middleView2];
    UIView *middleView3 = [[UIView alloc] initWithFrame:CGRectMake(listViewWeight * 0.2 + 2, 93, listViewWeight * 0.5, 60)];
    middleView3.backgroundColor = [UIColor whiteColor];
    [listView addSubview:middleView3];
    UIView *middleView4 = [[UIView alloc] initWithFrame:CGRectMake(listViewWeight * 0.2 + 2, 154, listViewWeight * 0.5, 60)];
    middleView4.backgroundColor = [UIColor whiteColor];
    [listView addSubview:middleView4];
    
    
    UILabel *middleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, listViewWeight * 0.5, 30)];
    middleLabel1.textColor = [AppUIModel UIViewNormalColor];
    [middleLabel1 setTextAlignment:NSTextAlignmentCenter];
    middleLabel1.font = [AppUIModel UIViewSmallFont];
    middleLabel1.text = NSLocalizedString(@"middleLabel1", nil);
    [middleView1 addSubview:middleLabel1];
    
    UILabel *middleLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, listViewWeight * 0.5, 30)];
    middleLabel2.textColor = [AppUIModel UIViewNormalColor];
    [middleLabel2 setTextAlignment:NSTextAlignmentCenter];
    middleLabel2.font = [AppUIModel UIViewSmallFont];
    middleLabel2.text = NSLocalizedString(@"middleLabel2", nil);
    middleLabel2.numberOfLines = 0;
    CGSize middleLabel2Size = [middleLabel2 sizeThatFits:CGSizeMake(listViewWeight * 0.5, MAXFLOAT)];
    CGRect middleLabel2Frame = middleLabel2.frame;
    middleLabel2Frame.size.height = middleLabel2Size.height;
    middleLabel2Frame.origin.y = (60 - middleLabel2Size.height) * 0.5;
    [middleLabel2 setFrame:middleLabel2Frame];
    [middleView2 addSubview:middleLabel2];
    
    UILabel *middleLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, listViewWeight * 0.5, 30)];
    middleLabel3.textColor = [AppUIModel UIViewNormalColor];
    [middleLabel3 setTextAlignment:NSTextAlignmentCenter];
    middleLabel3.font = [AppUIModel UIViewSmallFont];
    middleLabel3.text = NSLocalizedString(@"middleLabel3", nil);
    middleLabel3.numberOfLines = 0;
    CGSize middleLabel3Size = [middleLabel3 sizeThatFits:CGSizeMake(listViewWeight * 0.5, MAXFLOAT)];
    CGRect middleLabel3Frame = middleLabel3.frame;
    middleLabel3Frame.size.height = middleLabel3Size.height;
    middleLabel3Frame.origin.y = (60 - middleLabel3Size.height) * 0.5;
    [middleLabel3 setFrame:middleLabel3Frame];
    [middleView3 addSubview:middleLabel3];
    
    UILabel *middleLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, listViewWeight * 0.5, 30)];
    middleLabel4.textColor = [AppUIModel UIViewNormalColor];
    [middleLabel4 setTextAlignment:NSTextAlignmentCenter];
    middleLabel4.font = [AppUIModel UIViewSmallFont];
    middleLabel4.text = NSLocalizedString(@"middleLabel4", nil);
    middleLabel4.numberOfLines = 0;
    CGSize middleLabel4Size = [middleLabel4 sizeThatFits:CGSizeMake(listViewWeight * 0.5, MAXFLOAT)];
    CGRect middleLabel4Frame = middleLabel4.frame;
    middleLabel4Frame.size.height = middleLabel4Size.height;
    middleLabel4Frame.origin.y = (60 - middleLabel4Size.height) * 0.5;
    [middleLabel4 setFrame:middleLabel4Frame];
    [middleView4 addSubview:middleLabel4];
    
    // right
    UIView *rightView1 = [[UIView alloc] initWithFrame:CGRectMake(listViewWeight * 0.7 + 3, 1, listViewWeight * 0.3, 30)];
    rightView1.backgroundColor = [UIColor whiteColor];
    [listView addSubview:rightView1];
    UIView *rightView2 = [[UIView alloc] initWithFrame:CGRectMake(listViewWeight * 0.7 + 3, 32, listViewWeight * 0.3, 60)];
    rightView2.backgroundColor = [UIColor whiteColor];
    [listView addSubview:rightView2];
    UIView *rightView3 = [[UIView alloc] initWithFrame:CGRectMake(listViewWeight * 0.7 + 3, 93, listViewWeight * 0.3, 60)];
    rightView3.backgroundColor = [UIColor whiteColor];
    [listView addSubview:rightView3];
    UIView *rightView4 = [[UIView alloc] initWithFrame:CGRectMake(listViewWeight * 0.7 + 3, 154, listViewWeight * 0.3, 60)];
    rightView4.backgroundColor = [UIColor whiteColor];
    [listView addSubview:rightView4];
    
    UILabel *rightLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, listViewWeight * 0.3, 30)];
    rightLabel1.textColor = [AppUIModel UIViewNormalColor];
    [rightLabel1 setTextAlignment:NSTextAlignmentCenter];
    rightLabel1.font = [AppUIModel UIViewSmallFont];
    rightLabel1.text = NSLocalizedString(@"rightLabel1", nil);
    [rightView1 addSubview:rightLabel1];
    
    UILabel *rightLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, listViewWeight * 0.3, 30)];
    rightLabel2.textColor = [AppUIModel UIViewNormalColor];
    [rightLabel2 setTextAlignment:NSTextAlignmentCenter];
    rightLabel2.font = [AppUIModel UIViewSmallFont];
    rightLabel2.text = NSLocalizedString(@"rightLabel2", nil);
    rightLabel2.numberOfLines = 0;
    CGSize rightLabel2Size = [rightLabel2 sizeThatFits:CGSizeMake(listViewWeight * 0.3, MAXFLOAT)];
    CGRect rightLabel2Frame = rightLabel2.frame;
    rightLabel2Frame.size.height = rightLabel2Size.height;
    rightLabel2Frame.origin.y = (60 - rightLabel2Size.height) * 0.5;
    [rightLabel2 setFrame:rightLabel2Frame];
    [rightView2 addSubview:rightLabel2];
    
    UILabel *rightLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, listViewWeight * 0.3, 30)];
    rightLabel3.textColor = [AppUIModel UIViewNormalColor];
    [rightLabel3 setTextAlignment:NSTextAlignmentCenter];
    rightLabel3.font = [AppUIModel UIViewSmallFont];
    rightLabel3.text = NSLocalizedString(@"rightLabel3", nil);
    rightLabel3.numberOfLines = 0;
    CGSize rightLabel3Size = [rightLabel3 sizeThatFits:CGSizeMake(listViewWeight * 0.3, MAXFLOAT)];
    CGRect rightLabel3Frame = rightLabel3.frame;
    rightLabel3Frame.size.height = rightLabel3Size.height;
    rightLabel3Frame.origin.y = (60 - rightLabel3Size.height) * 0.5;
    [rightLabel3 setFrame:rightLabel3Frame];
    [rightView3 addSubview:rightLabel3];
    
    UILabel *rightLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, listViewWeight * 0.3, 30)];
    rightLabel4.textColor = [AppUIModel UIViewNormalColor];
    [rightLabel4 setTextAlignment:NSTextAlignmentCenter];
    rightLabel4.font = [AppUIModel UIViewSmallFont];
    rightLabel4.text = NSLocalizedString(@"rightLabel4", nil);
    rightLabel4.numberOfLines = 0;
    CGSize rightLabel4Size = [rightLabel4 sizeThatFits:CGSizeMake(listViewWeight * 0.3, MAXFLOAT)];
    CGRect rightLabel4Frame = rightLabel4.frame;
    rightLabel4Frame.size.height = rightLabel4Size.height;
    rightLabel4Frame.origin.y = (60 - rightLabel4Size.height) * 0.5;
    [rightLabel4 setFrame:rightLabel4Frame];
    [rightView4 addSubview:rightLabel4];
    
    [cell.contentView addSubview:listView];
    */
    
    return cell;
}

// row高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 400;
}

#pragma mark - tableview滑动事件
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // tableView 下位，根据偏移量计算出下位的高度
    CGFloat downHeight = -scrollView.contentOffset.y;
    // 根据下拉高度计算出 homeView 拉伸的高度
    CGRect homeViewframe = self.FAQDetailStyle1View.frame;
    homeViewframe.size.height = SCREEN_HEIGHT + downHeight;
    if (downHeight >= 64) {
        self.FAQDetailStyle1View.frame = homeViewframe;
    }
    else
    {
        self.FAQDetailStyle1View.frame = CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT + 64);
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
