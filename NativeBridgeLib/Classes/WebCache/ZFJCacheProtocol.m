//
//  ZFJCacheProtocol.m
//  poseidon
//
//  Created by ZFJ on 2017/5/17.
//  Copyright © 2017年 ZFJ. All rights reserved.
//  https://gitee.com/zfj1128/ZFJWebCache

#import "ZFJCacheProtocol.h"
#import "ZFJCacheConfig.h"
#import "NSString+Md5String.h"
#import "ZFJCacheManage.h"

// URL有没有被记录
static NSString * const ZFJURLAlreadyHandleKey = @"alreadyHandleKey";
// URL是否后台更新
static NSString * const ZFJURLCheckUpdateBgKey = @"checkUpdateBgKey";

@interface ZFJCacheProtocol()<NSURLSessionDataDelegate>

@property (readwrite, nonatomic, strong) NSURLSession *session;
@property (readwrite, nonatomic, strong) NSMutableData *data;
@property (readwrite, nonatomic, strong) NSURLResponse *response;

@end

@implementation ZFJCacheProtocol

+ (void)startMonitorRequest:(ZFJCacheType)cacheType{
    [[ZFJCacheConfig instance] setCacheType:cacheType];
    //注册NSURLProtocol子类.这一步必须要做,注册之后,才能执行Connection的handle,执行handle的方法
    [NSURLProtocol registerClass:[ZFJCacheProtocol class]];
    // 实现WKWebView拦截功能
    Class cls = NSClassFromString(@"WKBrowsingContextController");
    SEL sel = NSSelectorFromString(@"registerSchemeForCustomProtocol:");
    if ([(id)cls respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [(id)cls performSelector:sel withObject:@"http"];
        [(id)cls performSelector:sel withObject:@"https"];
#pragma clang diagnostic pop
    }
}

+ (void)cancelMonitorRequest{
    [NSURLProtocol unregisterClass:[ZFJCacheProtocol class]];
}

// 这个方法是注册后,NSURLProtocol就会通过这个方法确定参数request是否需要被处理
// return : YES 需要经过这个NSURLProtocol"协议" 的处理, NO 这个 协议request不需要遵守这个NSURLProtocol"协议"
// 这个方法的左右 : 1, 筛选Request是否需要遵守这个NSURLRequest , 2, 处理http: , https等URL
+ (BOOL)canInitWithRequest:(NSURLRequest *)request{
    NSString *urlstr = request.URL.absoluteString;
    //过滤忽略的url链接
    if([[ZFJCacheConfig instance].ignoreUrlArray containsObject:urlstr]){
        return NO;
    }
    NSString *urlScheme = [[request URL] scheme];
    //只处理http和https请求
    if ([urlScheme caseInsensitiveCompare:@"http"] == NSOrderedSame || [urlScheme caseInsensitiveCompare:@"https"] == NSOrderedSame){
        //判断是否标记过使用缓存来处理，或者是否有标记后台更新
        //看看是否已经处理过了，防止无限循环
        if ([NSURLProtocol propertyForKey:ZFJURLAlreadyHandleKey inRequest:request] || [NSURLProtocol propertyForKey:ZFJURLCheckUpdateBgKey inRequest:request]) {
            return NO;
        }
    }
    return YES;
}

// 这个方法就是返回request,当然这里可以处理的需求有 : 1,规范化请求头的信息 2, 处理DNS劫持,重定向App中所有的请求指向等
+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request{
    return request;
}

- (void)backgroundCheckUpdate{
    __weak typeof(self) weakSelf = self;
    [[[ZFJCacheConfig instance] backgroundNetQueue] addOperationWithBlock:^{
        NSDate *updateDate = [[ZFJCacheConfig instance].lastRequestDict objectForKey:weakSelf.request.URL.absoluteString];
        if (updateDate) {
            //判读两次相同的url地址发出请求相隔的时间，如果相隔的时间小于给定的时间
            NSDate *currentDate = [NSDate date];
            NSInteger interval = [currentDate timeIntervalSinceDate:updateDate];
            if (interval < [ZFJCacheConfig instance].updateInterval) {
                return;
            }
        }
        NSMutableURLRequest *mutableRequest = [[weakSelf request] mutableCopy];
        [NSURLProtocol setProperty:@YES forKey:ZFJURLCheckUpdateBgKey inRequest:mutableRequest];
        [weakSelf netRequestWithRequest:mutableRequest];
    }];
}

- (void)netRequestWithRequest:(NSURLRequest *)request{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[ZFJCacheConfig instance].forgeroundNetQueue];
    NSURLSessionDataTask *sessionTask = [self.session dataTaskWithRequest:request];
    [[ZFJCacheConfig instance].lastRequestDict setValue:[NSDate date] forKey:self.request.URL.absoluteString];
    [sessionTask resume];
}

