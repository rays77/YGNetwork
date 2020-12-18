//
//  YGNetworkManager.m
//  Pods
//
//  Created by YG on 12/11/2020.
//  Copyright (c) 2020 YG. All rights reserved.
//

#import "YGNetworkManager.h"
#import "YGNetworkMacro.h"
#import "YGNetworkTool.h"

@implementation YGNetworkManager

/// task 成功回调
typedef void(^YGNetworkDataTaskSuccess)(NSURLSessionDataTask * _Nonnull task);

#pragma mark - Init
- (instancetype)initWithBaseURL:(NSURL *)url {
    if (self = [super initWithBaseURL:url]) {
        
        self.requestSerializer.timeoutInterval = 20;
        
        // 设置打印开关
        self.headerLog = NO;
        self.requestLog = NO;
        self.responseLog = NO;
        
        /*
        // 安全策略，默认无条件信任
        self.securityPolicy = [[AFSecurityPolicy alloc] init];
        // 是否允许无效的证书，也就是自建证书
        self.securityPolicy.allowInvalidCertificates = YES;
        // 是否验证域名
        self.securityPolicy.validatesDomainName = NO;
         */
    }
    return self;
}

#pragma mark - Public Method

/// 合并请求头参数（外部传入参数 + baseHeaders参数）
/// @param headers 外部传入参数
- (NSDictionary *)mergeBaseHeaders:(NSDictionary *)headers {
    if (headers && self.baseHeaders) {
        NSMutableDictionary *headersParams = @{}.mutableCopy;
        [headersParams setValuesForKeysWithDictionary:self.baseHeaders];
        [headersParams setValuesForKeysWithDictionary:headers];
        return headersParams;
    } else if (self.baseHeaders) {
        return self.baseHeaders;
    }
    return headers;
}

/// 合并请求体参数（外部传入参数 + baseParameters参数）
/// @param parameters 外部传入参数
- (id)mergeBaseParameters:(id)parameters {
    if (parameters && self.baseParameters) {
        if ([parameters isKindOfClass:NSDictionary.class]) {
            NSMutableDictionary *paras = @{}.mutableCopy;
            [paras setValuesForKeysWithDictionary:self.baseParameters];
            [paras setValuesForKeysWithDictionary:parameters];
            return paras;
        }
    } else if (self.baseParameters) {
        return self.baseParameters;
    }
    return parameters;
}

/// 输出请求报文
- (void)logRequestUrlString:(NSString *)urlString header:(NSDictionary *)header parameters:(id)parameters {
    if (self.isHeaderLog) {
        NSMutableDictionary *headers = @{}.mutableCopy;
        if (self.requestSerializer.HTTPRequestHeaders) {
            [headers setValuesForKeysWithDictionary:self.requestSerializer.HTTPRequestHeaders];
        }
        if (header) {
            [headers setValuesForKeysWithDictionary:header];
        }
        [YGNetworkTool logHeaderObject:headers url:urlString];
    }
    
    if (self.isRequestLog) {
        [YGNetworkTool logRequestObject:parameters url:urlString];
    }
}

/// 成功时，输出响应内容
- (void)logResponseUrlString:(NSString *)urlString responseObject:(id)responseObject networkModel:(YGNetworkModel *)networkModel success:(YGNetworkSuccess)success {
    if (self.isResponseLog) {
        [YGNetworkTool logResponseObject:responseObject url:urlString];
    }
    
    BOOL isCallBack = [self processDelegateWithModel:networkModel success:success failure:nil];
    
    // 在实现代理时是否需要相应网络请求的block回调
    if (success && isCallBack) {
        success(responseObject);
    }
}

