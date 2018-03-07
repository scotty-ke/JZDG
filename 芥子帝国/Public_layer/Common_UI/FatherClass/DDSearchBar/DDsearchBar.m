//
//  DDsearchBar.m
//  easydoctor
//
//  Created by 丁东 on 15/10/27.
//  Copyright © 2015年 easygroup. All rights reserved.
//

#import "DDsearchBar.h"

@implementation DDsearchBar

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UITextField *textfield;
        
        NSLog(@"%@",self.subviews);
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")] && SYSTEM_NUMBER <7.0)
            {
                [view removeFromSuperview];
                break;
            }
            if ([view isKindOfClass:NSClassFromString(@"UISearchBarTextField")] && SYSTEM_NUMBER <7.0)
            {
                textfield = (UITextField*)view;
                textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
            }
            if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0 && SYSTEM_NUMBER >=7.0)
            {
                NSLog(@"%@",view.subviews);
                [[view.subviews objectAtIndex:0] removeFromSuperview];
                self.barTintColor = [UIColor whiteColor];
                textfield = [[[self.subviews firstObject] subviews] lastObject];
                textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
                              break;
            }
        }
        if (self.textFieldBackColor)
        {
            textfield.backgroundColor  = self.textFieldBackColor;
        }

        self.barTintColor = TOPCAIL_COLOR;

    }
    return self;
}


-(id)initWithFrame:(CGRect)frame withTextFieldBackColor:(UIColor*)textFieldBackColor
{
    _textFieldBackColor = textFieldBackColor;
    self = [self initWithFrame:frame];
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
