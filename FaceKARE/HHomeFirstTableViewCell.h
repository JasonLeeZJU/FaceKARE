//
//  HHomeFirstTableViewCell.h
//  FaceKARE
//
//  Created by Anan on 2017/4/27.
//  Copyright © 2017年 Anan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBannerView.h"

@protocol bannerDelegate <NSObject>

- (void)bannerWebName:(NSString *)str;

@end

@interface HHomeFirstTableViewCell : UITableViewCell

// 文本数组
@property (nonatomic, strong) NSArray *textsArray;

@property (nonatomic, strong) HBannerView *bannerView;

// contents 数组
@property (nonatomic, strong) NSMutableArray *contentsArray;
// contents 随机数数组
@property (nonatomic, strong) NSMutableArray *contentsRandomArray;

// images 数组
@property (nonatomic, strong) NSMutableArray *imagesArray;
// images 随机数数组
@property (nonatomic, strong) NSMutableArray *imagesRandomArray;

// 外部调用创建 cell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, weak) id<bannerDelegate> bannerDelegate;

- (void)addBannerImageView;
- (void)cancelBannerImageView;

@end
