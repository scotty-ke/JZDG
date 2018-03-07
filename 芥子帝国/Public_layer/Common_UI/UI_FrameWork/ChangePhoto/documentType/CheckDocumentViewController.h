//
//  CheckDocumentViewController.h
//  easydoctor
//
//  Created by stone on 15/12/1.
//  Copyright © 2015年 easygroup. All rights reserved.
//  查看文档

#import "BaseViewController.h"
#import "MJPhoto.h"

@protocol CheckDocumentViewControllerDelegate <NSObject>

- (void)clickDeleteDocument:(NSInteger)index;
- (NSString *)updateTitle:(NSInteger)index;
- (NSInteger)updateSelectType:(NSInteger)index;
- (void)clickDocumentType:(NSInteger)index docType:(id)docType;

@end

@interface CheckDocumentViewController : BaseViewController

// 当前展示的图片索引
@property (nonatomic, assign) NSUInteger currentPhotoIndex;
@property(nonatomic,strong) NSMutableArray *photos;
@property(nonatomic,weak) id<CheckDocumentViewControllerDelegate> checkDocumentDelegate;


@end
