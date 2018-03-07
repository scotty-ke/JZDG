//
//  BaseModel.h
//  NagriHealth
//
//  Created by 刘星辰 on 2017/3/23.
//  Copyright © 2017年 丁东. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject


/**
 Model 的属性拷贝方法

 @param obj 目标对象
 */
+ (instancetype)copyObjFrom:(id)obj;

- (instancetype)copyObjFrom:(id)obj;

@end
