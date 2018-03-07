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

#import "UIViewController+HUD.h"
#import <objc/runtime.h>

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
static const void *HttpRequestHUDKey = &HttpRequestHUDKey;

@implementation UIViewController (HUD)

@dynamic contenView;
@dynamic contentImageView;
@dynamic messageLabel;
@dynamic reFreshButton;

- (MBProgressHUD *)HUD{
    return objc_getAssociatedObject(self, HttpRequestHUDKey);
}

- (void)setHUD:(MBProgressHUD *)HUD{
    objc_setAssociatedObject(self, HttpRequestHUDKey, HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showHudInView:(UIView *)view hint:(NSString *)hint{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    HUD.labelText = hint;
    [view addSubview:HUD];
    [HUD show:YES];
    [self setHUD:HUD];
}



- (void)showHint:(NSString *)hint
{
    //显示提示信息
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = hint;
    hud.margin = 10.f;
    hud.yOffset = (SCREEN_HEIGHT <= 480)?-50.f:0;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
}

- (void)showHint:(NSString *)hint afterDelay:(CGFloat)delay
{
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = hint;
    hud.margin = 10.f;
    hud.yOffset = (SCREEN_HEIGHT <= 480)?-50.f:0;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:delay];
}


- (void)showHint:(NSString *)hint errorImage:(UIImage *)errorImage
{
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:errorImage];
    hud.labelText = hint;
    CGSize titleSize = [hint sizeWithFont:[UIFont boldSystemFontOfSize:16.f]constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
    if (titleSize.width >= [UIScreen mainScreen].bounds.size.width) {
        hud.labelFont = [UIFont systemFontOfSize:14];
    }
    hud.margin = 10.f;
    NSLog(@"%f",SCREEN_HEIGHT);
    NSLog(@"%d",SCREEN_HEIGHT <= 480);
    hud.yOffset = (SCREEN_HEIGHT <= 480)?-50.f:0;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
}

- (void)showHint:(NSString *)hint execBlock:(dispatch_block_t)execBlock block:(MBProgressHUDCompletionBlock)block
{
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = hint;
    [hud showAnimated:YES whileExecutingBlock:execBlock completionBlock:block];
}

- (void)showHint:(NSString *)hint yOffset:(float)yOffset {
    //显示提示信息
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    //    hud.color = TOPCAIL_COLOR;
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = hint;
    hud.margin = 10.f;
    //    hud.yOffset = IS_IPHONE_5?200.f:150.f;
    hud.yOffset += yOffset;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
}

- (void)hideHud{
    [[self HUD] hide:YES];
    if (self.contenView)
    {
        self.contenView.hidden = YES;
    }
}

- (void)showNoContentViewWithHint:(NSString*)hint refreshButtonText:(NSString*)buttonText andRefreshButton:(SEL)action onView:(UIView*)view;
{
    [self setContentView];
    self.contenView.hidden = NO;
    if (action == nil) {
        self.reFreshButton.hidden = YES;
    }
    [self.reFreshButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [self.reFreshButton setTitle:buttonText forState:UIControlStateNormal];
    self.messageLabel.text = hint;
    [self.messageLabel sizeToFit];
    CGRect frame =  self.messageLabel.frame;
    frame.size.width = SCREEN_WIDTH;
    self.messageLabel.frame = frame;
    [view addSubview:self.contenView];
    [view bringSubviewToFront:self.contenView];
}

- (void)showNoContentViewWithHint:(NSString*)hint refreshButtonText:(NSString*)buttonText andRefreshButton:(SEL)action onView:(UIView*)view andPlaceHolderImageImage:(UIImage*)holderImage
{
    [self showNoContentViewWithHint:hint
                  refreshButtonText:buttonText
                   andRefreshButton:action
                             onView:view];
    self.contentImageView.image = holderImage;
}

- (void)showImageText:(NSString *)hint onView:(UIView *)view andPlaceHolderImage:(UIImage *)holderImage {
    [self referContenView];
    self.contenView.hidden = NO;
    self.messageLabel.text = hint;
    [view addSubview:self.contenView];
    [view bringSubviewToFront:self.contenView];
    
    self.contentImageView.image = holderImage;
}

- (UIView *)referContenView {
    if (!self.contenView) {
        self.contenView = [[UIView alloc] initWithFrame:self.view.bounds];
        self.contenView.backgroundColor = BACKGROUND_COLOR;
    }
    
    //图片
    self.contentImageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 81)/2, 200, 81, 106)];
    self.contentImageView.image  = [UIImage imageNamed:@"img_imoji"];
    [self.contenView addSubview:self.contentImageView];
    
    //提示文字
    self.messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.contentImageView.frame) + 40, SCREEN_WIDTH, 20)];
    self.messageLabel.font = TEXT_FONT_15;
    self.messageLabel.textColor = TEXT_COLOR_3;
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    self.messageLabel.numberOfLines = 0;
    [self.contenView addSubview:self.messageLabel];
    
    self.contentImageView.hidden = NO;
    self.messageLabel.hidden = NO;
    return self.contenView;
    
}


