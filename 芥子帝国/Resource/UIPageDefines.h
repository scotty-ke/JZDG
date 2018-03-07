//
//  UIPageDefines.h
//  easydoctor
//
//  Created by easygroup on 15/10/21.
//  Copyright © 2015年 easygroup. All rights reserved.
//   定义页面所需要的常量

#ifndef UIPageDefines_h
#define UIPageDefines_h

/******** 页面定义 ********/
#define PageNumber_Main             @"001"
#define PageNumber_Message       @"002"
#define PageNumber_News            @"003"
#define PageNumber_Self              @"004"
#define PageNumber_Login             @"005"

//宽高
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define VIEW_HEIGHT CGRectGetHeight(self.view.frame)

#define SYSTEM_NUMBER [[[UIDevice currentDevice] systemVersion] floatValue]


//导航栏高度
#define NAVIGATOR_HEIGHT 64.0f

//UITabbarViewController
#define TABBAR_HEIGHT 49.0f


#endif /* UIPageDefines_h */
