//
//  YGNetworkManager.h
//  Pods
//
//  Created by YG on 12/11/2020.
//  Copyright (c) 2020 YG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "YGNetworkModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol YGNetworkManagerDelegate <NSObject>
@optional
/// 用来灵活控制 base url，传 nil 时将使用 initWithBaseURL 传入的 url
- (nullable NSURL *)yg_networkManagerBaseURL;

/// 网络请求成功
/// @param networkModel 响应model
/// @return 返回YES时会触发外部的请求成功的回调，返回NO不触发
- (BOOL)yg_networkManagerSuccessWithModel:(YGNetworkModel *)networkModel;

/// 网络请求失败
/// @param networkModel 响应model
/// @return 返回YES时会触发外部的请求失败的回调，返回NO不触发
- (BOOL)yg_networkManagerFailureWithModel:(YGNetworkModel *)networkModel;

/// 请求之前给 headers 做特殊处理
/// @param url 请求的 url
/// @return 不会修改全局参数，当为 nil 时不修改当前请求的参数
- (nullable NSDictionary *)yg_networkManagerRequestBeforHeaderUrl:(NSString *)url;

/// 请求之前给 parameters 做特殊处理
/// @param url 请求的 url
/// @return 不会修改全局参数，当为 nil 时不修改当前请求的参数
- (nullable NSDictionary *)yg_networkManagerRequestBeforParameterUrl:(NSString *)url;
@end


@interface YGNetworkManager : AFHTTPSessionManager <YGNetworkManagerDelegate>
/// YGNetworkManagerDelegate
@property (nonatomic, weak, nullable) id <YGNetworkManagerDelegate> ygDelegate;
/// 基础请求头
@property (nonatomic, copy, nullable) NSDictionary *baseHeaders;
/// 基础请求参数
@property (nonatomic, copy, nullable) NSDictionary *baseParameters;
/// 请求头日志，默认NO
@property (nonatomic, assign, getter=isHeaderLog) BOOL headerLog;
/// 请求参数日志，默认NO
@property (nonatomic, assign, getter=isRequestLog) BOOL requestLog;
/// 服务器响应的数据日志，默认NO
@property (nonatomic, assign, getter=isResponseLog) BOOL responseLog;

/// 初始化
- (instancetype)initWithBaseURL:(nullable NSURL *)url;

/// 网络请求
/// @param method 请求方式
/// @param url 请求的 url
/// @param parameters 请求参数
/// @param success 请求成功回调
/// @param failure 请求失败回调
- (nullable NSURLSessionDataTask *)yg_method:(YGNetworkRequestMethod)method
                                         url:(NSString *)url
                                  parameters:(nullable id)parameters
                                     success:(YGNetworkSuccess)success
                                     failure:(YGNetworkFailure)failure;

/// 网络请求，带头部
/// @param method 请求方式
/// @param url 请求的 url
/// @param parameters 请求参数
/// @param header 请求头附加参数
/// @param success 请求成功回调
/// @param failure 请求失败回调
- (nullable NSURLSessionDataTask *)yg_method:(YGNetworkRequestMethod)method
                                         url:(NSString *)url
                                  parameters:(nullable id)parameters
                                      header:(nullable NSDictionary <NSString *, NSString *> *)header
                                     success:(YGNetworkSuccess)success
                                     failure:(YGNetworkFailure)failure;

/// 网络请求，通过路由方式请求
/// @param method 请求方式
/// @param url 请求的 url，路由参数时，路由参数使用 {*} 替代
/// @param router 路由， router：["v", "v"]，“v”
/// @param success 请求成功回调
/// @param failure 请求失败回调
- (nullable NSURLSessionDataTask *)yg_method:(YGNetworkRequestMethod)method
                                         url:(NSString *)url
                                      router:(nullable id)router
                                     success:(YGNetworkSuccess)success
                                     failure:(YGNetworkFailure)failure;

/// 网络请求，带头部，通过路由方式请求
/// @param method 请求方式
/// @param url 请求的 url，路由参数时，路由参数使用 {*} 替代
/// @param router 路由， router：["v", "v"]，“v”
/// @param header 请求头附加参数
/// @param success 请求成功回调
/// @param failure 请求失败回调
- (nullable NSURLSessionDataTask *)yg_method:(YGNetworkRequestMethod)method
                                         url:(NSString *)url
                                      router:(nullable id)router
                                      header:(nullable NSDictionary <NSString *, NSString *> *)header
                                     success:(YGNetworkSuccess)success
                                     failure:(YGNetworkFailure)failure;

/// 网络请求，通过 body 参数/路由参数方式请求
/// @param method 请求方式
/// @param url 请求的 url，路由参数时，路由参数使用 {*} 替代
/// @param parameters 请求参数
/// @param router 路由， router：["v", "v"]，“v”
/// @param success 请求成功回调
/// @param failure 请求失败回调
- (nullable NSURLSessionDataTask *)yg_method:(YGNetworkRequestMethod)method
                                         url:(NSString *)url
                                  parameters:(nullable id)parameters
                                      router:(nullable id)router
                                     success:(YGNetworkSuccess)success
                                     failure:(YGNetworkFailure)failure;

/// 网络请求，带头部，通过 body 参数/路由参数方式请求
/// @param method 请求方式
/// @param url 请求的 url，路由参数时，路由参数使用 {*} 替代
/// @param parameters 请求参数
/// @param router 路由， router：["v", "v"]，“v”
/// @param header 请求头附加参数
/// @param success 请求成功回调
/// @param failure 请求失败回调
- (nullable NSURLSessionDataTask *)yg_method:(YGNetworkRequestMethod)method
                                         url:(NSString *)url
                                  parameters:(nullable id)parameters
                                      router:(nullable id)router
                                      header:(nullable NSDictionary <NSString *, NSString *> *)header
                                     success:(YGNetworkSuccess)success
                                     failure:(YGNetworkFailure)failure;

/// POST 上传附件
/// @param url 上传的 url
/// @param parameters 上传参数
/// @param header 附加头部信息
/// @param bodyBlock 上传表单
/// @param progressBlock 上传进度
/// @param success 上传成功回调
/// @param failure 上传失败回调
- (nullable NSURLSessionDataTask *)yg_UPLOAD:(NSString *)url
                                  parameters:(nullable id)parameters
                                      header:(nullable NSDictionary <NSString *, NSString *> *)header
                                   bodyBlock:(nullable void (^)(id <AFMultipartFormData> formData))bodyBlock
                               progressBlock:(nullable void (^)(NSProgress *uploadProgress))progressBlock
                                     success:(YGNetworkSuccess)success
                                     failure:(YGNetworkFailure)failure;

@end

NS_ASSUME_NONNULL_END