/// 输出响应内容，从 task 中获取code
- (void)logResponseUrlString:(NSString *)urlString dataTask:(NSURLSessionDataTask *)task networkModel:(YGNetworkModel *)networkModel success:(YGNetworkDataTaskSuccess)success {
    if (self.isResponseLog) {
        [YGNetworkTool logResponseObject:task url:urlString];
    }
    
    BOOL isCallBack = [self processDelegateWithModel:networkModel success:success failure:nil];
    
    // 在实现代理时是否需要相应网络请求的block回调
    if (success && isCallBack) {
        success(task);
    }
}

/// 失败时，输出响应内容
- (void)logResponseUrlString:(NSString *)urlString error:(NSError *)error networkModel:(YGNetworkModel *)networkModel failure:(YGNetworkFailure)failure {
    if (self.isResponseLog) {
        [YGNetworkTool logResponseObject:error url:urlString];
    }
    
    BOOL isCallBack = [self processDelegateWithModel:networkModel success:nil failure:failure];
    
    // 在实现代理时是否需要相应网络请求的block回调
    if (failure && isCallBack) {
        failure(error);
    }
}

/// 处理成功和失败的代理
- (BOOL)processDelegateWithModel:(YGNetworkModel *)model success:(YGNetworkDataTaskSuccess)success failure:(YGNetworkFailure)failure {
    if (self.ygDelegate) {
        if ([self.ygDelegate respondsToSelector:@selector(yg_networkManagerSuccessWithModel:)]) {
            model.success = success;
            return [self.ygDelegate yg_networkManagerSuccessWithModel:model];
        }
        if ([self.ygDelegate respondsToSelector:@selector(yg_networkManagerFailureWithModel:)]) {
            model.failure = failure;
            return [self.ygDelegate yg_networkManagerFailureWithModel:model];
        }
    }
    return YES;
}

/// 处理附加请求头代理
- (id)requestBeforUrl:(NSString *)url headers:(id)headers {
    if (self.ygDelegate && [self.ygDelegate respondsToSelector:@selector(yg_networkManagerRequestBeforHeaderUrl:)]) {
        NSDictionary *changeHeader = [self.ygDelegate yg_networkManagerRequestBeforHeaderUrl:url];
        if (changeHeader && headers) {
            NSMutableDictionary *resultHeader = @{}.mutableCopy;
            [resultHeader setValuesForKeysWithDictionary:changeHeader];
            [resultHeader setValuesForKeysWithDictionary:headers];
            return resultHeader;
        } else if (changeHeader) {
            return changeHeader;
        }
    }
    return headers;
}

/// 处理附加请求体代理
- (id)requestBeforUrl:(NSString *)url parameters:(id)parameters {
    if (self.ygDelegate && [self.ygDelegate respondsToSelector:@selector(yg_networkManagerRequestBeforParameterUrl:)]) {
        id changeObj = [self.ygDelegate yg_networkManagerRequestBeforParameterUrl:url];
        if (changeObj && parameters) {
            if ([parameters isKindOfClass:NSDictionary.class]) {
                NSMutableDictionary *resultParams = @{}.mutableCopy;
                [resultParams setValuesForKeysWithDictionary:changeObj];
                [resultParams setValuesForKeysWithDictionary:parameters];
                return resultParams;
            }
        } else if (changeObj) {
            return changeObj;
        }
    }
    // 其它数据类型不做组装处理
    return parameters;
}

#pragma mark - Request Method

#pragma mark 参数请求
- (NSURLSessionDataTask *)yg_method:(YGNetworkRequestMethod)method
                                url:(NSString *)url
                         parameters:(id)parameters
                            success:(YGNetworkSuccess)success
                            failure:(YGNetworkFailure)failure {
    return [self yg_method:method url:url parameters:parameters header:nil success:success failure:failure];
}

- (NSURLSessionDataTask *)yg_method:(YGNetworkRequestMethod)method
                                url:(NSString *)url
                         parameters:(id)parameters
                             header:(NSDictionary<NSString *,NSString *> *)header
                            success:(YGNetworkSuccess)success
                            failure:(YGNetworkFailure)failure {
    return [self yg_method:method url:url parameters:parameters router:nil header:header success:success failure:failure];
}

