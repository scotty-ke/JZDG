//
//  Public.h
//  NagriHealth
//
//  Created by 丁东 on 16/8/22.
//  Copyright © 2016年 丁东. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "TypeEnum.h"

@class perfectIDCardViewController;
typedef void(^perfectBlock)();

typedef enum : NSUInteger {
    AvatarThumbnail,//头像
    DataThumbnail,//图片资料
    OrganThumbnail,//机构
    PhotoOriginal,//手机原图
    PhotoHighOriginal,//手机高清原图
} AppPhotoType;


typedef NS_ENUM(NSUInteger, ViewStyle) {
    Line = 0,//线性
    Breach = 1,//缺角
    Semicircle = 2,//弧形
};


@interface Public : NSObject

/**
 *  基本数据类型转化为json
 *
 *  @param theData 基本数据类型
 *
 *  @return jsonz字符串
 */
+ (NSString *)toJSONData:(id)theData;


/**
  json字符串转为字典

 @param jsonString json字符串
 @return 返回结果字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;


/**
 *  MD5加密
 *
 *  @param pwd 被加密的字段
 *
 *  @return 已加密的字段
 */
+ (NSString *)getMd5_32Bit:(NSString *)pwd;

/**
 *  判断string是否为空
 *
 *  @param string 判断字符串
 *
 *  @return 返回结果
 */
+ (BOOL)isNotBlankString:(id)string;


/**
 *  判断字符串
 *
 *  @param string 输入字符串
 *
 *  @return 返回字符串,如果字符串存在则返回该字符串,如果不存在,则返回@""
 */
+ (id)blankString:(id)string;

/**
 *  计算label高度 带行间距
 */
+ (float)countLabelHeight:(NSString *)text width:(CGFloat )width font:(UIFont *)font minHeight:(float)minHeight;


/**
 计算label高度 不带行间距
 */
+ (float)countLabelHeightNoLineSpacing:(NSString *)text width:(CGFloat )width font:(UIFont *)font minHeight:(float)minHeight;

/**
 *  图片链接的封装
 *
 *  @param photoID   图片ID
 *  @param photoType 图片类型 AppPhotoType
 *
 *  @return 图片完整链接
 */
+ (NSString*)getPicUrlString:(NSInteger)photoID photoType:(AppPhotoType)photoType;


/**
 *  自动登录
 */
+ (void)autoLogin;

/**
 *  根据生日计算周岁
 *
 *  @param birth 生日
 *
 *  @return 年龄
 */
+ (NSInteger)getAgeFromBirthDay:(NSString*)birth;

/**  #pragma mark yyyy-MM-dd HH:mm:ss-->  HH:mm  **/
+(NSString*)getHourMinuteStringFromString:(NSString*)dateString;
/**  #pragma mark yyyy-MM-dd HH:mm:ss--> MM-dd HH:mm  **/
+(NSString*)getMonthDayHourMinuteStringFromString:(NSString*)dateString;
/**  #pragma mark yyyy-MM-dd HH:mm:ss--> MM月dd日 HH:mm 9月28号 宋柯修改 预约列表用到  MM月dd日 HH:mm  **/
+(NSString*)getMDHMStringFromString:(NSString*)dateString;

/**  #pragma mark yyyy-MM-dd HH:mm:ss--> 星期一  **/
+(NSString*)getweekStringFromDateString:(NSString*)dateString;

/**  #pragma mark yyyy-MM-dd HH:mm:ss--> 周几  **/
+(NSString*)getweekStringFromDate:(NSString*)date;

/** #pragma mark yyyy-MM-dd HH:mm:ss -- > 10月20日 **/
+ (NSString *)newMouthDayString:(NSString *)string;

/**  #pragma mark 刚刚/几分钟前/几小时前/几天前/  **/
+(NSString*)prettyDateWithReference:(NSString*)dateString;


/**  #pragma mark - 比较时间 返回分钟  **/
+ (NSInteger)compareMinuteWithNSString:(NSString *)compareDate firstDate:(NSString *)firstDate;
/**  #pragma mark  格式化时间 1 yyyy-MM-dd 2 yyyy年MM月dd日  **/
+ (NSString *)formatDate:(NSString *)dateStr mode:(NSInteger)mode;

//获取相差年限
+(NSString *)compareYear:(NSString *)toDateString;


/**
 *  画虚线
 *
 *  @param lineView    需要绘制成虚线的View
 *  @param lineFrame   虚线的所在视图的Frame
 *  @param lineLength  虚线的宽度
 *  @param lineSpacing 虚线的间距
 *  @param lineColor   虚线的颜色
 *  @param isX         X or Y 方面
 */
+ (void)drawDashLine:(UIView *)lineView lineFrame:(CGRect)lineFrame lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor isX:(BOOL)isX;

/**  #pragma mark -  写文字在image上  **/
+ (UIImage *)drawTextOnImage:(UIImage *)image text:(NSString *)text font:(UIFont *)font;

/** #pragma mark - 得到UILabel每一行的字符串 **/
+ (NSArray *)getSeparatedLinesFromLabel:(UILabel *)label;


/**
 获得第一响应者视图

 @return 返回第一相应这视图
 */
+ (UIView *)getFirstResponder;

/**  #pragma mark 颜色生成图片  **/
+ (UIImage*)createImageWithColor:(UIColor*) color;


/**
 给图片添加缺角性别 图片

 @param imgeView 目标图片
 @param sex 性别
 */
+(void)setSexPhotoOn:(UIImageView *)imgeView WithSex:(NSInteger)sex;


/** #pragma mark - 根据分数得到星星的个数 **/
+ (NSInteger)getNumberFormScore:(NSString *)scoreString;


/**
 选择到市的时候补全后面liangw

 @param code 城市的code
 @return 获取的区域code
 */
+(NSString *)getAreaCodeFormCode:(NSString*)code;

/*
    用户没有身份证时显示完善信息弹窗
 */
+(BOOL)showPerfectIdCardFormViewController:(UIViewController *)fromViewController ToViewController:(perfectIDCardViewController *)toViewController;
@end
