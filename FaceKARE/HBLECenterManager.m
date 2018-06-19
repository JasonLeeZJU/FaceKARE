
//
//  HBLECenterManager.m
//  FaceKARE
//
//  Created by Anan on 2017/5/10.
//  Copyright © 2017年 Anan. All rights reserved.
//

#import "HBLECenterManager.h"
#import "AppDelegate.h"
#import "MBProgressHUD+MJ.h"

@implementation HBLECenterManager
{
    NSString *selectedServiceUUID;
    NSString *selectedCharacteristicUUID;
    CBCharacteristic *selectedCharacteristic;
    NSOperationQueue *BLETaskQueue;
    int totalTime;
}

- (instancetype)init
{
    if (self = [super init])
    {
        self.manager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_queue_create("BLEQueue", DISPATCH_QUEUE_SERIAL)];
        self.dataProcessor = [[DataProcessor alloc] init];
        BLETaskQueue = [[NSOperationQueue alloc] init];
    }
    return self;
}

- (NSMutableArray *)discoverPeripheralsArray
{
    if (_discoverPeripheralsArray == nil)
    {
        _discoverPeripheralsArray = [NSMutableArray array];
    }
    return _discoverPeripheralsArray;
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
        case CBManagerStateUnknown:
            NSLog(@">>>CBManagerStateUnknown");
            break;
        case CBManagerStateResetting:
            NSLog(@">>>CBManagerStateResetting");
            break;
        case CBManagerStateUnsupported:
            NSLog(@">>>CBManagerStateUnsupported");
            break;
        case CBManagerStateUnauthorized:
            NSLog(@">>>CBManagerStateUnauthorized");
            break;
        case CBManagerStatePoweredOff:
            NSLog(@">>>CBManagerStatePoweredOff");
            break;
        case CBManagerStatePoweredOn:
            NSLog(@">>>CBManagerStatePoweredOn");
            break;
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"deviceIdentifier"]) {
        // 已保存蓝牙设备名字
        NSLog(@"设备名字存在");
        self.selectedDeviceIdentifier = [[NSUserDefaults standardUserDefaults] valueForKey:@"deviceIdentifier"];
        if (peripheral.name.length == 10) {
            // 蓝牙名字为10个字符的设备
            NSLog(@"蓝牙名字为10个字符");
            if ([[peripheral.name substringToIndex:5] isEqualToString:@"TriF-"])
            {
                // 蓝牙名字名字前5个字符为 TriF 的设备
                NSLog(@"蓝牙名字名字前5个字符为 TriF ，是我们的设备");
                if ([peripheral.identifier.UUIDString isEqualToString:self.selectedDeviceIdentifier]) {
                    // 查找到的设备名字是否和保存的名字一样
                    [self stopScanPeripherals];
                    ApplicationDelegate.selectedPeripheral = peripheral;
                    [self connectSelectedPeripheral];
                }
            }
            else
            {
                // 排除蓝牙名字名字前5个字符不为 TriF 的设备
                NSLog(@"蓝牙名字名字前5个字符不为 TriF ，不是我们的设备");
            }
        }
        else
        {
            // 排除蓝牙名字不为10个字符的设备
            NSLog(@"蓝牙名字不为10个字符，不是我们的设备");
        }
    }
    else
    {
        // 未保存蓝牙设备名字
        NSLog(@"设备名字不存在");
        if (peripheral.name.length == 10) {
            // 蓝牙名字为10个字符的设备
            NSLog(@"蓝牙名字为10个字符");
            if ([[peripheral.name substringToIndex:5] isEqualToString:@"TriF-"])
            {
                // 蓝牙名字名字前5个字符为 TriF 的设备
                NSLog(@"蓝牙名字名字前5个字符为 TriF ，是我们的设备");
                for (int i = 0; i < [self.discoverPeripheralsArray count]; i++)
                {
                    CBPeripheral *p = [[self.discoverPeripheralsArray objectAtIndex:i] valueForKey:@"peripheral"];
                    if ([p.name isEqualToString:peripheral.name])
                    {
                        if (p.identifier == peripheral.identifier)
                        {
                            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                 peripheral, @"peripheral",
                                                 RSSI, @"RSSI",
                                                 nil];
                            [self.discoverPeripheralsArray replaceObjectAtIndex:i withObject:dic];
                            NSLog(@"return");
                            return;
                        }
                    }
                }
                NSDictionary *peripheralsdic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                peripheral, @"peripheral",
                                                RSSI, @"RSSI",
                                                nil];
                [self.discoverPeripheralsArray addObject:peripheralsdic];
                if (ApplicationDelegate.isQuickConnectDevice == YES) {
                    // 快速连接上该设备
                    NSLog(@"快速连接上该设备 - %@",peripheralsdic);
                    ApplicationDelegate.isQuickConnectDevice = NO;
                    ApplicationDelegate.selectedPeripheral = peripheral;
                    [self connectSelectedPeripheral];
                }
            }
            else
            {
                // 排除蓝牙名字名字前5个字符不为 TriF 的设备
                NSLog(@"蓝牙名字名字前5个字符不为 TriF ，不是我们的设备");
            }
        }
        else
        {
            // 排除蓝牙名字不为10个字符的设备
            NSLog(@"蓝牙名字不为10个字符，不是我们的设备");
        }
    }
    NSLog(@"%@",self.discoverPeripheralsArray);
}

