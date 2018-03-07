//
//  VIPhotoViewController.h
//  easydoctor
//
//  Created by 姚驰 on 16/8/28.
//  Copyright © 2016年 easygroup. All rights reserved.
//

#import "BaseViewController.h"

@interface VIPhotoViewController : BaseViewController

//- (instancetype)initWithImageUrl:(NSString *)urlString;
//- (instancetype)initWithImage:(UIImage *)image;

- (instancetype)initWithImageUrlArr:(NSArray<NSString *> *)urlStringArr;
- (instancetype)initWithImageArr:(NSArray<UIImage *> *)imgArr;
- (instancetype)initWithImageAndName:(NSArray<NSDictionary *> *)imgAndStr;

@property (nonatomic,assign)NSInteger page;//点击第几页就从第几页过来

@end
