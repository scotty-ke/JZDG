//
//  DDPageConfig.h
//  easydoctor
//
//  Created by 丁东 on 15/11/16.
//  Copyright © 2015年 easygroup. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDPageConfig : NSObject

/** 顶部按钮的基本宽度 */
@property (nonatomic,assign) CGFloat barBtnWidth;

/** 顶部按钮的扩展宽度 */
@property (nonatomic,assign) CGFloat barBtnExtraWidth;

/** bar条的高度 */
@property (nonatomic,assign) CGFloat barViewH;

/** 字体大小 */
@property (nonatomic,assign) CGFloat barBtnFontPoint;

/** 顶部菜单最左和最右的间距 */
@property (nonatomic,assign) CGFloat barScrollMargin;

/** 菜单按钮之间的间距 */
@property (nonatomic,assign) CGFloat barBtnMargin;

/** 线条 宽度 */
@property (nonatomic,assign) CGFloat lineWidth;

/** 线条 高度 */
@property (nonatomic,assign) CGFloat lineHight;

/** 线条 颜色 */
@property (nonatomic,strong) UIColor *lineColor;

/** 主体内容区间距值 */
@property (nonatomic,assign) CGFloat barLineViewPadding;

/** 动画时长 */
@property (nonatomic,assign) CGFloat animDuration;

/** 正常状态下字体 */
@property (nonatomic,strong) UIFont *nomalFont;

/** 选中状态下字体 */
@property (nonatomic,strong) UIFont *selectFont;

/** 正常状态下字体颜色 */
@property (nonatomic,strong) UIColor *nomalColor;

/** 选中状态下字体颜色 */
@property (nonatomic,strong) UIColor *selectColor;

/* 开启菜单 默认不开启*/
@property (nonatomic) BOOL showIndentifier;

@property (nonatomic,strong)UIImage *openImage;

@property (nonatomic,strong)UIImage *closeImage;

@property (nonatomic,strong)UIColor *backColor;

@end
