# YGNetwork

[![CI Status](https://img.shields.io/travis/YG/YGNetwork.svg?style=flat)](https://travis-ci.org/yg/YGNetwork)
[![Version](https://img.shields.io/cocoapods/v/YGNetwork.svg?style=flat)](https://cocoapods.org/pods/YGNetwork)
[![License](https://img.shields.io/cocoapods/l/YGNetwork.svg?style=flat)](https://cocoapods.org/pods/YGNetwork)
[![Platform](https://img.shields.io/cocoapods/p/YGNetwork.svg?style=flat)](https://cocoapods.org/pods/YGNetwork)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

YGNetwork is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'YGNetwork'
```

### YGNetworkHttpRequest

#### 普通请求，配置基础参数

```objective-c
// 全局配置基础参数
YGNetworkHttpRequest.shared.baseParameters = @{@"type": @"video"};
YGNetworkHttpRequest.shared.baseHeaders = @{@"sss": @"24525"};
YGNetworkHttpRequest.shared.headerLog = YES;
YGNetworkHttpRequest.shared.requestLog = YES;
YGNetworkHttpRequest.shared.responseLog = YES;
  
id params = @{
      @"page": @"1",
    @"count": @"2"
};
    
[YGNetworkHttpRequest.shared yg_method:YGGET url:@"https://api.xxx/xx" parameters:params header:@{@"hh":@"哈哈哈"} success:^(id  _Nullable responseObject) {
        
} failure:^(NSError * _Nonnull error) {
        
}];
```

### YGNetworkManager

#### 特殊业务处理时，可以继承使用

```objective-c
#import "YGHttpPublicManager.h"

static NSString * const kBaseUrl = @"https://api.xxx.xxx/";

@implementation YGHttpPublicManager

static YGHttpPublicManager *publicHttpManager = nil;

#pragma mark - Init
+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
        publicHttpManager = [[[self class] alloc] initWithBaseURL:baseUrl];
    });
    return publicHttpManager;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    if (self = [super initWithBaseURL:url]) {
        // 这里可以配置特殊的SessionManager
        // TODO:
        self.ygDelegate = self;
        self.baseParameters = @{@"type": @"video"};
        self.headerLog = YES;
        self.requestLog = YES;
        self.responseLog = YES;
    }
    return self;
}

#pragma mark - YGNetworkManagerDelegate
- (BOOL)yg_networkManagerSuccessWithModel:(YGNetworkModel *)networkModel {
    // TODO: 
    // 这里可以根据不同url，不同resonseObj做特殊处理，例如存储token等信息
    return YES; // YES表示会继续触发外部成功调用时的block回调
}

- (BOOL)yg_networkManagerFailureWithModel:(YGNetworkModel *)networkModel {
    // TODO:
    // 这里可以根据不同url，不同resonseObj做特殊处理，例如错误码等
    return YES; // YES表示会继续触发外部失败调用时的block回调
}

- (NSDictionary *)yg_networkManagerRequestBeforHeaderUrl:(NSString *)url {
    // TODO:
    return nil;
}

- (NSDictionary *)yg_networkManagerRequestBeforParameterUrl:(NSString *)url {
    if ([url hasPrefix:@"https://api.apiopen.top"]) {
        return @{@"count": @"2"};
    }
    return nil;
}

@end
```

## Author

YG, xxx@gmail.com

## License

YGNetwork is available under the MIT license. See the LICENSE file for more info.
