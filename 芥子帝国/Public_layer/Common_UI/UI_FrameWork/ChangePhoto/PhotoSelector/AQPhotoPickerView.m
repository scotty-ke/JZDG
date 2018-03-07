//
//  AQPhotoPickerVC.m
//  MeeFree.com
//
//  Created by Abdul_Qavi on 14/09/2014.
//  Copyright (c) 2014 stone. All rights reserved.
//

#import "AQPhotoPickerView.h"
//#import "AppActionSheet.h"
#import "HcdActionSheet.h"

@interface AQPhotoPickerView ()<UIActionSheetDelegate>

@property (nonatomic, weak) BaseViewController <AQPhotoPickerViewDelegate> *delegateViewController;
@property (nonatomic) UIImagePickerController *imagePickerController;

@end

@implementation AQPhotoPickerView

static AQPhotoPickerView *photoPickerView;

+(void)presentInViewController:(BaseViewController<AQPhotoPickerViewDelegate>*) viewController photoEnum:(AQPhotoEnum)photoEnum isEdit:(BOOL)isEdit 
{
    if(photoPickerView == nil){
        photoPickerView = [AQPhotoPickerView new];
    }
    photoPickerView.photoEnum = photoEnum;
    photoPickerView.allowsEdit = isEdit;
    photoPickerView.delegateViewController = viewController;

    __weak AQPhotoPickerView *wphotoPickerView = photoPickerView;
    __weak AQPhotoPickerView *wself = photoPickerView;
    
    HcdActionSheet *sheet = [[HcdActionSheet alloc] initWithCancelStr:@"取消" otherButtonTitles:@[@"拍照", @"从相册中选择"] attachTitle:nil];
    [sheet changeTitleColor:TOPCAIL_COLOR andIndex:900];
    [[UIApplication sharedApplication].keyWindow addSubview:sheet];
    [sheet showHcdActionSheet];
    sheet.selectButtonAtIndex = ^(NSInteger index){
        if (index == 0) {
            [wphotoPickerView.delegateViewController showAuthType:PhoneAuthCamera successBlock:^{
                [wself takePhoto:nil];
            } failureBlock:^{
                
            }];
        }else if (index == 1){
            [wphotoPickerView.delegateViewController showAuthType:PhoneAuthPhoto successBlock:^{
                [wself selectPhoto:nil];
            } failureBlock:^{
                
            }];
        }else if (index == 2){
            if (photoPickerView.checkPhotoBlock) {
                photoPickerView.checkPhotoBlock();
            }
        }else if (index == 3){
            if (photoPickerView.deletePhotoBlock) {
                photoPickerView.deletePhotoBlock();
            }
        }
    };
    
#if 0
    AppActionSheet *actionSheet = [[AppActionSheet alloc]initWithParentController:viewController];
    [actionSheet showActionSheetWithTitle:nil
                                 messeage:nil
                              buttonItems:@[@"拍照", @"从相册中选择"]
                        actionSelectBlock:^(NSInteger selectIndex) {
                            if (selectIndex == 0) {
                                [wphotoPickerView.delegateViewController showAuthType:PhoneAuthCamera successBlock:^{
                                    [wself takePhoto:nil];
                                } failureBlock:^{
                                    
                                }];
                            }else if (selectIndex == 1){
                                [wphotoPickerView.delegateViewController showAuthType:PhoneAuthPhoto successBlock:^{
                                    [wself selectPhoto:nil];
                                } failureBlock:^{
                                    
                                }];
                            }else if (selectIndex == 2){
                                if (photoPickerView.checkPhotoBlock) {
                                    photoPickerView.checkPhotoBlock();
                                }
                            }else if (selectIndex == 3){
                                if (photoPickerView.deletePhotoBlock) {
                                    photoPickerView.deletePhotoBlock();
                                }
                            }

                        }];
#endif
}


