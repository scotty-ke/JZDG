//
//  ZYQAssetPickerController.m
//  ZYQAssetPickerControllerDemo
//
//  Created by Zhao Yiqi on 13-12-25.
//  Copyright (c) 2013年 heroims. All rights reserved.
//

#import "ZYQAssetPickerController.h"
#import "MJPhotoBrowser.h"
#import "ALAsset+Custom.h"

#define IS_IOS7             ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending)
#define kThumbnailLength    78.0f
#define kThumbnailSize      CGSizeMake(kThumbnailLength, kThumbnailLength)
#define kPopoverContentSize CGSizeMake(320, 480)

#pragma mark -

@interface NSDate (TimeInterval)

+ (NSDateComponents *)componetsWithTimeInterval:(NSTimeInterval)timeInterval;
+ (NSString *)timeDescriptionOfTimeInterval:(NSTimeInterval)timeInterval;

@end

@implementation NSDate (TimeInterval)

+ (NSDateComponents *)componetsWithTimeInterval:(NSTimeInterval)timeInterval
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDate *date1 = [[NSDate alloc] init];
    NSDate *date2 = [[NSDate alloc] initWithTimeInterval:timeInterval sinceDate:date1];
    
    unsigned int unitFlags =
    NSSecondCalendarUnit | NSMinuteCalendarUnit | NSHourCalendarUnit |
    NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
    
    return [calendar components:unitFlags
                       fromDate:date1
                         toDate:date2
                        options:0];
}

+ (NSString *)timeDescriptionOfTimeInterval:(NSTimeInterval)timeInterval
{
    NSDateComponents *components = [self.class componetsWithTimeInterval:timeInterval];
    NSInteger roundedSeconds = lround(timeInterval - (components.hour * 60) - (components.minute * 60 * 60));
    
    if (components.hour > 0)
    {
        return [NSString stringWithFormat:@"%ld:%02ld:%02ld", (long)components.hour, (long)components.minute, (long)roundedSeconds];
    }
    
    else
    {
        return [NSString stringWithFormat:@"%ld:%02ld", (long)components.minute, (long)roundedSeconds];
    }
}

@end

#pragma mark - ZYQAssetPickerController

@interface ZYQAssetPickerController ()

@property (nonatomic, copy) NSArray *indexPathsForSelectedItems;

@end

#pragma mark - ZYQVideoTitleView

@implementation ZYQVideoTitleView

-(void)drawRect:(CGRect)rect{
    CGFloat colors [] = {
        0.0, 0.0, 0.0, 0.0,
        0.0, 0.0, 0.0, 0.8,
        0.0, 0.0, 0.0, 1.0
    };
    
    CGFloat locations [] = {0.0, 0.75, 1.0};
    
    CGColorSpaceRef baseSpace   = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient      = CGGradientCreateWithColorComponents(baseSpace, colors, locations, 2);
    
    CGContextRef context    = UIGraphicsGetCurrentContext();
    
    CGFloat height          = rect.size.height;
    CGPoint startPoint      = CGPointMake(CGRectGetMidX(rect), height);
    CGPoint endPoint        = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, kCGGradientDrawsBeforeStartLocation);
    
    CGSize titleSize        = [self.text sizeWithAttributes:@{NSFontAttributeName:self.font}];
    [self.text drawAtPoint:CGPointMake(rect.size.width - titleSize.width - 2 , (height - 12) / 2) withAttributes:@{NSFontAttributeName:self.font}];

    UIImage *videoIcon=[UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ZYQAssetPicker.Bundle/Images/AssetsPickerVideo@2x.png"]];
    
    [videoIcon drawAtPoint:CGPointMake(2, (height - videoIcon.size.height) / 2)];
    
}

@end

#pragma mark - ZYQTapAssetView

@interface ZYQTapAssetView ()

@property(nonatomic,retain)UIImageView *selectView;

@end

@implementation ZYQTapAssetView

static UIImage *checkedIcon;
static UIImage *unCheckedIcon;
static UIColor *selectedColor;
static UIColor *disabledColor;

+ (void)initialize
{
    checkedIcon     =  [UIImage imageNamed:@"xuan"];
    unCheckedIcon = [UIImage imageNamed:@"weixuan"];
    selectedColor   = [UIColor colorWithWhite:1 alpha:0.3];
    disabledColor   = [UIColor colorWithWhite:1 alpha:0.9];
}

-(id)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        _selectView=[[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width-checkedIcon.size.width - 5,5, checkedIcon.size.width, checkedIcon.size.height)];
        [_selectView setImage:unCheckedIcon];
        _selectView.userInteractionEnabled = YES;
        //处理点击 selectView 为选择  点击view 为放大图片
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickSelectView:)];
        [_selectView addGestureRecognizer:tap];
        [self addSubview:_selectView];
    }
    return self;
}


