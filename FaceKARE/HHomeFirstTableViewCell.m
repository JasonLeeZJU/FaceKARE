//
//  HHomeFirstTableViewCell.m
//  FaceKARE
//
//  Created by Anan on 2017/4/27.
//  Copyright © 2017年 Anan. All rights reserved.
//

#import "HHomeFirstTableViewCell.h"
#import "AppDelegate.h"
#import "AppUIModel.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

@implementation HHomeFirstTableViewCell

- (NSMutableArray *)contentsRandomArray
{
    if (!_contentsRandomArray) {
        _contentsRandomArray = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return _contentsRandomArray;
}

- (NSMutableArray *)imagesRandomArray
{
    if (!_imagesRandomArray) {
        _imagesRandomArray = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return _imagesRandomArray;
}

- (NSArray *)textsArray
{
    if (!_textsArray) {
        _textsArray = [[NSArray alloc] init];
    }
    return _textsArray;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    // 标题数组
    self.contentsArray = [[NSMutableArray alloc] init];
    // 图片数组
    self.imagesArray = [[NSMutableArray alloc] init];
    if ([AppUIModel UIViewIsChinese] == YES) {
        for (int i = 1; i <= 6; i++) {
            [self.contentsRandomArray addObject:@(i)];
        }
    }
    else
    {
        for (int i = 1; i <= 4; i++) {
            [self.contentsRandomArray addObject:@(i)];
        }
    }
    
    for (int i = 1; i <= 7; i++) {
        [self.imagesRandomArray addObject:@(i)];
    }
    if ([AppUIModel UIViewIsChinese] == YES) {
        for (NSUInteger i = 0; i < 4; i++) {
            int x = (int)[self contentsrandom:self.textsArray.count];
            NSString *string = [@"banner" stringByAppendingString:[NSString stringWithFormat:@"%d",x]];
            NSString *content = NSLocalizedString(string, nil);
            [self.contentsArray addObject:content];
            NSString *string2 = [@"banner" stringByAppendingString:[NSString stringWithFormat:@"%d",x]];
            NSString *imageName = [string2 stringByAppendingString:@".png"];
            UIImage *image = [UIImage imageNamed:imageName];
            [self.imagesArray addObject:image];
        }
    }
    else
    {
        for (NSUInteger i = 0; i < 4; i++) {
            int x = (int)[self contentsrandom:self.textsArray.count];
            NSString *string = [@"bannerB" stringByAppendingString:[NSString stringWithFormat:@"%d",x]];
            NSString *content = NSLocalizedString(string, nil);
            [self.contentsArray addObject:content];
            NSString *string2 = [@"bannerB" stringByAppendingString:[NSString stringWithFormat:@"%d",x]];
            NSString *imageName = [string2 stringByAppendingString:@".png"];
            UIImage *image = [UIImage imageNamed:imageName];
            [self.imagesArray addObject:image];
        }
    }

    self.textsArray = self.contentsArray;
    
//    for (NSUInteger i = 0; i < self.textsArray.count; i++) {
//        int x = (int)[self imagesRandom:self.textsArray.count];
//        NSString *string = [@"Site_Images-" stringByAppendingString:[NSString stringWithFormat:@"%d",x]];
//        NSString *imageName = [string stringByAppendingString:@".jpg"];
//        UIImage *image = [UIImage imageNamed:imageName];
//        [self.imagesArray addObject:image];
//    }
    
    //创建轮播器控件
    self.bannerView = [[HBannerView alloc] initViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT * 0.25) autoPlayTime:5.0f imagesArray:self.imagesArray textsArray:(NSArray *)self.textsArray clickCallBack:^(NSInteger index){
        if ([self.bannerDelegate respondsToSelector:@selector(bannerWebName:)]) {
            [self.bannerDelegate bannerWebName:self.textsArray[(long)index]];
        }
    }];
    [self.contentView addSubview:self.bannerView];
    return self;
}

// 获取不重复随机数
- (NSInteger)contentsrandom:(NSInteger)bannerPages
{
    int index = arc4random() % self.contentsRandomArray.count;
    NSUInteger number = [self.contentsRandomArray[index] integerValue];
    [self.contentsRandomArray removeObjectAtIndex:index];
    return number;
}
- (NSInteger)imagesRandom:(NSInteger)textsArraycount
{
    NSInteger count = self.imagesRandomArray.count;
    int index = arc4random() % count;
    NSUInteger number = [self.imagesRandomArray[index] integerValue];
    [self.imagesRandomArray removeObjectAtIndex:index];
    return number;
}

// 外部调用创建 cell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identify = @"identify";
    HHomeFirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[HHomeFirstTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    return cell;
}

- (void)addBannerImageView
{
    [self.contentsArray addObject:NSLocalizedString(@"bannerFirst", nil)];
    [self.imagesArray addObject:[UIImage imageNamed:@"bannerFirst.png"]];
    
    self.bannerView = [[HBannerView alloc] initViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT * 0.25) autoPlayTime:5.0f imagesArray:self.imagesArray textsArray:(NSArray *)self.textsArray clickCallBack:^(NSInteger index){
        if ([self.bannerDelegate respondsToSelector:@selector(bannerWebName:)]) {
            [self.bannerDelegate bannerWebName:self.textsArray[(long)index]];
        }
    }];
    [self.contentView addSubview:self.bannerView];
}

- (void)cancelBannerImageView
{
    [self.contentsArray removeLastObject];
    [self.imagesArray removeLastObject];
    
    self.bannerView = [[HBannerView alloc] initViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT * 0.25) autoPlayTime:5.0f imagesArray:self.imagesArray textsArray:(NSArray *)self.textsArray clickCallBack:^(NSInteger index){
        if ([self.bannerDelegate respondsToSelector:@selector(bannerWebName:)]) {
            [self.bannerDelegate bannerWebName:self.textsArray[(long)index]];
        }
    }];
    [self.contentView addSubview:self.bannerView];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
