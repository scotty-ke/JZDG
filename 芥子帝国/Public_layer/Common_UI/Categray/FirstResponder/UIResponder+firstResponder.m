//
//  UIResponder+firstResponder.m
//  芥子帝国
//
//  Created by 纳里健康 on 2018/3/8.
//  Copyright © 2018年 songK. All rights reserved.
//

#import "UIResponder+firstResponder.h"

@implementation UIResponder (firstResponder)

static __weak id currentFirstResponder;

+ (id)currentFirstResponder
{
    currentFirstResponder = nil;
    // 通过将target设置为nil，让系统自动遍历响应链
    // 从而响应链当前第一响应者响应我们自定义的方法
//    he object to receive the action message. If target is nil, the app sends the message to the first responder, from whence it progresses up the responder chain until it is handled.
    [[UIApplication sharedApplication] sendAction:@selector(findFirstResponder:)
                                               to:nil
                                             from:nil
                                         forEvent:nil];
    return currentFirstResponder;

}

- (void)findFirstResponder:(id)sender
{
    currentFirstResponder = self;
}


@end
