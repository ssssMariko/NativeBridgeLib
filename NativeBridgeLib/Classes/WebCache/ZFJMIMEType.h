//
//  ZFJMIMEType.h
//  Ahaschool
//
//  Created by ZFJMBPro on 2020/1/13.
//  Copyright © 2020 ahaschool. All rights reserved.
//  https://gitee.com/zfj1128/ZFJWebCache

#import <Foundation/Foundation.h>

//image video audio text message x-world application
typedef NS_ENUM(NSInteger, ZFJCacheType) {
    ZFJCacheAllType         = 1 << 0,     //缓存全部
    ZFJCacheImageType       = 1 << 1,     //缓存图片
    ZFJCacheVideoType       = 1 << 2,     //缓存视频
    ZFJCacheAudioType       = 1 << 3,     //缓存音频
    ZFJCacheTextType        = 1 << 4,     //缓存text
    ZFJCacheMessageType     = 1 << 5,     //缓存message
    ZFJCacheX_WorldType     = 1 << 6,     //缓存x-world
    ZFJCacheApplicationType = 1 << 7,     //缓存application
    ZFJCacheNoneType        = 1 << 8,     //未知类型
};

@interface ZFJMIMEType : NSObject

/// 根据mimeType获取枚举类型
/// @param mimeType mimeType字符串
+ (ZFJCacheType)enumMimeType:(NSString *)mimeType;

/// 获取支持的mimeType类型
/// @param cacheType mimeType枚举
+ (NSArray *)supportArray:(ZFJCacheType)cacheType;

/// 根据URL获取MimeType
/// @param urlString url
+ (NSString *)getMimeTypeWithURL:(NSString *)urlString;


@end
