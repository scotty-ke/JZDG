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


/**
 重写Model的description
 */
- (NSString *)description
{
    NSMutableString *str = [NSMutableString string];
    [str appendFormat:@"\n<%@: %p>",[self class],self];
    [str appendString:@"\n{\n"];
    unsigned int outCount, i;
    
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    for (i = 0; i<outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f = property_getName(property);
        // 属性名
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        // 属性值
        id propertyValue = [self valueForKey:(NSString *)propertyName];
        
        if ([propertyValue isKindOfClass:[NSArray class]])
        {
            [str appendFormat:@"\t%@ = %@;\n",propertyName,[self descriptionWithArr:(NSArray *)propertyValue]];
            
        }
        else if([propertyValue isKindOfClass:[NSDictionary class]])
        {
            [str appendFormat:@"\t%@ = %@;\n",propertyName,[self descriptionWithDict:(NSDictionary *)propertyValue]];
        }
        else if([propertyValue isKindOfClass:[BaseModel class]])
        {
            [str appendFormat:@"\t%@ = <%@: %p>;\n",propertyName,[propertyValue class],&propertyValue];
        }
        else
        {
            [str appendFormat:@"\t%@ = %@;\n",propertyName,propertyValue];
        }
        
    }
    // 需手动释放 不受ARC约束
    free(properties);
    [str appendString:@"}\n"];
    return str;
}


/**
 修正数组中文显示问题
 */
- (NSString *)descriptionWithArr:(NSArray *)arr
{
    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"(\n"];
    
    for (id obj in arr) {
        if ([obj isKindOfClass:[BaseModel class]])
        {
            [str appendFormat:@"\t\t<%@: %p>, \n", [obj class],&obj];
        }
        else
        {
            [str appendFormat:@"\t\t%@, \n", obj];
        }
        
    }
    
    [str appendString:@"\t)"];
    
    return str;
}

/**
 修正字典中文显示问题
 */
- (NSString *)descriptionWithDict:(NSDictionary *)dict
{
    NSArray *allKeys = [dict allKeys];
    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"{\t\n "];
    for (NSString *key in allKeys) {
        id value= dict[key];
        
        if ([value isKindOfClass:[BaseModel class]])
        {
            [str appendFormat:@"\t \"%@\" = <%@: %p>,\n",key,[value class],&value];
        }
        else
        {
            [str appendFormat:@"\t \"%@\" = %@,\n",key, value];
        }
        
    }
    [str appendString:@"\t}"];
    
    return str;
}


//获取属性的方法
static const char *getPropertyType(objc_property_t property) {
    const char *attributes = property_getAttributes(property);
    //printf("attributes=%s\n", attributes);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char  *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T' && attribute[1] != '@') {
            // it's a C primitive type:
            
            // if you want a list of what will be returned for these primitives, search online for
            // "objective-c" "Property Attribute Description Examples"
            // apple docs list plenty of examples of what you get for int "i", long "l", unsigned "I", struct, etc.
            
            NSString *name = [[NSString alloc] initWithBytes:attribute + 1 length:strlen(attribute) - 1 encoding:NSASCIIStringEncoding];
            return (const char *)[name cStringUsingEncoding:NSASCIIStringEncoding];
        }
        else if (attribute[0] == 'T' && attribute[1] == '@' && strlen(attribute) == 2) {
            // it's an ObjC id type:
            return "id";
        }
        else if (attribute[0] == 'T' && attribute[1] == '@') {
            // it's another ObjC object type:
            NSString *name = [[NSString alloc] initWithBytes:attribute + 3 length:strlen(attribute) - 4 encoding:NSASCIIStringEncoding];
            return (const char  *)[name cStringUsingEncoding:NSASCIIStringEncoding];
        }
    }
    return "";
}

@end
