//
//  HHomeSecondTableViewCell.m
//  FaceKARE
//
//  Created by Anan on 2017/4/27.
//  Copyright © 2017年 Anan. All rights reserved.
//

#import "HHomeSecondTableViewCell.h"

#import "AppUIModel.h"
#import "AppDelegate.h"
#import "HBannerFirstViewController.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

@implementation HHomeSecondTableViewCell
{
    NSMutableArray *dataTitleArray;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    //不可选择cell
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //cell背景颜色
    self.backgroundColor = [AppUIModel UIViewBackgroundColor];
    
    dataTitleArray = [[NSMutableArray alloc] initWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59",@"60", nil];
    //    NSMutableArray *dataArray=[[NSMutableArray alloc] initWithObjects: @"0", @"50",@"50",@"50",@"50",@"50",@"50", @"45",@"45",@"45",@"45",@"45",@"45",@"45", @"45", @"2", @"40", @"5", @"35", @"10", @"30", @"15", @"20",@"50", @"0", @"45", @"2", @"40", @"5", @"35", @"10", @"30", @"15", @"20",@"50", @"0", @"45", @"2", @"40", @"5", @"35", @"10", @"30", @"15", @"20",@"50", @"0", @"45", @"2", @"40", @"5", @"35", @"10", @"30", @"15", @"20",@"50", @"0", @"45", @"2", @"40", @"5", @"35", @"10", @"30", @"15", @"20", nil];
//    NSMutableArray *dataArray=[[NSMutableArray alloc] init];
    
    self.mylinechart = [[HHomeChartView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    self.mylinechart.backgroundColor = [UIColor clearColor];
    self.mylinechart.titleArray = dataTitleArray;
    self.mylinechart.valueArray = ApplicationDelegate.electricityArray;
    CGFloat w = (SCREEN_WIDTH - 100.0f) / [dataTitleArray count];
    self.mylinechart.lineBetweenWidth = w;    //点间隔宽度
    [self.mylinechart initWithView];
    [self.contentView addSubview:self.mylinechart];
    
//    UISwipeGestureRecognizer *leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftHandleSwipe:)];
//    leftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
//    [self.contentView addGestureRecognizer:leftRecognizer];
//    [leftRecognizer requireGestureRecognizerToFail:_customGestureRecognizer];
    
    return self;
}



//外部调用创建cell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identify = @"identify";
    HHomeSecondTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[HHomeSecondTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    return cell;
}

- (void)changeChart
{
    [self.mylinechart.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.mylinechart.valueArray = ApplicationDelegate.electricityArray;
    CGFloat w = (SCREEN_WIDTH - 100.0f) / [dataTitleArray count];
    self.mylinechart.lineBetweenWidth = w;    //点间隔宽度
    [self.mylinechart initWithView];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
