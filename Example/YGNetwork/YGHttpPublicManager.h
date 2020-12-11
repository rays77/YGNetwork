//
//  YGHttpPublicManager.h
//  YGNetwork_Example
//
//  Created by YG on 12/11/2020.
//  Copyright © 2020 xxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YGNetworkManager.h"

#define YGHTTPPublicManager           ([YGHttpPublicManager shared])

NS_ASSUME_NONNULL_BEGIN

@interface YGHttpPublicManager : YGNetworkManager

+ (instancetype)shared;

@end

NS_ASSUME_NONNULL_END