/// 开始加载数据
// 需要在该方法中发起一个请求，对于NSURLConnection来说，就是创建一个NSURLConnection，对于NSURLSession，就是发起一个NSURLSessionTask
// 另外一点就是这个方法之后,会回调<NSURLProtocolClient>协议中的方法,
- (void)startLoading{
    NSURLRequest *request = self.request;
   
    // 加载本地资源包的缓存
    if ([[ZFJCacheConfig instance] isLoadLocalResource]) {
        NSCachedURLResponse *urlResponse_0 = [ZFJCacheManage readLocalResourceData:request];
        if(urlResponse_0){
            //如果缓存存在，则使用缓存。并且开启异步线程去更新缓存
            [self.client URLProtocol:self didReceiveResponse:urlResponse_0.response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
            [self.client URLProtocol:self didLoadData:urlResponse_0.data];
            [self.client URLProtocolDidFinishLoading:self];
            // 加载本地资源包的缓存，不需要验证缓存是否过期
            // 如果想替换缓存直接删除或者重新下载替换资源包就行了
            return;
        }
    }
    
    
    // 加载网络请求的缓存
    NSCachedURLResponse *urlResponse_1 = [ZFJCacheManage cachedResponseForRequest:request];
    if (urlResponse_1) {
        //如果缓存存在，则使用缓存。并且开启异步线程去更新缓存
        [self.client URLProtocol:self didReceiveResponse:urlResponse_1.response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
        [self.client URLProtocol:self didLoadData:urlResponse_1.data];
        [self.client URLProtocolDidFinishLoading:self];
        [self backgroundCheckUpdate];
        return;
    }
    
    // 没有缓存
    NSMutableURLRequest *mutableRequest = [[self request] mutableCopy];
    [NSURLProtocol setProperty:@YES forKey:ZFJURLAlreadyHandleKey inRequest:mutableRequest];
    [self netRequestWithRequest:mutableRequest];
}

/// 停止加载数据
// 这个方法是和start是对应的 一般在这个方法中,断开Connection
// 另外一点就是当NSURLProtocolClient的协议方法都回调完毕后,就会开始执行这个方法了
- (void)stopLoading{
    [self.session invalidateAndCancel];
    self.session = nil;
}

- (void)appendData:(NSData *)newData{
    if ([self data] == nil) {
        [self setData:[newData mutableCopy]];
    }else {
        [[self data] appendData:newData];
    }
}

#pragma mark - NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    [self.client URLProtocol:self didLoadData:data];
    [self appendData:data];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler{
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    self.response = response;
    NSString *mimeType = self.response.MIMEType;
    if([[ZFJCacheConfig instance] isSupportCache:mimeType]){
        NSString *responseUrlMd5 = [self.response.URL.absoluteString md5String];
        [[NSUserDefaults standardUserDefaults] setValue:mimeType forKey:responseUrlMd5];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"支持缓存的mimeType == %@",mimeType);
    }else{
        NSLog(@"不支持缓存的mimeType == %@",mimeType);
    }
    NSLog(@"URL.absoluteString == %@",self.response.URL.absoluteString);
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    if (error) {
        [self.client URLProtocol:self didFailWithError:error];
    } else {
        [self.client URLProtocolDidFinishLoading:self];
        if (!self.data) {
            return;
        }
        NSCachedURLResponse *cacheUrlResponse = [[NSCachedURLResponse alloc] initWithResponse:task.response data:self.data];
        [self storeCachedResponse:cacheUrlResponse forRequest:self.request];
        self.data = nil;
    }
}

/// 将服务器返回数据缓存起来
/// @param cachedResponse URL请求响应的缓存
/// @param request 网络请求
- (void)storeCachedResponse:(NSCachedURLResponse *)cachedResponse forRequest:(NSURLRequest *)request{
    NSString *urlStringMD5 = [request.URL.absoluteString md5String];
    [[[ZFJCacheConfig instance] diskCache] setObject:cachedResponse.data forKey:urlStringMD5];
}



@end




