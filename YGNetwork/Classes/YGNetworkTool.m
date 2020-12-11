//
//  YGNetworkTool.m
//  Pods
//
//  Created by YG on 12/11/2020.
//  Copyright (c) 2020 YG. All rights reserved.
//

#import "YGNetworkTool.h"
#import "YGNetworkManager.h"
#import "YGNetworkMacro.h"

@implementation YGNetworkTool

+ (NSString *)jsonToString:(id)obj {

    NSString *string;
    
    if ([NSJSONSerialization isValidJSONObject:obj]) {
        
        @try {
            
            string = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
            
        } @catch (NSException *exception) {
            
            NSString *reason = [NSString stringWithFormat:@"reason：%@",exception.reason];
            string = [NSString stringWithFormat:@"转换失败：\n%@", reason];
            
        } @finally {
            
        }
    }
    
    return string;
}

#pragma mark - Log
+ (void)logHeaderObject:(id)obj url:(NSString *)url {
    if (obj) {
        NSString *logUrl = [NSString stringWithFormat:@"\n请求URL：%@", url];
        if ([obj isKindOfClass:NSDictionary.class]) {
            NSString *headerStr = [self jsonToString:obj];
            NSString *logHeaderParams = [NSString stringWithFormat:@"\n请求头：\n%@", headerStr];
            YGNSLog(@"%@%@", logUrl, logHeaderParams);
        }
    }
}

+ (void)logRequestObject:(id)obj url:(NSString *)url {
    if (obj) {
        NSString *logUrl = [NSString stringWithFormat:@"\n请求URL：%@", url];
        if ([obj isKindOfClass:NSDictionary.class]) {
            NSString *jsonStr = [self jsonToString:obj];
            NSString *logParams = [NSString stringWithFormat:@"\n请求参数：\n%@", jsonStr];
            YGNSLog(@"%@%@", logUrl, logParams);
        } else {
            YGNSLog(@"\n请求参数：\n%@", obj);
        }
    }
}

+ (void)logResponseObject:(id)obj url:(NSString *)url {
    if (obj) {
        NSString *logUrl = [NSString stringWithFormat:@"\n响应URL：%@", url];
        if ([obj isKindOfClass:NSDictionary.class]) {
            NSString *jsonStr = [self jsonToString:obj];
            NSString *logJson = [NSString stringWithFormat:@"\n响应成功：\n%@", jsonStr];
            YGNSLog(@"%@%@", logUrl, logJson);
        } else if ([obj isKindOfClass:NSError.class]) {
            NSError *error = obj;
            NSString *logError = [NSString stringWithFormat:@"\n响应失败：\n%@", error.localizedDescription];
            YGNSLog(@"%@%@", logUrl, logError);
        } else if ([obj isKindOfClass:NSURLSessionDataTask.class]) {
            NSURLSessionDataTask *task = obj;
            NSString *logData = [NSString stringWithFormat:@"\n响应成功：\n%@", ((NSMutableURLRequest *)task.response).HTTPBody];
            YGNSLog(@"%@%@", logUrl, logData);
        } else {
            YGNSLog(@"%@\n响应成功：\n%@", logUrl, obj);
        }
    }
}

#pragma mark - Method
/// 获取完整的url
/// @param urlString 后面url部分
/// @param baseUrl baseUrl部分
+ (NSString *)getIntegralUrl:(NSString *)urlString baseUrl:(NSURL *)baseUrl {
    NSString *url = urlString;
    if ([url hasPrefix:@"http"]) {
        return url;
    } else if (baseUrl) {
        // 会自动去除尾部的斜杠/
        url = [[NSURL URLWithString:url relativeToURL:baseUrl] absoluteString];
        if (url.length <= 0) {
            url = @"";
        }
    }
    return url;
}

+ (NSString *)getIntegralRouter:(id)router {
    if ([router isKindOfClass:NSString.class]) {
        return [self urlParamEncode:router];
    } else if ([router isKindOfClass:NSArray.class] && router) {
        NSMutableArray *resultArr = [[NSMutableArray alloc] init];
        for (id sonParam in router) {
            NSString *rsltParam = [NSString stringWithFormat:@"%@",sonParam];
            [resultArr addObject:[self urlParamEncode:rsltParam]];
        }
        return [resultArr componentsJoinedByString:@"/"];
    }
    return @"";
}

+ (NSString *)getIntegralUrlWithRouter:(id)router url:(NSString *)url {
    if ([url containsString:@"{*}"]) {
        url = [self replaceRouter:router url:url];
    } else {
        NSString *routerUrl = [YGNetworkTool getIntegralRouter:router];
        if (routerUrl.length > 0) {
            url = [NSString stringWithFormat:@"%@/%@", url, routerUrl];
        }
    }
    return url;
}

+ (NSString *)replaceRouter:(id)router url:(NSString *)url {
    if ([router isKindOfClass:NSString.class]) {
        url = [self replaceRouteParams:router url:url];
    } else if ([router isKindOfClass:NSArray.class] && router) {
        for (id sonParam in router) {
            url = [self replaceRouteParams:sonParam url:url];
        }
    }
    return url;
}

+ (NSString *)replaceRouteParams:(id)params url:(NSString *)url {
    NSString *str = [NSString stringWithFormat:@"%@", params];
    NSRange range = [url rangeOfString:@"{*}"];
    if (range.location != NSNotFound) {
        url = [url stringByReplacingCharactersInRange:range withString:str];
    }
    return url;
}

+ (NSString *)urlParamEncode:(NSString *)sendParam {
    // 将Url转码在进行参数传递
    NSString *charactersToEscape = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\| ";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    return [sendParam stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
}

@end
