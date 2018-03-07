//
//  DDPopup.m
//  easydoctor
//
//  Created by 丁东 on 16/7/27.
//  Copyright © 2016年 easygroup. All rights reserved.
//

#import "DDPopup.h"

@implementation DDPopup


- (void)addInView:(UIView *)view withContentView:(UIView*)contentView;
{
    self.contentView = contentView;
    self.view = view;
    
    if (!self.showdView)
    {
        self.showdView = [[UIView alloc]initWithFrame:view.bounds];
        self.showdView.backgroundColor = [UIColor blackColor];
        self.showdView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                             action:@selector(hidden)];
        [self.showdView addGestureRecognizer:tap];
    }
    
    self.showdView.hidden = YES;
    
    [view addSubview:self.showdView];
    
    
    contentView.frame = CGRectMake(CGRectGetMidX(self.view.frame) - CGRectGetWidth(self.contentView.frame)/2, self.postion ==0?(CGRectGetMaxY(view.frame)+5):(-CGRectGetHeight(contentView.frame) - 5), CGRectGetWidth(contentView.frame), CGRectGetHeight(contentView.frame));
    
    [view addSubview:contentView];
    
    self.state = DDPopupStateDidClose;
}

- (void)addInView:(UIView *)view
  withContentView:(UIView *)contentView
     didShowBlock:(__DDPopupDidShowBlock)showBlock
   didHiddenBlock:(__DDPopupDidHiddenBlock)hiddenBlck
{
    self.showBlock = showBlock;
    self.hiddenBlcok = hiddenBlck;
    [self addInView:view withContentView:contentView];
}

-(void)showWithDIdShowBlock:(__DDPopupDidShowBlock)showBlock
{
    if (self.state == DDPopupStateDidClose)
    {
        self.showdView.hidden = NO;
        self.showdView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0];
        [UIView animateWithDuration:0.3
                         animations:^
         {
             self.contentView.frame =CGRectMake(CGRectGetMidX(self.view.frame) - CGRectGetWidth(self.contentView.frame)/2, self.postion ==DDPopupPostionUp?(CGRectGetHeight(self.view.frame) - CGRectGetHeight(self.contentView.frame)):0, CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame));
             self.showdView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
         }
                         completion:^(BOOL finished)
         {
             self.state = DDPopupStateDidOpen;
             if (showBlock)
             {
                 showBlock();
             }
             
         }];
    }
}

-(void)hidden
{
    [self hiddenWithDIdShowBlock:nil];
}


-(void)hiddenWithDIdShowBlock:(__DDPopupDidHiddenBlock)hidddenBlock
{
    if (self.state == DDPopupStateDidOpen)
    {
        [UIView animateWithDuration:0.3
                         animations:^
         {
             self.contentView.frame = CGRectMake(CGRectGetMidX(self.view.frame) -CGRectGetWidth(self.contentView.frame)/2, self.postion ==DDPopupPostionUp?(CGRectGetMaxY(self.view.frame)+5):(-CGRectGetHeight(self.contentView.frame) - 5), CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame));
             self.showdView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
         }
                         completion:^(BOOL finished)
         {
             self.state = DDPopupStateDidClose;
             self.showdView.hidden = YES;
             if (hidddenBlock)
             {
                 hidddenBlock();
             }
         }];
    }
}



@end
