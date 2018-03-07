//
//  ImageTextCell.h
//  easydoctor
//
//  Created by 刘星辰 on 2016/12/15.
//  Copyright © 2016年 easygroup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormDetailsCell.h"


typedef void(^__ShowOrHideBlock)(UIButton *btn);
@protocol ImageTextCellDelegate <NSObject>

// 具体方法
- (void)jumpToPhotoPhotoBrowserPage:(NSInteger)page;

@end

@interface ImageTextCell : FormDetailsCell

@property (strong, nonatomic)  UILabel *detail;
@property (strong, nonatomic)  UIView *imgContainer;
@property (strong, nonatomic)  UIButton *fullText;

@property (nonatomic,copy)__ShowOrHideBlock showOrHide;//全文按钮的block

@property (nonatomic,weak) id<ImageTextCellDelegate> delegate;

/**
 设置文字的 左边 约束

 @param left 默认 8
 */
- (void)setDetailLeft:(CGFloat )left;

/**
 设置文字 的 顶部 约束

 @param top 默认8

 */
- (void)setDetailTop:(CGFloat)top;

///**
// 赋值的方法
//
// @param text 文本描述
// @param imgArr 图片的名字
// */
//- (void)setDetailText:(NSString *)text andImg:(NSArray <CdrOtherdocs*>*)imgArr;

@end
