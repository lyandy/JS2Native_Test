//
//  JS2NativeClass.h
//  JS_Native
//
//  Created by 李扬 on 2019/4/18.
//  Copyright © 2019 李扬. All rights reserved.
//

#import <Foundation/Foundation.h>


#define JS2NATIVE_EXPORT_METHOD(JsMethodSign) \
- (void)Js2Native__##JsMethodSign

#define JS2NATIVE_CALL_METHOD(JsName, query) \
[JS2NativeClass callJsName:JsName queryStr:query relation:self];

@interface JS2NativeClass : NSObject

+ (void)callJsName:(NSString *)jsName queryStr:(NSString *)query relation:(NSObject *)relation;

@end