// 连接到Peripherals-失败
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@">>>连接到名称为（%@）的设备-失败,原因:%@",[peripheral name],[error localizedDescription]);
}

// Peripherals断开连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@">>>外设连接断开连接 %@: %@\n", [peripheral name], [error localizedDescription]);
    
    ApplicationDelegate.isConnectDevice = NO;
    ApplicationDelegate.deviceIDString = @"-";
    ApplicationDelegate.firmwareString = @"-";
    ApplicationDelegate.isWorking = NO;
    ApplicationDelegate.isCheckProtocol = YES;
    
    ApplicationDelegate.selectedPeripheral.delegate = nil;
    selectedServiceUUID = nil;
    selectedCharacteristicUUID = nil;
    selectedCharacteristic = nil;
    self.selectedDeviceIdentifier = nil;
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"deviceIdentifier"]) {
        [self.manager connectPeripheral:peripheral options:nil];
    }
    
    NSNotification *notification = [NSNotification notificationWithName:@"disconnectNotification" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    NSNotification *BatteryNotification = [NSNotification notificationWithName:@"BatteryNotification" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:BatteryNotification];
}

// 连接到Peripherals-成功
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@">>>连接到名称为（%@）的设备-成功",peripheral.identifier);
    [[NSUserDefaults standardUserDefaults] setObject:peripheral.name forKey:@"peripheral"];
    //@interface ViewController : UIViewController<CBCentralManagerDelegate,CBPeripheralDelegate>
    [peripheral setDelegate:self];
    //扫描外设Services，成功后会进入方法：-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    [peripheral discoverServices:nil];
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    //  NSLog(@">>>扫描到服务：%@",peripheral.services);
    if (error)
    {
        NSLog(@">>>Discovered services for %@ with error: %@", peripheral.name, [error localizedDescription]);
        return;
    }
    for (CBService *service in peripheral.services) {
        NSLog(@"%@",service.UUID);
        //扫描每个service的Characteristics，扫描到后会进入方法： -(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

// 扫描到Characteristics
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    NSLog(@"蓝牙连接+1");
    if (error)
    {
        NSLog(@"error Discovered characteristics for %@ with error: %@", service.UUID, [error localizedDescription]);
        return;
    }
    for (CBCharacteristic *characteristic in service.characteristics)
    {
        NSLog(@"service:%@ 的 Characteristic: %@",service.UUID,characteristic.UUID);
        selectedServiceUUID = [[NSString alloc] initWithFormat:@"%@", service.UUID];
        selectedCharacteristicUUID = [[NSString alloc] initWithFormat:@"%@", characteristic.UUID];
        selectedCharacteristic = characteristic;
        ApplicationDelegate.selectedCharacteristic = characteristic;
    }
    [self notifyCharacteristic:peripheral characteristic:selectedCharacteristic];
    
    NSNotification *notification = [NSNotification notificationWithName:@"didConnectNotification" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

// 发送蓝牙协议
- (void)writeWithoutResponceToSelectedCharacteristicWithData:(NSData *)data
{
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"[NSThread currentThread] >>> %@",[NSThread currentThread]);
        NSLog(@"data - %@",data);
        [ApplicationDelegate.selectedPeripheral writeValue:data forCharacteristic:self->selectedCharacteristic type:CBCharacteristicWriteWithoutResponse];
    }];
    // 4.队列添加任务
    [BLETaskQueue addOperation:operation];
}
- (void)sendProtocol:(const char *)code
{
    NSLog(@"%s",code);
    NSData *data = [self.dataProcessor encription:code];
    [self writeWithoutResponceToSelectedCharacteristicWithData:data];
}

