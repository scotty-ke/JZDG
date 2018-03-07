//
//  SexAgeView.m
//  easydoctor
//
//  Created by 丁东 on 16/3/8.
//  Copyright © 2016年 easygroup. All rights reserved.
//

#import "SexAgeView.h"
#import "Masonry.h"

@implementation SexAgeView

-(id)init
{
    self = [super init];
    if (self)
    {
        self.sexIcon = [[UIImageView alloc]init];
        [self addSubview:self.sexIcon];
        
        self.ageLabel = [[UILabel alloc]init];
        self.ageLabel.font = TEXT_FONT_12;
        self.ageLabel.textColor = [UIColor whiteColor];
        self.ageLabel.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = 3;
        self.clipsToBounds = YES;
        [self addSubview:self.ageLabel];
    }
    return self;
}

-(void)setSexAgeViewWith:(NSInteger)sex adnAge:(NSInteger)age
{
    if (sex == 1) //男
    {
        self.sexIcon.image = [UIImage imageNamed:@"nan"];
        self.backgroundColor =  LABEL_GREEN;
    }
    else
    {
        self.sexIcon.image = [UIImage imageNamed:@"nv"];
        self.backgroundColor =  LABEL_PURPLE;

    }
    
    self.ageLabel.text = [NSString stringWithFormat:@"%lu",age];
    [self.ageLabel sizeToFit];
    
    self.sexIcon.frame = CGRectMake(6, (CGRectGetHeight(self.ageLabel.frame) - 10)/2, 9, 10);
    self.ageLabel.frame = CGRectMake(CGRectGetMaxX(self.sexIcon.frame) + 3, 0, CGRectGetWidth(self.ageLabel.frame), CGRectGetHeight(self.ageLabel.frame));
    CGRect frame = self.frame;
    frame.size = CGSizeMake(CGRectGetMaxX(self.ageLabel.frame) + 6, CGRectGetHeight(self.ageLabel.frame));
    self.frame = frame;
}


- (void)setSizeConstraints {
    [self.sexIcon mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.mas_equalTo(6);
    }];
    
    [self.ageLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.sexIcon.mas_right).offset(3);
    }];
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.ageLabel.mas_right).offset(6);
        make.height.mas_equalTo(CGRectGetHeight(self.ageLabel.frame));
    }];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

@end