-(UIView*)setContentView
{
    if (!self.contenView)
    {
        self.contenView = [[UIView alloc]initWithFrame:self.view.bounds];
        self.contenView.backgroundColor = BACKGROUND_COLOR;
        
        //图片
        self.contentImageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 81)/2, 100, 81, 106)];
        self.contentImageView.image  = [UIImage imageNamed:@"img_imoji"];
        self.contentImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contenView addSubview:self.contentImageView];
        
        //提示文字
        self.messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.contentImageView.frame) + 40, SCREEN_WIDTH, 20)];
        self.messageLabel.font = TEXT_FONT_15;
        self.messageLabel.textColor = TEXT_COLOR_3;
        self.messageLabel.textAlignment = NSTextAlignmentCenter;
        self.messageLabel.numberOfLines = 0;
        [self.contenView addSubview:self.messageLabel];
        
        //刷新按钮
        self.reFreshButton = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH -120)/2, CGRectGetMaxY(self.messageLabel.frame) + 20, 120, 30)];
        self.reFreshButton.backgroundColor = [UIColor clearColor];
        [self.reFreshButton setTitleColor:TOPCAIL_COLOR forState:UIControlStateNormal];
        [self.reFreshButton setTitleColor:GREEN_SELECTED forState:UIControlStateHighlighted];
        [self.reFreshButton setTitle:@"重新加载" forState:UIControlStateNormal];
        self.reFreshButton.titleLabel.font = TEXT_FONT_15;
        self.reFreshButton.titleLabel.font = [UIFont systemFontOfSize:14];
        self.reFreshButton.layer.cornerRadius = 5;
        self.reFreshButton.layer.borderColor = [TOPCAIL_COLOR CGColor];
        self.reFreshButton.layer.borderWidth = 1;
        [self.contenView addSubview:self.reFreshButton];
    }
    self.contentImageView.hidden = NO;
    self.messageLabel.hidden = NO;
    self.reFreshButton.hidden = NO;
    return self.contenView;
}

//为新添加的属性添加 setter 和 getter 方法

//---contentImageView
static char contentImageViewKey;
-(void)setContentImageView:(UIImageView *)contentImageView
{
    objc_setAssociatedObject(self, &contentImageViewKey, contentImageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(UIImageView*)contentImageView
{
    return objc_getAssociatedObject(self, &contentImageViewKey);
}

//---contenView
static char contenViewKey;
-(void)setContenView:(UIView *)contenView
{
    objc_setAssociatedObject(self, &contenViewKey, contenView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIView*)contenView
{
    return objc_getAssociatedObject(self, &contenViewKey);
}

//---messageLabel
static char messageLabelKey;
-(void)setMessageLabel:(UILabel *)messageLabel
{
    objc_setAssociatedObject(self, &messageLabelKey, messageLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UILabel*)messageLabel
{
    return objc_getAssociatedObject(self, &messageLabelKey);
}

//---reFreshButton
static char reFreshButtonKey;
-(void)setReFreshButton:(UIButton *)reFreshButton
{
    objc_setAssociatedObject(self, &reFreshButtonKey, reFreshButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIButton*)reFreshButton
{
    return objc_getAssociatedObject(self, &reFreshButtonKey);
}

@end
