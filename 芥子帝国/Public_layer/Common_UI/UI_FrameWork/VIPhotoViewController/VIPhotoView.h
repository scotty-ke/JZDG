//
//  VIPhotoView.h
//  VIPhotoViewDemo
//
//  Created by Vito on 1/7/15.
//  Copyright (c) 2015 vito. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol VIPhotoViewDelegate <NSObject>

- (void)photoViewSingleTap;
- (void)photoViewLongPressTap:(UIImage *)images;

@end


@interface VIPhotoView : UIScrollView

@property (nonatomic, weak) id<VIPhotoViewDelegate> photoViewDelegate;

@property (nonatomic, strong, readonly) UIImage *image;

- (instancetype)initWithFrame:(CGRect)frame andImage:(UIImage *)image;

@end
