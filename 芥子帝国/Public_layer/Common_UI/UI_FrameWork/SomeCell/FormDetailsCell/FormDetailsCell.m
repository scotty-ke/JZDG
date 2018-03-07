//
//  FormDetailsCell.m
//  easydoctor
//
//  Created by 刘星辰 on 2016/12/29.
//  Copyright © 2016年 easygroup. All rights reserved.
//

#import "FormDetailsCell.h"

@implementation FormDetailsCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self formDetailsUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self formDetailsUI];
}


- (void)formDetailsUI{

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    
    [self setHidenLine:YES];
    
    self.bgView = [[UIView alloc] init];
    self.bgView.backgroundColor = WHITE_COLOR;
    [self.contentView addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
}

- (void)setBgViewSpace:(CGFloat)space{
    [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, space, 0, space));
    }];
}

- (void)setHidenLine:(BOOL)hiden
{
    if (hiden) {
        self.separatorInset = UIEdgeInsetsMake(0, SCREEN_WIDTH / 2, 0, SCREEN_WIDTH / 2);
    }else{
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
}


- (void)setHidenArrows:(BOOL)hiden{
    if (hiden) {
        self.accessoryType = UITableViewCellAccessoryNone;
    }else{
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
