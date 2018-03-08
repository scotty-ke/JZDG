//
//  DDTextField.m
//  easydoctor
//
//  Created by 丁东 on 15/12/28.
//  Copyright © 2015年 easygroup. All rights reserved.
//

#import "JZTextField.h"

@implementation JZTextField

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addTarget:self
                 action:@selector(textChange)
       forControlEvents:UIControlEventEditingChanged];

}

-(id)init
{
    self = [super init];
    if (self)
    {
        [self addTarget:self
                 action:@selector(textChange)
       forControlEvents:UIControlEventEditingChanged];
    }
    return self;
}

-(void)textChange
{
    UITextRange *selectedRange = [self markedTextRange];
    //获取高亮部分
    UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position)
    {

    if (self.text.length > self.maxNum)
    {
        self.text = [self.text substringToIndex:self.maxNum];
    }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
