//
//  CommonChartCell.h
//  NagriHealth
//
//  Created by 丁东 on 16/8/29.
//  Copyright © 2016年 丁东. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonChartCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIImageView *arrowIcon;

@property (weak, nonatomic) IBOutlet UIView *line;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMargin;


/**
 设置内容

 @param text 内容 可以为属性字符串
 */
-(void)setContentText:(id)text;


/**
 *  隐藏箭头
 */
-(void)hiddenArrow;

/**
 *  显示箭头 默认显示
 */
-(void)showArrow;

@end
