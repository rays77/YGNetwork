//
//  YGNetworkHttpRequest.m
//  Pods
//
//  Created by YG on 12/11/2020.
//  Copyright (c) 2020 YG. All rights reserved.
//

#import "YGNetworkHttpRequest.h"

@implementation YGNetworkHttpRequest

static YGNetworkHttpRequest *httpManager = nil;

#pragma mark - Init
+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        httpManager = [[[self class] alloc] initWithBaseURL:nil];
    });
    return httpManager;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    if (self = [super initWithBaseURL:url]) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                          @"application/octet-stream",
                                                          @"application/json",
                                                          @"multipart/form-data",
                                                          @"text/javascript",
                                                          @"text/json",
                                                          @"text/html",
                                                          @"text/plain",
                                                          @"video/mpeg4",
                                                          @"image/jpeg",
                                                          @"image/png",
                                                          nil];
        
        self.requestSerializer.timeoutInterval = 20;
        
//        self.securityPolicy = [YGNetworkHttpRequest customSecurityPolicy];
    }
    return self;
}

/// 参考
+ (AFSecurityPolicy *)customSecurityPolicy {
    
    // 先导入证书 证书由服务端生成，具体由服务端人员操作
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"m2" ofType:@"cer"];//证书的路径 xx.cer
    NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
    
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    
    securityPolicy.pinnedCertificates = [[NSSet alloc] initWithObjects:cerData, nil];
    
    return securityPolicy;
}

@end