+(void)presentInViewControllerMoreFunction:(BaseViewController<AQPhotoPickerViewDelegate> *)viewController photoEnum:(AQPhotoEnum)photoEnum isEdit:(BOOL)isEdit checkPhoto:(void (^)())checkPhoto deletePhoto:(void (^)())deletePhoto
{
    if(photoPickerView == nil){
        photoPickerView = [AQPhotoPickerView new];
    }
    photoPickerView.checkPhotoBlock = checkPhoto;
    photoPickerView.deletePhotoBlock = deletePhoto;
    photoPickerView.photoEnum = photoEnum;
    photoPickerView.allowsEdit = isEdit;
    photoPickerView.delegateViewController = viewController;
    
    /*
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:photoPickerView
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"拍照", @"从相册中选择",@"看大图",@"删除",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:viewController.view];
     */
    __weak AQPhotoPickerView *wphotoPickerView = photoPickerView;
    __weak AQPhotoPickerView *wself = photoPickerView;
    
    HcdActionSheet *sheet = [[HcdActionSheet alloc] initWithCancelStr:nil otherButtonTitles:@[@"拍照", @"从相册中选择",@"看大图",@"删除"] attachTitle:nil];
    [sheet changeTitleColor:TOPCAIL_COLOR andIndex:900];
    [[UIApplication sharedApplication].keyWindow addSubview:sheet];
    [sheet showHcdActionSheet];
    sheet.selectButtonAtIndex = ^(NSInteger index){
        if (index == 0) {
            [wphotoPickerView.delegateViewController showAuthType:PhoneAuthCamera successBlock:^{
                [wself takePhoto:nil];
            } failureBlock:^{
                
            }];
        }else if (index == 1){
            [wphotoPickerView.delegateViewController showAuthType:PhoneAuthPhoto successBlock:^{
                [wself selectPhoto:nil];
            } failureBlock:^{
                
            }];
        }else if (index == 2){
            if (photoPickerView.checkPhotoBlock) {
                photoPickerView.checkPhotoBlock();
            }
        }else if (index == 3){
            if (photoPickerView.deletePhotoBlock) {
                photoPickerView.deletePhotoBlock();
            }
        }

    };
    
#if 0
    AppActionSheet *actionSheet = [[AppActionSheet alloc]initWithParentController:viewController];
    [actionSheet showActionSheetWithTitle:nil
                                 messeage:nil
                              buttonItems:@[@"拍照", @"从相册中选择",@"看大图",@"删除"]
                        actionSelectBlock:^(NSInteger selectIndex) {
                            if (selectIndex == 0) {
                                [wphotoPickerView.delegateViewController showAuthType:PhoneAuthCamera successBlock:^{
                                    [wself takePhoto:nil];
                                } failureBlock:^{
                                    
                                }];
                            }else if (selectIndex == 1){
                                [wphotoPickerView.delegateViewController showAuthType:PhoneAuthPhoto successBlock:^{
                                    [wself selectPhoto:nil];
                                } failureBlock:^{
                                    
                                }];
                            }else if (selectIndex == 2){
                                if (photoPickerView.checkPhotoBlock) {
                                    photoPickerView.checkPhotoBlock();
                                }
                            }else if (selectIndex == 3){
                                if (photoPickerView.deletePhotoBlock) {
                                    photoPickerView.deletePhotoBlock();
                                }
                            }
                            
                        }];
#endif

}

