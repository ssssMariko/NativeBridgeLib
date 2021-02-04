//
//  ZFJCacheManage.m
//  ZFJiOSDemo
//
//  Created by ZFJMBPro on 2020/1/17.
//  Copyright © 2020 ZFJ. All rights reserved.
//  https://gitee.com/zfj1128/ZFJWebCache

#import "ZFJCacheManage.h"
#import "NSString+Md5String.h"
#import "ZFJCacheConfig.h"
#import "ZFJMIMEType.h"

@implementation ZFJCacheManage

/// 获取缓存数据
/// @param request 网络请求
+ (NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)request{
    NSString *urlStringMD5 = [request.URL.absoluteString md5String];
    NSString *mimeType = [[NSUserDefaults standardUserDefaults] objectForKey:urlStringMD5];
    //如果缓存存在，并是支持的mimeType，则返回缓存数据，否则使用系统默认处理
    YYDiskCache * diskCache = [[ZFJCacheConfig instance] diskCache];
    if ([diskCache containsObjectForKey:urlStringMD5] && mimeType != nil) {
        NSData *fileData = (NSData *)[diskCache objectForKey:urlStringMD5];
        NSURLResponse *response = [[NSURLResponse alloc] initWithURL:[request URL] MIMEType:mimeType expectedContentLength:[fileData length] textEncodingName:@"UTF-8"];
        NSCachedURLResponse *cachedResponse = [[NSCachedURLResponse alloc] initWithResponse:response data:fileData];
        return cachedResponse;
    } else {
        return nil;
    }
    
    
    
    
}

// 这里面写自己的加载下发资源的逻辑 没有需求的小伙伴可以不需要
+ (NSCachedURLResponse *)readLocalResourceData:(NSURLRequest *)request{
    NSString *absoluteString = request.URL.absoluteString;
    NSString *path = nil;
    NSString *mimeType = [ZFJMIMEType getMimeTypeWithURL:absoluteString];
    if([request.URL.absoluteString containsString:@"?"]){
        absoluteString = [[absoluteString componentsSeparatedByString:@"?"] firstObject];
    }
    // 这里面是我为了做demo随便写的 无意义
//    if ([absoluteString hasSuffix:@".png"]){
//        path = [[NSBundle mainBundle] pathForResource:@"my_image_0" ofType:@"png"];
//
//    }else if([absoluteString hasSuffix:@".jpeg"]){
//        path = [[NSBundle mainBundle] pathForResource:@"my_image_1" ofType:@"jpeg"];
//        
//    }else if ([absoluteString hasSuffix:@".jpg"]){
//        path = [[NSBundle mainBundle] pathForResource:@"my_image_3" ofType:@"jpg"];
//        
//    }else if ([absoluteString hasSuffix:@".gif"]){
//        path = [[NSBundle mainBundle] pathForResource:@"my_image_2" ofType:@"gif"];
//
//    }

    // 本地资源获取失败
    if(path == nil){
        NSLog(@"mimeType == %@",mimeType);
        NSLog(@"没用本地资源的URL == %@",request.URL.absoluteString);
        return nil;
    }
    
    NSData *fileData = [NSData dataWithContentsOfFile:path];
    NSURLResponse *response = [[NSURLResponse alloc] initWithURL:[request URL] MIMEType:mimeType expectedContentLength:[fileData length] textEncodingName:@"UTF-8"];
    NSCachedURLResponse *cachedResponse = [[NSCachedURLResponse alloc] initWithResponse:response data:fileData];
    return cachedResponse;
}

/// 判断有没有自动缓存的文件
+ (BOOL)isCachedForRequest:(NSURLRequest *)request{
    NSCachedURLResponse *urlResponse = [ZFJCacheManage cachedResponseForRequest:request];
    if (urlResponse) {
        return YES;
    }
    return NO;
}

/// 判断有没有资源包的缓存
+ (BOOL)isCachedForLocalResource:(NSURLRequest *)request{
    NSCachedURLResponse *urlResponse = [ZFJCacheManage readLocalResourceData:request];
    if (urlResponse) {
        return YES;
    }
    return NO;
}

@end
