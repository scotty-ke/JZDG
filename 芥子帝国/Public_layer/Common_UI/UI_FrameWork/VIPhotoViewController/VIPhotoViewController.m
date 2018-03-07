//
//  VIPhotoViewController.m
//  easydoctor
//
//  Created by 姚驰 on 16/8/28.
//  Copyright © 2016年 easygroup. All rights reserved.
//

#import "VIPhotoViewController.h"
#import "VIPhotoView.h"
#import "SDWebImageManager.h"
#import "Masonry.h"
#import "HcdActionSheet.h"


#define FORMATF_STR @"[%lu/%lu]%@"


@interface VIPhotoViewController ()<VIPhotoViewDelegate,UIScrollViewDelegate>
{
    //    NSString *_imgUrl;
    //    UIImage *_image;
    
    NSArray<NSString *> *_imgUrlArr;
    NSArray<UIImage *> *_imgArr;
    NSArray<NSDictionary *>*_imgAndName;
    UIScrollView *_scrollView;
    
    //    NSMutableArray<VIPhotoView *> *_photoViewArr;
    NSMutableArray<UIActivityIndicatorView *> *_activityIndicatorArr;
    //    VIPhotoView *_photoView;
    //    UIActivityIndicatorView *_activityIndicator;
    
    UILabel * _signLab;
}

@end

@implementation VIPhotoViewController


- (instancetype)initWithImageUrlArr:(NSArray *)urlStringArr {
    self = [super init];
    
    if (self) {
        _imgUrlArr = urlStringArr;
    }
    
    return self;
}


- (instancetype)initWithImageArr:(NSArray<UIImage *> *)imgArr {
    self = [super init];
    
    if (self) {
        _imgArr = imgArr;
    }
    
    return self;
}

- (instancetype)initWithImageAndName:(NSArray<NSDictionary *> *)imgAndStr{
    if (self = [super init]) {
        _imgAndName = imgAndStr;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    //    _photoViewArr = [NSMutableArray array];
    _activityIndicatorArr = [NSMutableArray array];
    
    NSInteger count = 0;
    if (_imgUrlArr.count > 0) {
        count = _imgUrlArr.count;
    } else if(_imgUrlArr.count > 0){
        count = _imgArr.count;
    }else{
        count = _imgAndName.count;
    }
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.contentSize = CGSizeMake(self.view.bounds.size.width * count, self.view.bounds.size.height);
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.contentOffset = CGPointMake(self.view.bounds.size.width * self.page, 0);
    [self.view addSubview:_scrollView];
    
    if (_imgAndName) {
        [self addsignLab];
    }
    
    [self makeActivityIndicator];
    [self startLoadImage];
}
- (void)addsignLab{
    _signLab =  [[UILabel alloc] init];
    NSString *name = [_imgAndName[self.page] objectForKey:@"name"];
    
    NSString *text;
    if (_imgAndName.count > 1) {
        text = [NSString stringWithFormat:FORMATF_STR,self.page + 1,_imgAndName.count,name];
    }else{
        text = [NSString stringWithFormat:@"%@",name];
    }
    _signLab.text = text;
    _signLab.font = TEXT_FONT_15;
    _signLab.textColor = TOPCAIL_COLOR;
    _signLab.textAlignment = NSTextAlignmentCenter;
    _signLab.numberOfLines = 0;
    [_signLab sizeToFit];
    [_scrollView addSubview:_signLab];
    
    [_signLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-100);
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}


- (void)makeActivityIndicator {
    NSInteger count = 0;
    if (_imgUrlArr.count > 0) {
        count = _imgUrlArr.count;
    } else if(_imgArr.count > 0) {
        count = _imgArr.count;
    }else{
        count = _imgAndName.count;
    }
    
    for (int i = 0; i < count; ++i) {
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [_scrollView addSubview:activityIndicator];
        [_scrollView bringSubviewToFront:activityIndicator];
        [_activityIndicatorArr addObject:activityIndicator];
        [activityIndicator setCenter:CGPointMake(self.view.bounds.size.width * (0.5 + i), self.view.bounds.size.height * 0.5)];
        [activityIndicator startAnimating];
    }
}


- (void)startLoadImage {
    if (_imgArr) {
        for (int i = 0; i < _imgArr.count; ++i) {
            [self makePhotoView:_imgArr[i] withIndex:i];
        }
    } else if(_imgUrlArr){
        for (int i = 0; i < _imgUrlArr.count; ++i) {
            [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:_imgUrlArr[i]]
                                                            options:SDWebImageRetryFailed
                                                           progress:nil
                                                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                              [self makePhotoView:image withIndex:i];
                                                          }];
        }
    }else if (_imgAndName){
        for (int i = 0; i < _imgAndName.count; ++i) {
            NSString *urlStr = [_imgAndName[i] objectForKey:@"img"];
            [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:urlStr]
                                                            options:SDWebImageRetryFailed
                                                           progress:nil
                                                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                              [self makePhotoView:image withIndex:i];
                                                          }];
        }
        
    }
}


- (void)makePhotoView:(UIImage *)image withIndex:(NSInteger)index {
    [_activityIndicatorArr[index] stopAnimating];
    VIPhotoView *photoView = [[VIPhotoView alloc] initWithFrame:CGRectMake(index * self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height) andImage:image];
    photoView.photoViewDelegate = self;
    [_scrollView addSubview:photoView];
    [_scrollView sendSubviewToBack:photoView];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (_imgAndName) {
        CGPoint contentOffset = scrollView.contentOffset;
        NSInteger index = contentOffset.x / SCREEN_WIDTH;
        NSString *name = [_imgAndName[index] objectForKey:@"name"];
        _signLab.text = [NSString stringWithFormat:FORMATF_STR,index + 1,_imgAndName.count,name];
    }
}



- (void)photoViewSingleTap {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)photoViewLongPressTap:(UIImage *)image {
    //    AppActionSheet *actionSheet = [[AppActionSheet alloc] initWithParentController:self];
    //    [actionSheet showActionSheetWithTitle:nil messeage:nil buttonItems:@[@"保存到手机相册"] actionSelectBlock:^(NSInteger selectIndex) {
    //        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    //    }];
    HcdActionSheet *sheet = [[HcdActionSheet alloc] initWithCancelStr:@"取消" otherButtonTitles:@[@"保存到手机相册"] attachTitle:nil];
    [sheet changeTitleColor:TOPCAIL_COLOR andIndex:900];
    [[UIApplication sharedApplication].keyWindow addSubview:sheet];
    [sheet showHcdActionSheet];
    sheet.selectButtonAtIndex = ^(NSInteger index){
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    };
    
    
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    [self showHint:@"图片已保存" errorImage:[UIImage imageNamed:@"rt"]];
}


- (BOOL)prefersStatusBarHidden {
    return YES;
}


@end
