//
//  MMWebviewJSNative.h
//  PlatformSDK
//
//  Created by 李扬 on 2019/4/18.
//  Copyright © 2019 taou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMWebviewJSNative : NSObject

+ (void)registerJsUrlPath:(NSString *)urlPath callBlock:(void(^)(NSDictionary * parameters))block relation:(NSObject *)relation;

+ (void)callByJsUrlPath:(NSString *)urlPath query:(NSString *)query relation:(NSObject *)relation;

+ (void)prepareJS2NativeRegisterByRelation:(NSObject *)relation;

@end
