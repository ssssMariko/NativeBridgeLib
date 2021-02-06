//
//  DownloadTaskViewController.m
//  NativeBridgeLibDemo
//
//  Created by Mariko0Oo on 2021/2/6.
//
#define ScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define ScreenHeight ([UIScreen mainScreen].bounds.size.height)


#import "DownloadTaskViewController.h"
#import "WebResourceManager.h"
@interface DownloadTaskViewController ()

@property(nonatomic, strong)UIProgressView * progressView;
@end

@implementation DownloadTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    _progressView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 3.0);
    [self.view addSubview:_progressView];
     
    [WebResourceManager getWebResourceWithUrl:@"http://139.199.87.192/resource/www.zip" progressView:_progressView progress:nil successHandler:^(NSURL * _Nullable fileUrl, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
          
        });
    }];

}


@end
