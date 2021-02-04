//
//  ZFJMIMEType.m
//  Ahaschool
//
//  Created by ZFJMBPro on 2020/1/13.
//  Copyright © 2020 ahaschool. All rights reserved.
//  https://gitee.com/zfj1128/ZFJWebCache

#import "ZFJMIMEType.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface ZFJMIMEType ()

@end

@implementation ZFJMIMEType

//image video audio text message x-world application
+ (ZFJCacheType)enumMimeType:(NSString *)mimeType{
    mimeType = [[mimeType componentsSeparatedByString:@"/"] firstObject];
    // 图片
    if([mimeType isEqualToString:@"image"]){
        return ZFJCacheImageType;
    }
    
    // 视频
    else if([mimeType isEqualToString:@"video"]){
        return ZFJCacheVideoType;
    }
    
    // 音频
    else if([mimeType isEqualToString:@"audio"]){
        return ZFJCacheAudioType;
    }
    
    // Text
    else if([mimeType isEqualToString:@"text"]){
        return ZFJCacheTextType;
    }
    
    // message
    else if([mimeType isEqualToString:@"message"]){
        return ZFJCacheTextType;
    }
    
    // x-world
    else if([mimeType isEqualToString:@"x-world"]){
        return ZFJCacheTextType;
    }
    
    // application
    else if([mimeType isEqualToString:@"application"]){
        return ZFJCacheTextType;
    }
    
    return ZFJCacheNoneType;
}

+ (NSArray *)supportArray:(ZFJCacheType)cacheType{
    NSMutableArray *supportArray = [[NSMutableArray alloc] init];
    if (cacheType & ZFJCacheAllType){
        [supportArray addObject:@"image"];
        [supportArray addObject:@"video"];
        [supportArray addObject:@"audio"];
        [supportArray addObject:@"text"];
        [supportArray addObject:@"message"];
        [supportArray addObject:@"x-world"];
        [supportArray addObject:@"application"];
    }

    if (cacheType & ZFJCacheImageType){
        [supportArray addObject:@"image"];
    }
    
    if (cacheType & ZFJCacheVideoType){
        [supportArray addObject:@"video"];
    }
    
    if (cacheType & ZFJCacheAudioType){
        [supportArray addObject:@"audio"];
    }
    
    if (cacheType & ZFJCacheTextType){
        [supportArray addObject:@"text"];
    }
    
    if (cacheType & ZFJCacheMessageType){
        [supportArray addObject:@"message"];
    }
    
    if (cacheType & ZFJCacheX_WorldType){
        [supportArray addObject:@"x-world"];
    }
    
    if (cacheType & ZFJCacheApplicationType){
        [supportArray addObject:@"application"];
    }
    
    //去重
    NSSet *set = [NSSet setWithArray:supportArray];
    [supportArray removeAllObjects];
    [supportArray addObjectsFromArray:[set allObjects]];
    return supportArray;
}

/// 根据URL获取MimeType
/// @param urlString url
+ (NSString *)getMimeTypeWithURL:(NSString *)urlString{
    NSURL *url = [NSURL URLWithString:urlString];
    CFStringRef fileExtension = (__bridge CFStringRef)[url pathExtension];
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileExtension, NULL);
    CFStringRef MIMEType = UTTypeCopyPreferredTagWithClass(UTI, kUTTagClassMIMEType);
    CFRelease(UTI);
    return (__bridge_transfer NSString *)MIMEType;
}

@end
