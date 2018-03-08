//
//  AppDelegate+function.m
//  芥子帝国
//
//  Created by 纳里健康 on 2018/3/8.
//  Copyright © 2018年 songK. All rights reserved.
//

#import "AppDelegate+function.h"
#import "LoginViewController.h"

@implementation AppDelegate (function)


#pragma mark 改变根视图控制器
-(void)changeRootViewcontroller
{
    self.window.backgroundColor = BACKGROUND_COLOR;
    
    if ([USER_DEFAULT valueForKey:DEFAULT_Uid] &&
        [[USER_DEFAULT valueForKey:DEFAULT_Uid] integerValue]> 0)
    {
        
        NSLog(@"%@",[USER_DEFAULT valueForKey:DEFAULT_AccessToken]);
        if (!self.tabbarViewController)
        {
            self.tabbarViewController = [[TabbarViewController alloc]init];
        }
        self.window.rootViewController = self.tabbarViewController;
    }
    else
    {
        if (self.tabbarViewController && self.window.rootViewController == self.tabbarViewController)
        {
            UITabBarController *tabbar = (UITabBarController*)[self getCurrentVC];
            for (UINavigationController *NVC in tabbar.viewControllers)
            {
                [NVC popToRootViewControllerAnimated:NO];
            }
            [tabbar setSelectedIndex:0];
        }
        
        if (!self.loginViewVC)
        {
            LoginViewController *loginVc = [[LoginViewController alloc] init];
            self.loginViewVC = [[JZNavigationViewController alloc] initWithRootViewController:loginVc];
        }
        [self.loginViewVC popToRootViewControllerAnimated:YES];
        
        self.window.rootViewController = self.loginViewVC;
    }
}

#pragma mark prive 获得当前显示ViewCotroller
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}



@end
