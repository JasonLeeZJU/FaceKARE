//
//  HPicturesCollectionViewCell.h
//  FaceKARE
//
//  Created by Anan on 2017/7/27.
//  Copyright © 2017年 Anan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCircleStyleButton.h"

@interface HPicturesCollectionViewCell : UICollectionViewCell

// 选择按钮
@property (nonatomic, strong) HCircleStyleButton *checkButton;

// 图片 ImageView
@property (nonatomic, strong) UIImageView *pictureImageView;

// 图片 Image Path
@property (nonatomic, strong) NSString *pictureImagePath;

// 日期 Label
@property (nonatomic, strong) UILabel *dateLabel;

//// 模式 Label
//@property (nonatomic, strong) UILabel *modelLabel;

// text
@property (nonatomic, assign) NSIndexPath *indexPath;

@end
