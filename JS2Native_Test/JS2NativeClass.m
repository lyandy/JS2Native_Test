//
//  JS2NaitveClass.m
//  JS_Native
//
//  Created by 李扬 on 2019/4/18.
//  Copyright © 2019 李扬. All rights reserved.
//

#import "JS2NativeClass.h"
#import "NSMutableDictionary+Utilities.h"

#import <objc/runtime.h>

typedef void(^paramInvocationBlock)(NSString *, NSInvocation *, NSUInteger);

static NSString * const PropertyTypeInt = @"i";
static NSString * const PropertyTypeShort = @"s";
static NSString * const PropertyTypeFloat = @"f";
static NSString * const PropertyTypeDouble = @"d";
static NSString * const PropertyTypeLong = @"l";
static NSString * const PropertyTypeLongLong = @"q";
static NSString * const PropertyTypeChar = @"c";
static NSString * const PropertyTypeBOOL1 = @"c";
static NSString * const PropertyTypeBOOL2 = @"b";
static NSString * const PropertyTypeId = @"@";

@implementation JS2NativeClass

+ (void)callJsName:(NSString *)jsName queryStr:(NSString *)query relation:(NSObject *)relation
{
    NSDictionary *selDict = [self getSelDictStrByJsName:jsName relation:relation];
    
    NSMethodSignature *signature = selDict[@"signature"];
    SEL selector = NSSelectorFromString(selDict[@"sel"]);
    NSArray *paramInvocationBlockArr = selDict[@"paramInvocation"];
    
    if (signature == nil || selector == nil || paramInvocationBlockArr == nil) return;
    
    // NSInvocation : 利用一个NSInvocation对象包装一次方法调用（方法调用者、方法名、方法参数、方法返回值）
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = relation;
    invocation.selector = selector;
    
    // query 转换为字典
    NSDictionary *parameters = [NSMutableDictionary dictionaryWithQuery:query decode:YES];
    
    // 设置参数
    for (NSInteger i = 0; i < paramInvocationBlockArr.count; i++)
    {
        NSArray *arr = paramInvocationBlockArr[i];
        paramInvocationBlock block = arr.lastObject;
        NSString *paramKey = arr.firstObject;
        block(parameters[paramKey], invocation, i + 3);
    }
    
    // 单独设置 第一个参数为 query
    if (signature.numberOfArguments > 2)
    {
        [invocation setArgument:&query atIndex:2];
    }
    
    // 调用方法
    [invocation invoke];
    
    // 获取返回值
    id returnValue = nil;
    if (signature.methodReturnLength != 0)
    { // 有返回值类型，才去获得返回值
        [invocation getReturnValue:&returnValue];
    }
}

