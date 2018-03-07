//
//  DDPageHeaderView.h
//  easydoctor
//
//  Created by 丁东 on 15/11/16.
//  Copyright © 2015年 easygroup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDPageConfig.h"

@protocol DDPageHeaderViewrDelegate <NSObject>
@optional
-(void)DDPageHeaderViewDidSelectAtIndex:(NSInteger)index;

//*监控header的index *//
-(void)DDPageHeaderViewDidSelecttoIndex:(NSInteger)toIndex fromIndex:(NSInteger)fromIndex;

//* 只有showIndentifier == yes 时可用*/
-(void)DDPageHeaderViewOpenMenuAtIndex:(NSInteger)index;

-(void)DDPageHeaderViewCloseMenuAtIndex:(NSInteger)index;


@end

@interface DDPageHeaderView : UIView<UICollectionViewDataSource,UICollectionViewDelegate>
{
    UIView *_line;
    NSInteger cellState;
}
@property (nonatomic,strong) UICollectionView *collectonView;
@property (nonatomic,strong)DDPageConfig *config;
@property (nonatomic,strong)NSArray *titleArray;
@property (nonatomic,strong)NSArray *classArray;
@property (nonatomic) NSInteger selectIndex;
@property (nonatomic) id <DDPageHeaderViewrDelegate> delegate;

-(instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray*)titleArray classArray:(NSArray*)classArray andConfig:(DDPageConfig*)config andSelectIndex:(NSInteger)selectIndex;

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

-(void)selectCollectionViewAtIndex:(NSInteger)index withAnimation:(BOOL)animation;

@end
