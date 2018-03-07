//
//  FoldLabel.m
//  diandiandian
//
//  Created by 刘星辰 on 2016/12/6.
//  Copyright © 2016年 刘星辰. All rights reserved.
//

#import "FoldLabel.h"



@interface FoldLabel()
{
    NSInteger _line;
}

@end

@implementation FoldLabel

- (instancetype)initWithWidth:(CGFloat)width point:(CGPoint)point line:(NSInteger)line string:(NSString *)string{
    if (self = [super init])
    {
        self.frame = CGRectMake(point.x, point.y, width, 0);
        
        _line = line;
        
        self.label = [[UILabel alloc] init];
        self.label.font = [UIFont systemFontOfSize:15];
        self.label.textColor = [UIColor blackColor];
        self.label.text = string;
        [self addSubview:self.label];
        
        self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn.frame = CGRectMake(0, 0, 0, 0);
        self.btn.selected = NO;
        [self.btn setTitleColor:TOPCAIL_COLOR forState:UIControlStateNormal];
        [self.btn setTitleColor:TOPCAIL_COLOR forState:UIControlStateSelected];
        
        [self.btn addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
       
        [self.btn setTitle:@"全文" forState:UIControlStateNormal];
        [self.btn setTitle:@"收起" forState:UIControlStateSelected];
        
        [self.btn sizeToFit];
        
        [self addSubview:self.btn];
        
        [self resetStyle];
        
    }
    return self;
}

#pragma mark 重置样式
- (void)resetStyle{
    
    //字体一致性
    self.btn.titleLabel.font = self.label.font;
    
    //1.判断是否出现按钮
    if ([self judgeIsHaveButton])
    {
        //出现 文字显示为几行
        self.btn.hidden = NO;
        
        [self showOrHide];
        
    }
    else
    {
        //不出现
        self.btn.hidden = YES;
        self.label.frame = CGRectMake(0, 0, self.width, [self textHeight]);
        self.height = self.label.bottom;
    }
    
}

#pragma mark 是否存在全文按钮
- (BOOL)judgeIsHaveButton{
    
    //计算行数
    NSNumber *count = @([self textHeight] / self.label.font.lineHeight);
    NSInteger lines = [count integerValue];
    
    if (lines > _line)
    {
        return YES;
    }
    else
    {
        return NO;
    }
    
}

#pragma mark 显示或者隐藏
- (void)showOrHide
{
    if (self.btn.selected == NO)
    {
        //收起全文
        self.label.frame = CGRectMake(0, 0, self.width, self.label.font.lineHeight * _line);
        self.label.numberOfLines = _line;
    }
    else
    {
        //显示全文
        self.label.frame = CGRectMake(0, 0, self.width, [self textHeight]);
        self.label.numberOfLines = 0;
    }
    
    self.btn.top = self.label.bottom;
    
    self.height = self.btn.bottom;

}

- (void)buttonClick{
    
     self.btn.selected = !self.btn.selected;
    
    [self showOrHide];
    
    //发出需要刷新的通知
    [NS_NOTIFICATION_CENTER postNotificationName:@"foldOrShow" object:nil];
}



#pragma mark 当前文字的高度
- (CGFloat)textHeight{
    return [self heightForString:self.label.text font:self.label.font andWidth:self.width];
}

//获得字符串的高度
-(float) heightForString:(NSString *)value font:(UIFont*)font andWidth:(float)width
{
    NSDictionary *fontAttributesDict = @{NSFontAttributeName:font};
    CGRect sizeToFit = [value boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:fontAttributesDict context:nil];
    
    return sizeToFit.size.height;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
}

- (void)dealloc{
    [NS_NOTIFICATION_CENTER removeObserver:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
