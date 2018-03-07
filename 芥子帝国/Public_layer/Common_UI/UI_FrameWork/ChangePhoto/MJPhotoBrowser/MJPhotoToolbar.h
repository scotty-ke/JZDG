//
//  MJPhotoToolbar.h
//  FingerNews
//
//  Created by mj on 13-9-24.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ALAsset;

@protocol MJPhotoToolBarDelegate <NSObject>

- (void)clickToolBarALAsset:(ALAsset *)asset isSelect:(BOOL)isSelect;

- (BOOL)shouldClickToolBarALAsset:(ALAsset *)asset isSelect:(BOOL)isSelect;

- (void)finishToolBar;

@end

@interface MJPhotoToolbar : UIView
// 所有的图片对象
@property (nonatomic, strong) NSArray *photos;
// 当前展示的图片索引
@property (nonatomic, assign) NSUInteger currentPhotoIndex;

//已选中多少张
@property(nonatomic,assign) NSUInteger selectNum;
//限制多少张
@property(nonatomic,assign) NSUInteger limitNum;
//是否选择相册图片
@property (nonatomic, assign) BOOL sourceFromAblum;

@property (nonatomic, weak) id<MJPhotoToolBarDelegate> toolBarDelegate;


@end
