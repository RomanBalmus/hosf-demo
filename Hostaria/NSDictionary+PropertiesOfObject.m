//
//  NSDictionary+PropertiesOfObject.m
//  Hostaria
//
//  Created by iOS on 11/10/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "NSDictionary+PropertiesOfObject.h"
#import <objc/runtime.h>

@implementation NSDictionary (PropertiesOfObject)
static NSDateFormatter *reverseFormatter;

+ (NSDateFormatter *)getReverseDateFormatter {
    if (!reverseFormatter) {
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        reverseFormatter = [[NSDateFormatter alloc] init];
        [reverseFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
        [reverseFormatter setLocale:locale];
    }
    return reverseFormatter;
}

+ (NSDictionary *)dictionaryWithPropertiesOfObject:(id)obj {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([obj class], &count);
    
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        id object = [obj valueForKey:key];
        
        if (object) {
            if ([object isKindOfClass:[NSArray class]]) {
                NSMutableArray *subObj = [NSMutableArray array];
                for (id o in object) {
                    [subObj addObject:[self dictionaryWithPropertiesOfObject:o]];
                }
                dict[key] = subObj;
            }
            else if ([object isKindOfClass:[NSString class]]) {
                dict[key] = object;
            } else if ([object isKindOfClass:[NSDate class]]) {
                dict[key] = [[NSDictionary getReverseDateFormatter] stringFromDate:(NSDate *) object];
            } else if ([object isKindOfClass:[NSNumber class]]) {
                dict[key] = object;
            } else if ([[object class] isSubclassOfClass:[NSObject class]]) {
                dict[key] = [self dictionaryWithPropertiesOfObject:object];
            }
        }
        
    }
    return dict;
}

@end
