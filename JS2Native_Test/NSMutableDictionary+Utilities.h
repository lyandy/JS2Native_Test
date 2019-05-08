//
//  NSMutableDictionary+Utilities.h
//  JS2Native_Test
//
//  Created by 李扬 on 2019/5/8.
//  Copyright © 2019 李扬. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableDictionary (Utilities)

+ (NSMutableDictionary *)dictionaryWithQuery:(NSString *)query decode:(BOOL)decode;

@end

NS_ASSUME_NONNULL_END
