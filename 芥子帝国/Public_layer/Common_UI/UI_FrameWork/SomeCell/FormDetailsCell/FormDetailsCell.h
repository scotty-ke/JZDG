//
//  FormDetailsCell.h
//  easydoctor
//
//  Created by 刘星辰 on 2016/12/29.
//  Copyright © 2016年 easygroup. All rights reserved.
//


//这个cell 用于 详情单中的  父类cell

//所有的控件摆放于bgView上
//自带分割线的隐藏和显示

#import <UIKit/UIKit.h>
#import "Masonry.h"
#import "UIImageView+WebCache.h"

@interface FormDetailsCell : UITableViewCell

@property (nonatomic,strong)UIView *bgView;//背景



/**
 设置bgView的左右间隔

 @param space 默认为8
 */
- (void)setBgViewSpace:(CGFloat)space;


/**
 cell的分割线

 @param hiden 是否显示
 */
- (void)setHidenLine:(BOOL)hiden;


/**
 cell的右边的小标志

 @param hiden 是否显示
 */
- (void)setHidenArrows:(BOOL)hiden;


@end
