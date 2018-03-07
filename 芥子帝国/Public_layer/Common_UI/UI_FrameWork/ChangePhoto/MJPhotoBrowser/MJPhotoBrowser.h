//
//  MJPhotoBrowser.h
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.

#import <UIKit/UIKit.h>
#import "MJPhoto.h"

@protocol MJPhotoBrowserDelegate;
@interface MJPhotoBrowser : UIViewController <UIScrollViewDelegate>
// 代理
@property (nonatomic, weak) id<MJPhotoBrowserDelegate> delegate;
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


// 显示
- (void)show;
@end

@protocol MJPhotoBrowserDelegate <NSObject>
@optional
// 切换到某一页图片
- (void)photoBrowser:(MJPhotoBrowser *)photoBrowser didChangedToPageAtIndex:(NSUInteger)index;

- (void)clickToolBarALAsset:(ALAsset *)asset isSelect:(BOOL)isSelect;

- (BOOL) shouldClickToolBarALAsset:(ALAsset *)asset isSelect:(BOOL)isSelect;

- (void)finishToolBar;

@end