//
//  Color.h
//  easydoctor
//
//  Created by 丁东 on 15/10/21.
//  Copyright © 2015年 easygroup. All rights reserved.
//

#ifndef Color_h
#define Color_h

#define Banner_Height  (SCREEN_WIDTH / 72) * 35


/*16进制颜色*/
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define RGBCOLOR(r,g,b)    [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

//主题色 - 绿色
#define TOPCAIL_COLOR  HospitalM.topicColor
#define ZHUAN_COLOR UIColorFromRGB(0x42d049)
//背景底色
#define BACKGROUND_COLOR UIColorFromRGB(0xf5f5f5)
#define WHITE_COLOR   [UIColor whiteColor]
#define BLACK_COLOR [UIColor blackColor]
#define RED_COLOR  RGBCOLOR(252,119,56) 
#define YELLOW_COLOR  UIColorFromRGB(0xfba91e)
#define LINE_COLOR    UIColorFromRGB(0xf5f5f5)
#define PURE_COLOR RGBCOLOR(114,54,207)
#define SEPARATORLINE_COLOR RGBCOLOR(221, 221, 221)
#define BLUE_COLOR UIColorFromRGB(0x54baef)

//字体颜色
#define TEXT_COLOR_1 UIColorFromRGB(0x222222)

#define TEXT_COLOR_2 UIColorFromRGB(0x969696)   

#define TEXT_COLOR_3 UIColorFromRGB(0x818181) 

#define TEXT_COLOR_4 UIColorFromRGB(0xdddddd)

#define TEXT_COLOR_5 UIColorFromRGB(0x4f5356)

#define TEXT_COLOR_ORANGE UIColorFromRGB(0xffa019)

//字体大小
#define TEXT_FONT_21  [UIFont systemFontOfSize:21]

#define TEXT_FONT_20  [UIFont systemFontOfSize:20]

#define TITLE_FONT_19  [UIFont systemFontOfSize:19] //用于标题大小 会更改暂时不要用

#define TEXT_FONT_18  [UIFont systemFontOfSize:18]

#define TEXT_FONT_17  [UIFont systemFontOfSize:17]

#define TEXT_FONT_16  [UIFont systemFontOfSize:16]

#define TEXT_FONT_15  [UIFont systemFontOfSize:15]

#define TEXT_FONT_14  [UIFont systemFontOfSize:14]

#define TEXT_FONT_13  [UIFont systemFontOfSize:13]

#define TEXT_FONT_12  [UIFont systemFontOfSize:12]

#define TEXT_FONT_11  [UIFont systemFontOfSize:11]

#define TEXT_FONT_10  [UIFont systemFontOfSize:10]




//绿色 选中
#define GREEN_SELECTED UIColorFromRGB(0xa0f4e7)
#define GREEN_UN_SELECTED UIColorFromRGB(0xc1f6ee)
#define GRAY_UN_SELECTED UIColorFromRGB(0xDDDDDD)
//按钮选中颜色 灰色
#define Select_Color UIColorFromRGB(0xbec6ce)
//绿色 按钮高亮
#define GREEN_HIGHLIGHTED UIColorFromRGB(0x40b6a4)

//标签蓝色
#define LABEL_BLUE UIColorFromRGB(0x66CCFF)
#define LABEL_PURPLE UIColorFromRGB(0xC41DAE)
#define LABEL_GREEN UIColorFromRGB(0x4CD8C3)

//纸张黄色
#define PAPER_Yellow RGBCOLOR(255,250,243)

//五角星颜色
#define STAR_Yellow UIColorFromRGB(0xf9b954)

#endif /* Color_h */