#pragma mark -
#pragma mark  点击selectView 选择按钮图片
- (void)clickSelectView:(UIGestureRecognizer *)res
{
    if (_disabled) {
        return;
    }
    
    if (_delegate!=nil&&[_delegate respondsToSelector:@selector(shouldTap:)]) {
        if (![_delegate shouldTap:_selected]&&!_selected) {
            return;
        }
    }
    
    if ((_selected=!_selected)) {
        self.backgroundColor=selectedColor;
        [_selectView setImage:checkedIcon];
    }
    else{
        self.backgroundColor=[UIColor clearColor];
        [_selectView setImage:unCheckedIcon];
    }
    if (_delegate!=nil&&[_delegate respondsToSelector:@selector(touchSelect:)]) {
        [_delegate touchSelect:_selected];
    }

}

#pragma mark -
#pragma mark  点击放大
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if ([_delegate respondsToSelector:@selector(touchImageView)]) {
        [_delegate touchImageView];
    }
}

-(void)setDisabled:(BOOL)disabled{
    _disabled=disabled;
    if (_disabled) {
        self.backgroundColor=disabledColor;
    }
    else{
        self.backgroundColor=[UIColor clearColor];
    }
}

-(void)setSelected:(BOOL)selected{
    if (_disabled) {
        self.backgroundColor=disabledColor;
        [_selectView setImage:unCheckedIcon];
        return;
    }

    _selected=selected;
    if (_selected) {
        self.backgroundColor=selectedColor;
        [_selectView setImage:checkedIcon];
    }
    else{
        self.backgroundColor=[UIColor clearColor];
        [_selectView setImage:unCheckedIcon];
    }
}

@end

#pragma mark - ZYQAssetView

@interface ZYQAssetView ()<ZYQTapAssetViewDelegate>

@property (nonatomic, strong) ALAsset *asset;

@property (nonatomic, weak) id<ZYQAssetViewDelegate> delegate;

@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) ZYQVideoTitleView *videoTitle;
@property (nonatomic, retain) ZYQTapAssetView *tapAssetView;

@end

@implementation ZYQAssetView

static UIFont *titleFont = nil;

static CGFloat titleHeight;
static UIColor *titleColor;

+ (void)initialize
{
    titleFont       = [UIFont systemFontOfSize:12];
    titleHeight     = 20.0f;
    titleColor      = [UIColor whiteColor];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.opaque                     = YES;
        self.isAccessibilityElement     = YES;
        self.accessibilityTraits        = UIAccessibilityTraitImage;
        
        _imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kThumbnailSize.width, kThumbnailSize.height)];
        [self addSubview:_imageView];
        
        _videoTitle=[[ZYQVideoTitleView alloc] initWithFrame:CGRectMake(0, kThumbnailSize.height-20, kThumbnailSize.width, titleHeight)];
        _videoTitle.hidden=YES;
        _videoTitle.font=titleFont;
        _videoTitle.textColor=titleColor;
        _videoTitle.textAlignment=NSTextAlignmentRight;
        _videoTitle.backgroundColor=[UIColor clearColor];
        [self addSubview:_videoTitle];
        
        _tapAssetView=[[ZYQTapAssetView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _tapAssetView.delegate=self;
        [self addSubview:_tapAssetView];
    }
    
    return self;
}

