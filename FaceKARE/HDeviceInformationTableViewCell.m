//
//  HDeviceInformationTableViewCell.m
//  FaceKARE
//
//  Created by Anan on 2017/5/2.
//  Copyright © 2017年 Anan. All rights reserved.
//

#import "HDeviceInformationTableViewCell.h"
#import "AppUIModel.h"
#import "HDynamicLabel.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

@implementation HDeviceInformationTableViewCell
{
    UIImageView *imageView;
    UILabel *devideInformationLabel;
    UILabel *deviceIdLeftLabel;
    HDynamicLabel *deviceIdRightLabel;
    UILabel *firmwareLeftLabel;
    HDynamicLabel *firmwareRightLabel;
    
}

- (void)setImageName:(NSString *)imageName
{
    _imageName = imageName;
    UIImage *image = [UIImage imageNamed:_imageName];
    imageView.image = image;
}

- (void)setDeviceIDString:(NSString *)deviceIDString
{
    _deviceIDString = deviceIDString;
    deviceIdRightLabel.text = _deviceIDString;
}

- (void)setFirmwareString:(NSString *)firmwareString
{
    _firmwareString = firmwareString;
    firmwareRightLabel.text = _firmwareString;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    //不可选择cell
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 30, 30)];
    [self.contentView addSubview:imageView];
    
    devideInformationLabel = [[UILabel alloc] initWithFrame:CGRectMake(62, 15, SCREEN_WIDTH - 80, 30)];
    devideInformationLabel.font = [AppUIModel UIViewNormalFont];
    devideInformationLabel.textColor = [AppUIModel UIViewNormalColor];
    devideInformationLabel.text = NSLocalizedString(@"DeviceInformation", nil);
    [self.contentView addSubview:devideInformationLabel];
    
    deviceIdLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(62, 60, 110, 30)];
    deviceIdLeftLabel.font = [AppUIModel UIViewNormalFont];
    deviceIdLeftLabel.textColor = [AppUIModel UIViewNormalColor];
    deviceIdLeftLabel.text = NSLocalizedString(@"DeviceId", nil);
    [self.contentView addSubview:deviceIdLeftLabel];
    
    firmwareLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(62, 105, 110, 30)];
    firmwareLeftLabel.font = [AppUIModel UIViewNormalFont];
    firmwareLeftLabel.textColor = [AppUIModel UIViewNormalColor];
    firmwareLeftLabel.text = NSLocalizedString(@"firmware", nil);
    [self.contentView addSubview:firmwareLeftLabel];
    
    deviceIdRightLabel = [[HDynamicLabel alloc] initWithFrame:CGRectMake(180, 65, SCREEN_WIDTH - 200, 30)];
    deviceIdRightLabel.speed = 0.5;
    deviceIdRightLabel.textFont = [AppUIModel UIViewNormalFont];
    deviceIdRightLabel.textColor = [AppUIModel UIViewNormalColor];
    [self.contentView addSubview:deviceIdRightLabel];
    
    firmwareRightLabel = [[HDynamicLabel alloc] initWithFrame:CGRectMake(180, 110, SCREEN_WIDTH - 200, 30)];
    firmwareRightLabel.speed = 0.5;
    firmwareRightLabel.textFont = [AppUIModel UIViewNormalFont];
    firmwareRightLabel.textColor = [AppUIModel UIViewNormalColor];
    [self.contentView addSubview:firmwareRightLabel];
    
    return self;
}

// 外部调用创建 cell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identify = @"identify";
    HDeviceInformationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[HDeviceInformationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
