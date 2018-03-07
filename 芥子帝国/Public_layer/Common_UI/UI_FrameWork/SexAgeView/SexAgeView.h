//
//  SexAgeView.h
//  easydoctor
//
//  Created by 丁东 on 16/3/8.
//  Copyright © 2016年 easygroup. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SexAgeView : UIView

@property (nonatomic,strong) UIImageView *sexIcon;

@property (nonatomic,strong) UILabel *ageLabel;

-(void)setSexAgeViewWith:(NSInteger)sex adnAge:(NSInteger)age;

- (void)setSizeConstraints;

@end
