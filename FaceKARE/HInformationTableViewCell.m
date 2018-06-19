//
//  HInformationTableViewCell.m
//  FaceKARE
//
//  Created by Anan on 2017/4/29.
//  Copyright © 2017年 Anan. All rights reserved.
//

#import "HInformationTableViewCell.h"
#import "AppUIModel.h"
#import "AppDelegate.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

@implementation HInformationTableViewCell
{
    UIImageView *imageView;
    UILabel *label;
}

- (void)setInformationNumber:(NSInteger)informationNumber
{
    _informationNumber = informationNumber;
    UIImage *image = [UIImage imageNamed:[[ApplicationDelegate.informationArray objectAtIndex:_informationNumber ] valueForKey:@"image"]];
    // 裁剪 image
    if (image.size.height > image.size.width) {
        CGImageRef cgRef = image.CGImage;
        CGImageRef imageRef = CGImageCreateWithImageInRect(cgRef, CGRectMake(0, (image.size.height - image.size.width) * 0.5, image.size.width, image.size.width));
        UIImage *thumbScale = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
        image = thumbScale;
    }
    else if (image.size.height < image.size.width)
    {
        CGImageRef cgRef = image.CGImage;
        CGImageRef imageRef = CGImageCreateWithImageInRect(cgRef, CGRectMake((image.size.width - image.size.height) * 0.5, 0, image.size.height, image.size.height));
        UIImage *thumbScale = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
        image = thumbScale;
    }
    imageView.image = image;
    
    label.text = [[ApplicationDelegate.informationArray objectAtIndex:_informationNumber ] valueForKey:@"title"];
    label.numberOfLines = 0;
    CGSize labelSize = [label sizeThatFits:CGSizeMake(SCREEN_WIDTH - 160, MAXFLOAT)];
    CGRect labelFrame = label.frame;
    labelFrame.size.height = labelSize.height;
    labelFrame.origin.y = (100 - labelSize.height) * 0.5;
    [label setFrame:labelFrame];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 80, 80)];
    [imageView.layer setMasksToBounds:YES];
    [imageView.layer setCornerRadius:10.0f];
    [self.contentView addSubview:imageView];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(120, 10, SCREEN_WIDTH - 160, 20)];
    label.font = [AppUIModel UIViewNormalFont];
    label.textColor = [AppUIModel UIViewNormalColor];
    label.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:label];
    
    return self;
}

// 外部调用创建 cell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identify = @"identify";
    HInformationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[HInformationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
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
