//
//  ViewController+Test.m
//  JS_Native
//
//  Created by 李扬 on 2019/4/18.
//  Copyright © 2019 李扬. All rights reserved.
//

#import "ViewController+Test.h"
#import "JS2NaitveClass.h"

@implementation ViewController (Test)

JS2NATIVE_EXPORT_METHOD(iap_maiicon_pay:(NSString *)query hit:(NSString *)hit callback:(NSString *)callback count:(int)count open:(BOOL)isOpen)
{
    self.view.backgroundColor = [UIColor redColor];
}
////
JS2NATIVE_EXPORT_METHOD(iap_maiicon_pay:(NSString *)query)
{
    self.view.backgroundColor = [UIColor greenColor];
}
////
JS2NATIVE_EXPORT_METHOD(iap_maiicon_pay)
{
    self.view.backgroundColor = [UIColor grayColor];
}

JS2NATIVE_EXPORT_METHOD(test_no_params)
{
    self.view.backgroundColor = [UIColor blueColor];
}

@end
