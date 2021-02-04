//
//  ZFJCacheConfig.m
//  Ahaschool
//
//  Created by ZFJMBPro on 2020/1/13.
//  Copyright © 2020 ahaschool. All rights reserved.
//  https://gitee.com/zfj1128/ZFJWebCache

#import "ZFJCacheConfig.h"

@interface ZFJCacheConfig ()

/// 支持的缓存类型
@property (nonatomic, strong) NSArray *supportArray;

@end

@implementation ZFJCacheConfig

- (NSInteger)updateInterval{
    if (_updateInterval == 0) {
        _updateInterval = 3600;
    }
    return _updateInterval;
}

- (NSURLSessionConfiguration *)config{
    if (!_config) {
        _config = [NSURLSessionConfiguration defaultSessionConfiguration];
    }
    return _config;
}

- (NSMutableDictionary *)lastRequestDict{
    if (!_lastRequestDict) {
        _lastRequestDict = [[NSMutableDictionary alloc] init];
    }
    return _lastRequestDict;
}

- (NSOperationQueue *)forgeroundNetQueue{
    if (!_forgeroundNetQueue) {
        _forgeroundNetQueue = [[NSOperationQueue alloc] init];
        _forgeroundNetQueue.maxConcurrentOperationCount = 10;
    }
    return _forgeroundNetQueue;
}

- (NSOperationQueue *)backgroundNetQueue{
    if (!_backgroundNetQueue) {
        _backgroundNetQueue = [[NSOperationQueue alloc] init];
        _backgroundNetQueue.maxConcurrentOperationCount = 6;
    }
    return _backgroundNetQueue;
}

- (NSArray *)ignoreUrlArray{
    if(_ignoreUrlArray == nil){
        _ignoreUrlArray = [[NSArray alloc] init];
    }
    return _ignoreUrlArray;
}


- (YYDiskCache *)diskCache{
    if (!_diskCache) {
        _diskCache = [[YYDiskCache alloc] initWithPath:self.documentPath];
    }
    return _diskCache;
}


//image video audio text message x-world application
- (void)setCacheType:(ZFJCacheType)cacheType{
    _cacheType = cacheType;
    _supportArray = [ZFJMIMEType supportArray:cacheType];
}

- (void)clearUrlDict{
    [ZFJCacheConfig instance].lastRequestDict = nil;
}

/// 是否支持缓存
- (BOOL)isSupportCache:(NSString *)mimeType{
    mimeType = [[mimeType componentsSeparatedByString:@"/"] firstObject];
    if([self.supportArray containsObject:mimeType]){
        return YES;
    }
    return NO;
}

/// 获取缓存路径
- (NSString *)documentPath{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    return documentPath;
}

/// 清空磁盘缓存
-(void)clearDiskCache{
    [self.diskCache removeAllObjects];
}


+ (instancetype)instance{
    static ZFJCacheConfig *cacheConfig = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cacheConfig = [[ZFJCacheConfig alloc] init];
    });
    return cacheConfig;
}

@end
