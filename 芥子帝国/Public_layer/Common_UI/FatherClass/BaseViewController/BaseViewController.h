//
//  BaseViewController.h
//  EZGuan
//
//  Created by wu on 14/12/22.
//  Copyright (c) 2014年 wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UINavigationBar+Awesome.h"
#import "UIViewController+HUD.h"
#import "UIViewController+pop.h"

@class JumpManager;

typedef enum : NSUInteger {
    PhoneAuthCamera, //相机权限
    PhoneAuthPhoto,
    PhoneAuthLocation,
} PhoneAuthType;

typedef void(^authSuccessBlock)();
typedef void(^authFailureBlock)();

@interface BaseViewController : UIViewController


@property (nonatomic,strong)JumpManager *jumpManager;

//储存cell高的字典
@property (nonatomic,strong)NSMutableDictionary *cellHeight;

-(void)showAuthType:(PhoneAuthType)authType  successBlock:(authSuccessBlock)successBlock
          failureBlock:(authFailureBlock)failureBlock;

-(void)addtableViewTap;


-(UIViewController*)getPopViewController;

- (BOOL)shouldAutorotate;

//刘星辰 定义 储存和取值的方法
- (void)setLxcCellDictValue:(CGFloat)cellHeight WithKey:(NSIndexPath *)path;
- (CGFloat)getLxcCellDictValueWith:(NSIndexPath *)path;


@end
