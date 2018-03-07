/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface UIViewController (HUD)
@property (nonatomic,strong)UIView *contenView;
@property (nonatomic,strong)UIImageView *contentImageView;
@property (nonatomic,strong)UILabel *messageLabel;
@property (nonatomic,strong)UIButton *reFreshButton;
- (void)showHudInView:(UIView *)view hint:(NSString *)hint;

- (void)hideHud;

- (void)showHint:(NSString *)hint;
- (void)showHint:(NSString *)hint afterDelay:(CGFloat)delay;

- (void)showHint:(NSString *)hint errorImage:(UIImage *)errorImage;
- (void)showHint:(NSString *)hint execBlock:(dispatch_block_t)execBlock block:(MBProgressHUDCompletionBlock)block;

// 从默认(showHint:)显示的位置再往上(下)yOffset
- (void)showHint:(NSString *)hint yOffset:(float)yOffset;

- (void)showNoContentViewWithHint:(NSString*)hint refreshButtonText:(NSString*)buttonText andRefreshButton:(SEL)action onView:(UIView*)view;

- (void)showNoContentViewWithHint:(NSString*)hint refreshButtonText:(NSString*)buttonText andRefreshButton:(SEL)action onView:(UIView*)view andPlaceHolderImageImage:(UIImage*)holderImage;

- (void)showImageText:(NSString *)hint onView:(UIView *)view andPlaceHolderImage:(UIImage *)holderImage;

@end
