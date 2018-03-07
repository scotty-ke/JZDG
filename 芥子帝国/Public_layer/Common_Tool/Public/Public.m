
//
//  Public.m
//  NagriHealth
//
//  Created by 丁东 on 16/8/22.
//  Copyright © 2016年 丁东. All rights reserved.
//

#import "Public.h"
#import <CommonCrypto/CommonDigest.h>
#import <CoreText/CoreText.h>

#import "UIResponder+firstResponder.h"
@implementation Public

#pragma mark 基本数据类型转化为json
+ (NSString *)toJSONData:(id)theData
{
    if (theData == nil)
    {
        return nil;
    }
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if ([jsonData length] > 0 && error == nil )
    {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                     encoding:NSUTF8StringEncoding];;
        return jsonString;
    }
    else
    {
        return nil;
    }
}

#pragma  mark json转字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


#pragma mark 根据性别得到默认头像
+(NSString*)getPatinetPlaceHolderImageWithSex:(NSInteger)sex
{
    return sex==1?@"patient_boy":@"patient_girl";
}

#pragma mark    MD5 加密
+ (NSString *)getMd5_32Bit:(NSString *)pwd
{
    const char *cStr = [pwd UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, pwd.length, digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    return result;
}

#pragma mark 判断string是否为空

+ (BOOL)isNotBlankString:(id)string
{
    
    if (string == nil || string == NULL) {
        return NO;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return NO;
    }
    if ([string isKindOfClass:[NSString class]]) {
        if ([string isEqualToString:@"<null>"]) {
            return NO;
        }
        if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
            return NO;
        }
    }
    return YES;
}



#pragma mark  计算Label高度
+ (float)countLabelHeight:(NSString *)text width:(CGFloat )width font:(UIFont *)font minHeight:(float)minHeight
{
    CGSize textBlockMinSize = {width, CGFLOAT_MAX};
    
    float height;
    CGSize size;
    if (IOS(7)) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:2];//调整行间距
        CGSize size = [text boundingRectWithSize:textBlockMinSize options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{
                                                   NSFontAttributeName:font,
                                                   NSParagraphStyleAttributeName:paragraphStyle
                                                   }
                                         context:nil].size;
        height = size.height;
    }else{
        size = [text sizeWithFont:font
                constrainedToSize:textBlockMinSize
                    lineBreakMode:NSLineBreakByCharWrapping];
        
        height = size.height;
    }
    if (height < minHeight) {
        height = minHeight;
    }
    return height;
}

#pragma mark  计算Label高度 不带行间距
+ (float)countLabelHeightNoLineSpacing:(NSString *)text width:(CGFloat )width font:(UIFont *)font minHeight:(float)minHeight{
    CGSize textBlockMinSize = {width, CGFLOAT_MAX};
    NSDictionary *fontDict = @{NSFontAttributeName:font};
    CGRect computeFrame = [text boundingRectWithSize:textBlockMinSize options:NSStringDrawingUsesLineFragmentOrigin attributes:fontDict context:nil];
    CGFloat height = computeFrame.size.height;
    if (height < minHeight) {
        height = minHeight;
    }
    
    return height;
}

#pragma mark 根据生日算年龄
+ (NSInteger)getAgeFromBirthDay:(NSString*)birth
{
    //1992-07-02
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSDate *myDate= [dateFormatter dateFromString:birth];
    if (!myDate)
    {
        [dateFormatter setDateFormat: @"yyyy-MM-dd mm:mm:mm"];
        myDate= [dateFormatter dateFromString:birth];
        if (!myDate)
        {
            return 0;
        }
    }
    // 出生日期转换 年月日
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:myDate];
    NSInteger brithDateYear  = [components1 year];
    NSInteger brithDateMonth = [components1 month];
    NSInteger brithDateDay   = [components1 day];
    
    
    // 获取系统当前 年月日
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    NSInteger currentDateYear  = [components2 year];
    NSInteger currentDateMonth = [components2 month];
    NSInteger currentDateDay   = [components2 day];
    
    // 计算年龄
    //申洋 3.2 第二轮bug修复 将currentDateDay <= brithDateDay  改成 currentDateDay < brithDateDay
    NSInteger iAge = currentDateYear - brithDateYear;
    if ((currentDateMonth < brithDateMonth) || (currentDateMonth == brithDateMonth && currentDateDay < brithDateDay)) {
        //周岁是公历生日的第二天起算
        iAge--;
    }
    return iAge;
}