- (void)bind:(ALAsset *)asset selectionFilter:(NSPredicate*)selectionFilter isSeleced:(BOOL)isSeleced
{
    self.asset=asset;
    
    [_imageView setImage:[UIImage imageWithCGImage:asset.thumbnail]];
    
    if ([[asset valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
        _videoTitle.hidden=NO;
        _videoTitle.text=[NSDate timeDescriptionOfTimeInterval:[[asset valueForProperty:ALAssetPropertyDuration] doubleValue]];
    }
    else{
        _videoTitle.hidden=YES;
    }
    
    _tapAssetView.disabled=! [selectionFilter evaluateWithObject:asset];
    
    _tapAssetView.selected=isSeleced;
}

#pragma mark - ZYQTapAssetView Delegate

-(BOOL)shouldTap:(BOOL)select{
    if (_delegate!=nil&&[_delegate respondsToSelector:@selector(shouldSelectAsset:select:)]) {
        return [_delegate shouldSelectAsset:_asset select:select];
    }
    return YES;
}

-(void)touchSelect:(BOOL)select{
    if (_delegate!=nil&&[_delegate respondsToSelector:@selector(tapSelectHandle:asset:)]) {
        [_delegate tapSelectHandle:select asset:_asset];
    }
}

- (void)touchImageView
{
    if ([_delegate respondsToSelector:@selector(clickImageViewHandle:)]) {
        [_delegate clickImageViewHandle:_asset];
    }
}

@end

#pragma mark - ZYQAssetViewCell

@interface ZYQAssetViewCell ()<ZYQAssetViewDelegate>

@end

@class ZYQAssetViewController;

@implementation ZYQAssetViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

- (void)bind:(NSArray *)assets selectionFilter:(NSPredicate*)selectionFilter minimumInteritemSpacing:(float)minimumInteritemSpacing minimumLineSpacing:(float)minimumLineSpacing columns:(int)columns assetViewX:(float)assetViewX{
    
    if (self.contentView.subviews.count<assets.count) {
        for (int i=0; i<assets.count; i++) {
            if (i>((NSInteger)self.contentView.subviews.count-1)) {
                ZYQAssetView *assetView=[[ZYQAssetView alloc] initWithFrame:CGRectMake(assetViewX+(kThumbnailSize.width+minimumInteritemSpacing)*i, minimumLineSpacing-1, kThumbnailSize.width, kThumbnailSize.height)];
                [assetView bind:assets[i] selectionFilter:selectionFilter isSeleced:[((ZYQAssetViewController*)_delegate).indexPathsForSelectedItems containsObject:assets[i]]];
                assetView.delegate=self;
                [self.contentView addSubview:assetView];
            }
            else{
                ((ZYQAssetView*)self.contentView.subviews[i]).frame=CGRectMake(assetViewX+(kThumbnailSize.width+minimumInteritemSpacing)*(i), minimumLineSpacing-1, kThumbnailSize.width, kThumbnailSize.height);
                [(ZYQAssetView*)self.contentView.subviews[i] bind:assets[i] selectionFilter:selectionFilter isSeleced:[((ZYQAssetViewController*)_delegate).indexPathsForSelectedItems containsObject:assets[i]]];
            }

        }
        
    }
    else{
        for (NSInteger i=self.contentView.subviews.count; i>0; i--) {
            if (i>assets.count) {
                [((ZYQAssetView*)self.contentView.subviews[i-1]) removeFromSuperview];
            }
            else{
                ((ZYQAssetView*)self.contentView.subviews[i-1]).frame=CGRectMake(assetViewX+(kThumbnailSize.width+minimumInteritemSpacing)*(i-1), minimumLineSpacing-1, kThumbnailSize.width, kThumbnailSize.height);
                [(ZYQAssetView*)self.contentView.subviews[i-1] bind:assets[i-1] selectionFilter:selectionFilter isSeleced:[((ZYQAssetViewController*)_delegate).indexPathsForSelectedItems containsObject:assets[i-1]]];
            }
        }
    }
}

#pragma mark - ZYQAssetView Delegate

-(BOOL)shouldSelectAsset:(ALAsset *)asset select:(BOOL)select{
    if (_delegate!=nil&&[_delegate respondsToSelector:@selector(shouldSelectAsset:select:)]) {
        return [_delegate shouldSelectAsset:asset select:select];
    }
    return YES;
}

-(void)tapSelectHandle:(BOOL)select asset:(ALAsset *)asset{
    if (select) {
        if (_delegate!=nil&&[_delegate respondsToSelector:@selector(didSelectAsset:)]) {
            [_delegate didSelectAsset:asset];
        }
    }
    else{
        if (_delegate!=nil&&[_delegate respondsToSelector:@selector(didDeselectAsset:)]) {
            [_delegate didDeselectAsset:asset];
        }
    }
}

- (void)clickImageViewHandle:(ALAsset *)asset
{
    if ([_delegate respondsToSelector:@selector(clickImageViewAssest:)]) {
        [_delegate clickImageViewAssest:asset];
    }
}

@end

#pragma mark - ZYQAssetViewController

@interface ZYQAssetViewController ()<ZYQAssetViewCellDelegate,MJPhotoBrowserDelegate,UITableViewDataSource,UITableViewDelegate>{
    int columns;
    
    float minimumInteritemSpacing;
    float minimumLineSpacing;
    
    BOOL unFirst;
}

@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, assign) NSInteger numberOfPhotos;
@property (nonatomic, assign) NSInteger numberOfVideos;

@end

#define kAssetViewCellIdentifier           @"AssetViewCellIdentifier"

@implementation ZYQAssetViewController
{
    UIButton *finishBtn;
    UIButton *_rightButton;
}

- (id)init
{
    _indexPathsForSelectedItems=[[NSMutableArray alloc] init];
    
    if (self = [super init])
    {
        if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
            [self setEdgesForExtendedLayout:UIRectEdgeNone];
        
        if ([self respondsToSelector:@selector(setContentSizeForViewInPopover:)])
            [self setPreferredContentSize:kPopoverContentSize];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupViews];
    [self setupButtons];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!unFirst) {
        columns=floor(self.view.frame.size.width/(kThumbnailSize.width+minimumInteritemSpacing));
        
        [self setupAssets];
        
        unFirst=YES;
    }
}

//- (void)viewDidAppear:(BOOL)animated
//{
//    APPLOG(@"%.2f",self.tableView.contentSize.height);
//    float height = SCREEN_HEIGHT - NAVIGATOR_HEIGHT;
//    if (self.tableView.contentSize.height > height) {
//        height = self.tableView.contentSize.height;
//    }
//
//}


#pragma mark - Rotation

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation))
    {
        self.tableView.contentInset=UIEdgeInsetsMake(9.0, 0, 0, 0);
        
        minimumInteritemSpacing=3;
        minimumLineSpacing=3;
    }
    else
    {
        self.tableView.contentInset=UIEdgeInsetsMake(9.0, 0, 0, 0);
        
        minimumInteritemSpacing=2;
        minimumLineSpacing=2;
    }
    
    columns=floor(self.view.frame.size.width/(kThumbnailSize.width+minimumInteritemSpacing));

    [self.tableView reloadData];
}

#pragma mark - Setup