+ (NSDictionary<NSString *, NSDictionary *> *)getSelDictStrByJsName:(NSString *)jsName relation:(NSObject *)relation
{
    @synchronized (self) {
        static NSMutableDictionary *dictM = nil;
        if (dictM == nil)
        {
            dictM = [NSMutableDictionary dictionary];
            
            unsigned int count;
            Method *methods = class_copyMethodList([relation class], &count);
            for (int i = 0; i < count; i++) {
                SEL sel = method_getName(methods[i]);
                NSString *selName = [NSString stringWithUTF8String:sel_getName(sel)];
                
                NSString *prefix = @"Js2Native__";
                if ([selName hasPrefix:prefix] == YES)
                {
                    NSLog(@"%@", selName);

                    NSString *jsRealSelName = [selName substringFromIndex:[selName rangeOfString:prefix].length];;
                    
                    NSArray<NSString *> *paramsArr = nil;
                    NSString *jsNameKey = nil;
                    if (jsRealSelName.length > 0)
                    {
                        paramsArr = [jsRealSelName componentsSeparatedByString:@":"];
                        jsNameKey = paramsArr.firstObject;
                    }
                    if (jsNameKey.length > 0)
                    {
#if DEBUG
                        NSString *assertStr = [NSString stringWithFormat:@"js2native method for %@ should be single", jsNameKey];
                        NSAssert(dictM[jsNameKey] == nil, assertStr);
#endif
                        NSMutableDictionary *signatureDictM = [NSMutableDictionary dictionary];
                        // 方法签名(方法的描述)
                        NSMethodSignature *signature = [[relation class] instanceMethodSignatureForSelector:sel];
                        [signatureDictM setValue:signature forKey:@"signature"];
                        [signatureDictM setValue:selName forKey:@"sel"];
                        
                        NSMutableArray *paramInvocationBlockArrM = [NSMutableArray array];
                        [signatureDictM setValue:paramInvocationBlockArrM forKey:@"paramInvocation"];
                        
                        [dictM setValue:signatureDictM forKey:jsNameKey];
                        
                        NSInteger paramsCount = signature.numberOfArguments - 3; // 除self、_cmd、query以外的参数个数
                        for (NSInteger i = 0; i < paramsCount; i++)
                        {
                            NSString *type = [NSString stringWithUTF8String:[signature getArgumentTypeAtIndex:i + 3]].lowercaseString;
                            
                            // 需要做参数类型判断然后解析成对应类型
                            if ([type isEqualToString:PropertyTypeInt])
                            {
                                [paramInvocationBlockArrM addObject:@[paramsArr[i + 1], ^(NSString * param, NSInvocation *invocation, NSUInteger index) {
                                    int value = [param intValue];
                                    [invocation setArgument:&value atIndex:index];
                                }]];
                            }
                            else if ([type isEqualToString:PropertyTypeShort])
                            {
                                [paramInvocationBlockArrM addObject:@[paramsArr[i + 1], ^(NSString * param, NSInvocation *invocation, NSUInteger index) {
                                    short value = (short)[param intValue];
                                    [invocation setArgument:&value atIndex:index];
                                }]];
                            }
                            else if ([type isEqualToString:PropertyTypeFloat])
                            {
                                [paramInvocationBlockArrM addObject:@[paramsArr[i + 1], ^(NSString * param, NSInvocation *invocation, NSUInteger index) {
                                    float value = [param floatValue];
                                    [invocation setArgument:&value atIndex:index];
                                }]];
                            }
                            else if ([type isEqualToString:PropertyTypeDouble])
                            {
                                [paramInvocationBlockArrM addObject:@[paramsArr[i + 1], ^(NSString * param, NSInvocation *invocation, NSUInteger index) {
                                    double value = [param doubleValue];
                                    [invocation setArgument:&value atIndex:index];
                                }]];
                            }
                            else if ([type isEqualToString:PropertyTypeLong])
                            {
                                [paramInvocationBlockArrM addObject:@[paramsArr[i + 1], ^(NSString * param, NSInvocation *invocation, NSUInteger index) {
                                    long value = (long)[param longLongValue];
                                    [invocation setArgument:&value atIndex:index];
                                }]];
                            }
                            else if ([type isEqualToString:PropertyTypeLongLong])
                            {
                                [paramInvocationBlockArrM addObject:@[paramsArr[i + 1], ^(NSString * param, NSInvocation *invocation, NSUInteger index) {
                                    long long value = [param longLongValue];
                                    [invocation setArgument:&value atIndex:index];
                                }]];
                            }
                            else if ([type isEqualToString:PropertyTypeChar])
                            {
                                [paramInvocationBlockArrM addObject:@[paramsArr[i + 1], ^(NSString * param, NSInvocation *invocation, NSUInteger index) {
                                    char value = (char)[param intValue];
                                    [invocation setArgument:&value atIndex:index];
                                }]];
                            }
                            else if ([type isEqualToString:PropertyTypeBOOL1])
                            {
                                [paramInvocationBlockArrM addObject:@[paramsArr[i + 1], ^(NSString * param, NSInvocation *invocation, NSUInteger index) {
                                    NSNumber *value = [NSNumber numberWithBool:[param boolValue]];
                                    [invocation setArgument:&value atIndex:index];
                                }]];
                            }
                            else if ([type isEqualToString:PropertyTypeBOOL2])
                            {
                                [paramInvocationBlockArrM addObject:@[paramsArr[i + 1], ^(NSString * param, NSInvocation *invocation, NSUInteger index) {
                                    BOOL value = [param boolValue];
                                    [invocation setArgument:&value atIndex:index];
                                }]];
                            }
                            else if ([type isEqualToString:PropertyTypeId])
                            {
                                [paramInvocationBlockArrM addObject:@[paramsArr[i + 1], ^(NSString * param, NSInvocation *invocation, NSUInteger index) {
                                    NSString *value = param;
                                    [invocation setArgument:&value atIndex:index];
                                }]];
                            }
                            else
                            {
                                [paramInvocationBlockArrM addObject:@[paramsArr[i + 1], ^(NSString * param, NSInvocation *invocation, NSUInteger index) {
                                }]];
                            }
                        }
                    }
                }
                
            }
            free(methods);
        }
        
        return dictM[jsName];
    }
}


@end