+(void)presentInViewController:(BaseViewController<AQPhotoPickerViewDelegate>*) viewController photoEnum:(AQPhotoEnum)photoEnum isEdit:(BOOL)isEdit tag:(NSInteger)tag {
    if (photoPickerView == nil) {
        photoPickerView = [AQPhotoPickerView new];
    }
    photoPickerView.photoEnum = photoEnum;
    photoPickerView.allowsEdit = isEdit;
    photoPickerView.delegateViewController = viewController;
    if (tag == 1) {
        if (photoPickerView.chosenImage == nil) {
            __weak AQPhotoPickerView *wphotoPickerView = photoPickerView;
            __weak AQPhotoPickerView *wself = photoPickerView;
            
            
            HcdActionSheet *sheet = [[HcdActionSheet alloc] initWithCancelStr:nil otherButtonTitles:@[@"拍照", @"从相册中选择"] attachTitle:nil];
            [sheet changeTitleColor:TOPCAIL_COLOR andIndex:900];
            [[UIApplication sharedApplication].keyWindow addSubview:sheet];
            [sheet showHcdActionSheet];
            sheet.selectButtonAtIndex = ^(NSInteger index){
                if (index == 0) {
                    [wphotoPickerView.delegateViewController showAuthType:PhoneAuthCamera successBlock:^{
                        [wself takePhoto:nil];
                    } failureBlock:^{
                        
                    }];
                }else if (index == 1){
                    [wphotoPickerView.delegateViewController showAuthType:PhoneAuthPhoto successBlock:^{
                        [wself selectPhoto:nil];
                    } failureBlock:^{
                        
                    }];
                }else if (index == 2){
                    if (photoPickerView.checkPhotoBlock) {
                        photoPickerView.checkPhotoBlock();
                    }
                }else if (index == 3){
                    if (photoPickerView.deletePhotoBlock) {
                        photoPickerView.deletePhotoBlock();
                    }
                }

            };
#if 0
            AppActionSheet *actionSheet = [[AppActionSheet alloc]initWithParentController:viewController];
            [actionSheet showActionSheetWithTitle:nil
                                         messeage:nil
                                      buttonItems:@[@"拍照", @"从相册中选择"]
                                actionSelectBlock:^(NSInteger selectIndex) {
                                    if (selectIndex == 0) {
                                        [wphotoPickerView.delegateViewController showAuthType:PhoneAuthCamera successBlock:^{
                                            [wself takePhoto:nil];
                                        } failureBlock:^{
                                            
                                        }];
                                    }else if (selectIndex == 1){
                                        [wphotoPickerView.delegateViewController showAuthType:PhoneAuthPhoto successBlock:^{
                                            [wself selectPhoto:nil];
                                        } failureBlock:^{
                                            
                                        }];
                                    }else if (selectIndex == 2){
                                        if (photoPickerView.checkPhotoBlock) {
                                            photoPickerView.checkPhotoBlock();
                                        }
                                    }else if (selectIndex == 3){
                                        if (photoPickerView.deletePhotoBlock) {
                                            photoPickerView.deletePhotoBlock();
                                        }
                                    }
                                    
                                }];
#endif
        } else {
            ImageZoomViewController *zoomView = [[ImageZoomViewController alloc] init];
            zoomView.deletePhotoDelegate = photoPickerView;
            UINavigationController *zoomNavigation = [[UINavigationController alloc] initWithRootViewController:zoomView];
            [zoomView zoomImage:photoPickerView.choseImageView];
            [photoPickerView.delegateViewController presentViewController:zoomNavigation animated:YES completion:nil];
        }
    }
    if (tag == 2) {
        if (photoPickerView.chosenImage == nil) {
            __weak AQPhotoPickerView *wphotoPickerView = photoPickerView;
            __weak AQPhotoPickerView *wself = photoPickerView;
            
            
            HcdActionSheet *sheet = [[HcdActionSheet alloc] initWithCancelStr:nil otherButtonTitles:@[@"拍照", @"从相册中选择"] attachTitle:nil];
            [sheet changeTitleColor:TOPCAIL_COLOR andIndex:900];
            [[UIApplication sharedApplication].keyWindow addSubview:sheet];
            [sheet showHcdActionSheet];
            sheet.selectButtonAtIndex = ^(NSInteger index){
                if (index == 0) {
                    [wphotoPickerView.delegateViewController showAuthType:PhoneAuthCamera successBlock:^{
                        [wself takePhoto:nil];
                    } failureBlock:^{
                        
                    }];
                }else if (index == 1){
                    [wphotoPickerView.delegateViewController showAuthType:PhoneAuthPhoto successBlock:^{
                        [wself selectPhoto:nil];
                    } failureBlock:^{
                        
                    }];
                }else if (index == 2){
                    if (photoPickerView.checkPhotoBlock) {
                        photoPickerView.checkPhotoBlock();
                    }
                }else if (index == 3){
                    if (photoPickerView.deletePhotoBlock) {
                        photoPickerView.deletePhotoBlock();
                    }
                }

            };
#if 0
            AppActionSheet *actionSheet = [[AppActionSheet alloc]initWithParentController:viewController];
            [actionSheet showActionSheetWithTitle:nil
                                         messeage:nil
                                      buttonItems:@[@"拍照", @"从相册中选择"]
                                actionSelectBlock:^(NSInteger selectIndex) {
                                    if (selectIndex == 0) {
                                        [wphotoPickerView.delegateViewController showAuthType:PhoneAuthCamera successBlock:^{
                                            [wself takePhoto:nil];
                                        } failureBlock:^{
                                            
                                        }];
                                    }else if (selectIndex == 1){
                                        [wphotoPickerView.delegateViewController showAuthType:PhoneAuthPhoto successBlock:^{
                                            [wself selectPhoto:nil];
                                        } failureBlock:^{
                                            
                                        }];
                                    }else if (selectIndex == 2){
                                        if (photoPickerView.checkPhotoBlock) {
                                            photoPickerView.checkPhotoBlock();
                                        }
                                    }else if (selectIndex == 3){
                                        if (photoPickerView.deletePhotoBlock) {
                                            photoPickerView.deletePhotoBlock();
                                        }
                                    }
                                    
                                }];
#endif
        } else {
            ImageZoomViewController *zoomView = [[ImageZoomViewController alloc] init];
            zoomView.deletePhotoDelegate = photoPickerView;
            UINavigationController *zoomNavigation = [[UINavigationController alloc] initWithRootViewController:zoomView];
            [zoomView zoomImage:photoPickerView.choseImageView];
            [photoPickerView.delegateViewController presentViewController:zoomNavigation animated:YES completion:nil];
        }
    }
    if (tag == 3) {
        if (photoPickerView.chosenImage == nil) {
            /*
            UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                          initWithTitle:nil
                                          delegate:photoPickerView
                                          cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:nil
                                          otherButtonTitles:@"拍照", @"从相册中选择",nil];
            actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
            [actionSheet showInView:viewController.view];
             */
            __weak AQPhotoPickerView *wphotoPickerView = photoPickerView;
            __weak AQPhotoPickerView *wself = photoPickerView;
            
            HcdActionSheet *sheet = [[HcdActionSheet alloc] initWithCancelStr:nil otherButtonTitles:@[@"拍照", @"从相册中选择"] attachTitle:nil];
            [sheet changeTitleColor:TOPCAIL_COLOR andIndex:900];
            [[UIApplication sharedApplication].keyWindow addSubview:sheet];
            [sheet showHcdActionSheet];
            sheet.selectButtonAtIndex = ^(NSInteger index){
                if (index == 0) {
                    [wphotoPickerView.delegateViewController showAuthType:PhoneAuthCamera successBlock:^{
                        [wself takePhoto:nil];
                    } failureBlock:^{
                        
                    }];
                }else if (index == 1){
                    [wphotoPickerView.delegateViewController showAuthType:PhoneAuthPhoto successBlock:^{
                        [wself selectPhoto:nil];
                    } failureBlock:^{
                        
                    }];
                }else if (index == 2){
                    if (photoPickerView.checkPhotoBlock) {
                        photoPickerView.checkPhotoBlock();
                    }
                }else if (index == 3){
                    if (photoPickerView.deletePhotoBlock) {
                        photoPickerView.deletePhotoBlock();
                    }
                }

            };
#if 0
            AppActionSheet *actionSheet = [[AppActionSheet alloc]initWithParentController:viewController];
            [actionSheet showActionSheetWithTitle:nil
                                         messeage:nil
                                      buttonItems:@[@"拍照", @"从相册中选择"]
                                actionSelectBlock:^(NSInteger selectIndex) {
                                    if (selectIndex == 0) {
                                        [wphotoPickerView.delegateViewController showAuthType:PhoneAuthCamera successBlock:^{
                                            [wself takePhoto:nil];
                                        } failureBlock:^{
                                            
                                        }];
                                    }else if (selectIndex == 1){
                                        [wphotoPickerView.delegateViewController showAuthType:PhoneAuthPhoto successBlock:^{
                                            [wself selectPhoto:nil];
                                        } failureBlock:^{
                                            
                                        }];
                                    }else if (selectIndex == 2){
                                        if (photoPickerView.checkPhotoBlock) {
                                            photoPickerView.checkPhotoBlock();
                                        }
                                    }else if (selectIndex == 3){
                                        if (photoPickerView.deletePhotoBlock) {
                                            photoPickerView.deletePhotoBlock();
                                        }
                                    }
                                    
                                }];
#endif
        }
        else
        {
            ImageZoomViewController *zoomView = [[ImageZoomViewController alloc] init];
            zoomView.deletePhotoDelegate = photoPickerView;
            UINavigationController *zoomNavigation = [[UINavigationController alloc] initWithRootViewController:zoomView];
            [zoomView zoomImage:photoPickerView.choseImageView];
            [photoPickerView.delegateViewController presentViewController:zoomNavigation animated:YES completion:nil];
        }
    }
}