- (void)setupViews
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 50)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = BACKGROUND_COLOR;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.tableView];
    
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
    {
        self.tableView.contentInset=UIEdgeInsetsMake(9.0, 2.0, 0, 2.0);
        
        minimumInteritemSpacing=3;
        minimumLineSpacing=3;
        
    }
    else
    {
        self.tableView.contentInset=UIEdgeInsetsMake(9.0, 0, 0, 0);
        
        minimumInteritemSpacing=2;
        minimumLineSpacing=2;
    }

    
    //添加完成按钮
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT-NAVIGATOR_HEIGHT - 50, self.view.width, 50)];
    finishBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    finishBtn.titleLabel.font = TEXT_FONT_18;
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [finishBtn setTitleColor:TOPCAIL_COLOR  forState:UIControlStateNormal];
    [finishBtn setTitleColor:RGBCOLOR(168, 227, 216) forState:UIControlStateDisabled];
    [finishBtn setBackgroundColor:WHITE_COLOR];
    [finishBtn addTarget:self action:@selector(finishPickingAssets:) forControlEvents:UIControlEventTouchUpInside];
    //    finishBtn.enabled = self.navigationItem.rightBarButtonItem.enabled;
    finishBtn.enabled = _rightButton.enabled;
    footView.layer.borderColor = TEXT_COLOR_2.CGColor;
    footView.layer.borderWidth = 0.5f;
    [footView addSubview:finishBtn];
    
    [self.view addSubview:footView];
}

