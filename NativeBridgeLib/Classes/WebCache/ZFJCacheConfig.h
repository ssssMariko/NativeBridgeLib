//
//  ZFJCacheConfig.h
//  Ahaschool
//
//  Created by ZFJMBPro on 2020/1/13.
//  Copyright © 2020 ahaschool. All rights reserved.
//  https://gitee.com/zfj1128/ZFJWebCache

#import <Foundation/Foundation.h>
#import "ZFJMIMEType.h"
#import <YYCache/YYCache.h>

@interface ZFJCacheConfig : NSObject

+ (instancetype)instance;

/// 上一次url请求时间
@property (nonatomic,strong) NSMutableDictionary *lastRequestDict;

/// 支持的缓存类型
@property (nonatomic,assign) ZFJCacheType cacheType;

/// 相同的Url请求缓存时间间隔(默认3600s)
@property (nonatomic,assign) NSInteger updateInterval;

/// 为NSURLSession配置一些请求所需要的策略
@property (nonatomic,strong) NSURLSessionConfiguration *config;

/// 请求任务队列
@property (nonatomic,strong) NSOperationQueue *forgeroundNetQueue;

/// URL是否后台更新
@property (nonatomic,strong) NSOperationQueue *backgroundNetQueue;

/// 忽略的url链接
@property (nonatomic,strong) NSArray *ignoreUrlArray;

/// 本地资源部缓存路径
@property (nonatomic,  copy) NSString *localResourcePath;

/// 是否加载本地图片
@property (nonatomic,assign) BOOL isLoadLocalResource;

/// 本地存储
@property(nonatomic, strong)YYDiskCache *diskCache;

/// 清空内存中的url记录(收到内存警告的时候可以调用这个方法清空内存中的url记录)
- (void)clearUrlDict;

/// 清空磁盘缓存
-(void)clearDiskCache;

/// 获取缓存路径
- (NSString *)documentPath;

/// 是否支持缓存
- (BOOL)isSupportCache:(NSString *)mimeType;

@end
