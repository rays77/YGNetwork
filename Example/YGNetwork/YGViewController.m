//
//  YGViewController.m
//  YGNetwork
//
//  Created by YG on 12/11/2020.
//  Copyright (c) 2020 YG. All rights reserved.
//

#import "YGViewController.h"
#import <YGNetwork/YGNetwork.h>
#import "YGHttpPublicManager.h"

@interface YGViewController ()

@end

@implementation YGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self defaultHttpManager];
//    [self pubLichHttpManager];
}

- (void)defaultHttpManager {
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
    
    [YGNetworkHttpRequest.shared yg_method:YGGET url:@"https://api.apiopen.top/getJoke" parameters:params header:@{@"hh":@"哈哈哈"} success:^(id  _Nullable responseObject) {
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)pubLichHttpManager {
    
    id params1 = @{
        @"page": @"1",
    };
    
    [YGHTTPPublicManager yg_method:YGGET url:@"/getJok" parameters:params1 success:^(id  _Nullable responseObject) {
        NSLog(@"成功=========%@", responseObject);
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"失败=========%@", error);
    }];
}

@end
