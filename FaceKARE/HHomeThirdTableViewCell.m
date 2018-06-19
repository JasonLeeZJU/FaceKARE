//
//  HHomeThirdTableViewCell.m
//  FaceKARE
//
//  Created by Anan on 2017/6/2.
//  Copyright © 2017年 Anan. All rights reserved.
//

#import "HHomeThirdTableViewCell.h"
#import "AppUIModel.h"
#import "AppDelegate.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

@implementation HHomeThirdTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    //不可选择cell
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //cell背景颜色
    self.backgroundColor = [AppUIModel UIViewBackgroundColor];
    
    // 设置进度条（表示电流强度）
    self.progressView = [[HProgressView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 0.34, 22, SCREEN_WIDTH * 0.32, 6)];
    self.progressView.progressBackgroundColor = [AppUIModel UIUselessColor];
    self.progressView.progressBarColor = [AppUIModel UIViewMainColorII];
    [self.progressView setProgress:ApplicationDelegate.nowElectricity / ApplicationDelegate.maxElectricity];
    [self.contentView addSubview:self.progressView];
    
    //设置减小 button
    self.homeReduceButton = [[HCircleStyleButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 0.34 - 50, 10, 30, 30)];
    [self.homeReduceButton.layer setMasksToBounds:YES];
    [self.homeReduceButton.layer setCornerRadius:15.0f];
    [self.homeReduceButton setImage:[UIImage imageNamed:@"reduce96.png"] forState:UIControlStateNormal];
    self.homeReduceButton.titleLabel.font = [AppUIModel UIViewTitleFont];
    [self.homeReduceButton setShowsTouchWhenHighlighted:YES];
    [self.homeReduceButton addTarget:self action:@selector(reduceButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.homeReduceButton];
    
    //设置增大 button
    self.homeIncreaseButton = [[HCircleStyleButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 0.66 + 20, 10, 30, 30)];
    [self.homeIncreaseButton.layer setMasksToBounds:YES];
    [self.homeIncreaseButton.layer setCornerRadius:15.0f];
    [self.homeIncreaseButton setImage:[UIImage imageNamed:@"increase96.png"] forState:UIControlStateNormal];
    self.homeIncreaseButton.titleLabel.font = [AppUIModel UIViewTitleFont];
    [self.homeIncreaseButton setShowsTouchWhenHighlighted:YES];
    [self.homeIncreaseButton addTarget:self action:@selector(increaseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.homeIncreaseButton];
    
    UILabel *intensityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    CGPoint intensityLabelCenterPoint = CGPointMake(SCREEN_WIDTH * 0.5, 40);
    intensityLabel.center = intensityLabelCenterPoint;
    intensityLabel.textColor = [AppUIModel UIViewNormalColor];
    intensityLabel.font = [AppUIModel UIViewSmallFont];
    intensityLabel.text = NSLocalizedString(@"intensityLabel", nil);
    intensityLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:intensityLabel];
    
    return self;
}

- (void)reduceButtonAction:(UIButton *)sender
{
    UIView *bView = [[UIView alloc] initWithFrame:sender.frame];
    bView.layer.borderWidth = 3.0f;
    bView.layer.borderColor = [AppUIModel UIViewMainColorII].CGColor;
    
    [bView setBackgroundColor:[UIColor clearColor]];
    bView.layer.cornerRadius = 15;
    [self.contentView insertSubview:bView atIndex:0];
    
    [UIView animateWithDuration:1.0f delay:0.2 options:0 animations:^{
        bView.transform = CGAffineTransformMakeScale(1.5, 1.5);
        bView.alpha = 0;
    } completion:^(BOOL finished) {
        [bView removeFromSuperview];
    }];
    
    if (ApplicationDelegate.isWorking)
    {
        if (ApplicationDelegate.nowElectricity <= ApplicationDelegate.maxElectricity * 0.1)
        {
            //            [MBProgressHUD showError:NSLocalizedString(@"homeMessage2", nil)];
        }
        else
        {
            ApplicationDelegate.nowElectricity = ApplicationDelegate.nowElectricity - ApplicationDelegate.maxElectricity * 0.1;
            if (ApplicationDelegate.nowElectricity < ApplicationDelegate.maxElectricity * 0.1) {
                ApplicationDelegate.nowElectricity = ApplicationDelegate.maxElectricity * 0.1;
            }
            int setElectricityPercent = 100 * (float)ApplicationDelegate.nowElectricity / (float)ApplicationDelegate.maxElectricity;
            if (setElectricityPercent > 100)
            {
                setElectricityPercent = 100;
            }
            else if (setElectricityPercent < 10)
            {
                setElectricityPercent = 10;
            }
            NSString *s = [NSString stringWithFormat:@"S0507,%@\r\n",[NSString stringWithFormat:@"%d", setElectricityPercent]];
            const char *code = [s UTF8String];
            NSData* data = [ApplicationDelegate.manager.dataProcessor encription:code];
            [ApplicationDelegate.manager writeWithoutResponceToSelectedCharacteristicWithData:data];
        }
    }
    else
    {
        //        [MBProgressHUD showError:NSLocalizedString(@"homeMessage1", nil)];
    }
}

- (void)increaseButtonAction:(UIButton *)sender
{
    UIView *bView = [[UIView alloc] initWithFrame:sender.frame];
    bView.layer.borderWidth = 3.0f;
    bView.layer.borderColor = [AppUIModel UIViewMainColorII].CGColor;
    
    [bView setBackgroundColor:[UIColor clearColor]];
    bView.layer.cornerRadius = 15;
    [self.contentView insertSubview:bView atIndex:0];
    
    [UIView animateWithDuration:1.0f delay:0.2 options:0 animations:^{
        bView.transform = CGAffineTransformMakeScale(1.5, 1.5);
        bView.alpha = 0;
    } completion:^(BOOL finished) {
        [bView removeFromSuperview];
    }];
    
    if (ApplicationDelegate.isWorking)
    {
        if (ApplicationDelegate.nowElectricity >= ApplicationDelegate.maxElectricity)
        {
            //            [MBProgressHUD showError:NSLocalizedString(@"homeMessage3", nil)];
        }
        else
        {
            ApplicationDelegate.nowElectricity = ApplicationDelegate.nowElectricity + ApplicationDelegate.maxElectricity * 0.1;
            if (ApplicationDelegate.nowElectricity > ApplicationDelegate.maxElectricity) {
                ApplicationDelegate.nowElectricity = ApplicationDelegate.maxElectricity;
            }
            int setElectricityPercent = 100 * (float)ApplicationDelegate.nowElectricity / (float)ApplicationDelegate.maxElectricity;
            if (setElectricityPercent > 100)
            {
                setElectricityPercent = 100;
            }
            else if (setElectricityPercent < 10)
            {
                setElectricityPercent = 10;
            }
            NSString *s = [NSString stringWithFormat:@"S0507,%@\r\n",[NSString stringWithFormat:@"%d", setElectricityPercent]];
            const char *code = [s UTF8String];
            NSData* data = [ApplicationDelegate.manager.dataProcessor encription:code];
            [ApplicationDelegate.manager writeWithoutResponceToSelectedCharacteristicWithData:data];
        }
    }
    else
    {
        //        [MBProgressHUD showError:NSLocalizedString(@"homeMessage1", nil)];
    }
}

//外部调用创建cell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identify = @"identify";
    HHomeThirdTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[HHomeThirdTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
