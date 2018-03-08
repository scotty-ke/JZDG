//
//  AppDefines.h
//  芥子帝国
//
//  Created by 纳里健康 on 2018/3/8.
//  Copyright © 2018年 songK. All rights reserved.
//

#ifndef AppDefines_h
#define AppDefines_h


#ifndef __OPTIMIZE__
#define IS_DEBUG true
//static const DDLogLevel ddLogLevel = DDLogLevelVerbose;
#else
#define IS_DEBUG false
//static const DDLogLevel ddLogLevel = DDLogLevelInfo;
#endif

#define APPLOG(...) DDLogVerbose(__VA_ARGS__)
#define APPLOGInfo(...) DDLogInfo(__VA_ARGS__)
#define APPLOGWarn(...) DDLogWarn(__VA_ARGS__)

#define APP_Image_WorkError [UIImage imageNamed:@"nian"]

/********  常用宏  ********/
#define ApplicationVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define APP_DELEGATE_INSTANCE                       ((AppDelegate*)([UIApplication sharedApplication].delegate))
#define USER_DEFAULT                                          [NSUserDefaults standardUserDefaults]
#define NS_NOTIFICATION_CENTER                   [NSNotificationCenter defaultCenter]
#define kNetworkReachabilityStatus [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus
#define IOS(x) [[[UIDevice currentDevice] systemVersion]floatValue]>=x
#define IOS7STATUS ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0?20.0:0.0)
#define isSystem32   sizeof(long) == 4
#define IS_IPHONE_4 (( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )480) < DBL_EPSILON ))
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IS_IPHONE_6 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )667 ) < DBL_EPSILON )
#define IS_IPHONE_6_PLUS ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )736 ) < DBL_EPSILON )
#define UUID [[UIDevice currentDevice].identifierForVendor UUIDString]

/******* 指令响应码 ******/
#define COMMAND_CODE_SUCCESS 200  //成功
#define COMMAND_CODE_SESSIONFAIL 403 //session实效
#define COMMAND_CODE_NOUSER  404 //  没有找到此用户
#define COMMAND_CODE_PWDFAIL 501 //  密码错误
#define COMMAND_CODE_NOREGIST 609 //  用户未注册  or  号码已注册
#define COMMAND_CODE_SERVERMSG 609 //服务器端返回的错误信息
#define COMMAND_CODE_MEASSEAGE 602 //  后台业务提示

/******* userDefault 常量 begin ******/
#define DEFAULT_MainFunction @"functionUIArray"
#define DEFAULT_SqliteVersion @"sqliteVersion" //数据库版本
#define DEFAULT_AppVersion @"AppVersion" //应用程序的版本
#define DEFAULT_AutoLogin @"autoLogin"    //自动登录
#define DEFAULT_AccessToken @"accessToken"    //token
#define DEFAULT_LoginId @"loginId"  //登录ID
#define DEFAULT_Pwd @"pwd"   //登录密码

#define DEFAULT_UserName @"userName"  //用户姓名
#define DEFAULT_UserHeaderImage @"userHeaderImage"  //用户头像
#define DEFAULT_Uid @"uid" //用户id
#define DEFAULT_ManageUnit @"manageUnit"
#define DEFAULT_MpiId @"mpiId"
#define DEFAULT_PatientName @"patientName"
#define DEFAULT_PatientSex @"patientSex" //用户性别
#define DEFAULT_PatientTypeText @"patientTypeText"
#define DEFAULT_PatientType @"patientType"

#define DEFAULT_PatientIdCard @"patientIdCard"

/******* userDefault 常量 end ******/
#define APP_Text_NoNetwork @"网络缓慢，请求超时"
#define APP_Text_SystemFailure @"系统错误"

#endif /* AppDefines_h */
