/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>

CGPoint CGRectGetCenter(CGRect rect);
CGRect  CGRectMoveToCenter(CGRect rect, CGPoint center);

@interface UIView (ViewFrameGeometry)
@property CGPoint origin;
@property CGSize size;

@property (readonly) CGPoint bottomLeft;
@property (readonly) CGPoint bottomRight;
@property (readonly) CGPoint topRight;

@property CGFloat height;
@property CGFloat width;

@property CGFloat top;
@property CGFloat left;

@property CGFloat bottom;
@property CGFloat right;

- (void) moveBy: (CGPoint) delta;
- (void) scaleBy: (CGFloat) scaleFactor;
- (void) fitInSize: (CGSize) aSize;

- (void) testFrame;
/**
 * 设置图片圆形
 */
- (void)setImageCircleWithImageWidth:(CGFloat)width;
@end

@interface UITableViewCell(TableViewCellADD)
- (void)addBackGround;
@end

/**
 *  圆角按钮设置
 */
@interface  UIButton(cornerBtn)
- (void)setCornerFrame;
@end