// 设置通知
-(void)notifyCharacteristic:(CBPeripheral *)peripheral characteristic:(CBCharacteristic *)characteristic
{
    //设置通知，数据通知会进入：didUpdateValueForCharacteristic方法
    [peripheral setNotifyValue:YES forCharacteristic:characteristic];
}

// 取消通知
-(void)cancelNotifyCharacteristic:(CBPeripheral *)peripheral characteristic:(CBCharacteristic *)characteristic
{
    [peripheral setNotifyValue:NO forCharacteristic:characteristic];
}

// 开始搜索
- (void)beginScanPeripherals
{
    [self.manager scanForPeripheralsWithServices:nil options:nil];
}

// 停止搜索
- (void)stopScanPeripherals
{
    [self.manager stopScan];
}

// 连接设备
- (void)connectSelectedPeripheral
{
    [self.manager connectPeripheral:ApplicationDelegate.selectedPeripheral options:nil];
}

// 断开设备
- (void)disconnectSelectedPeripheral
{
    [self cancelNotifyCharacteristic:ApplicationDelegate.selectedPeripheral characteristic:selectedCharacteristic];
    [self.manager cancelPeripheralConnection:ApplicationDelegate.selectedPeripheral];
    ApplicationDelegate.selectedPeripheral.delegate = nil;
//    [self.discoverPeripheralsArray removeAllObjects];
    selectedServiceUUID = nil;
    selectedCharacteristicUUID = nil;
    self.selectedDeviceIdentifier = nil;
    ApplicationDelegate.selectedCharacteristic = nil;
}

