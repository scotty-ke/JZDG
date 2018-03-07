//
//  DDTextView.m
//  NagriHealth
//
//  Created by 丁东 on 2016/10/26.
//  Copyright © 2016年 丁东. All rights reserved.
//

#import "DDTextView.h"

@interface DDTextView()
{
    UILabel *_placeLabel;
}

@end

@implementation DDTextView


-(void)setPlaceHolder:(NSString *)placeHolder
{
    _placeHolder = placeHolder;
    
    if (!_placeLabel)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textViewDidChangeText:)
                                                     name:UITextViewTextDidChangeNotification
                                                   object:nil];
        
        _placeLabel = [[UILabel alloc]init];
        _placeLabel.frame = CGRectMake(5, 3, self.frame.size.width - 40, 30);
        _placeLabel.text = _placeHolder;
        _placeLabel.font = self.font;
        _placeLabel.textColor = [UIColor grayColor];
        _placeLabel.font =[UIFont systemFontOfSize:16];
    }
    [self addSubview:_placeLabel];
}

-(void)setText:(NSString *)text
{
    [super setText:text];
    if (text && ![text isEqualToString:@""])
    {
        _placeLabel.hidden = YES;
    }
}

-(void)textViewDidChangeText:(NSNotification *)notification
{
    if ( [notification.object isEqual:self]  )
    {
        if (self.text.length != 0)
        {
            _placeLabel.hidden = YES;
        }
        else
        {
            _placeLabel.hidden = NO;
        }
    }
}


@end
