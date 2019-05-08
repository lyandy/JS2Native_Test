//
//  MMWebviewJSNative.m
//  PlatformSDK
//
//  Created by 李扬 on 2019/4/18.
//  Copyright © 2019 taou. All rights reserved.
//

#import "MMWebviewJSNative.h"
#import <objc/runtime.h>

@interface MMWebviewJSNative ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, void (^)(NSDictionary *)> *dictM;

@end

@implementation MMWebviewJSNative

- (NSMutableDictionary<NSString *,void (^)(NSDictionary *)> *)dictM
{
    if (_dictM == nil)
    {
        _dictM = [NSMutableDictionary dictionary];
    }
    return _dictM;
}

+ (void)registerJsUrlPath:(NSString *)urlPath callBlock:(void (^)(NSDictionary *))block relation:(NSObject *)relation
{
    if (urlPath.length > 0 && block != nil)
    {
        NSObject *obj = [relation valueForKey:@"_webviewJsNative"];
        if ([obj isKindOfClass:[MMWebviewJSNative class]])
        {
            @synchronized (self) {
                [((MMWebviewJSNative *)obj).dictM setValue:block forKey:urlPath];
            }
        }
    }
}

+ (void)callByJsUrlPath:(NSString *)urlPath query:(NSString *)query relation:(NSObject *)relation
{
    void(^block)(NSDictionary *) = nil;
    
    NSObject *obj = [relation valueForKey:@"_webviewJsNative"];
    if ([obj isKindOfClass:[MMWebviewJSNative class]])
    {
        @synchronized (self) {
            block = [((MMWebviewJSNative *)obj).dictM objectForKey:urlPath];
        }
    }
    if (block != nil)
    {
        NSDictionary *parameters = [NSMutableDictionary dictionaryWithQuery:query decode:YES];
        block(parameters);
        return;
    }
}

+ (void)prepareJS2NativeRegisterByRelation:(NSObject *)relation
{
    [relation setValue:[[MMWebviewJSNative alloc] init] forKey:@"_webviewJsNative"];
    unsigned int count;
    Method *methods = class_copyMethodList([relation class], &count);
    for (int i = 0; i < count; i++) {
        SEL sel = method_getName(methods[i]);
        NSString *selName = [NSString stringWithUTF8String:sel_getName(sel)];
        NSLog(@"%@", selName);
        
        NSArray<NSString *> *arr = [selName componentsSeparatedByString:@"__"];
        if (arr.count == 3)
        {
            if ([arr.firstObject isEqualToString:@"register"] && [arr.lastObject isEqualToString:@"Js2Native"])
            {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [relation performSelector:sel];
#pragma clang diagnostic pop
            }
        }
    }
    free(methods);
}

- (void)dealloc
{
    NSLog(@"");
}

@end
