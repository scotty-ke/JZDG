//
//  DDPageViewController.h
//  easydoctor
//
//  Created by 丁东 on 15/11/16.
//  Copyright © 2015年 easygroup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDPageConfig.h"
#import "DDPageHeaderView.h"
@protocol DDPageViewControllerDelegate <NSObject>
@optional
-(void)DDPageViewOpenMenuAtIndex:(NSInteger)index;

-(void)DDPageVieCloseMenuAtIndex:(NSInteger)index;

-(void)ddPageViewSelectAtIndex:(NSInteger)index;

@end

@interface DDPageViewController : UIViewController

//控制器数组
@property (nonatomic,strong)NSArray *classArray;

//标题数组
@property (nonatomic,strong)NSArray *titleArray;

//配置文件
@property (nonatomic,strong)DDPageConfig *config;

@property (nonatomic,strong)DDPageHeaderView *pageHader;

@property (nonatomic,weak) id <DDPageViewControllerDelegate> delegate;



//选中位置 默认为0
@property (nonatomic) NSInteger selectIndex;

-(id)initWithClassArray:(NSArray*)classArray titleArray:(NSArray*)titleArray config:(DDPageConfig*)config;

-(void)setSelectIndex:(NSInteger)selectIndex withAnimation:(BOOL)animation;

@end
