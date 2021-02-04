//
//  ZFJCacheManage.h
//  ZFJiOSDemo
//
//  Created by ZFJMBPro on 2020/1/17.
//  Copyright © 2020 ZFJ. All rights reserved.
//  https://gitee.com/zfj1128/ZFJWebCache

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZFJCacheManage : NSObject

/// 获取缓存数据
/// @param request 网络请求
+ (NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)request;

/// 加载本地资源部
/// @param request 网络请求
+ (NSCachedURLResponse *)readLocalResourceData:(NSURLRequest *)request;

/// 判断有没有自动缓存的文件
+ (BOOL)isCachedForRequest:(NSURLRequest *)request;

/// 判断有没有资源包的缓存
+ (BOOL)isCachedForLocalResource:(NSURLRequest *)request;

@end

NS_ASSUME_NONNULL_END
