//
//  DDPageConfig.m
//  easydoctor
//
//  Created by 丁东 on 15/11/16.
//  Copyright © 2015年 easygroup. All rights reserved.
//

#import "DDPageConfig.h"

@implementation DDPageConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        //默认值设置
        [self defaultValueSet];
    }
    return self;
}


/** 默认值设置 */
-(void)defaultValueSet{
    
    //顶部按钮的基本宽度
    _barBtnWidth = 60;
    
    //顶部按钮的扩展宽度
    _barBtnExtraWidth = 10;
        
    //bar条的高度
    _barViewH = 44;
    
    //字体大小
    _barBtnFontPoint = 15.0f;
    
    //顶部菜单最左和最右的间距
    _barScrollMargin = 30;
    
    //菜单按钮之间的间距
    _barBtnMargin = 30;
    
    //线条多余长度（单边）
    _barLineViewPadding = 10;
    
    //主体内容区间距值
    
    //动画时长
    _animDuration = 0.25f;
}

@end