- (void)setupButtons
{
//    self.navigationItem.rightBarButtonItem =
//    [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"取消", nil)
//                                     style:UIBarButtonItemStylePlain
//                                    target:self
//                                    action:@selector(dismiss:)];
//    [self.navigationItem.rightBarButtonItem setTintColor:RGBCOLOR(168, 227, 216)];
//    self.navigationItem.rightBarButtonItem.enabled = NO;
//    self.navigationController.navigationBar.translucent = NO;
    
    _rightButton = [[UIButton alloc]init];
    
    _rightButton.frame = CGRectMake(0, 0, 40, 40);
    
    _rightButton.titleLabel.font = TEXT_FONT_15;
    
    [_rightButton setTitle:@"取消"
                  forState:UIControlStateNormal];
    
    [_rightButton setTitleColor:TOPCAIL_COLOR  forState:UIControlStateNormal];
    [_rightButton setTitleColor:RGBCOLOR(168, 227, 216) forState:UIControlStateDisabled];
    
    [_rightButton addTarget:self
                     action:@selector(dismiss:)
           forControlEvents:UIControlEventTouchUpInside];
    
//    _rightButton.enabled = NO;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_rightButton];
    
//    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    UIButton *leftButton = [[UIButton alloc]init];
    
    leftButton.frame = CGRectMake(0, 0, 30, 40);
    
    leftButton.titleLabel.font = TEXT_FONT_15;
    
    [leftButton setImage:[UIImage imageNamed:@"ico_return_normal"]
                forState:UIControlStateNormal];
    
    [leftButton setTitleColor:TEXT_COLOR_1
                     forState:UIControlStateNormal];
    
    leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
    
    [leftButton addTarget:self
                   action:@selector(popOrDismiss:)
         forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    
}

-(void)popOrDismiss:(UIButton*)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dismiss:(id)sender
{
    ZYQAssetPickerController *picker = (ZYQAssetPickerController *)self.navigationController;
    
    if ([picker.delegate respondsToSelector:@selector(assetPickerControllerDidCancel:)])
        [picker.delegate assetPickerControllerDidCancel:picker];
    
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)setupAssets
{
//    self.title = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    self.title = @"所有图片";
    self.numberOfPhotos = 0;
    self.numberOfVideos = 0;
    
    if (!self.assets)
        self.assets = [[NSMutableArray alloc] init];
    else
        [self.assets removeAllObjects];
    
    ALAssetsGroupEnumerationResultsBlock resultsBlock = ^(ALAsset *asset, NSUInteger index, BOOL *stop) {
        
        if (asset)
        {
            NSString *type = [asset valueForProperty:ALAssetPropertyType];
            
            if ([type isEqual:ALAssetTypePhoto]){
                asset.tag = self.numberOfPhotos;
                asset.isSelect = NO;
                [self.assets addObject:asset];
                 self.numberOfPhotos ++;
            }
            
//            if ([type isEqual:ALAssetTypeVideo])
//                self.numberOfVideos ++;
        }
        
        else if (self.assets.count > 0)
        {
            [self.tableView reloadData];

            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:ceil(self.assets.count*1.0/columns)  inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    };
    
    [self.assetsGroup enumerateAssetsUsingBlock:resultsBlock];
}

#pragma mark - UITableView DataSource
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    if (indexPath.row==ceil(self.assets.count*1.0/columns)) {
//        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cellFooter"];
//        
//        if (cell==nil) {
//            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellFooter"];
//            cell.textLabel.font=[UIFont systemFontOfSize:18];
//            cell.textLabel.backgroundColor=[UIColor clearColor];
//            cell.textLabel.textAlignment=NSTextAlignmentCenter;
//            cell.textLabel.textColor=[UIColor blackColor];
//            cell.backgroundColor=[UIColor clearColor];
//            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//        }
//        
//        NSString *title;
//        
//        if (_numberOfVideos == 0)
//            title = [NSString stringWithFormat:NSLocalizedString(@"%ld 张照片", nil), (long)_numberOfPhotos];
//        else if (_numberOfPhotos == 0)
//            title = [NSString stringWithFormat:NSLocalizedString(@"%ld 部视频", nil), (long)_numberOfVideos];
//        else
//            title = [NSString stringWithFormat:NSLocalizedString(@"%ld 张照片, %ld 部视频", nil), (long)_numberOfPhotos, (long)_numberOfVideos];
//        
//        cell.textLabel.text=title;
//        return cell;
//    }
    
    
    NSMutableArray *tempAssets=[[NSMutableArray alloc] init];
    for (int i=0; i<columns; i++) {
        if ((indexPath.row*columns+i)<self.assets.count) {
            [tempAssets addObject:[self.assets objectAtIndex:indexPath.row*columns+i]];
        }
    }
    
    static NSString *CellIdentifier = kAssetViewCellIdentifier;
    ZYQAssetPickerController *picker = (ZYQAssetPickerController *)self.navigationController;
    
    ZYQAssetViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell=[[ZYQAssetViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = BACKGROUND_COLOR;
    }
    cell.delegate=self;

    [cell bind:tempAssets selectionFilter:picker.selectionFilter minimumInteritemSpacing:minimumInteritemSpacing minimumLineSpacing:minimumLineSpacing columns:columns assetViewX:(self.tableView.frame.size.width-kThumbnailSize.width*tempAssets.count-minimumInteritemSpacing*(tempAssets.count-1))/2];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return ceil(self.assets.count*1.0/columns)+1;
}

#pragma mark - UITableView Delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row==ceil(self.assets.count*1.0/columns)) {
//        return 44;
//    }
    return kThumbnailSize.height+minimumLineSpacing;
}


//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 50;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(-1, 0, SCREEN_WIDTH+2, 51)];
//    finishBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
//    finishBtn.titleLabel.font = TEXT_FONT_18;
//    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
//    [finishBtn setTitleColor:TOPCAIL_COLOR  forState:UIControlStateNormal];
//    [finishBtn setTitleColor:RGBCOLOR(168, 227, 216) forState:UIControlStateDisabled];
//    [finishBtn setBackgroundColor:WHITE_COLOR];
//    [finishBtn addTarget:self action:@selector(finishPickingAssets:) forControlEvents:UIControlEventTouchUpInside];
////    finishBtn.enabled = self.navigationItem.rightBarButtonItem.enabled;
//    finishBtn.enabled = _rightButton.enabled;
//    footView.layer.borderColor = TEXT_COLOR_2.CGColor;
//    footView.layer.borderWidth = 0.5f;
//    [footView addSubview:finishBtn];
//    return footView;
//}


#pragma mark - ZYQAssetViewCell Delegate

- (BOOL)shouldSelectAsset:(ALAsset *)asset select:(BOOL)select
{
    ZYQAssetPickerController *vc = (ZYQAssetPickerController *)self.navigationController;
    BOOL selectable = [vc.selectionFilter evaluateWithObject:asset];
    if (_indexPathsForSelectedItems.count >= vc.maximumNumberOfSelection&&!select) {
        
        if (vc.delegate!=nil&&[vc.delegate respondsToSelector:@selector(assetPickerControllerDidMaximum:)]) {
            [vc.delegate assetPickerControllerDidMaximum:vc];
        }
    }
    
    //刘星辰添加  图片限制的提示
    if (_indexPathsForSelectedItems.count >= vc.maximumNumberOfSelection)
    {
        //图片添加限制
        [self showHint:[NSString stringWithFormat:@"你最多只能选择9张图片"]];
    }
    
    return (selectable && _indexPathsForSelectedItems.count < vc.maximumNumberOfSelection);
}

- (void)didSelectAsset:(ALAsset *)asset
{
//    [self.navigationItem.rightBarButtonItem setTintColor:TOPCAIL_COLOR];
//    self.navigationItem.rightBarButtonItem.enabled = YES;
    _rightButton.enabled = YES;
    finishBtn.enabled = YES;
    [_indexPathsForSelectedItems addObject:asset];
    asset.isSelect = YES;
    ZYQAssetPickerController *vc = (ZYQAssetPickerController *)self.navigationController;
    vc.indexPathsForSelectedItems = _indexPathsForSelectedItems;
    
    if (vc.delegate!=nil&&[vc.delegate respondsToSelector:@selector(assetPickerController:didSelectAsset:)])
        [vc.delegate assetPickerController:vc didSelectAsset:asset];
    
    [self setTitleWithSelectedIndexPaths:_indexPathsForSelectedItems];
}

- (void)didDeselectAsset:(ALAsset *)asset
{
    [_indexPathsForSelectedItems removeObject:asset];
    if (_indexPathsForSelectedItems.count<= 0) {
//        [self.navigationItem.rightBarButtonItem setTintColor:TOPCAIL_COLOR];
//        self.navigationItem.rightBarButtonItem.enabled = NO;
        _rightButton.enabled = NO;
        finishBtn.enabled = NO;
    }
    asset.isSelect = NO;
    ZYQAssetPickerController *vc = (ZYQAssetPickerController *)self.navigationController;
    vc.indexPathsForSelectedItems = _indexPathsForSelectedItems;
    
    if (vc.delegate!=nil&&[vc.delegate respondsToSelector:@selector(assetPickerController:didDeselectAsset:)])
        [vc.delegate assetPickerController:vc didDeselectAsset:asset];
    
    [self setTitleWithSelectedIndexPaths:_indexPathsForSelectedItems];
}

#pragma mark -
#pragma mark  这个地方要放大图片了
- (void)clickImageViewAssest:(ALAsset *)asset
{
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    for (int i = 0 ; i < self.assets.count; i++) {
        ALAsset *asset = [self.assets objectAtIndex:i];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.asset = asset;
        photo.sourceFromAblum = YES;
        [photos addObject:photo];
    }
    MJPhotoBrowser *browser = [MJPhotoBrowser new];
    browser.photos = photos;
    browser.delegate = self;
    browser.sourceFromAblum = YES;
    browser.selectNum = _indexPathsForSelectedItems.count;
    ZYQAssetPickerController *vc = (ZYQAssetPickerController *)self.navigationController;
    browser.limitNum = vc.maximumNumberOfSelection;
    browser.currentPhotoIndex = asset.tag;
    [browser show];
}


#pragma mark -
#pragma mark  MJPhotoBrowserDelegate
- (void)clickToolBarALAsset:(ALAsset *)asset isSelect:(BOOL)isSelect
{
    if (isSelect) {
        if ([self shouldClickToolBarALAsset:asset isSelect:isSelect]) {
            [self didSelectAsset:asset];
        }
    }else{
        [self didDeselectAsset:asset];
    }
    [self.tableView reloadData];
}

- (BOOL)shouldClickToolBarALAsset:(ALAsset *)asset isSelect:(BOOL)isSelect
{
    return [self shouldSelectAsset:asset select:isSelect];
}


- (void)finishToolBar
{
    [self finishPickingAssets:nil];
}


#pragma mark - Title

- (void)setTitleWithSelectedIndexPaths:(NSArray *)indexPaths
{
    // Reset title to group name
    if (indexPaths.count == 0)
    {
        self.title = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
        return;
    }
    
    BOOL photosSelected = NO;
    BOOL videoSelected  = NO;
    
    for (int i=0; i<indexPaths.count; i++) {
        ALAsset *asset = indexPaths[i];
        
        if ([[asset valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypePhoto])
            photosSelected  = YES;
        
        if ([[asset valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo])
            videoSelected   = YES;
        
        if (photosSelected && videoSelected)
            break;

    }
    
    NSString *format;
    
    if (photosSelected && videoSelected)
        format = NSLocalizedString(@"已选择 %ld 个项目", nil);
    
    else if (photosSelected)
        format = (indexPaths.count > 1) ? NSLocalizedString(@"已选择 %ld 张照片", nil) : NSLocalizedString(@"已选择 %ld 张照片 ", nil);
    
    else if (videoSelected)
        format = (indexPaths.count > 1) ? NSLocalizedString(@"已选择 %ld 部视频", nil) : NSLocalizedString(@"已选择 %ld 部视频 ", nil);
    
    self.title = [NSString stringWithFormat:format, (long)indexPaths.count];
}


#pragma mark - Actions

- (void)finishPickingAssets:(id)sender
{
    
    ZYQAssetPickerController *picker = (ZYQAssetPickerController *)self.navigationController;
    
    if (_indexPathsForSelectedItems.count < picker.minimumNumberOfSelection) {
        if (picker.delegate!=nil&&[picker.delegate respondsToSelector:@selector(assetPickerControllerDidMaximum:)]) {
            [picker.delegate assetPickerControllerDidMaximum:picker];
        }
    }
    

    if ([picker.delegate respondsToSelector:@selector(assetPickerController:didFinishPickingAssets:)])
        [picker.delegate assetPickerController:picker didFinishPickingAssets:_indexPathsForSelectedItems];
    
    if (picker.isFinishDismissViewController) {
        [picker.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
    }
}

@end

#pragma mark - ZYQAssetGroupViewCell

@interface ZYQAssetGroupViewCell ()

@property (nonatomic, strong) ALAssetsGroup *assetsGroup;

@end

@implementation ZYQAssetGroupViewCell


- (void)bind:(ALAssetsGroup *)assetsGroup
{
    self.assetsGroup            = assetsGroup;
    
    CGImageRef posterImage      = assetsGroup.posterImage;
    size_t height               = CGImageGetHeight(posterImage);
    float scale                 = height / kThumbnailLength;
    
    self.imageView.image        = [UIImage imageWithCGImage:posterImage scale:scale orientation:UIImageOrientationUp];
    self.textLabel.text         = [assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    self.detailTextLabel.text   = [NSString stringWithFormat:@"%ld", (long)[assetsGroup numberOfAssets]];
    self.accessoryType          = UITableViewCellAccessoryDisclosureIndicator;
}

- (NSString *)accessibilityLabel
{
    NSString *label = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    
    return [label stringByAppendingFormat:NSLocalizedString(@"%ld 张照片", nil), (long)[self.assetsGroup numberOfAssets]];
}

@end


#pragma mark - ZYQAssetGroupViewController

@interface ZYQAssetGroupViewController()

@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, strong) NSMutableArray *groups;

@end

@implementation ZYQAssetGroupViewController

- (id)init
{
    if (self = [super initWithStyle:UITableViewStylePlain])
    {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0
        self.preferredContentSize=kPopoverContentSize;
#else
        if ([self respondsToSelector:@selector(setContentSizeForViewInPopover:)])
            [self setContentSizeForViewInPopover:kPopoverContentSize];
#endif
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupViews];
    [self setupButtons];
    [self localize];
    [self setupGroup];
    
}


#pragma mark - Rotation

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}


#pragma mark - Setup

- (void)setupViews
{
    self.tableView.rowHeight = kThumbnailLength + 12;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)setupButtons
{
    ZYQAssetPickerController *picker = (ZYQAssetPickerController *)self.navigationController;
    
    if (picker.showCancelButton)
    {
        self.navigationItem.rightBarButtonItem =
        [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"取消", nil)
                                         style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(dismiss:)];
        self.navigationItem.rightBarButtonItem.tintColor = TOPCAIL_COLOR;
    }
}

- (void)localize
{
    self.title = NSLocalizedString(@"相簿", nil);
}

- (void)setupGroup
{
    if (!self.assetsLibrary)
        self.assetsLibrary = [self.class defaultAssetsLibrary];
    
    if (!self.groups)
        self.groups = [[NSMutableArray alloc] init];
    else
        [self.groups removeAllObjects];
    
    ZYQAssetPickerController *picker = (ZYQAssetPickerController *)self.navigationController;
    ALAssetsFilter *assetsFilter = picker.assetsFilter;
    
    ALAssetsLibraryGroupsEnumerationResultsBlock resultsBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        if (group)
        {
            [group setAssetsFilter:assetsFilter];
            if (group.numberOfAssets > 0 || picker.showEmptyGroups)
                [self.groups addObject:group];
        }
        else
        {
            [self reloadData];
        }
    };
    
    
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
        
        [self showNotAllowed];
        
    };
    
    // Enumerate Camera roll first
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                                      usingBlock:resultsBlock
                                    failureBlock:failureBlock];
    
    // Then all other groups
    NSUInteger type =
    ALAssetsGroupLibrary | ALAssetsGroupAlbum | ALAssetsGroupEvent |
    ALAssetsGroupFaces | ALAssetsGroupPhotoStream;
    
    [self.assetsLibrary enumerateGroupsWithTypes:type
                                      usingBlock:resultsBlock
                                    failureBlock:failureBlock];
}


