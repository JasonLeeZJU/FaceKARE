//
//  HBLECenterManager.h
//  FaceKARE
//
//  Created by Anan on 2017/5/10.
//  Copyright © 2017年 Anan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "DataProcessor.h"



@interface HBLECenterManager : NSObject<CBCentralManagerDelegate, CBPeripheralDelegate>

// 负责数据处理
@property (nonatomic, strong) DataProcessor *dataProcessor;

// 系统蓝牙设备管理对象，可以把它理解为主设备，通过它，可以去扫描和连接外围设备
@property (nonatomic, strong) CBCentralManager *manager;

// 用于保存被发现设备
@property (nonatomic, strong) NSMutableArray *discoverPeripheralsArray;

// 选择的设备名字
@property (nonatomic, strong) NSString *selectedDeviceIdentifier;

// 开始搜索
- (void)beginScanPeripherals;

// 停止搜索
- (void)stopScanPeripherals;

// 连接设备
- (void)connectSelectedPeripheral;

// 断开设备
- (void)disconnectSelectedPeripheral;

-(void)cancelNotifyCharacteristic:(CBPeripheral *)peripheral characteristic:(CBCharacteristic *)characteristic;

// 发送协议
- (void)writeWithoutResponceToSelectedCharacteristicWithData:(NSData *)data;

@end
