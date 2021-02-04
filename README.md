# NativeBridgeLib

[![CI Status](https://img.shields.io/travis/ssssMariko/NativeBridgeLib.svg?style=flat)](https://travis-ci.org/ssssMariko/NativeBridgeLib)
[![Version](https://img.shields.io/cocoapods/v/NativeBridgeLib.svg?style=flat)](https://cocoapods.org/pods/NativeBridgeLib)
[![License](https://img.shields.io/cocoapods/l/NativeBridgeLib.svg?style=flat)](https://cocoapods.org/pods/NativeBridgeLib)
[![Platform](https://img.shields.io/cocoapods/p/NativeBridgeLib.svg?style=flat)](https://cocoapods.org/pods/NativeBridgeLib)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

NativeBridgeLib is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'NativeBridgeLib'
```

## WebCache

### 支持的缓存类型

```objective-c
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
```



### 使用

* 在Controller的viewWillAppear开启监听,viewWillDisappear关闭。

```objective-c
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //开始监听缓存数据
    [ZFJCacheProtocol startMonitorRequest:ZFJCacheImageType];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //在不需要用到webview的时候即使的取消监听
    [ZFJCacheProtocol cancelMonitorRequest];
}
```

* 设置缓存过期时间

```objective-c
 [ZFJCacheConfig instance].updateInterval = 1200;
```

* 设置忽略的url链接

```objective-c
NSArray *ignoreUrlArray = @[@"http://www.baidu.com"];
[ZFJCacheConfig instance].ignoreUrlArray = ignoreUrlArray;
```

*  清空磁盘缓存

```objective-c
[[ZFJCacheConfig instance] clearDiskCache];
```

