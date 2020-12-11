//
//  YGNetworkMacro.h
//  Pods
//
//  Created by YG on 12/11/2020.
//  Copyright (c) 2020 YG. All rights reserved.
//

#ifndef YGNetworkMacro_h
#define YGNetworkMacro_h

#ifdef DEBUG
#   define YGNSLog(fmt, ...) NSLog(fmt, ##__VA_ARGS__)
#else
#   define YGNSLog(...)
#endif

#endif /* YGNetworkMacro_h */
