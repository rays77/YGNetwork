//
//  YGNetworkModel.h
//  Pods
//
//  Created by YG on 12/11/2020.
//  Copyright (c) 2020 YG. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 请求方式
typedef NS_ENUM(NSInteger, YGNetworkRequestMethod) {
    YGGET = 1,
    YGPOST,
    YGHEAD,
    YGPUT,
    YGPATCH,
    YGDELETE,
    YGUPLOAD
};


/// 成功回调
typedef void(^YGNetworkSuccess)(id _Nullable responseObj);
/// 失败回调
typedef void(^YGNetworkFailure)(NSError * _Nullable error);


@interface YGNetworkModel : NSObject
/// 请求方式
@property (nonatomic, assign) YGNetworkRequestMethod method;
/// 请求url
@property (nonatomic, copy, nullable) NSString *url;
/// 请求头
@property (nonatomic, copy, nullable) NSDictionary *header;
/// 请求参数
@property (nonatomic, strong, nullable) id parameters;
/// 路由参数
@property (nonatomic, strong, nullable) id router;
/// 相应结果
@property (nonatomic, strong, nullable) id responseObj;
/// 错误信息
@property (nonatomic, strong, nullable) NSError *error;
/// 成功 block
@property (nonatomic, copy, nullable) YGNetworkSuccess success;
/// 失败 block
@property (nonatomic, copy, nullable) YGNetworkFailure failure;
/// 是否为词典，并且不为nil / null，但是包含内容为空的数据
@property (nonatomic, assign, readonly, getter=isDictionary) BOOL dictionary;
 
+ (instancetype)instanceUrl:(nullable NSString *)url
                     method:(YGNetworkRequestMethod)method
                 parameters:(nullable id)parameters
                     router:(nullable id)router
                     header:(nullable NSDictionary *)header
                    success:(nullable YGNetworkSuccess)success
                    failure:(nullable YGNetworkFailure)failure;

@end

NS_ASSUME_NONNULL_END
