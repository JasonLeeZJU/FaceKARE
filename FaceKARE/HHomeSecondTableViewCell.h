//
//  HHomeSecondTableViewCell.h
//  FaceKARE
//
//  Created by Anan on 2017/4/27.
//  Copyright © 2017年 Anan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHomeChartView.h"

@interface HHomeSecondTableViewCell : UITableViewCell

@property (nonatomic, strong) HHomeChartView *mylinechart;

// 外部调用创建 cell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)changeChart;

@end
