//
//  ZFJCacheProtocol.h
//  poseidon
//
//  Created by ZFJ on 2017/5/17.
//  Copyright © 2017年 ZFJ. All rights reserved.
//  https://gitee.com/zfj1128/ZFJWebCache

#import <Foundation/Foundation.h>
#import "ZFJMIMEType.h"

@interface ZFJCacheProtocol : NSURLProtocol

/// 开始监听
/// @param cacheType 缓存的类型
+ (void)startMonitorRequest:(ZFJCacheType)cacheType;

//取消网络监听-在不需要用到webview的时候即使的取消监听
+ (void)cancelMonitorRequest;

@end