// 获取的charateristic的值
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    // 打印出characteristic的UUID和值
    // !注意，value的类型是NSData，具体开发时，会根据外设协议制定的方式去解析数据
    NSLog(@"characteristic uuid:%@  value:%@",characteristic.UUID,characteristic.value);
    [self.dataProcessor decyptData:characteristic.value];
    
    NSLog(@"APP: Full descrypted message is :%@", self.dataProcessor.completeMessage);
    //将收到的完整数据处理成Array
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:self.dataProcessor.completeMessageComponents];
    NSLog(@"开始之前确认 array %@",array);
    
    NSLog(@"开始！");
    
    if (array) {
        //0101
        if ([[array objectAtIndex:0] isEqualToString:@"R0101"])
        {
            if ([array objectAtIndex:4]) {
                ApplicationDelegate.battery = [[array objectAtIndex:4] intValue];
                NSNotification *BatteryNotification = [NSNotification notificationWithName:@"BatteryNotification" object:nil userInfo:nil];
                [[NSNotificationCenter defaultCenter] postNotification:BatteryNotification];
            }
            if ([[array objectAtIndex:3] isEqualToString:@"idle"])
            {
                if (ApplicationDelegate.isWorking == YES) {
                    ApplicationDelegate.isWorking = NO;
                    NSNotification *notification = [NSNotification notificationWithName:@"R0101IdleNotification" object:nil userInfo:nil];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                }
            }
            else if ([[array objectAtIndex:3] isEqualToString:@"run"])
            {
                ApplicationDelegate.isWorking = YES;
                // 发送 S0508 获取美容信息
                NSData* data = [self.dataProcessor encription:"S0508\r\n"];
                NSLog(@"data base - %@",data);
                [self writeWithoutResponceToSelectedCharacteristicWithData:data];
            }
            else
            {
                if (ApplicationDelegate.isWorking == YES) {
                    ApplicationDelegate.isWorking = NO;
                    NSNotification *notification = [NSNotification notificationWithName:@"R0101StopNotification" object:nil userInfo:nil];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                }
                ApplicationDelegate.isAbleSetModelID = YES;
            }
        }
        
        //0105
        if ([[array objectAtIndex:0] isEqualToString:@"R0105"])
        {
            ApplicationDelegate.deviceIDString = [array objectAtIndex:2];
            // 发送 S0106 获取固件版本
            NSData* data = [self.dataProcessor encription:"S0106\r\n"];
            NSLog(@"data base - %@",data);
            [self writeWithoutResponceToSelectedCharacteristicWithData:data];
        }
        
        //0106
        if ([[array objectAtIndex:0] isEqualToString:@"R0106"])
        {
            ApplicationDelegate.firmwareString = [array objectAtIndex:2];
            
            NSNotification *notification = [NSNotification notificationWithName:@"R0106Notification" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }
        
        //0501
        if ([[array objectAtIndex:0] isEqualToString:@"R0501"])
        {
            if ([[array objectAtIndex:4] intValue] == 1)
            {
                //            [MBProgressHUD showError:NSLocalizedString(@"errorMessage1", nil)];
                NSNotification *notification = [NSNotification notificationWithName:@"R0501Notification1" object:nil userInfo:nil];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            }
            else if ([[array objectAtIndex:4] intValue] == 5)
            {
                //            [MBProgressHUD showError:NSLocalizedString(@"errorMessage2", nil)];
                //            NSNotification *notification = [NSNotification notificationWithName:@"R0501Notification2" object:nil userInfo:nil];
                //            [[NSNotificationCenter defaultCenter] postNotification:notification];
            }
            else if ([[array objectAtIndex:4] intValue] == 6)
            {
                //            [MBProgressHUD showError:NSLocalizedString(@"errorMessage3", nil)];
                NSNotification *notification = [NSNotification notificationWithName:@"R0501Notification1" object:nil userInfo:nil];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            }
            else
            {
                ;
            }
        }
        
        //0502
        if ([[array objectAtIndex:0] isEqualToString:@"R0502"])
        {
            int time = (int)([[array objectAtIndex:4] integerValue] / 60000) + 1;
            totalTime = totalTime + time;
            NSLog(@"final totalTime - %d",totalTime);
            
            if ((int)ApplicationDelegate.electricityArray.count < totalTime - 1) {
                for (int i = (int)ApplicationDelegate.electricityArray.count; i < totalTime - 1; i++) {
                    if (ApplicationDelegate.electricityArray.count > 0) {
                        [ApplicationDelegate.electricityArray addObject:[ApplicationDelegate.electricityArray lastObject]];
                    }
                    else
                    {
                        [ApplicationDelegate.electricityArray addObject:@"0"];
                    }
                    NSInteger collagen = [[ApplicationDelegate.collagenArray lastObject] integerValue] * 0.8;
                    [ApplicationDelegate.collagenArray addObject:[NSString stringWithFormat:@"%ld", (long)collagen]];
                }
            }
//            else if ((int)ApplicationDelegate.electricityArray.count > totalTime - 1)
//            {
//                for (int i = (int)ApplicationDelegate.electricityArray.count; i > totalTime - 1; i--) {
//                    [ApplicationDelegate.electricityArray removeLastObject];
//                    [ApplicationDelegate.collagenArray removeLastObject];
//                }
//            }
            
            NSData* data = [self.dataProcessor encription:"S0506\r\n"];
            NSLog(@"data base - %@",data);
            [self writeWithoutResponceToSelectedCharacteristicWithData:data];
        }
        
        //0506
        if ([[array objectAtIndex:0] isEqualToString:@"R0506"])
        {
            
            ApplicationDelegate.nowElectricity = [[array objectAtIndex:3] integerValue];
            ApplicationDelegate.maxElectricity = [[array objectAtIndex:4] integerValue];
            
            if ((int)ApplicationDelegate.electricityArray.count > totalTime - 1)
            {
                totalTime = totalTime + 1;
            }
            else
            {
                NSLog(@"添加一次electricityArray");
                [ApplicationDelegate.electricityArray addObject:[array objectAtIndex:3]];
                NSLog(@"添加一次collagenArray");
                if (ApplicationDelegate.collagenArray.count > 0) {
                    NSInteger collagen = [[ApplicationDelegate.collagenArray lastObject] integerValue] * 0.8 + [[array objectAtIndex:4] integerValue] * 0.2;
                    [ApplicationDelegate.collagenArray addObject:[NSString stringWithFormat:@"%ld", (long)collagen]];
                }
                else
                {
                    [ApplicationDelegate.collagenArray addObject:[array objectAtIndex:4]];
                }
                NSNotification *notification = [NSNotification notificationWithName:@"R0506Notification" object:nil userInfo:nil];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                totalTime = totalTime + 1;
                ApplicationDelegate.isAbleSetModelID = YES;
            }
            
        }
        
        //0507
        if ([[array objectAtIndex:0] isEqualToString:@"R0507"])
        {
//            if ([[array objectAtIndex:2] isEqualToString:@"OK"]) {
//                NSNotification *notification = [NSNotification notificationWithName:@"R0507Notification" object:nil userInfo:nil];
//                [[NSNotificationCenter defaultCenter] postNotification:notification];
//            }
        }
        
        //0508
        if ([[array objectAtIndex:0] isEqualToString:@"R0508"])
        {
            ApplicationDelegate.totalProgress = [[array objectAtIndex:3] intValue] + [[array objectAtIndex:4] intValue] + [[array objectAtIndex:5] intValue] + [[array objectAtIndex:6] intValue] + 3;
            
            // 判断是否是相同的协议
            NSLog(@"ApplicationDelegate.modelID  =  %ld",(long)ApplicationDelegate.modelID);
            NSLog(@"ApplicationDelegate.setModelID  =  %ld",(long)ApplicationDelegate.setModelID);
            NSLog(@"[array objectAtIndex:1] integerValue]  =  %ld",(long)[[array objectAtIndex:1] integerValue]);
            if (ApplicationDelegate.modelID == [[array objectAtIndex:1] integerValue] + 1 && ApplicationDelegate.setModelID == [[array objectAtIndex:1] integerValue] + 1) {
                NSLog(@"相同协议");
                // 判断是否是需要检查协议
                if (ApplicationDelegate.isCheckProtocol == YES) {
                    NSLog(@"需要检查");
                    ApplicationDelegate.isCheckProtocol = NO;
                    // 判断是否同一个协议重新开始
                    if (ApplicationDelegate.subjectID > [[array objectAtIndex:2] integerValue]) {
                        NSLog(@"重新开始协议");
                        [ApplicationDelegate.electricityArray removeAllObjects];
                        [ApplicationDelegate.collagenArray removeAllObjects];
                        ApplicationDelegate.modelID = [[array objectAtIndex:1] integerValue] + 1;
                        ApplicationDelegate.subjectID = [[array objectAtIndex:2] integerValue];
                        NSNotification *notification = [NSNotification notificationWithName:@"R0508DifferentNotification" object:nil userInfo:nil];
                        [[NSNotificationCenter defaultCenter] postNotification:notification];
                        if (ApplicationDelegate.isNeedTransform == YES) {
                            NSNotification *notification = [NSNotification notificationWithName:@"transformNotification" object:nil userInfo:nil];
                            [[NSNotificationCenter defaultCenter] postNotification:notification];
                        }
                        totalTime = 0;
                        for (int i = 0; i < [[array objectAtIndex:2] integerValue]; i ++) {
                            totalTime = totalTime + [[array objectAtIndex:(3 + i)] intValue] + 1 * i;
                            NSLog(@"计算出 totalTime - %d",totalTime);
                        }
                        NSData* data = [self.dataProcessor encription:"S0502\r\n"];
                        NSLog(@"data base - %@",data);
                        [self writeWithoutResponceToSelectedCharacteristicWithData:data];
                    }
                    else
                    {
                        NSLog(@"没有重新开始协议");
                        if (ApplicationDelegate.isNeedTransform == YES) {
                            NSNotification *notification = [NSNotification notificationWithName:@"transformNotification" object:nil userInfo:nil];
                            [[NSNotificationCenter defaultCenter] postNotification:notification];
                        }
                        totalTime = 0;
                        for (int i = 0; i < [[array objectAtIndex:2] integerValue]; i ++) {
                            totalTime = totalTime + [[array objectAtIndex:(3 + i)] intValue] + 1 * i;
                            NSLog(@"计算出 totalTime - %d",totalTime);
                        }
                        NSData* data = [self.dataProcessor encription:"S0502\r\n"];
                        NSLog(@"data base - %@",data);
                        [self writeWithoutResponceToSelectedCharacteristicWithData:data];
                    }
                }
                else
                {
                    NSLog(@"不需要检查");
                    if (ApplicationDelegate.isNeedTransform == YES) {
                        NSNotification *notification = [NSNotification notificationWithName:@"transformNotification" object:nil userInfo:nil];
                        [[NSNotificationCenter defaultCenter] postNotification:notification];
                    }
                    NSData* data = [self.dataProcessor encription:"S0506\r\n"];
                    NSLog(@"data base - %@",data);
                    [self writeWithoutResponceToSelectedCharacteristicWithData:data];
                }
            }
            else
            {
                NSLog(@"不相同协议");
                [ApplicationDelegate.electricityArray removeAllObjects];
                [ApplicationDelegate.collagenArray removeAllObjects];
                ApplicationDelegate.modelID = [[array objectAtIndex:1] integerValue] + 1;
                ApplicationDelegate.setModelID = [[array objectAtIndex:1] integerValue] + 1;
                ApplicationDelegate.subjectID = [[array objectAtIndex:2] integerValue];
                NSNotification *notification = [NSNotification notificationWithName:@"R0508DifferentNotification" object:nil userInfo:nil];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                if (ApplicationDelegate.isNeedTransform == YES) {
                    NSNotification *notification = [NSNotification notificationWithName:@"transformNotification" object:nil userInfo:nil];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                }
                totalTime = 0;
                for (int i = 0; i < [[array objectAtIndex:2] integerValue]; i ++) {
                    totalTime = totalTime + [[array objectAtIndex:(3 + i)] intValue] + 1 * i;
                    NSLog(@"计算出 totalTime - %d",totalTime);
                }
                NSData* data = [self.dataProcessor encription:"S0502\r\n"];
                NSLog(@"data base - %@",data);
                [self writeWithoutResponceToSelectedCharacteristicWithData:data];
            }
        }
        
        // 0509
        if ([[array objectAtIndex:0] isEqualToString:@"R0509"])
        {
            if ([[array objectAtIndex:2] isEqualToString:@"OK"]) {
                NSNotification *notification = [NSNotification notificationWithName:@"R0509Notification" object:nil userInfo:nil];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            }
        }

        // 1007
        if ([[array objectAtIndex:0] isEqualToString:@"R1007"])
        {
            NSNotification *notification = [NSNotification notificationWithName:@"R1007Notification" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }
        
        // 1008
        if ([[array objectAtIndex:0] isEqualToString:@"R1008"])
        {
            NSNotification *notification = [NSNotification notificationWithName:@"R1008Notification" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }
        
        NSLog(@"结束！");
    }
    
}

@end