#pragma mark -
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [photoPickerView.delegateViewController showAuthType:PhoneAuthCamera successBlock:^{
            [self takePhoto:nil];
        } failureBlock:^{
            
        }];
    }else if (buttonIndex == 1){
        [photoPickerView.delegateViewController showAuthType:PhoneAuthPhoto successBlock:^{
            [self selectPhoto:nil];
        } failureBlock:^{
            
        }];
    }else if (buttonIndex == 2){
        if (photoPickerView.checkPhotoBlock) {
            photoPickerView.checkPhotoBlock();
        }
    }else if (buttonIndex == 3){
        if (photoPickerView.deletePhotoBlock) {
            photoPickerView.deletePhotoBlock();
        }
    }
}

#pragma mark - Image capture and picker methods

- (IBAction)selectPhoto:(id)sender {
    switch (photoPickerView.photoEnum) {
        //单图
        case SimplePhoto:
        {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                picker.allowsEditing = _allowsEdit;
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
                [self.delegateViewController presentViewController:picker animated:YES completion:nil];
        }
            break;
        case MultiplePhoto:
        {
            ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
            if ([self.delegateViewController respondsToSelector:@selector(photosCount)]) {
                picker.maximumNumberOfSelection = [self.delegateViewController photosCount];
            }else{
                picker.maximumNumberOfSelection = 0;
            }
            picker.assetsFilter = [ALAssetsFilter allAssets];
            picker.showEmptyGroups=NO;
            picker.delegate=self;
            picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
                    NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
                    return duration >= 5;
                } else {
                    return YES;
                }
            }];
            
            //    [self presentViewController:picker animated:YES completion:NULL];
            [self.delegateViewController presentViewController:picker animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}

