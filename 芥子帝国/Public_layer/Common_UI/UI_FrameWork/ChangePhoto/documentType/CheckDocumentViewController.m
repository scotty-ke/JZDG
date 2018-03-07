//
//  CheckDocumentViewController.m
//  easydoctor
//
//  Created by stone on 15/12/1.
//  Copyright © 2015年 easygroup. All rights reserved.
//


#import "CheckDocumentViewController.h"
#import "MJPhotoView.h"
#import "Document.h"
#import "DocumentTypeView.h"

#define kPadding 10
#define kPhotoViewTagOffset 1000
#define barHeight  64
#define kPhotoViewIndex(photoView) ([photoView tag] - kPhotoViewTagOffset)

@interface CheckDocumentViewController ()<UIScrollViewDelegate,MJPhotoViewDelegate,DocumentTypeViewDelegate>
{
    // 滚动的view
    UIScrollView *_photoScrollView;
    // 所有的图片view
    NSMutableSet *_visiblePhotoViews;
    NSMutableSet *_reusablePhotoViews;
    
    // 一开始的状态栏
    BOOL _statusBarHiddenInited;
    
    UIPageControl *_pageControl;
    
    NSMutableArray *_dataArray;
}

@end

@implementation CheckDocumentViewController
{
    UIButton *_rightButton;
    DocumentTypeView *docTypeView;
}

#pragma mark - Lifecycle
- (void)loadView
{
    _statusBarHiddenInited = [UIApplication sharedApplication].isStatusBarHidden;
    // 隐藏状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    self.view = [[UIView alloc] init];
    self.view.frame = [UIScreen mainScreen].bounds;
    self.view.backgroundColor = [UIColor blackColor];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TEXT_COLOR_1;
    
    // 1.创建UIScrollView
    [self createScrollView];
    
    //2.设置navigatorBar
    [self setNavigatorBar];
    
    // 3.显示图片
    [self showPhotos];
    
    //显示分页
    [self showPageController];
    
    //4显示标签
    [self showLabels];
    
    if (_currentPhotoIndex == 0) {
        [self updateTollbarState];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [self updateTollbarState];
}

- (void)setNavigatorBar
{
    _rightButton = [[UIButton alloc]init];
    
    _rightButton.frame = CGRectMake(0, 0, 30, 40);
    
    _rightButton.titleLabel.font = TEXT_FONT_15;
    
    [_rightButton setImage:[UIImage imageNamed:@"lajitong"]
                 forState:UIControlStateNormal];
    
    [_rightButton setTitleColor:TEXT_COLOR_1
                      forState:UIControlStateNormal];
    
    _rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    
    [_rightButton addTarget:self
                     action:@selector(deleteDocument:)
          forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_rightButton];
    
    UIButton *leftButton = [[UIButton alloc]init];
    
    leftButton.frame = CGRectMake(0, 0, 30, 40);
    
    leftButton.titleLabel.font = TEXT_FONT_15;
    
    [leftButton setImage:[UIImage imageNamed:@"fanhui_white"]
                forState:UIControlStateNormal];
    
    [leftButton setTitleColor:TEXT_COLOR_1
                     forState:UIControlStateNormal];
    
    leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
    
    [leftButton addTarget:self
                   action:@selector(popOrDismiss:)
         forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.barTintColor = RGBACOLOR(24, 23, 28, 0.8);
    self.navigationController.navigationBar.titleTextAttributes =  [NSDictionary dictionaryWithObject:WHITE_COLOR forKey:NSForegroundColorAttributeName];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.barTintColor = WHITE_COLOR;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : TEXT_COLOR_1 , NSFontAttributeName : TITLE_FONT_19};
}


#pragma mark 创建UIScrollView
- (void)createScrollView
{
    CGRect frame = self.view.bounds;
    frame.origin.x -= kPadding;
    frame.size.width += (2 * kPadding);
    _photoScrollView = [[UIScrollView alloc] initWithFrame:frame];
    _photoScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _photoScrollView.pagingEnabled = YES;
    _photoScrollView.delegate = self;
    _photoScrollView.showsHorizontalScrollIndicator = NO;
    _photoScrollView.showsVerticalScrollIndicator = NO;
    _photoScrollView.backgroundColor = [UIColor clearColor];
    _photoScrollView.clipsToBounds = YES;
    _photoScrollView.contentSize = CGSizeMake(frame.size.width * _photos.count, 0);
    [self.view addSubview:_photoScrollView];
    _photoScrollView.contentOffset = CGPointMake(_currentPhotoIndex * frame.size.width, 0);
}


#pragma mark - 分页
- (void)showPageController
{
    _pageControl = [[UIPageControl alloc]init];
    _pageControl.numberOfPages = _photos.count;
    _pageControl.frame = CGRectMake( 0, self.view.height - 100,20*_photos.count, 20);
    _pageControl.center = CGPointMake(self.view.width / 2, self.view.height - 100);
    _pageControl.currentPage = _currentPhotoIndex;
    _pageControl.enabled = NO;
    [self.view addSubview:_pageControl];
}

#pragma mark - 创建标签
- (DocumentTypeView *)showLabels
{
    if(docTypeView == nil)
    {
        float tempWidth = (SCREEN_WIDTH-3)/4;
        float tempHeight = tempWidth / 3 * 2 * 3;
        docTypeView = [[DocumentTypeView alloc] initWithFrame:CGRectMake(0, self.view.height - tempHeight-NAVIGATOR_HEIGHT, SCREEN_WIDTH, tempHeight) status:DocumentTypeChect];
        docTypeView.documentTypeViewDelegate = self;
        [self.view addSubview:docTypeView];
    }
    return docTypeView;
}

//- (void)show
//{
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    [window addSubview:self.view];
//    [window.rootViewController addChildViewController:self];
//    
//    if (_currentPhotoIndex == 0) {
//        [self showPhotos];
//    }
//}


- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    
    if (photos.count > 1) {
        _visiblePhotoViews = [NSMutableSet set];
        _reusablePhotoViews = [NSMutableSet set];
    }
    
    for (int i = 0; i<_photos.count; i++) {
        MJPhoto *photo = _photos[i];
        photo.index = i;
        photo.firstShow = i == _currentPhotoIndex;
    }
}

