//
//  YGNetworkTool.h
//  Pods
//
//  Created by YG on 12/11/2020.
//  Copyright (c) 2020 YG. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YGNetworkTool : NSObject

/// 词典格式化
/// @param obj 词典对象
+ (NSString *)jsonToString:(nullable id)obj;

/// 打印请求头
/// @param obj 请求头数据
/// @param url url
+ (void)logHeaderObject:(nullable id)obj url:(nullable NSString *)url;

/// 打印请求体
/// @param obj 请求体数据
/// @param url url
+ (void)logRequestObject:(nullable id)obj url:(nullable NSString *)url;

/// 打印服务响应数据
/// @param obj 响应结果
/// @param url url
+ (void)logResponseObject:(nullable id)obj url:(nullable NSString *)url;

/// 获取完整的url
/// @param urlString 后面url部分
/// @param baseUrl baseUrl部分
+ (NSString *)getIntegralUrl:(NSString *)urlString baseUrl:(NSURL *)baseUrl;

/// 获取完整的路由部分
/// @param router 路由
+ (NSString *)getIntegralRouter:(id)router;

/// 获取我完整 url，替换路由参数
/// @param router 路由
/// @param url url
+ (NSString *)getIntegralUrlWithRouter:(id)router url:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
