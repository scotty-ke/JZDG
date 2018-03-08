//
//  MHRefresh.m
//  NHBaseUIFrameWork
//
//  Created by 刘星辰 on 2018/1/16.
//  Copyright © 2018年 刘星辰. All rights reserved.
//

#import "JZRefresh.h"
#import "UIViewExt.h"


@implementation JZRefreshHeader

#pragma mark - 重写方法
#pragma mark 基本设置
- (void)prepare
{
    [super prepare];
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSInteger i = 0; i< self.refreshingImages.count; i++)
    {
        UIImage *img = [UIImage imageNamed:self.refreshingImages[i]];
        NSAssert(img != nil, @"方法imageNamed: 获取不到这个%@图片",self.refreshingImages[i]);
        [idleImages addObject:img];
       
    }
    [self setImages:idleImages forState:MJRefreshStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    [self setImages:idleImages forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
    [self setImages:idleImages forState:MJRefreshStateRefreshing];
    
    self.stateLabel.hidden = YES;
    self.lastUpdatedTimeLabel.hidden = YES;
    
}

- (void)placeSubviews
{
    [super placeSubviews];
    self.gifView.frame = CGRectMake(0, 0, self.refreshSize.width, self.refreshSize.height);
    self.gifView.center = CGRectGetCenter(self.bounds);
    self.gifView.contentMode = UIViewContentModeScaleAspectFit;

}

- (void)setImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(MJRefreshState)state
{
    [super setImages:images duration:duration forState:state];
    if (images == nil) return;
    
    self.mj_h = self.refreshSize.height + 20 * 2;
    
    
}

- (NSArray *)refreshingImages
{
    return [JZRefreshHeader appearance].refreshingImages;
}

- (CGSize)refreshSize
{
    return [JZRefreshHeader appearance].refreshSize;
}

@end


@implementation JZRefreshFooter

@end
