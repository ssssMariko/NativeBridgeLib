//
//  NSString+Md5String.m
//  ZFJiOSDemo
//
//  Created by ZFJMBPro on 2020/1/17.
//  Copyright © 2020 ZFJ. All rights reserved.
//  https://gitee.com/zfj1128/ZFJWebCache

#import "NSString+Md5String.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Md5String)

- (NSString *)md5String{
    if(self == nil || [self length] == 0){
        return nil;
    }
    const char *value = [self UTF8String];
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    return outputString;
}

@end