- (IBAction)takePhoto:(id)sender {

    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"Test on real device, camera is not available in simulator" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }

    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = _allowsEdit;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    
    [self.delegateViewController presentViewController:picker animated:YES completion:nil];
    [self.imagePickerController takePicture];
}


#pragma mark -
#pragma mark ZYQAssetPickerControllerDelegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    if ([self.delegateViewController respondsToSelector:@selector(assetPickerController:didFinishPickingAssets:)]) {
        [self.delegateViewController assetPickerController:picker didFinishPickingAssets:assets];
    }
}


#pragma mark - UIImagePickerControllerDelegate

// This method is called when an image has been chosen from the library or taken from the camera.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    if (_allowsEdit) {
        _chosenImage = [info objectForKey:UIImagePickerControllerEditedImage];
    }else{
        _chosenImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    photoPickerView.choseImageView = [[UIImageView alloc] initWithImage:_chosenImage];
    if ([self.delegateViewController respondsToSelector:@selector(photoFromImagePickerView:)]) {
            [self.delegateViewController photoFromImagePickerView:_chosenImage];
    }
    //[picker dismissViewControllerAnimated:YES completion:NULL];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self removeFromSuperview];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [self removeFromSuperview];
}

#pragma mark - Utility methods 

- (IBAction)backgroundViewTapped:(id)sender {
    
    [self removeFromSuperview];
}

#pragma mark 删除照片 
- (void)deletePhoto {
    _chosenImage = [UIImage imageNamed:@"zhaopian"];
    if ([self.delegateViewController respondsToSelector:@selector(photoFromImagePickerView:)]) {
        [self.delegateViewController photoFromImagePickerView:_chosenImage];
    }
    [photoPickerView.delegateViewController dismissViewControllerAnimated:YES completion:nil];
    _chosenImage = nil;
}


@end
