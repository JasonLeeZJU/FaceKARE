//
//  AppDelegate.h
//  FaceKARE
//
//  Created by Anan on 2017/4/25.
//  Copyright © 2017年 Anan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBLECenterManager.h"

#define ApplicationDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;

@property (nonatomic, strong) HBLECenterManager *manager;

@property (nonatomic, strong) CBPeripheral *selectedPeripheral;
@property (nonatomic, strong) CBCharacteristic *selectedCharacteristic;

// 蒙版 View
@property (nonatomic, strong) UIView *maskView;

// setting.plist 数据（不可变数组）
@property (nonatomic, strong) NSArray *settingArray;
// information.plist 数据（不可变数组）
@property (nonatomic, strong) NSArray *informationArray;
// FAQList.plist 数据（不可变数组）
@property (nonatomic, strong) NSArray *FAQListArray;
// pictures.plist 数据（可变数组）
//@property (nonatomic, strong) NSMutableArray *picturesArray;  改为👇
// eyelidsPictures.plist (祛眼袋 - 可变数组)
@property (nonatomic, strong) NSMutableArray *eyelidsPicturesArray;
// blemishPictures.plist (淡斑 - 可变数组)
@property (nonatomic, strong) NSMutableArray *blemishPicturesArray;
// firmingPictures.plist (紧肤 - 可变数组)
@property (nonatomic, strong) NSMutableArray *firmingPicturesArray;


// 是否需要旋转
@property (nonatomic, assign) BOOL isNeedTransform;
// 连接界面图片旋转角度
@property (nonatomic, assign) CGAffineTransform angle;
// 是否快速连上当前找到的设备
@property (nonatomic, assign) BOOL isQuickConnectDevice;
// 蓝牙连接状态（是否连接上）
@property (nonatomic, assign) BOOL isConnectDevice;
// 连接界面按钮状态（只要连接上一次，除非重启，否则不可再次点击）
@property (nonatomic, assign) BOOL isOnceConnectDevice;
// 产品ID
@property (nonatomic, strong) NSString *deviceIDString;
// 固件版本
@property (nonatomic, strong) NSString *firmwareString;
// 美容状态（是否正在治疗）
@property (nonatomic, assign) BOOL isWorking;
// 美容模式
@property (nonatomic, assign) NSInteger modelID;
// 美容阶段
@property (nonatomic, assign) NSInteger subjectID;
// 美容协议最大电流
@property (nonatomic, assign) NSInteger maxElectricity;
// 美容协议当前电流
@property (nonatomic, assign) NSInteger nowElectricity;
// 美容电流数组
@property (nonatomic, strong) NSMutableArray *electricityArray;
// 胶原蛋白数组
@property (nonatomic, strong) NSMutableArray *collagenArray;
// 是否检查更换了协议
@property (nonatomic, assign) BOOL isCheckProtocol;
// 是否震动
@property (nonatomic, assign) BOOL isShake;
// 电池电量
@property (nonatomic, assign) int battery;
// 美容总时间
@property (nonatomic, assign) int totalProgress;

@property (nonatomic, assign) BOOL isReplace;

// 是否按照 setModelID 来确定显示图标
@property (nonatomic, assign) BOOL isUseSetModelID;

// 编辑状态下被选中图片的 Array
@property (nonatomic, strong) NSMutableArray *selectedPicturesArray;

// 从 App 设置到 设备的美容模式（设置按钮点击之后设置的模式-显式状态）
@property (nonatomic, assign) NSInteger setModelID;

@property (nonatomic, assign) BOOL isAbleSetModelID;

@property (nonatomic, assign) float setElectricityPercent;

// 阴影显示提示内容
- (void)addDisableConnectTips;
- (void)addChartTips;
- (void)addBigPicture:(NSIndexPath *)indexPath;
- (void)addComparePictures;

// 阴影消失
- (void)deleteMaskView;

@end
