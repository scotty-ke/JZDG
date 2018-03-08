//
//  UILabel+Copy.m
//  芥子帝国
//
//  Created by 纳里健康 on 2018/3/8.
//  Copyright © 2018年 songK. All rights reserved.
//

#import "UILabel+Copy.h"
#import <objc/runtime.h>

@interface UILabel()

@property (nonatomic,strong)UIColor *bgColor;

@end

@implementation UILabel (Copy)

static char *colorKey = "colorKey";

- (void)setBgColor:(UIColor *)bgColor{
    objc_setAssociatedObject(self, colorKey, bgColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)bgColor{
    return  objc_getAssociatedObject(self, colorKey);
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return (action == @selector(copyText:));
}

- (void)attachTapHandler {
    self.userInteractionEnabled = YES;
    
    self.bgColor = self.backgroundColor ;
    
    UILongPressGestureRecognizer *g = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:g];
    
    [NS_NOTIFICATION_CENTER addObserver:self selector:@selector(menuShow) name:UIMenuControllerWillShowMenuNotification object:nil];
    [NS_NOTIFICATION_CENTER addObserver:self selector:@selector(menuHide) name:UIMenuControllerWillHideMenuNotification object:nil];
    
}

//  处理手势相应事件
- (void)handleTap:(UIGestureRecognizer *)g {
    
    if (g.state == UIGestureRecognizerStateBegan)
    {
        [self becomeFirstResponder];
        
        UIMenuItem *item = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyText:)];
        [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObject:item]];
        [[UIMenuController sharedMenuController] setTargetRect:self.frame inView:self.superview];
        [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
    }
    
    
}

- (void)menuShow
{
    self.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.2];
}

-(void)menuHide
{
    self.backgroundColor = self.bgColor;
}

//  复制时执行的方法
- (void)copyText:(id)sender {
    //  通用的粘贴板
    UIPasteboard *pBoard = [UIPasteboard generalPasteboard];
    
    //  有些时候只想取UILabel的text中的一部分
    if (objc_getAssociatedObject(self, @"expectedText")) {
        pBoard.string = objc_getAssociatedObject(self, @"expectedText");
    } else {
        
        //  因为有时候 label 中设置的是attributedText
        //  而 UIPasteboard 的string只能接受 NSString 类型
        //  所以要做相应的判断
        if (self.text) {
            pBoard.string = self.text;
        } else {
            pBoard.string = self.attributedText.string;
        }
    }
}
- (BOOL)canBecomeFirstResponder {
    return [objc_getAssociatedObject(self, @selector(isCopyable)) boolValue];
}

- (void)setIsCopyable:(BOOL)number {
    objc_setAssociatedObject(self, @selector(isCopyable), [NSNumber numberWithBool:number], OBJC_ASSOCIATION_ASSIGN);
    [self attachTapHandler];
}

- (BOOL)isCopyable {
    return [objc_getAssociatedObject(self, @selector(isCopyable)) boolValue];
}

- (void)dealloc{
    [NS_NOTIFICATION_CENTER removeObserver:self];
}

@end