#pragma mark 路由参数请求

- (NSURLSessionDataTask *)yg_method:(YGNetworkRequestMethod)method
                                url:(NSString *)url
                             router:(id)router
                            success:(YGNetworkSuccess)success
                            failure:(YGNetworkFailure)failure {
    return [self yg_method:method url:url parameters:nil router:router header:nil success:success failure:failure];
}

- (NSURLSessionDataTask *)yg_method:(YGNetworkRequestMethod)method
                                url:(NSString *)url
                             router:(id)router
                             header:(NSDictionary<NSString *,NSString *> *)header
                            success:(YGNetworkSuccess)success
                            failure:(YGNetworkFailure)failure {
    return [self yg_method:method url:url parameters:nil router:router header:header success:success failure:failure];
}

#pragma mark - body参数和路由参数请求

- (NSURLSessionDataTask *)yg_method:(YGNetworkRequestMethod)method url:(NSString *)url parameters:(id)parameters router:(id)router success:(YGNetworkSuccess)success failure:(YGNetworkFailure)failure {
    return [self yg_method:method url:url parameters:parameters router:router header:nil success:success failure:failure];
}

- (NSURLSessionDataTask *)yg_method:(YGNetworkRequestMethod)method url:(NSString *)url parameters:(id)parameters router:(id)router header:(NSDictionary<NSString *,NSString *> *)header success:(YGNetworkSuccess)success failure:(YGNetworkFailure)failure {
  
    NSString *preuUrl = [YGNetworkTool getIntegralUrlWithRouter:router url:url];
    
    NSURL *tempBaseURL = nil;
    
    if (self.ygDelegate && [self.ygDelegate respondsToSelector:@selector(yg_networkManagerBaseURL)]) {
        tempBaseURL = [self.ygDelegate yg_networkManagerBaseURL];
    }
    
    if (tempBaseURL == nil) {
        tempBaseURL = self.baseURL;
    }
    
    NSString *integralUrl = [YGNetworkTool getIntegralUrl:preuUrl baseUrl:tempBaseURL];
  
    NSDictionary *currHeader = [self requestBeforUrl:integralUrl headers:header];
    id currParams = [self requestBeforUrl:integralUrl parameters:parameters];
    
    NSDictionary *integralHeaders = [self mergeBaseHeaders:currHeader];
    id integralParams = [self mergeBaseParameters:currParams];
    [self logRequestUrlString:integralUrl header:integralHeaders parameters:integralParams];
    
    YGNetworkModel *networkModel = [YGNetworkModel instanceUrl:url method:method parameters:parameters router:router header:header success:success failure:failure];
    
    // 路由参数不需要传 params，因为参数已经在 integralUrl 中拼接好了
    return [self requestMethod:method integralUrl:integralUrl params:parameters headers:integralHeaders networkModel:networkModel success:success failure:failure];
}

#pragma mark - upload 网络请求

