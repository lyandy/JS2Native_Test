//
//  NSMutableDictionary+Utilities.m
//  JS2Native_Test
//
//  Created by 李扬 on 2019/5/8.
//  Copyright © 2019 李扬. All rights reserved.
//

#import "NSMutableDictionary+Utilities.h"

@implementation NSMutableDictionary (Utilities)

+ (NSMutableDictionary *)dictionaryWithQuery:(NSString *)query decode:(BOOL)decode
{
    NSMutableDictionary *parameterDict = [NSMutableDictionary dictionary];
    for (NSString *parameters in [query componentsSeparatedByString:@"&"])
    {
        NSArray *parameterArray = [parameters componentsSeparatedByString:@"="];
        if (parameterArray.count > 1)
        {
            if (decode)
            {
                [parameterDict setObject:([parameterArray[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding])forKey:([parameterArray[0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding])];
            }
            else
            {
                [parameterDict setObject:parameterArray[1] forKey:parameterArray[0]];
            }
        }
    }
    
    return parameterDict;
}

@end
