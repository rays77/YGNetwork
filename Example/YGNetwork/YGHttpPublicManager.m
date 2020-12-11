//
//  YGHttpPublicManager.m
//  YGNetwork_Example
//
//  Created by YG on 12/11/2020.
//  Copyright © 2020 xxx. All rights reserved.
//

#import "YGHttpPublicManager.h"

static NSString * const kBaseUrl = @"https://api.apiopen.top/";

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
    return YES;
}

- (BOOL)yg_networkManagerFailureWithModel:(YGNetworkModel *)networkModel {
    // TODO:
    return YES;
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