- (NSURLSessionDataTask *)yg_UPLOAD:(NSString *)url
                         parameters:(id)parameters
                             header:(NSDictionary<NSString *,NSString *> *)header
                          bodyBlock:(nullable void (^)(id<AFMultipartFormData> _Nonnull))bodyBlock
                      progressBlock:(nullable void (^)(NSProgress * _Nonnull))progressBlock
                            success:(nonnull YGNetworkSuccess)success
                            failure:(nonnull YGNetworkFailure)failure {
    
    NSURL *tempBaseURL = nil;
    
    if (self.ygDelegate && [self.ygDelegate respondsToSelector:@selector(yg_networkManagerBaseURL)]) {
        tempBaseURL = [self.ygDelegate yg_networkManagerBaseURL];
    }
    
    if (tempBaseURL == nil) {
        tempBaseURL = self.baseURL;
    }
    
    NSString *integralUrl = [YGNetworkTool getIntegralUrl:url baseUrl:tempBaseURL];
    
    NSDictionary *currHeader = [self requestBeforUrl:integralUrl headers:header];
    id currParams = [self requestBeforUrl:integralUrl parameters:parameters];
    
    NSDictionary *integralHeaders = [self mergeBaseHeaders:currHeader];
    id integralParams = [self mergeBaseParameters:currParams];
    [self logRequestUrlString:integralUrl header:integralHeaders parameters:integralParams];
    
                                YGNetworkModel *networkModel = [YGNetworkModel instanceUrl:url method:YGUPLOAD parameters:parameters router:nil header:header success:success failure:failure];
    
    return [self POST:integralUrl parameters:integralParams headers:integralHeaders constructingBodyWithBlock:bodyBlock progress:progressBlock success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        networkModel.responseObj = responseObject;
        [self logResponseUrlString:integralUrl responseObject:responseObject networkModel:networkModel success:success];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        networkModel.error = error;
        [self logResponseUrlString:integralUrl error:error networkModel:networkModel failure:failure];
    }];
}

#pragma mark - 统一处理请求

- (NSURLSessionDataTask *)requestMethod:(YGNetworkRequestMethod)method
                            integralUrl:(NSString *)integralUrl
                                 params:(id)params
                                headers:(NSDictionary<NSString *,NSString *> *)headers
                           networkModel:(YGNetworkModel *)networkModel
                                success:(YGNetworkSuccess)success
                                failure:(YGNetworkFailure)failure {
    
    switch (method) {
        case YGGET: {
            return [self GET:integralUrl parameters:params headers:headers progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                networkModel.responseObj = responseObject;
                [self logResponseUrlString:integralUrl responseObject:responseObject networkModel:networkModel success:success];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                networkModel.error = error;
                [self logResponseUrlString:integralUrl error:error networkModel:networkModel failure:failure];
            }];
        }
            
        case YGHEAD: {
            return [self HEAD:integralUrl parameters:params headers:headers success:^(NSURLSessionDataTask * _Nonnull task) {
                [self logResponseUrlString:integralUrl dataTask:task networkModel:networkModel success:success];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                networkModel.error = error;
                [self logResponseUrlString:integralUrl error:error networkModel:networkModel failure:failure];
            }];
        }
            
        case YGPOST: {
            return [self POST:integralUrl parameters:params headers:headers progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                networkModel.responseObj = responseObject;
                [self logResponseUrlString:integralUrl responseObject:responseObject networkModel:networkModel success:success];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                networkModel.error = error;
                [self logResponseUrlString:integralUrl error:error networkModel:networkModel failure:failure];
            }];
        }
            
        case YGPUT: {
            return [self PUT:integralUrl parameters:params headers:headers success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                networkModel.responseObj = responseObject;
                [self logResponseUrlString:integralUrl responseObject:responseObject networkModel:networkModel success:success];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                networkModel.error = error;
                [self logResponseUrlString:integralUrl error:error networkModel:networkModel failure:failure];
            }];
        }
            
        case YGPATCH: {
            return [self PATCH:integralUrl parameters:params headers:headers success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                networkModel.responseObj = responseObject;
                [self logResponseUrlString:integralUrl responseObject:responseObject networkModel:networkModel success:success];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                networkModel.error = error;
                [self logResponseUrlString:integralUrl error:error networkModel:networkModel failure:failure];
            }];
        }
            
        case YGDELETE: {
            return [self DELETE:integralUrl parameters:params headers:headers success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                networkModel.responseObj = responseObject;
                [self logResponseUrlString:integralUrl responseObject:responseObject networkModel:networkModel success:success];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                networkModel.error = error;
                [self logResponseUrlString:integralUrl error:error networkModel:networkModel failure:failure];
            }];
        }
            
        default:
            return nil;
    }
}

@end
