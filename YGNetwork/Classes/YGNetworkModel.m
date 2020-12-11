//
//  YGNetworkModel.m
//  Pods
//
//  Created by YG on 12/11/2020.
//  Copyright (c) 2020 YG. All rights reserved.
//

#import "YGNetworkModel.h"

@implementation YGNetworkModel

+ (instancetype)instanceUrl:(NSString *)url
                     method:(YGNetworkRequestMethod)method
                 parameters:(id)parameters
                     router:(id)router
                     header:(NSDictionary *)header
                    success:(YGNetworkSuccess)success
                    failure:(YGNetworkFailure)failure {
    
    YGNetworkModel *networkModel = [[YGNetworkModel alloc] init];
    networkModel.url = url;
    networkModel.method = method;
    networkModel.parameters = parameters;
    networkModel.router = router;
    networkModel.header = header;
    networkModel.success = success;
    networkModel.failure = failure;
    return networkModel;
}

- (BOOL)isDictionary {
    return self.responseObj != nil && self.responseObj != NSNull.class && [self.responseObj isKindOfClass:NSDictionary.class];
}

@end
