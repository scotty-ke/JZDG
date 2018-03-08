//
//  NHPopView.m
//  NHBaseUIFrameWork
//
//  Created by 刘星辰 on 2018/2/26.
//  Copyright © 2018年 刘星辰. All rights reserved.
//

#import "NHPopView.h"
//#import "NHUINotification.h"

@interface NHPopView()<UIGestureRecognizerDelegate>

@end


@implementation NHPopView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor blackColor];
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                             action:@selector(hiddenView)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)showOnWindowWithContentView:(UIView *)contentView
{
    UIView *window = [[[UIApplication sharedApplication] delegate] window];
    [self addInView:window withContentView:contentView];

    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNotice:) name:NHRemoveWindowAllMaskViewNotification object:nil];
    
}

- (void)addInView:(UIView *)view withContentView:(UIView*)contentView;
{
    self.contentView = contentView;
    self.backgroundView = view;
    
    self.frame = view.bounds;
    
    self.hidden = YES;
    
    [self addSubview:contentView];
    
    [view addSubview:self];
    [view bringSubviewToFront:self];
    
    
    switch (self.postion)
    {
        case NHPopupPostionUp:
        {
            contentView.top = self.height;
            contentView.left = (self.width - contentView.width) / 2.0;
        }
            break;
        case NHPopupPostionDown:
        {
            contentView.top = - contentView.height;
            contentView.left = (self.width - contentView.width) / 2.0;
        }
            break;
        case NHPopupPostionCenter:
        {
            contentView.center = CGRectGetCenter(self.frame);;
            contentView.transform = CGAffineTransformMakeScale(0.8, 0.8);
            contentView.alpha = 0;
            contentView.hidden = YES;
        }
            break;
        default:
            break;
    }
    
    self.state = NHPopupStateDidClose;
}

- (void)addInView:(UIView *)view
  withContentView:(UIView *)contentView
     didShowBlock:(__NHPopupDidShowBlock)showBlock
   didHiddenBlock:(__NHPopupDidHiddenBlock)hiddenBlck
{
    self.showBlock = showBlock;
    self.hiddenBlcok = hiddenBlck;
    [self addInView:view withContentView:contentView];
}

-(void)showWithDidShowBlock:(__NHPopupDidShowBlock)showBlock
{
    if (self.state == NHPopupStateDidClose)
    {
        self.hidden = NO;
        self.contentView.hidden = NO;
        [self.backgroundView addSubview:self];
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0];
        [UIView animateWithDuration:0.3
                         animations:^
         {
             switch (self.postion)
             {
                 case NHPopupPostionUp:
                 {
                     _contentView.top = self.height - _contentView.height - self.insets.bottom;
                 }
                     break;
                 case NHPopupPostionDown:
                 {
                     _contentView.top = 0.0 + self.insets.top;
                 }
                     break;
                 case NHPopupPostionCenter:
                 {
                     _contentView.top = _contentView.top - (self.insets.top - self.insets.bottom);
                     _contentView.left = (self.insets.left != 0)?(self.insets.left):(_contentView.left);
                     _contentView.right = (self.insets.right != 0)?(self.insets.right):(_contentView.right);
                     _contentView.transform = CGAffineTransformIdentity;
                     _contentView.alpha = 1.0;
                     
                 }
                     break;
                 default:
                     break;
             }
             self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
         }
                         completion:^(BOOL finished)
         {
             self.state = NHPopupStateDidOpen;
             if (showBlock)
             {
                 showBlock(self);
             }
             
         }];
    }
}

-(void)hiddenView
{
    [self hiddenWithDidHiddenBlock:self.hiddenBlcok];
}


-(void)hiddenWithDidHiddenBlock:(__NHPopupDidHiddenBlock)hidddenBlock
{
    if (self.state == NHPopupStateDidOpen)
    {
        [UIView animateWithDuration:0.3
                         animations:^
         {
             self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0];
             switch (self.postion)
             {
                 case NHPopupPostionUp:
                 {
                     _contentView.top = self.height;
                 }
                     break;
                 case NHPopupPostionDown:
                 {
                     _contentView.top = - _contentView.height;
                 }
                     break;
                 case NHPopupPostionCenter:
                 {
                     _contentView.transform = CGAffineTransformMakeScale(0.8, 0.8);
                     _contentView.alpha = 0.0f;
                 }
                     break;
                 default:
                     break;
             }
         }
                         completion:^(BOOL finished)
         {
             self.state = NHPopupStateDidClose;
             self.hidden = YES;
             if (self.postion == NHPopupPostionCenter)
             {
                 _contentView.transform = CGAffineTransformIdentity;
                 _contentView.hidden = YES;
             }
             if (hidddenBlock)
             {
                 hidddenBlock(self);
             }
             [self removeFromSuperview];
         }];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint point = [gestureRecognizer locationInView:gestureRecognizer.view];
    for (UIView *view in [gestureRecognizer.view subviews])
    {
        if (CGRectContainsPoint(view.frame, point))
        {
            return NO;
        }
    }
    return YES;
}

- (void)addNotice:(NSNotification *)notification
{
//    NsLog(@"%@",notification.userInfo[NHRemoveReasonKey]);
    [self hiddenView];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