#pragma mark yyyy-MM-dd HH:mm:ss-->  HH:mm
+(NSString*)getHourMinuteStringFromString:(NSString*)dateString{
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    if (dateString.length == 19) {
        [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }else{
        [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    }
    NSDate *date = [dateformatter dateFromString:dateString];
    [dateformatter setDateFormat:@"HH:mm"];
    NSString *newDateStr = [dateformatter stringFromDate:date];
    return newDateStr == nil ? dateString : newDateStr;
}

#pragma mark yyyy-MM-dd HH:mm:ss--> MM-dd HH:mm
+(NSString*)getMonthDayHourMinuteStringFromString:(NSString*)dateString
{
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    if (dateString.length == 19) {
        [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }else{
        [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    }
    NSDate *date = [dateformatter dateFromString:dateString];
    [dateformatter setDateFormat:@"MM-dd HH:mm"];
    NSString *newDateStr = [dateformatter stringFromDate:date];
    return newDateStr == nil ? dateString : newDateStr;
}

#pragma mark yyyy-MM-dd HH:mm:ss--> MM月dd日 HH:mm 9月28号 宋柯修改 预约列表用到  MM月dd日 HH:mm
+(NSString*)getMDHMStringFromString:(NSString*)dateString
{
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    if (dateString.length == 19) {
        [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }else{
        [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    }
    NSDate *date = [dateformatter dateFromString:dateString];
    [dateformatter setDateFormat:@"MM月dd日 HH:mm"];
    NSString *newDateStr = [dateformatter stringFromDate:date];
    return newDateStr == nil ? dateString : newDateStr;
}



#pragma mark yyyy-MM-dd HH:mm:ss--> 星期一
+(NSString*)getweekStringFromDateString:(NSString*)dateString
{
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateformatter dateFromString:dateString];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];//设置成中国阳历
//    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;//设置时区
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    NSInteger weekNumber = [comps weekday]; //获取星期对应的长整形字符串
    
    NSString *weekDay;
    switch (weekNumber) {
        case 1:
            weekDay=@"星期日";
            break;
        case 2:
            weekDay=@"星期一";
            break;
        case 3:
            weekDay=@"星期二";
            break;
        case 4:
            weekDay=@"星期三";
            break;
        case 5:
            weekDay=@"星期四";
            break;
        case 6:
            weekDay=@"星期五";
            break;
        case 7:
            weekDay=@"星期六";
            break;
            
        default:
            break;
    }
    return weekDay;
}
+ (NSString *)getweekStringFromDate:(NSString *)dateString
{
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateformatter dateFromString:dateString];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];//设置成中国阳历
//    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;//设置时区
   NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    NSInteger weekNumber = [comps weekday]; //获取星期对应的长整形字符串
    
    NSString *weekDay;
    switch (weekNumber) {
        case 1:
            weekDay=@"周日";
            break;
        case 2:
            weekDay=@"周一";
            break;
        case 3:
            weekDay=@"周二";
            break;
        case 4:
            weekDay=@"周三";
            break;
        case 5:
            weekDay=@"周四";
            break;
        case 6:
            weekDay=@"周五";
            break;
        case 7:
            weekDay=@"周六";
            break;
            
        default:
            break;
    }
    return weekDay;
}

#pragma mark yyyy-MM-dd HH:mm:ss -- > 10月20日
+ (NSString *)newMouthDayString:(NSString *)string
{
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateformatter dateFromString:string];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];//设置成中国阳历
//    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;//设置时区
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    NSInteger day=[comps day];//获取日期对应的长整形字符串
    NSInteger month=[comps month];//获取月对应的长整形字符串
    
    return [NSString stringWithFormat:@"%lu月%lu日",month,day];
    
}

