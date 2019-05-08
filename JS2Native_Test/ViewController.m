//
//  ViewController.m
//  JS2Native_Test
//
//  Created by 李扬 on 2019/5/8.
//  Copyright © 2019 李扬. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>

@interface ViewController ()

@end

@implementation ViewController

typedef void (*RCTImageLoader_canHandleRequest_IMP)(id self, SEL _cmd, NSString* request, NSUInteger count);
static RCTImageLoader_canHandleRequest_IMP original_RCTImageLoader_canHandleRequest_IMP = nil;
static void replaced_RCTImageLoader_canHandleRequest_IMP(id self, SEL _cmd, NSString* request, NSUInteger count) {
    original_RCTImageLoader_canHandleRequest_IMP(self, _cmd, request, count);
    NSLog(@"");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Class cls = self.class;
    if (cls) {
        SEL sel = @selector(Js2Native__coin_pay:count:);
        Method method = class_getInstanceMethod(cls, sel);
        
        original_RCTImageLoader_canHandleRequest_IMP = (RCTImageLoader_canHandleRequest_IMP)method_setImplementation(method, (IMP)replaced_RCTImageLoader_canHandleRequest_IMP);
    }
    
    JS2NATIVE_CALL_METHOD(@"coin_pay", @"count=3a");
}

JS2NATIVE_EXPORT_METHOD(coin_pay:(NSString *)query count:(NSUInteger)count)
{
    NSLog(@"");
}

-(NSString*)description {
    return nil;
}

@end
