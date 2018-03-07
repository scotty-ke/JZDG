//
//  DDPopup.h
//  easydoctor
//
//  Created by 丁东 on 16/7/27.
//  Copyright © 2016年 easygroup. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    DDPopupStateDidOpen,
    DDPopupStateDidClose,
} DDPopupState;



typedef enum : NSUInteger {
    DDPopupPostionUp,
    DDPopupPostionDown,
} DDPopupPostion;

typedef void(^__DDPopupDidShowBlock)();
typedef void(^__DDPopupDidHiddenBlock)();


@interface DDPopup : NSObject

@property(nonatomic,strong)UIView *contentView;

@property(nonatomic,strong)UIView *view;

@property (nonatomic,strong)UIView *showdView;

@property (nonatomic) DDPopupState state;

@property (nonatomic) DDPopupPostion postion;//方向

@property (nonatomic,copy) __DDPopupDidShowBlock showBlock;

@property (nonatomic,copy) __DDPopupDidHiddenBlock hiddenBlcok;


/*
 * view 父视图
 * contentView 子视图
 */
- (void)addInView:(UIView *)view
  withContentView:(UIView*)contentView;


-(void)showWithDIdShowBlock:(__DDPopupDidShowBlock)showBlock;


-(void)hiddenWithDIdShowBlock:(__DDPopupDidHiddenBlock)hidddenBlock;



@end