#pragma mark 刚刚/几分钟前/几小时前/几天前/
+(NSString*)prettyDateWithReference:(NSString*)dateString
{
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date = [dateformatter dateFromString:dateString];
    if (!date)
    {
        [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        date = [dateformatter dateFromString:dateString];
    }
    
    if (date)
    {
        NSTimeInterval secondsPerDay = 24 * 60 * 60;
        
        //修正8小时之差
        NSDate *date1 = [NSDate date];
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        NSInteger interval = [zone secondsFromGMTForDate: date1];
        NSDate *localeDate = [date1  dateByAddingTimeInterval: interval];
        
        //NSLog(@"nowdate=%@\nolddate = %@",localeDate,date);
        NSDate *today = localeDate;
        NSDate *yesterday,*beforeOfYesterday;
        //今年
        yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
        
        // 10 first characters of description is the calendar date:
        NSString *todayString = [[today description] substringToIndex:10];
        NSString *yesterdayString = [[yesterday description] substringToIndex:10];
        
        NSString *dateDayString = [[date description] substringToIndex:10];
        
        NSString *dateContent;
        //今 昨 前天的时间
        NSString *time = [[date description] substringWithRange:(NSRange){11,5}];
        //其他时间
        NSString *time2 = [[date description] substringWithRange:(NSRange){5,11}];
        if ([dateDayString isEqualToString:todayString])
        {
            NSTimeInterval time = [today timeIntervalSinceDate:date];
            //******* 刚申请的时间应为1分钟前 *******
            if (time < 60) {
                dateContent = @"1分钟内";
            }
            else if(time >= 60 && time < 3600)
            {
                dateContent = [NSString stringWithFormat:@"%.f分钟前",time/60];
            }
            else if (time >= 3600)
            {
                dateContent = [NSString stringWithFormat:@"%.f小时前",time/3600];
            }
            //            dateContent = [NSString stringWithFormat:@"今天 %@",time];
            return dateContent;
        }
        else if ([dateDayString isEqualToString:yesterdayString]){
            dateContent = [NSString stringWithFormat:@"昨天 %@",time];
            return dateContent;
        }
        else{
            return time2;
        }
        
    }
    else
        return dateString;
}
 #pragma mark - 比较时间 返回分钟
+ (NSInteger)compareMinuteWithNSString:(NSString *)compareDate firstDate:(NSString *)firstDate{
    if ([Public isNotBlankString:compareDate]) {
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"HH:mm:ss"];
        NSDate *fromDate = [dateformatter dateFromString:compareDate];
        NSDate *now = nil;
        if ([Public isNotBlankString:firstDate]) {
            now = [dateformatter dateFromString:firstDate];
        }else{
            now = [NSDate date];
        }
//        NSCalendar* calendar = [NSCalendar currentCalendar];
        
        unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
//        NSDateComponents* comp1 = [calendar components:unitFlags fromDate:fromDate];
//        NSDateComponents* comp2 = [calendar components:unitFlags fromDate:now];
//        
//        if ([comp1 day]   == [comp2 day] && [comp1 month] == [comp2 month] && [comp1 year]  == [comp2 year]) {
//            return 1;
//        }else{
            if ([now timeIntervalSince1970] > [fromDate timeIntervalSince1970]) {
                return 0;
            }
//        };
        //3.4 7月21号 申洋更改
        //NSTimeInterval time = [now timeIntervalSinceDate:fromDate];
        NSTimeInterval time = [fromDate timeIntervalSinceDate:now];
        int minute = time / 60;
        return minute == 0 ? 0 : minute;
    }
    else
    {
        return 0;
    }
}
#pragma mark  格式化时间 1 yyyy-MM-dd 2 yyyy年MM月dd日
+ (NSString *)formatDate:(NSString *)dateStr mode:(NSInteger)mode
{
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateformatter dateFromString:dateStr];
    
    switch (mode) {
        case 1:
            [dateformatter setDateFormat:@"yyyy-MM-dd"];
            break;
        case 2:
            [dateformatter setDateFormat:@"yyyy年MM月dd日"];
            break;
        case 3:
            [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            break;
        default:
            break;
    }
    return [dateformatter stringFromDate:date];
}