#pragma mark 设置选中的图片
- (void)setCurrentPhotoIndex:(NSUInteger)currentPhotoIndex
{
    _currentPhotoIndex = currentPhotoIndex;
    
    for (int i = 0; i<_photos.count; i++) {
        MJPhoto *photo = _photos[i];
        photo.firstShow = i == currentPhotoIndex;
    }
    
    if ([self isViewLoaded]) {
        _photoScrollView.contentOffset = CGPointMake(_currentPhotoIndex * _photoScrollView.frame.size.width, 0);
        
        // 显示所有的相片
        [self showPhotos];
    }
}

#pragma mark - MJPhotoView代理
- (void)photoViewSingleTap:(MJPhotoView *)photoView
{
//    [UIApplication sharedApplication].statusBarHidden = _statusBarHiddenInited;
//    self.view.backgroundColor = [UIColor clearColor];
//    [self.navigationController popViewControllerAnimated:YES];
    if (docTypeView.hidden) {
        docTypeView.hidden = NO;
        [UIView animateWithDuration:2.0 delay:0.0 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
            docTypeView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
        }];
    }else{
        [UIView animateWithDuration:2.0 delay:0.0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
            docTypeView.transform = CGAffineTransformMakeTranslation(0, docTypeView.height);
        } completion:^(BOOL finished) {
            docTypeView.hidden = YES;
        }];
    }
}

#pragma mark - 修改类别
- (void)clickDocumentTypeLabel:(id)documentType
{
    if ([self.checkDocumentDelegate respondsToSelector:@selector(clickDocumentType:docType:)]) {
        [self.checkDocumentDelegate clickDocumentType:_currentPhotoIndex docType:documentType];
    }
}

- (void)photoViewDidEndZoom:(MJPhotoView *)photoView
{
//    [self.view removeFromSuperview];
//    [self removeFromParentViewController];
}


#pragma mark 显示照片
- (void)showPhotos
{
    // 只有一张图片
    if (_photos.count == 1) {
        [self showPhotoViewAtIndex:0];
        return;
    }
    
    CGRect visibleBounds = _photoScrollView.bounds;
    NSInteger firstIndex = (int)floorf((CGRectGetMinX(visibleBounds)+kPadding*2) / CGRectGetWidth(visibleBounds));
    NSInteger lastIndex  = (int)floorf((CGRectGetMaxX(visibleBounds)-kPadding*2-1) / CGRectGetWidth(visibleBounds));
    if (firstIndex < 0) firstIndex = 0;
    if (firstIndex >= _photos.count) firstIndex = _photos.count - 1;
    if (lastIndex < 0) lastIndex = 0;
    if (lastIndex >= _photos.count) lastIndex = _photos.count - 1;
    
    // 回收不再显示的ImageView
    NSInteger photoViewIndex;
    for (MJPhotoView *photoView in _visiblePhotoViews) {
        photoViewIndex = kPhotoViewIndex(photoView);
        if (photoViewIndex < firstIndex || photoViewIndex > lastIndex) {
            [_reusablePhotoViews addObject:photoView];
            [photoView removeFromSuperview];
        }
    }
    
    [_visiblePhotoViews minusSet:_reusablePhotoViews];
    while (_reusablePhotoViews.count > 2) {
        [_reusablePhotoViews removeObject:[_reusablePhotoViews anyObject]];
    }
    
    for (NSUInteger index = firstIndex; index <= lastIndex; index++) {
        if (![self isShowingPhotoViewAtIndex:index]) {
            [self showPhotoViewAtIndex:index];
        }
    }
}