#pragma mark - Reload Data

- (void)reloadData
{
    if (self.groups.count == 0)
        [self showNoAssets];
    
    [self.tableView reloadData];
}


#pragma mark - ALAssetsLibrary

+ (ALAssetsLibrary *)defaultAssetsLibrary
{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}


#pragma mark - Not allowed / No assets

- (void)showNotAllowed
{
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        [self setEdgesForExtendedLayout:UIRectEdgeLeft | UIRectEdgeRight | UIRectEdgeBottom];
    
    self.title              = nil;
    
    UIImageView *padlock    = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ZYQAssetPicker.Bundle/Images/AssetsPickerLocked@2x.png"]]];
    padlock.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *title          = [UILabel new];
    title.translatesAutoresizingMaskIntoConstraints = NO;
    title.preferredMaxLayoutWidth = 304.0f;
    
    UILabel *message        = [UILabel new];
    message.translatesAutoresizingMaskIntoConstraints = NO;
    message.preferredMaxLayoutWidth = 304.0f;
    
    title.text              = NSLocalizedString(@"此应用无法使用您的照片或视频。", nil);
    title.font              = [UIFont boldSystemFontOfSize:17.0];
    title.textColor         = [UIColor colorWithRed:129.0/255.0 green:136.0/255.0 blue:148.0/255.0 alpha:1];
    title.textAlignment     = NSTextAlignmentCenter;
    title.numberOfLines     = 5;
    
    message.text            = NSLocalizedString(@"你可以在「隐私设置」中启用存取。", nil);
    message.font            = [UIFont systemFontOfSize:14.0];
    message.textColor       = [UIColor colorWithRed:129.0/255.0 green:136.0/255.0 blue:148.0/255.0 alpha:1];
    message.textAlignment   = NSTextAlignmentCenter;
    message.numberOfLines   = 5;
    
    [title sizeToFit];
    [message sizeToFit];
    
    UIView *centerView = [UIView new];
    centerView.translatesAutoresizingMaskIntoConstraints = NO;
    [centerView addSubview:padlock];
    [centerView addSubview:title];
    [centerView addSubview:message];
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(padlock, title, message);
    
    [centerView addConstraint:[NSLayoutConstraint constraintWithItem:padlock attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:centerView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [centerView addConstraint:[NSLayoutConstraint constraintWithItem:title attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:padlock attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [centerView addConstraint:[NSLayoutConstraint constraintWithItem:message attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:padlock attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [centerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[padlock]-[title]-[message]|" options:0 metrics:nil views:viewsDictionary]];
    
    UIView *backgroundView = [UIView new];
    [backgroundView addSubview:centerView];
    [backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:centerView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:backgroundView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:centerView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:backgroundView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
    
    self.tableView.backgroundView = backgroundView;
}

- (void)showNoAssets
{
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        [self setEdgesForExtendedLayout:UIRectEdgeLeft | UIRectEdgeRight | UIRectEdgeBottom];
    
    UILabel *title          = [UILabel new];
    title.translatesAutoresizingMaskIntoConstraints = NO;
    title.preferredMaxLayoutWidth = 304.0f;
    UILabel *message        = [UILabel new];
    message.translatesAutoresizingMaskIntoConstraints = NO;
    message.preferredMaxLayoutWidth = 304.0f;
    
    title.text              = NSLocalizedString(@"没有照片或视频。", nil);
    title.font              = [UIFont systemFontOfSize:26.0];
    title.textColor         = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
    title.textAlignment     = NSTextAlignmentCenter;
    title.numberOfLines     = 5;
    
    message.text            = NSLocalizedString(@"您可以使用 iTunes 将照片和视频\n同步到 iPhone。", nil);
    message.font            = [UIFont systemFontOfSize:18.0];
    message.textColor       = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
    message.textAlignment   = NSTextAlignmentCenter;
    message.numberOfLines   = 5;
    
    [title sizeToFit];
    [message sizeToFit];
    
    UIView *centerView = [UIView new];
    centerView.translatesAutoresizingMaskIntoConstraints = NO;
    [centerView addSubview:title];
    [centerView addSubview:message];
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(title, message);
    
    [centerView addConstraint:[NSLayoutConstraint constraintWithItem:title attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:centerView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [centerView addConstraint:[NSLayoutConstraint constraintWithItem:message attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:title attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [centerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[title]-[message]|" options:0 metrics:nil views:viewsDictionary]];
    
    UIView *backgroundView = [UIView new];
    [backgroundView addSubview:centerView];
    [backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:centerView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:backgroundView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:centerView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:backgroundView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
    
    self.tableView.backgroundView = backgroundView;
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.groups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    ZYQAssetGroupViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[ZYQAssetGroupViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    [cell bind:[self.groups objectAtIndex:indexPath.row]];
    
    return cell;
}


#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kThumbnailLength + 12;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZYQAssetViewController *vc = [[ZYQAssetViewController alloc] init];
    vc.assetsGroup = [self.groups objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Actions

- (void)dismiss:(id)sender
{
    ZYQAssetPickerController *picker = (ZYQAssetPickerController *)self.navigationController;
    
    if ([picker.delegate respondsToSelector:@selector(assetPickerControllerDidCancel:)])
        [picker.delegate assetPickerControllerDidCancel:picker];
    
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

@end

#pragma mark - ZYQAssetPickerController

@implementation ZYQAssetPickerController

@dynamic delegate;

- (id)init
{
    ZYQAssetGroupViewController *groupViewController = [[ZYQAssetGroupViewController alloc] init];
    
    if (self = [super initWithRootViewController:groupViewController])
    {
        _maximumNumberOfSelection      = 10;
        _minimumNumberOfSelection      = 0;
        _assetsFilter                  = [ALAssetsFilter allAssets];
        _showCancelButton              = YES;
        _showEmptyGroups               = NO;
        _selectionFilter               = [NSPredicate predicateWithValue:YES];
        _isFinishDismissViewController = YES;
        
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0
        self.preferredContentSize=kPopoverContentSize;
#else
        if ([self respondsToSelector:@selector(setContentSizeForViewInPopover:)])
            [self setContentSizeForViewInPopover:kPopoverContentSize];
#endif
    }
    
    [self pushToAssetViewController];
    
    return self;
}


- (void)pushToAssetViewController
{
    ZYQAssetViewController *vc = [[ZYQAssetViewController alloc] init];
   
    ALAssetsLibrary *assetsLibrary = [ZYQAssetGroupViewController defaultAssetsLibrary];
    
    ALAssetsLibraryGroupsEnumerationResultsBlock resultsBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        if (group)
        {
//            APPLOG(@"%@,%@,%@",[group valueForProperty:ALAssetsGroupPropertyName],[group valueForProperty:ALAssetsGroupPropertyType],[group valueForProperty:ALAssetsGroupPropertyPersistentID]);
            if (group.numberOfAssets > 0 && [[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:@"相机胶卷"]){
//                [groups addObject:group];
                vc.assetsGroup = group;
                [self pushViewController:vc animated:NO];
                return;
            }
        }
    };
    
    
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
        
    };
    
    // Enumerate Camera roll first
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                                      usingBlock:resultsBlock
                                    failureBlock:failureBlock];
    
    // Then all other groups
    NSUInteger type =
    ALAssetsGroupLibrary | ALAssetsGroupAlbum | ALAssetsGroupEvent |
    ALAssetsGroupFaces | ALAssetsGroupPhotoStream;
    
    [assetsLibrary enumerateGroupsWithTypes:type
                                      usingBlock:resultsBlock
                                    failureBlock:failureBlock];
    
//    vc.assetsGroup = [groups objectAtIndex:0];
    
//    [self pushViewController:vc animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationBar.titleTextAttributes =  [NSDictionary dictionaryWithObject:TITLE_FONT_19 forKey:NSFontAttributeName];
    [self.navigationBar setBarTintColor:WHITE_COLOR];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