#pragma mark 判断字符串
+ (id)blankString:(id)string
{
    if (string == nil || string == NULL) {
        return @"";
    }
    if ([string isKindOfClass:[NSNull class]]) {
        
        return @"";
    }
    
    if ([string isKindOfClass:[NSString class]]) {
        if ([string isEqualToString:@"<null>"]) {
            return @"";
        }
        if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
            return @"";
        }
    }
    return string;
}

#pragma mark  获取相差年份
+ (NSString *)compareYear:(NSString *)toDateString
{
    if (![Public isNotBlankString:toDateString]) {
        return @"";
    }
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    int year = (int)[dateComponent year];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *toDate = [dateformatter dateFromString:toDateString];
    
    NSDateComponents *toDateComponent = [calendar components:unitFlags fromDate:toDate];
    int toYear = (int)[toDateComponent year];
    
    int tempYer = year - toYear;
    
    return [NSString stringWithFormat:@"%d年",tempYer < 0 ? 0 : tempYer];
}


//画虚线
+ (void)drawDashLine:(UIView *)lineView lineFrame:(CGRect)lineFrame lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor isX:(BOOL)isX{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    if (isX) {
        [shapeLayer setLineWidth:CGRectGetHeight(lineFrame)];
    }else{
        [shapeLayer setLineWidth:CGRectGetWidth(lineFrame)];
    }
    
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    if (isX) {
        CGPathMoveToPoint(path, NULL, lineFrame.origin.x, lineFrame.origin.y );
        CGPathAddLineToPoint(path, NULL, lineFrame.origin.x + CGRectGetWidth(lineFrame), lineFrame.origin.y);
    }else{
        CGPathMoveToPoint(path, NULL, lineFrame.origin.x, lineFrame.origin.y );
        CGPathAddLineToPoint(path, NULL, lineFrame.origin.x, lineFrame.origin.y + CGRectGetHeight(lineFrame));
    }
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}

#pragma mark -  获取性别图片 role 1=医生 2=患者
+(UIImage *)getGenderImage:(NSInteger)gender role:(NSInteger)role text:(NSString *)text
{
    //    NSString *boy = (role == 1 ? @"doctor_boy" : @"patient_boy");
    //    NSString *girl = (role == 1 ? @"doctor_girl" : @"patient_girl");
    //    return gender == 2 ? [UIImage imageNamed:girl] : [UIImage imageNamed:boy];
    UIImage *placeHolderImage;
    if (role == 1) {
        placeHolderImage = (gender == 2 ? [UIImage imageNamed:@"doctor_girl"] : [UIImage imageNamed:@"doctor_boy"]);
    }else{
        if ([Public isNotBlankString:text]) {
            placeHolderImage = [Public drawTextOnImage:[UIImage imageNamed:@"huanzhe"] text:[text substringToIndex:1] font:TEXT_FONT_21];
        }else{
            placeHolderImage = [UIImage imageNamed:@"huanzhe"];
        }
    }
    return placeHolderImage;
}


