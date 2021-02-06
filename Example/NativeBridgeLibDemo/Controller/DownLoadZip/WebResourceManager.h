//
//  WebResourceManager.h
//  NativeBridgeLibDemo
//
//  Created by Mariko0Oo on 2021/2/6.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface WebResourceManager : NSObject

/// 获取web下载资源
/// @param urlStr 下载资源链接
/// @param downloadProgressBlock 下载进度回调
/// @param successHandler 结果回调
+(void)getWebResourceWithUrl:(NSString *)urlStr
                progressView:(UIProgressView *)progressView
                    progress:(void (^ _Nullable)(NSProgress *downloadProgress)) downloadProgressBlock
              successHandler:(void (^)( NSURL * _Nullable fileUrl,  NSError *_Nullable error))successHandler;
@end

NS_ASSUME_NONNULL_END
