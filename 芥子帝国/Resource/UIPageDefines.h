//
//  UIPageDefines.h
//  芥子帝国
//
//  Created by 纳里健康 on 2018/3/8.
//  Copyright © 2018年 songK. All rights reserved.
//   定义页面所需要的常量

#ifndef UIPageDefines_h
#define UIPageDefines_h

//宽高
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define VIEW_HEIGHT CGRectGetHeight(self.view.frame)

#define SYSTEM_NUMBER [[[UIDevice currentDevice] systemVersion] floatValue]


//导航栏高度
#define NAVIGATOR_HEIGHT (IS_IPHONE_X ? 88.0f : 64.0f)

//iPhone 虚拟home键的高度
#define HOMEBAR_HEIGHT (IS_IPHONE_X ? 34.0f : 0.0f)

//UITabbarViewController
#define TABBAR_HEIGHT (IS_IPHONE_X ? 83.0f : 49.0f)

#define IS_IPHONE_4 (( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )480) < DBL_EPSILON ))
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IS_IPHONE_6 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )667 ) < DBL_EPSILON )
#define IS_IPHONE_6_PLUS ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )736 ) < DBL_EPSILON )

#define IS_IPHONE_X ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )812 ) < DBL_EPSILON )
#define UUID [[UIDevice currentDevice].identifierForVendor UUIDString]


#if DEBUG // Set to 1 to enable debug logging
#define NSLog(x, ...) NSLog(x, ## __VA_ARGS__);
#else
#define NSLog(x, ...)
#endif


#endif /* UIPageDefines_h */