+ (UIImage *)drawTextOnImage:(UIImage *)image text:(NSString *)text font:(UIFont *)font
{
    if (![Public isNotBlankString:text]) {
        return image;
    }
    CGSize sizeImg = image.size;
    
    CGSize sizeTextCanDraw = [text sizeWithAttributes:@{NSFontAttributeName : font}];
    int maxWidth = sizeImg.width;
    int maxHeight = sizeImg.height;
    
    CGFloat scale = [[UIScreen mainScreen] scale];
    UIGraphicsBeginImageContext(CGSizeMake(maxWidth*scale, maxHeight*scale));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(UIGraphicsGetCurrentContext(), scale, scale);
    
    CGRect rcImage = CGRectMake(0, 0, sizeImg.width, sizeImg.height);
    [image drawInRect:rcImage];
    // 绘制文字
    CGContextSetFillColorWithColor(context, TOPCAIL_COLOR.CGColor);
    CGRect rcTextRect = CGRectMake(CGRectGetMaxX(rcImage)/2 - (sizeTextCanDraw.width/2), (sizeImg.height - sizeTextCanDraw.height)/2, sizeTextCanDraw.width, sizeTextCanDraw.height);
    [text drawInRect:rcTextRect withAttributes:@{NSFontAttributeName : font ,NSForegroundColorAttributeName : TOPCAIL_COLOR}];
    
    UIImage *textImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return textImage;
}

+ (NSArray *)getSeparatedLinesFromLabel:(UILabel *)label
{
    NSString *text = [label text];
    UIFont   *font = [label font];
    CGRect    rect = [label frame];
    
    CTFontRef myFont = CTFontCreateWithName((__bridge CFStringRef)([font fontName]), [font pointSize], NULL);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)myFont range:NSMakeRange(0, attStr.length)];
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attStr);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,rect.size.width,100000));
    
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
    
    for (id line in lines)
    {
        CTLineRef lineRef = (__bridge CTLineRef )line;
        CFRange lineRange = CTLineGetStringRange(lineRef);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        
        NSString *lineString = [text substringWithRange:range];
        [linesArray addObject:lineString];
    }
    return (NSArray *)linesArray;
}

#pragma mark 获得第一响应者
+ (UIView *)getFirstResponder
{
//    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
//    UIView *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
//    return firstResponder;
    return [UIResponder currentFirstResponder];

}

#pragma mark 颜色生成图片
+ (UIImage*)createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}


+(void)setSexPhotoOn:(UIImageView *)view WithSex:(NSInteger)sex{
    
    NSString *imgName = (sex == 1) ? (@"logo_nan"):(@"logo_nv");
    
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
    
    //图片需要修正一下位置
    CGFloat xiu = 3.0f;
    
    image.frame = CGRectMake(view.width / 2 + xiu , view.height / 2 + xiu, view.width / 2, view.height / 2);
    [view addSubview:image];
    [view bringSubviewToFront:image];
    
}

+ (NSInteger)getNumberFormScore:(NSString *)scoreString
{
    
    double score = [scoreString doubleValue];
    
    if (score == 0.0)
    {
        return 0;
    }
    else if (score >= 9.2 && score < 9.4)
    {
        return 1;
    }
    else if (score >= 9.4 && score < 9.6)
    {
        return 2;
    }
    else if (score >= 9.6 && score < 9.8)
    {
        return 3;
    }
    else if (score >= 9.8 && score < 10)
    {
        return 4;
    }
    else
    {
        return 5;
    }
}

+(NSString *)getAreaCodeFormCode:(NSString*)code
{
    if(code.length == 4)
    {
        return [NSString stringWithFormat:@"%@00",code];
    }else
    {
        return code;
    }
}


+(BOOL)showPerfectIdCardFormViewController:(UIViewController *)fromViewController ToViewController:(perfectIDCardViewController *)toViewController
{
    NSString *patientIDCard = [USER_DEFAULT objectForKey:DEFAULT_PatientIdCard];
    
    if([Public isNotBlankString:patientIDCard])
    {
        return YES;
    }else
    {        
        [fromViewController presentViewController:toViewController animated:YES completion:nil];
        
        return NO;
    }
}


@end
