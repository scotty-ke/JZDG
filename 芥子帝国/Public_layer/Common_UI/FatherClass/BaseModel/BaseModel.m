//
//  BaseModel.m
//  NagriHealth
//
//  Created by 刘星辰 on 2017/3/23.
//  Copyright © 2017年 丁东. All rights reserved.
//

#import "BaseModel.h"
#import <objc/runtime.h>
@implementation BaseModel

+ (instancetype)copyObjFrom:(id)obj
{
    return [[self alloc] initWithCopyObj:obj];
}

- (instancetype)initWithCopyObj:(id)obj
{
    if (self = [super init])
    {
        [self copyObjFrom:obj];
    }
    return  self;
}

- (instancetype)copyObjFrom:(id)obj
{
    NSAssert([self class] == [obj class], @"这两个类不相同啊");
    
    unsigned int outCount, i;
    // class:获取哪个类的成员属性列表
    // count:成员属性总数
    // 拷贝属性列表
    objc_property_t *properties = class_copyPropertyList([obj class], &outCount);
    
    for (i = 0; i<outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f = property_getName(property);
        // 属性名
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        // 属性值
        id propertyValue = [obj valueForKey:(NSString *)propertyName];
        
        [self setValue:propertyValue forKey:propertyName];
        
    }
    // 需手动释放 不受ARC约束
    free(properties);
    
    return self;
}

@end
