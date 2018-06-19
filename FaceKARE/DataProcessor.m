//
//  DataProcessor.m
//  PainKARE1.0
//
//  Created by 吴 标 on 16/12/2015.
//  Copyright © 2015 Biao WU. All rights reserved.
//

#import "DataProcessor.h"

@implementation DataProcessor
char completeData[100];
int completeDataSize;

-(id)init{
    if (self = [super init]) {
        self.allChars = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
        self.numChars = [self.allChars length];
    }
    return self;
}

//对BLE接受的数据解码（已经考虑了处理设备分段发送的信息）
-(BOOL)decyptData:(NSData *)data{
    //判断接受到信息的长度，并且将接受到的信息存储为Byte形式准备解码
    NSInteger dataLen = [data length];
    Byte *undecryptedMessage = (Byte*)data.bytes;
    Byte *descryptedMessage;
    //如果待解码数据前两位为0x55 0xAA，则我们认为这是一条新信息开头。（0x55 0xAA为通讯协议中定义的head）
    if (undecryptedMessage[0] == 0x55 && undecryptedMessage[1] == 0xAA) {
        NSLog(@"InitSize = %lu", strlen(completeData));
        //头信息中的第3位存储着完整信息的长度，在这里获取可以用来处理分段发送的信息。
        completeDataSize = undecryptedMessage[2];
        NSLog(@"Full message size is : %d", completeDataSize);
        //前四位为head，所以如果该接受的信息包含了head,则将head后的数据进行解码
        descryptedMessage = [self decryption:(undecryptedMessage+4) size:dataLen-4];
    }
    else{
        //如果该数据不包含head,代表这条数据是分段发送过来的，并且head已经在之前的数据中发送。那我们可以直接对整条数据进行解码操作
        descryptedMessage = [self decryption:undecryptedMessage size:dataLen];
    }
    //获取之前已收到的数据长度，以及当前数据长度。有时候收到的数据可能不严格符合通讯协议。为了保险起见，当已有数据长度和当前收到的数据长度之和大于head中定义的总长度时，我们把当前收到数据长度多出的部分视为多余的错误信息。
    int currentMessageLen = (int)strlen(completeData);
    int descryptedMesLen = (int)strlen((char*)descryptedMessage);
    if ((descryptedMesLen+currentMessageLen) > completeDataSize) {
        descryptedMesLen = completeDataSize - currentMessageLen;
    }
    //将新解码的数据添加到已有数据的尾部进行合并
    for (int i = 0; i<descryptedMesLen; i++) {
        completeData[currentMessageLen+i] = descryptedMessage[i];
    }
    completeData[currentMessageLen+descryptedMesLen] = '\0';
    NSLog(@"current descripted message is %s", descryptedMessage);
    NSLog(@"current message is %s", completeData);
    NSLog(@"current size = %lu", strlen(completeData));
    
    //如果合并后的数据长度和先前head中所定义的总数据长度一样，则表明一条完整的数据被接受了。因此我们可以输出该数据，并把用来合并数据的变量清零。并返回YES。如果不相等，则表示后面还有分段数据，返回No，表示该条信息还未接受完整。
    if (strlen(completeData) == completeDataSize) {
        NSLog(@"The complete message is received!");
        self.completeMessage = [NSString stringWithCString:completeData encoding:NSUTF8StringEncoding];
        if ([self.completeMessage length] - 2 <= 0) {
            return NO;
        }
         self.completeMessage = [self.completeMessage substringWithRange:NSMakeRange(0, [self.completeMessage length] - 2)];
        
        self.completeMessageComponents = [self.completeMessage componentsSeparatedByString:@","];
        
        strcpy(completeData, "");
        NSLog(@"message after clear is: %s", completeData);
        completeDataSize = 0;
        return YES;
    }
    return NO;
}

