//
//  HHomeThirdTableViewCell.h
//  FaceKARE
//
//  Created by Anan on 2017/6/2.
//  Copyright © 2017年 Anan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HProgressView.h"
#import "HCircleStyleButton.h"

@interface HHomeThirdTableViewCell : UITableViewCell

// 减小 Button
@property (nonatomic, strong) HCircleStyleButton *homeReduceButton;
// 增大 Button
@property (nonatomic, strong) HCircleStyleButton *homeIncreaseButton;
// 进度条（表示电流强度）
@property (nonatomic, strong) HProgressView *progressView;

// 外部调用创建 cell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
