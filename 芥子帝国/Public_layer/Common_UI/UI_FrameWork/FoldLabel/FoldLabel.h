//
//  FoldLabel.h
//  diandiandian
//
//  Created by 刘星辰 on 2016/12/6.
//  Copyright © 2016年 刘星辰. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FoldLabel : UIView

@property (nonatomic,strong)UILabel *label;//文本
@property (nonatomic,strong)UIButton *btn;//显示更多按钮


- (instancetype)initWithWidth:(CGFloat)width point:(CGPoint)point line:(NSInteger)line string:(NSString *)string;


- (void)resetStyle;

@end
