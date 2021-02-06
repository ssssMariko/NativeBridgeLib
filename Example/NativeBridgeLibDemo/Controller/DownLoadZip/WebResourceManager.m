//
//  WebResourceManager.m
//  NativeBridgeLibDemo
//
//  Created by Mariko0Oo on 2021/2/6.
//

#import "WebResourceManager.h"
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/UIProgressView+AFNetworking.h>
#import <NativeBridgeLib/NSString+Md5String.h>
#import <SSZipArchive/ZipArchive.h>

static NSString *const kCachesDirectory = @"zipDownload";

@interface WebResourceManager()

@end
@implementation WebResourceManager


/// 获取web下载资源
/// @param urlStr 下载资源链接
/// @param downloadProgressBlock 下载进度回调
/// @param successHandler 结果回调
+(void)getWebResourceWithUrl:(NSString *)urlStr
                progressView:(UIProgressView *)progressView
                    progress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock
              successHandler:(void (^)( NSURL * _Nullable fileUrl,  NSError *_Nullable error))successHandler{
   
    NSString * md5 = [urlStr md5String];
    NSString * zipPath = [self tempZipPath:md5];
    NSString * unzipPath = [self tempUnzipPath:md5];
    
    BOOL isFileExists = [[NSFileManager defaultManager] fileExistsAtPath:unzipPath];
    
    if (isFileExists) {
        NSURL * webUrl = [self webPath:unzipPath];
        successHandler(webUrl,nil);
    } else {
        NSURL * url = [NSURL URLWithString:urlStr];
        if (url == nil) {
            return;
        }
        NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager * manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        
        NSURLRequest * request = [NSURLRequest requestWithURL:url];
        
        __weak typeof(self) weakSelf = self;

        NSURLSessionDownloadTask * downloadTask = [manager
                                                   downloadTaskWithRequest:request
                                                   progress:downloadProgressBlock
                                                   destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            return [NSURL fileURLWithPath:zipPath];
        }
                                                   completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            if (error == nil) {
                NSLog(@"File downloaded to: %@", filePath);
                NSError *unzipError;
                BOOL isUnzipSuccess = [SSZipArchive unzipFileAtPath:zipPath toDestination:unzipPath overwrite:YES password:nil error:&unzipError];
                
//                BOOL isUnzipSuccess = [SSZipArchive unzipFileAtPath:zipPath toDestination:unzipPath overwrite:YES password:nil progressHandler:nil completionHandler:nil];
                if (isUnzipSuccess) {
                    NSLog(@"%@ 解压成功，返回html",filePath);

                    NSURL * webUrl = [weakSelf webPath:unzipPath];
                    successHandler(webUrl,nil);
                    
                    [[NSFileManager defaultManager] removeItemAtPath:zipPath error:nil];
                } else {
                    NSLog(@"%@ 解压失败",filePath);
                    successHandler(nil,unzipError);
                }
                
            } else {
                NSLog(@"%@ 下载失败",urlStr);
                successHandler(nil,error);
            }
        }];
        [downloadTask resume];
        if (progressView) {
            [progressView setProgressWithDownloadProgressOfTask:downloadTask animated:YES];
        }
    }
    
}
#pragma mark - ————— Helper methods —————

/// 下载zip的文件路径
/// - Parameter fileName: 文件名 一般md5
/// - Returns:
+(NSString *)tempZipPath:(NSString *)fileName{
    NSString * path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES)[0];
    NSString * zipPath = [NSString stringWithFormat:@"%@/%@/%@.zip",path,kCachesDirectory,fileName];
    return zipPath;
}

/// zip解压目录
/// - Parameter fileName: 文件名 一般md5
/// - Returns:
+(NSString *)tempUnzipPath:(NSString *)fileName{
    NSString * path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES)[0];
    NSString * zipPath = [NSString stringWithFormat:@"%@/%@/%@",path,kCachesDirectory,fileName];
    return zipPath;
}

/// zip压缩后的文件目录转换成html
/// - Parameter filePath: zip压缩后的文件目录
/// - Returns:
+(NSURL *)webPath:(NSString *)filePath{
   NSArray * subPaths = [[NSFileManager defaultManager] subpathsAtPath:filePath];
    NSString *webPath = [NSString stringWithFormat:@"%@/%@/index.html",filePath,subPaths[0]];
    NSURL * url = [NSURL fileURLWithPath:webPath];
    return url;
}
@end
