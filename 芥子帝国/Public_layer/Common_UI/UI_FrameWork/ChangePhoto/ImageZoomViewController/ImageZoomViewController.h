//
//  ImageZoomViewController.h
//  easydoctor
//
//  Created by shenyang on 16/1/20.
//  Copyright © 2016年 easygroup. All rights reserved.
//

#import "BaseViewController.h"

@protocol ImageZoomViewControllerDelegate <NSObject>

- (void)deletePhoto;

@end

@interface ImageZoomViewController : BaseViewController

@property(nonatomic,weak) id<ImageZoomViewControllerDelegate> deletePhotoDelegate;


- (void)zoomImage:(UIImageView*)avatarImageView;

@end
