//
//  AttentionHeaderCell.m
//  NagriHealth
//
//  Created by 纳里健康 on 2016/12/29.
//  Copyright © 2016年 丁东. All rights reserved.
//

#import "AttentionHeaderCell.h"
#import "Masonry.h"

@implementation AttentionHeaderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier String:(NSString *)titleString RepleaseString:(NSString *)repleaseStr
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self)
    {
        [self initUIWithTitleString:[titleString mutableCopy] RepleaseString:repleaseStr];
    }
    
    return  self;
}

- (void)initUIWithTitleString:(NSMutableString *)titleString RepleaseString:(NSString *)repleaseStr
{
    UILabel * label =  [[UILabel alloc] init];
    
    //字符串处理
    NSRange range = [titleString rangeOfString:@"*"];
    
    [titleString replaceCharactersInRange:NSMakeRange(range.location, range.length) withString:repleaseStr];
    
    
    label.font = TEXT_FONT_13;
    label.textColor = [UIColor orangeColor];
    
    //富文本
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:titleString];
    
    [attribute addAttribute:NSForegroundColorAttributeName value:TOPCAIL_COLOR range:NSMakeRange(range.location, repleaseStr.length)];
    label.attributedText = attribute;
    
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    [label sizeToFit];
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).multipliedBy(1.1);
        make.centerY.equalTo(self);
    }];
    
    UIImageView *bell = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bell"]];
    bell.frame = CGRectMake(0, 0, 20, 20);
    [self addSubview:bell];
    [bell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label);
        make.right.equalTo(label.mas_left).offset(-5);
        make.size.mas_offset(bell.size);
    }];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
