//
//  HPicturesCollectionViewCell.m
//  FaceKARE
//
//  Created by Anan on 2017/7/27.
//  Copyright © 2017年 Anan. All rights reserved.
//

#import "HPicturesCollectionViewCell.h"
#import "AppUIModel.h"
#import "AppDelegate.h"

@implementation HPicturesCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        // 图片 Imageview
        self.pictureImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width)];
        self.pictureImageView.backgroundColor = [AppUIModel UIViewBackgroundColor];
        [self.pictureImageView.layer setMasksToBounds:YES];
        [self.pictureImageView.layer setCornerRadius:10.0];
        [self addSubview:self.pictureImageView];
        
        // check 按钮
        self.checkButton = [[HCircleStyleButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 40, 0, 40, 40)];
        [self.checkButton.layer setMasksToBounds:YES];
        [self.checkButton.layer setCornerRadius:20.0f];
        self.checkButton.titleLabel.font = [AppUIModel UIViewTitleFont];
        [self.checkButton setImage:[UIImage imageNamed:@"grayCheckOff32.png"] forState:UIControlStateNormal];
        [self.checkButton setImage:[UIImage imageNamed:@"pinkCheckOn32.png"] forState:UIControlStateSelected];
        [self.checkButton addTarget:self action:@selector(checkButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.checkButton];
        
        // 日期 Label
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.width, self.frame.size.width, 30)];
        self.dateLabel.font = [AppUIModel UIViewNormalFont];
        self.dateLabel.textColor = [AppUIModel UIViewNormalColor];
        [self.dateLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:self.dateLabel];
        
//        // 模式 label
//        self.modelLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.width + 30, self.frame.size.width, 30)];
//        self.modelLabel.font = [AppUIModel UIViewNormalFont];
//        self.modelLabel.textColor = [AppUIModel UIViewNormalColor];
//        [self.modelLabel setTextAlignment:NSTextAlignmentCenter];
//        [self addSubview:self.modelLabel];
    }
    return self;
}

- (void)checkButtonAction:(UIButton *)sender
{
    NSLog(@"%@", self.indexPath);

    if (self.checkButton.isSelected == YES)
    {
        [ApplicationDelegate.selectedPicturesArray removeObject:self.indexPath];
        [self.checkButton setSelected:NO];
    }
    else
    {
        [ApplicationDelegate.selectedPicturesArray addObject:self.indexPath];
        [self.checkButton setSelected:YES];
    }
    NSNotification *notification = [NSNotification notificationWithName:@"checkCompareNotification" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    NSLog(@"^^^ %@",ApplicationDelegate.selectedPicturesArray);
}

@end
