//
//  KeyboardX.m
//  自定义键盘
//
//  Created by 刘星辰 on 2016/11/7.
//  Copyright © 2016年 LiuXingChen. All rights reserved.
//

#import "KeyboardX.h"
#import "UITextField+ExtentRange.h"


#define Delete @"删除"
#define KeyboardX_H 220.0f
#define Line_H 1.0f

@interface KeyboardX()
{
    DDTextField *_textField;
    NSArray *_keyArr;
    NSTimer *_timer;
    CGPoint _start;
}

@end

@implementation KeyboardX


- (instancetype)initWithFrame:(CGRect)frame AndTextField:(DDTextField *)textField{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        _textField = textField;
        
        _keyArr = @[@[@"1",@"2",@"3"],
                    @[@"4",@"5",@"6"],
                    @[@"7",@"8",@"9"],
                    @[@"X",@"0",Delete],];
        
        _textField.inputView = self;
    }
    return self;
}

+ (instancetype)keyboardXAddIn:(DDTextField  *)textField{
    return [[self alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, KeyboardX_H)AndTextField:textField];
}

- (void)drawRect:(CGRect)rect {
    
    for (NSInteger i = 0; i < _keyArr.count; i++)
    {
        for (NSInteger j = 0; j < [_keyArr[i] count]; j++)
        {
            
            CGFloat width = (SCREEN_WIDTH - Line_H * 2) / 3.0;
            CGFloat height = (KeyboardX_H - Line_H * 3) / 4.0;
            
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(j * (width + Line_H), i * (height + Line_H), width, height);
            [button setTitle:_keyArr[i][j] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont boldSystemFontOfSize:23];
            UIImage *backImage = [Public createImageWithColor:TEXT_COLOR_4];
            [button setBackgroundImage:backImage forState:UIControlStateHighlighted];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            if (i == 3 && (j == 2 || j == 0))
            {
                [button setTitleColor:TOPCAIL_COLOR forState:UIControlStateNormal];
//                [button setBackgroundColor:UIColorFromRGB(0xd2d5dc)];
                if (j == 2)
                {
                    button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
                    [button setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
//                    [button setTitleColor:LINE_COLOR forState:UIControlStateSelected];
                    [button setTitle:_keyArr[i][j] forState:UIControlStateSelected];
                    
                    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(delete:)];
                    longPress.minimumPressDuration = 0.5f;
                    [button addGestureRecognizer:longPress];
                }
            }
            
            button.tag =  i * 10 + j;
            [self addSubview:button];
            
            
            UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
            [button addGestureRecognizer:pan];
            
            // 划线操作
            if (i == 0)
            {
                //竖线
                if (j != 0) {
                    [self drawLine:CGRectMake( j * width + Line_H ,0, Line_H, self.frame.size.height)];
                }
            }
            else if (j == 0)
            {
                //横线
                 [self drawLine:CGRectMake(0, i * height + Line_H, SCREEN_WIDTH, Line_H)];
            }
            
        }
    }
}

#pragma mark 画线
- (void)drawLine:(CGRect)frame{
    UIView *line = [[UIView alloc] initWithFrame:frame];
    line.backgroundColor = UIColorFromRGB(0xdddddd);
    [self addSubview:line];
}

#pragma mark -
- (void)buttonClick:(UIButton *)btn{
    NSInteger tag = btn.tag;
    NSString *keyStr = _keyArr[tag / 10][tag % 10];
//    NSLog(@"%@",keyStr);
    
    if (!([keyStr isEqualToString:Delete]))
    {
        [self addText:keyStr];
    }
    else
    {
        [self deleteText];
    }
}

- (void)move:(UIPanGestureRecognizer *)pan{
    if (pan.state == UIGestureRecognizerStateBegan)
    {
        _start = [pan locationInView:self];
            NSLog(@"开始的手势%lf-%lf",_start.x,_start.y);
    }
    
    else if(pan.state == UIGestureRecognizerStateChanged)
    {
        CGPoint change = [pan locationInView:self];
//        NSLog(@"改变的手势%lf-%lf",change.x,change.y);
        
        [self manageOffset:change.x - _start.x SavePoint:change];
    }
    
    

}

//处理偏移量
- (void)manageOffset:(CGFloat )offset SavePoint:(CGPoint)point{
    
    NSInteger num = fabs(offset) / 15;
    
    if (num > 0) //代表可以移动光标
    {
        if (offset > 0)
        {
            //右偏移
            if (_textField.text.length > _textField.selectedRange.location) {
                _textField.selectedRange = NSMakeRange(_textField.selectedRange.location + 1, 0);
            }
        }
        else
        {
            //左偏移
            _textField.selectedRange = NSMakeRange(_textField.selectedRange.location - 1, 0);
        }
        _start = point;
    }
    
    
    
}

- (void)delete:(UILongPressGestureRecognizer *)longPress{
    
    UIButton *btn = (UIButton *)longPress.view;
    
    if (longPress.state == UIGestureRecognizerStateBegan)
    {
        btn.selected = YES;
        
        if (_timer.valid == NO) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(deleteText) userInfo:nil repeats:YES];
        }
        
    }
    else if (longPress.state == UIGestureRecognizerStateEnded)
    {
        
        btn.selected = NO;
        [_timer invalidate];
    }
    
}

- (void)deleteEnd{
    
}

#pragma mark 添加文字
- (void)addText:(NSString *)keyStr{
    if (_textField.text.length < _textField.maxNum)
    {
        
        NSMutableString *str = [[NSMutableString alloc] initWithString:_textField.text];
        NSInteger location = _textField.selectedRange.location;
        [str insertString:keyStr atIndex:location];
        _textField.text = str;
        _textField.selectedRange = NSMakeRange(location + 1, 0);
        
    }
}

#pragma mark 删除文字
- (void)deleteText{
    if (_textField.text.length > 0)
    {
        NSMutableString *str = [[NSMutableString alloc] initWithString:_textField.text];
        NSInteger location = _textField.selectedRange.location - 1;
        if (location >= 0) {
            [str deleteCharactersInRange:NSMakeRange(location, 1)];
        }
        _textField.text = str;
        _textField.selectedRange = NSMakeRange(location, 0);
    }
}

@end
