//
//  AppDelegate.h
//  芥子帝国
//
//  Created by 纳里健康 on 2018/3/7.
//  Copyright © 2018年 songK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabbarViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/**
 *  TabbarViewController 避免重复创建
 */
@property(nonatomic,strong) TabbarViewController *tabbarViewController;

/**
 *  LoginViewController 避免重复创建
 */
@property (nonatomic,strong) JZNavigationViewController *loginViewVC;

@end

