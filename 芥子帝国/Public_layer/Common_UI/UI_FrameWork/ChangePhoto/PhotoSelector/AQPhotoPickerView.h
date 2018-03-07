//
//  AQPhotoPickerVC.h
//  MeeFree.com
//
//  Created by stone on 14/09/2014.
//  Copyright (c) 2014 MeeFree.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYQAssetPickerController.h"
#import "BaseViewController.h"
#import "ImageZoomViewController.h"

typedef enum : NSUInteger {
    SimplePhoto,//单图
    MultiplePhoto,//多图
} AQPhotoEnum;

typedef void(^CheckPhotoBlock)();
typedef void(^DeletePhotoBlock)();

@class AQPhotoPickerView;
@protocol AQPhotoPickerViewDelegate
@optional
#pragma mark 单图回调
- (void)photoFromImagePickerView:(UIImage*)photo;
#pragma mark 多图回调
- (void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets;
- (NSInteger)photosCount;
@end

@interface AQPhotoPickerView : UIView <UIImagePickerControllerDelegate, UINavigationControllerDelegate,AQPhotoPickerViewDelegate,ImageZoomViewControllerDelegate>

@property (nonatomic, assign)  AQPhotoEnum photoEnum;
@property (nonatomic,assign) BOOL allowsEdit;
@property (nonatomic,strong) UIImageView *choseImageView;
@property (nonatomic,strong) UIImage *chosenImage;
@property(nonatomic,copy) CheckPhotoBlock checkPhotoBlock;
@property(nonatomic,copy) DeletePhotoBlock deletePhotoBlock;


+(void)presentInViewController:(BaseViewController<AQPhotoPickerViewDelegate>*) viewController photoEnum:(AQPhotoEnum)photoEnum isEdit:(BOOL)isEdit;

+(void)presentInViewControllerMoreFunction:(BaseViewController<AQPhotoPickerViewDelegate>*) viewController photoEnum:(AQPhotoEnum)photoEnum isEdit:(BOOL)isEdit checkPhoto:(void (^)())checkPhoto deletePhoto:(void(^)())deletePhoto;

+(void)presentInViewController:(BaseViewController<AQPhotoPickerViewDelegate>*) viewController photoEnum:(AQPhotoEnum)photoEnum isEdit:(BOOL)isEdit tag:(NSInteger)tag;

- (IBAction)takePhoto:(id)sender;
- (IBAction)selectPhoto:(id)sender;

@end

