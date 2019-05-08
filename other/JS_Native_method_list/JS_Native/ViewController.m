//
//  ViewController.m
//  JS_Native
//
//  Created by 李扬 on 2019/4/18.
//  Copyright © 2019 李扬. All rights reserved.
//

#import "ViewController.h"
#import "ViewController+Test.h"
#import "JS2NaitveClass.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    JS2NATIVE_CALL_METHOD(@"iap_maiicon_pay", @"&hit=ceshi&callback=测试啊");
    JS2NATIVE_CALL_METHOD(@"iap_maiicon_pay", @"&hit=ceshi&callback=测试啊&count=5&open=1");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        JS2NATIVE_CALL_METHOD(@"test_no_params", nil);
    });
}


@end
