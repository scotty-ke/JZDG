//
//  DDPageViewController.m
//  easydoctor
//
//  Created by 丁东 on 15/11/16.
//  Copyright © 2015年 easygroup. All rights reserved.
//

#import "DDPageViewController.h"
#import "DDPageHeaderView.h"
@interface DDPageViewController ()<UIScrollViewDelegate,DDPageHeaderViewrDelegate>
{
    UIScrollView *_backScrollView;//底部滑动试图
    CGFloat _offsetX;//记录offsetX
}
@end

@implementation DDPageViewController

-(id)initWithClassArray:(NSArray*)classArray
             titleArray:(NSArray*)titleArray
                 config:(DDPageConfig*)config
{
    self = [super init];
    if (self) {
        _classArray = classArray;
        
        _titleArray = titleArray;
        
        _config = config;
    }
    return self;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
}

-(void)dealloc
{
    NSLog(@"retianCount --- %ld",CFGetRetainCount((__bridge CFTypeRef)self));
}

#pragma mark 添加头部
-(void)addDDPageHeader
{
    _pageHader = [[DDPageHeaderView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), _config.barViewH)
                                             titleArray:_titleArray
                                             classArray:_classArray
                                              andConfig:_config
                                         andSelectIndex:self.selectIndex];
    [self.view addSubview:_pageHader];
    _pageHader.delegate = self;
}


#pragma mark 添加content
-(void)addBackScrollerView
{
    _backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_pageHader.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - CGRectGetMaxY(_pageHader.frame))];
    _backScrollView.delegate  = self;
    _backScrollView.backgroundColor = BACKGROUND_COLOR;
    [self.view addSubview:_backScrollView];
    _backScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame)*_classArray.count, CGRectGetHeight(_backScrollView.frame));
    _backScrollView.pagingEnabled = YES;
    
    [self addClassVieWithIndex:self.selectIndex];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x > 0 && scrollView.contentOffset.x < scrollView.contentSize.width)
    {
        if (scrollView == _backScrollView)
        {
            NSInteger pageNum = 0;
            if (scrollView.contentOffset.x > _offsetX) //左滑
            {
                pageNum = ceil(scrollView.contentOffset.x/CGRectGetWidth(_backScrollView.frame));
            }
            else //右滑
            {
                pageNum = floor(scrollView.contentOffset.x/CGRectGetWidth(_backScrollView.frame));
            }
            _offsetX = scrollView.contentOffset.x;
            
            [self addClassVieWithIndex:pageNum];
        }

    }
}

-(void)addClassVieWithIndex:(NSInteger)index
{
    if (index >=0 && index < _classArray.count)
    {
        UIViewController *viewController = [_classArray objectAtIndex:index];
        
        if (![self.childViewControllers containsObject:viewController])
        {
            [self addChildViewController:viewController];
            viewController.view.frame = CGRectMake(CGRectGetWidth(_backScrollView.frame)*index, 0, CGRectGetWidth(_backScrollView.frame), CGRectGetHeight(_backScrollView.frame));
            [_backScrollView addSubview:viewController.view];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _backScrollView)
    {
        NSInteger pageNum = 0;
        if (scrollView.contentOffset.x > _offsetX) //左滑
        {
            pageNum = ceil(scrollView.contentOffset.x/CGRectGetWidth(_backScrollView.frame));
        }
        else //右滑
        {
            pageNum = floor(scrollView.contentOffset.x/CGRectGetWidth(_backScrollView.frame));
        }
        
        if (pageNum >=0 && pageNum <= _classArray.count && pageNum != self.selectIndex)
        {
            [_pageHader selectCollectionViewAtIndex:pageNum withAnimation:YES];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self addDDPageHeader];
    
    [self addBackScrollerView];
    
    [self DDPageHeaderViewDidSelectAtIndex:self.selectIndex];
}

-(void)DDPageHeaderViewDidSelectAtIndex:(NSInteger)index
{
    self.selectIndex = index;
    if ([self.delegate respondsToSelector:@selector(ddPageViewSelectAtIndex:)]) {
        [self.delegate ddPageViewSelectAtIndex:index];
    }
    [_backScrollView setContentOffset:CGPointMake(index * CGRectGetWidth(_backScrollView.frame), 0) animated:YES];
}

-(void)DDPageHeaderViewOpenMenuAtIndex:(NSInteger)index
{
    _backScrollView.scrollEnabled = NO;
    if ([self.delegate respondsToSelector:@selector(DDPageViewOpenMenuAtIndex:)]) {
        [self.delegate DDPageViewOpenMenuAtIndex:index];
    }
}

-(void)DDPageHeaderViewCloseMenuAtIndex:(NSInteger)index
{
    _backScrollView.scrollEnabled = YES;
    if ([self.delegate respondsToSelector:@selector(DDPageVieCloseMenuAtIndex:)]) {
        [self.delegate DDPageVieCloseMenuAtIndex:index];
    }
}


-(void)setSelectIndex:(NSInteger)selectIndex withAnimation:(BOOL)animation
{
    self.selectIndex = selectIndex;
    [_pageHader selectCollectionViewAtIndex:selectIndex withAnimation:animation];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
