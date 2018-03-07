//
//  ALAsset+Custom.m
//  easydoctor
//
//  Created by stone on 15/11/19.
//  Copyright © 2015年 easygroup. All rights reserved.
//

#import "ALAsset+Custom.h"
#import <objc/runtime.h>

@implementation ALAsset (Custom)


- (BOOL)isSelect {
    return [objc_getAssociatedObject(self, @selector(isSelect)) boolValue];
}

- (void)setIsSelect:(BOOL)value {
    objc_setAssociatedObject(self, @selector(isSelect), [NSNumber numberWithBool:value], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)tag
{
    return [objc_getAssociatedObject(self, @selector(tag)) integerValue];
}

- (void)setTag:(NSInteger)tag
{
    objc_setAssociatedObject(self, @selector(tag), [NSNumber numberWithInteger:tag], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
