//
//  HInformationTableViewCell.h
//  FaceKARE
//
//  Created by Anan on 2017/4/29.
//  Copyright © 2017年 Anan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HInformationTableViewCell : UITableViewCell

@property (nonatomic, assign) NSInteger informationNumber;

// 外部调用创建 cell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
