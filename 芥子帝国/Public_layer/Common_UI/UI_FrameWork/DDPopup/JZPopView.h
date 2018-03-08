//
//  NHPopView.h
//  NHBaseUIFrameWork
//
//  Created by 刘星辰 on 2018/2/26.
//  Copyright © 2018年 刘星辰. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JZPopView;

typedef NS_ENUM(NSUInteger, JZPopupState) {
    /** 开启状态 */
    JZPopupStateDidOpen = 1,
    /** 关闭状态 */
    JZPopupStateDidClose = 0,
};

typedef NS_ENUM(NSUInteger, JZPopupPostion) {
    JZPopupPostionUp = 0,
    JZPopupPostionDown = 1,
    JZPopupPostionCenter = 2,
};


typedef void(^__JZPopupDidShowBlock)(JZPopView * view);
typedef void(^__JZPopupDidHiddenBlock)(JZPopView * view);

@interface JZPopView : UIView

/**
 内容view
 */
@property(nonatomic,strong)UIView *contentView;

/**
 添加在这个view上
 */
@property(nonatomic,strong)UIView *backgroundView;

/**
 弹窗状态
 */
@property (nonatomic,assign) JZPopupState state;

/**
 方向
 */
@property (nonatomic,assign) JZPopupPostion postion;

/**
 显示的偏移量
 */
@property (nonatomic,assign)UIEdgeInsets insets;

@property (nonatomic,copy) __JZPopupDidShowBlock showBlock;

@property (nonatomic,copy) __JZPopupDidHiddenBlock hiddenBlcok;


/*
 * view 父视图
 * contentView 子视图
 */
- (void)addInView:(UIView *)view
  withContentView:(UIView*)contentView;

/**
 直接显示在window上

 @param contentView 子视图
 */
- (void)showOnWindowWithContentView:(UIView*)contentView;

-(void)showWithDidShowBlock:(__JZPopupDidShowBlock)showBlock;


-(void)hiddenWithDidHiddenBlock:(__JZPopupDidHiddenBlock)hidddenBlock;


@end
