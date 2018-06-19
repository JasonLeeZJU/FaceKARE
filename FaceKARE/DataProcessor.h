//
//  DataProcessor.h
//  PainKARE1.0
//
//  Created by 吴 标 on 16/12/2015.
//  Copyright © 2015 Biao WU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataProcessor : NSObject
@property NSString *completeMessage;//最近收到的完整的信息

//--------- by Honey 20160723 ----------
@property NSArray *testCompleteMessageComponents1;  //改变completeMessageComponents的值
@property NSMutableArray *testCompleteMessageComponents2;  //改变completeMessageComponents的值
//---------- End ----------

@property NSArray *completeMessageComponents;//最近收到的完整信息的Array形式

//用于“通过short ID生成buddy ID的压缩算法”
@property (strong, nonatomic) NSString* allChars;
@property NSInteger numChars;

-(id)init;
-(BOOL)decyptData:(NSData*)data;//BLE接受信息解码（并处理合并分段信息），首选的信息解密方法。
-(NSData*)encription:(const char *)code;//BLE通讯协议加密算法
-(Byte*)decryption:(Byte*)mydata size:(NSInteger)size;//BLE通讯协议解密算法（一般不直接使用该方法，因为该解密方法不处理分段信息）。被-(BOOL)decyptData:(NSData*)data;方法使用。
-(NSString*)generateBuddyID:(NSString*)shortID;//通过short ID生成buddy ID的压缩算法

@end
