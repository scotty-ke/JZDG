//
//  NHPopView.h
//  NHBaseUIFrameWork
//
//  Created by 刘星辰 on 2018/2/26.
//  Copyright © 2018年 刘星辰. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NHPopView;

typedef NS_ENUM(NSUInteger, NHPopupState) {
    /** 开启状态 */
    NHPopupStateDidOpen = 1,
    /** 关闭状态 */
    NHPopupStateDidClose = 0,
};

typedef NS_ENUM(NSUInteger, NHPopupPostion) {
    NHPopupPostionUp = 0,
    NHPopupPostionDown = 1,
    NHPopupPostionCenter = 2,
};


typedef void(^__NHPopupDidShowBlock)(NHPopView * view);
typedef void(^__NHPopupDidHiddenBlock)(NHPopView * view);

@interface NHPopView : UIView

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
@property (nonatomic,assign) NHPopupState state;

/**
 方向
 */
@property (nonatomic,assign) NHPopupPostion postion;

/**
 显示的偏移量
 */
@property (nonatomic,assign)UIEdgeInsets insets;

@property (nonatomic,copy) __NHPopupDidShowBlock showBlock;

@property (nonatomic,copy) __NHPopupDidHiddenBlock hiddenBlcok;


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

-(void)showWithDidShowBlock:(__NHPopupDidShowBlock)showBlock;


-(void)hiddenWithDidHiddenBlock:(__NHPopupDidHiddenBlock)hidddenBlock;


@end