#pragma mark 显示一个图片view
- (void)showPhotoViewAtIndex:(NSUInteger)index
{
    MJPhotoView *photoView = [self dequeueReusablePhotoView];
    if (!photoView) { // 添加新的图片view
        photoView = [[MJPhotoView alloc] init];
        photoView.photoViewDelegate = self;
    }
    
    // 调整当期页的frame
    CGRect bounds = _photoScrollView.bounds;
    CGRect photoViewFrame = bounds;
    photoViewFrame.size.width -= (2 * kPadding);
    photoViewFrame.origin.x = (bounds.size.width * index) + kPadding;
    photoViewFrame.origin.y = photoViewFrame.origin.y - 44;
    photoViewFrame.size.height += 44;
    photoView.tag = kPhotoViewTagOffset + index;
    
    
    //FIX 内容 photos放的document对象
    MJPhoto *photo = _photos[index];
//    Document *document = _photos[index];
//    MJPhoto *photo = [[MJPhoto alloc] init];
//     ALAssetRepresentation* representation = [document.photo defaultRepresentation];
//    photo.image = [UIImage imageWithCGImage: [representation fullResolutionImage]];
//    photo.image = [UIImage imageWithCGImage:document.photo.thumbnail];
//    photo.image = [UIImage imageWithCGImage:document.photo.defaultRepresentation.fullResolutionImage
//                                           scale:0.1
//                                     orientation:(UIImageOrientation)document.photo.defaultRepresentation.orientation];
    photoView.frame = photoViewFrame;
    photoView.photo = photo;
    
    [_visiblePhotoViews addObject:photoView];
    [_photoScrollView addSubview:photoView];
    
}


#pragma mark index这页是否正在显示
- (BOOL)isShowingPhotoViewAtIndex:(NSUInteger)index {
    for (MJPhotoView *photoView in _visiblePhotoViews) {
        if (kPhotoViewIndex(photoView) == index) {
            return YES;
        }
    }
    return  NO;
}

#pragma mark 循环利用某个view
- (MJPhotoView *)dequeueReusablePhotoView
{
    MJPhotoView *photoView = [_reusablePhotoViews anyObject];
    if (photoView) {
        [_reusablePhotoViews removeObject:photoView];
    }
    return photoView;
}

#pragma mark 更新当前选中页面
- (void)updateTollbarState
{
    _currentPhotoIndex = _photoScrollView.contentOffset.x / _photoScrollView.frame.size.width;
    if ([self.checkDocumentDelegate respondsToSelector:@selector(updateTitle:)]) {
        self.title = [self.checkDocumentDelegate updateTitle:_currentPhotoIndex];
        NSInteger key = [self.checkDocumentDelegate updateSelectType:_currentPhotoIndex];
        [docTypeView setSelectType:key];
    }
}


#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self showPhotos];
    [self updateTollbarState];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger  index = _photoScrollView.contentOffset.x / _photoScrollView.frame.size.width;
    _pageControl.currentPage = index;
}


#pragma mark - deleteDocument 删除文档
- (void)deleteDocument:(id)sender
{
    if ([self.checkDocumentDelegate respondsToSelector:@selector(clickDeleteDocument:)]) {
        [self.checkDocumentDelegate clickDeleteDocument:_currentPhotoIndex];
    }
    if (self.photos.count <= 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.photos removeObjectAtIndex:_currentPhotoIndex];
        _pageControl.numberOfPages = self.photos.count;
        _visiblePhotoViews = [NSMutableSet set];
        _reusablePhotoViews = [NSMutableSet set];
        [[_photoScrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        _photoScrollView.contentSize = CGSizeMake(_photoScrollView.size.width * _photos.count, 0);
        _currentPhotoIndex = 0;
        [self showPhotoViewAtIndex:0];
        _photoScrollView.contentOffset = CGPointMake(_currentPhotoIndex * _photoScrollView.size.width, 0);
        
    }
    
}

-(void)popOrDismiss:(UIButton*)buuton
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
