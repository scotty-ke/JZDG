//
//  DDPageHeaderView.m
//  easydoctor
//
//  Created by 丁东 on 15/11/16.
//  Copyright © 2015年 easygroup. All rights reserved.
//

#import "DDPageHeaderView.h"
#import "DDPageHeaderCell.h"
@implementation DDPageHeaderView

-(instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray*)titleArray classArray:(NSArray*)classArray andConfig:(DDPageConfig*)config andSelectIndex:(NSInteger)selectIndex
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.frame = frame;
        _config = config;
        _titleArray = titleArray;
        _classArray = classArray;
        self.selectIndex = selectIndex;
        [self addCollectionView];
        self.backgroundColor = _config.backColor;
        
        _line = [[UIView alloc]initWithFrame:CGRectMake((_config.barBtnWidth/2 - _config.lineWidth/2) + _config.barBtnWidth*self.selectIndex, _config.barViewH - _config.lineHight , _config.lineWidth, _config.lineHight)];
        _line.backgroundColor = _config.lineColor;
        [self addSubview:_line];
        
        if (_config.showIndentifier)
        {
            cellState = 1;
        }
        else
        {
            cellState = 0;
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(selectViewControllerByNotice:)
                                                     name:@"hiddenMenu"
                                                   object:nil];

        
    }
    return self;
}

//-(void)setSelectIndex:(NSInteger)selectIndex
//{
//    if (_selectIndex != selectIndex)
//    {
//        _selectIndex = selectIndex;
//    }
//    _line = [[UIView alloc]initWithFrame:CGRectMake((_config.barBtnWidth/2 - _config.lineWidth/2) + _config.barBtnWidth*_selectIndex, _config.barViewH - _config.lineHight , _config.lineWidth, _config.lineHight)];
//}
//
-(void)dealloc{
    
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)addCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectonView =  [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    _collectonView.backgroundColor = _config.backColor;
    _collectonView.dataSource = self;
    _collectonView.delegate = self;
    UINib *cellNib = [UINib nibWithNibName:@"DDPageHeaderCell" bundle:nil];
    [_collectonView registerNib:cellNib forCellWithReuseIdentifier:@"DDPageHeaderCell"];
    [self addSubview:_collectonView];
}

#pragma mark -
#pragma mark  UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return  1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DDPageHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DDPageHeaderCell" forIndexPath:indexPath];
    cell.nameLabel.text = self.titleArray[indexPath.row];
    [cell.nameLabel sizeToFit];
    if (indexPath.item == _selectIndex)
    {
        cell.nameLabel.textColor = _config.selectColor;
        cell.nameLabel.font = _config.selectFont;
        if (_config.showIndentifier)
        {
            cell.icon.hidden = NO;
            if (cellState ==1)
            {
                cell.icon.image = _config.closeImage;
            }
            else if (cellState == 2)
            {
                cell.icon.image = _config.openImage;
            }
        }
    }
    else
    {
        cell.nameLabel.textColor = _config.nomalColor;
        cell.nameLabel.font = _config.nomalFont;
        cell.icon.hidden = YES;
    }
    return cell;
}

#pragma mark -
#pragma mark  UICollectionViewDelegate
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


    
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return  CGSizeMake(_config.barBtnWidth, _config.barViewH);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(1, 0, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeZero;
}

#pragma mark -
#pragma mark  点击item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.config.showIndentifier)
    {
        if (_selectIndex == indexPath.item)
        {
            if (cellState == 1)
            {
                cellState = 2;
                [self.delegate DDPageHeaderViewOpenMenuAtIndex:_selectIndex];
            }
            else
            {
                cellState = 1;
                _selectIndex = indexPath.row;
                [self.delegate DDPageHeaderViewCloseMenuAtIndex:_selectIndex];
                [self collectionViewAndLineChange:indexPath];
            }
        }
        else
        {
            if (cellState == 2)
            {
                cellState = 1;
                [self.delegate DDPageHeaderViewCloseMenuAtIndex:_selectIndex];
            }
            else
            {
                cellState = 1;
                _selectIndex = indexPath.row;
                [self collectionViewAndLineChange:indexPath];
            }
        }
    }
    else
    {
        _selectIndex = indexPath.row;
        [self collectionViewAndLineChange:indexPath];
    }
    
    [_collectonView reloadData];
}

-(void)collectionViewAndLineChange:(NSIndexPath*)indexPath
{
    
    DDPageHeaderCell *cell = (DDPageHeaderCell*)[_collectonView cellForItemAtIndexPath:indexPath];
    CGRect rect = [_collectonView convertRect:cell.frame
                                       toView:[_collectonView superview]];
    [UIView animateWithDuration:0.3 animations:^{
        _line.frame = CGRectMake(CGRectGetMidX(rect) - CGRectGetWidth(_line.frame)/2, CGRectGetMaxY(rect) - CGRectGetHeight(_line.frame), CGRectGetWidth(_line.frame), CGRectGetHeight(_line.frame));
    }];
    [self.delegate DDPageHeaderViewDidSelectAtIndex:indexPath.item];

}


-(void)selectCollectionViewAtIndex:(NSInteger)index withAnimation:(BOOL)animation
{
    [_collectonView selectItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]
                                           animated:animation
                                     scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    [self collectionView:_collectonView didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
}



-(void)selectViewControllerByNotice:(NSNotification*)notice
{
    NSDictionary *dic = notice.userInfo;
    UIViewController *viewController = [dic objectForKey:@"viewController"];
    NSLog(@"%@",_classArray);
    if ([_classArray containsObject:viewController])
    {
        NSInteger index = [_classArray indexOfObject:viewController];
        [self selectCollectionViewAtIndex:index withAnimation:YES];
    }
}

@end
