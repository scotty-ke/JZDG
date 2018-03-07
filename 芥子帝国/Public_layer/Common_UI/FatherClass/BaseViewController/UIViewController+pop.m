//
//  UIViewController+pop.m
//  NagriHealth
//
//  Created by 丁东 on 2016/11/16.
//  Copyright © 2016年 丁东. All rights reserved.
//

#import "UIViewController+pop.h"
#import <objc/runtime.h>

@implementation UIViewController (pop)

-(void)popOrDismiss:(UIButton*)buuton
{
    if (self.navigationController.viewControllers.count == 1)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    else
    {
        //        UIViewController *viewContorller = [self.navigationController.viewControllers lastObject];
        //        NSLog(@"%@",NSStringFromClass([viewContorller class]));
        //        viewContorller = nil;
        //        NSLog(@"%@",NSStringFromClass([viewContorller class]));
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

static char leftButtonKey;
-(void)setLeftButton:(UIButton *)leftButton
{
    objc_setAssociatedObject(self, &leftButtonKey, leftButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIButton*)leftButton
{
    return objc_getAssociatedObject(self, &leftButtonKey);
}



@end
