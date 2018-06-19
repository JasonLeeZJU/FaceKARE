//
//  HDeviceInformationTableViewCell.h
//  FaceKARE
//
//  Created by Anan on 2017/5/2.
//  Copyright © 2017年 Anan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDeviceInformationTableViewCell : UITableViewCell

// 图片名字
@property (nonatomic, strong) NSString *imageName;

// 产品ID
@property (nonatomic, strong) NSString *deviceIDString;

// 固件版本
@property (nonatomic, strong) NSString *firmwareString;

// 外部调用创建 cell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
