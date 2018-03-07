//
//  DDsearchBar.h
//  easydoctor
//  诊断 患者
//  Created by 丁东 on 15/10/27.
//  Copyright © 2015年 easygroup. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDsearchBar : UISearchBar

@property (nonatomic,strong)UIColor *textFieldBackColor;

-(id)initWithFrame:(CGRect)frame withTextFieldBackColor:(UIColor*)textFieldBackColor;

@end