//BLE通讯协议的加密算法
-(NSData*)encription:(const char *)code{
    NSLog(@"code is: %s", code);
    Byte head1 = 0x55;
    Byte head2 = 0xAA;
    char Buf[255];
    Byte myBuf[255];
    NSLog(@"code length: %lu ",strlen(code));
    strcpy(Buf, code);
    unsigned long size = strlen(Buf);
    char checkSum = 0;
    int i;
    for (i = 0; i < size; i++) {
        if(Buf[i]>=0x21)
        {
            Buf[i]-=0x21;
            
        }else
        {
            Buf[i]+=0x80;
        }
    }
    for (i = 0; i < size; i++) {
        checkSum+=Buf[i];
    }
    //生成最终要发送的字符串：
    myBuf[0] = head1;
    myBuf[1] = head2;
    myBuf[2] = (Byte)size;
    myBuf[3] = (Byte)checkSum;
    for (i = 0; i<size; i++) {
        myBuf[4+i] = (Byte)(Buf[i]);
    }
    //字符串已生成［head1,head2,size,checkSum,Buf]
    for (i = 0; i<(4+size); i++) {
    }
    //uint16_t val = 2;
    NSData *myData = [[NSData alloc] initWithBytes:myBuf length:size+4];
    NSLog(@"The size of encripted data is : %lu", size+4);
    return myData;
}

//BLE通讯协议的解码算法
-(Byte*)decryption:(Byte*)mydata size:(NSInteger)size{
    Byte *decryptedMessage = mydata;
    for (NSInteger i = 0; i < size; i++) {
        if(decryptedMessage[i]>=0x80)
        {
            decryptedMessage[i]-=0x80;
        }
        else
        {
            decryptedMessage[i]+=0x21;
        }
    }
    return decryptedMessage;
}

//由shortID生成buddyID（BLE名称）的压缩算法。
-(NSString *)generateBuddyID:(NSString *)shortID{
    //由于新的格式，而弃用旧格式的算法。
    //获取packingID中的prefix, year, month, index
    /*NSString *prefix = [packingID substringToIndex:5];
    NSString *year = [packingID substringWithRange:NSMakeRange(7, 2)];
    NSString *month = [packingID substringWithRange:NSMakeRange(9, 2)];
    NSString *index = [packingID substringWithRange:NSMakeRange(11, 6)];
    NSLog(@"prefix = %@\n year = %@\n month = %@\n index = %@\n", prefix, year, month, index);*/
    NSString *prefix = @"TriD-";
    NSString *year = [shortID substringWithRange:NSMakeRange(2, 2)];
    NSString *month = [shortID substringWithRange:NSMakeRange(4, 2)];
    NSString *index = [shortID substringWithRange:NSMakeRange(6, 6)];
    NSLog(@"prefix = %@\n year = %@\n month = %@\n index = %@\n", prefix, year, month, index);
    
    //将packingID中的year, month, index转化成Integer
    NSInteger yearInt = [year integerValue] % self.numChars;
    NSInteger monthInt = [month integerValue] % self.numChars;
    NSInteger indexInt = [index integerValue] % (self.numChars*3);
    
    //开始通过压缩pckingID获取buddyID
    //获取和存储新的year和month
    year = [self.allChars substringWithRange:NSMakeRange(yearInt, 1)];
    month = [self.allChars substringWithRange:NSMakeRange(monthInt, 1)];
    
    //获取和存储新的index
    index = @"";
    while (indexInt!=0) {
        NSString *indexChar = [self.allChars substringWithRange:NSMakeRange(indexInt%self.numChars, 1)];
        index = [NSString stringWithFormat:@"%@%@", indexChar, index];
        indexInt = indexInt / self.numChars;
    }
    NSInteger generatedIndexNum = [index length];
    for (int i = 0; i < (3 - generatedIndexNum); i++) {
        index = [NSString stringWithFormat:@"0%@", index];
    }
    
    //buddyID = prefix + 新的year + 新的month + 新的index
    NSString *buddyID = [NSString stringWithFormat:@"%@%@%@%@", prefix, year, month, index];
    NSLog(@"根据packingID: %@\n一个新的buddyID已生成: %@", shortID, buddyID);
    return buddyID;
}

@end
