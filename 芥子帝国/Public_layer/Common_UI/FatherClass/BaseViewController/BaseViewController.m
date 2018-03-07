//
//  BaseViewController.m
//  EY
//
//  Created by stone on 14/12/22.
//  Copyright (c) 2014年 wu. All rights reserved.
//

#import "BaseViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreLocation/CoreLocation.h>
#import "SDImageCache.h"
@interface BaseViewController ()<UIGestureRecognizerDelegate>

@end

@implementation BaseViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cellHeight = [[NSMutableDictionary alloc] init];
    
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    self.leftButton = [[UIButton alloc]init];
    
    self.leftButton.frame = CGRectMake(0, 0, 25, 25);
    
    self.leftButton.titleLabel.font = TEXT_FONT_15;
    
    [self.leftButton setImage:[UIImage imageNamed:@"ico_return_normal"]
                forState:UIControlStateNormal];
    
    [self.leftButton setTitleColor:TEXT_COLOR_1
                     forState:UIControlStateNormal];
    
    self.leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
    
    [self.leftButton addTarget:self
                   action:@selector(popOrDismiss:)
         forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.leftButton];
    self.navigationItem.backBarButtonItem = nil;
    self.navigationController.navigationBar.translucent = NO;
    
   
    if (self.navigationController && [self.navigationController.viewControllers count] == 1) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
 /*
    UIScreenEdgePanGestureRecognizer *edgePanGestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(edgePanGesture:)];
    edgePanGestureRecognizer.delegate = self;
    edgePanGestureRecognizer.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:edgePanGestureRecognizer];
     */
    
//    [NS_NOTIFICATION_CENTER addObserver:self selector:@selector(changTopicColor) name:kNotification_TopicColorChange object:nil];
}


-(void)changTopicColor
{

}

- (void)edgePanGesture:(UIScreenEdgePanGestureRecognizer*)edgePanGestureRecognizer{
    [self popOrDismiss:self.leftButton];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}


- (void)viewWillDisappear:(BOOL)animated
{
    //刘星辰 为了解决跳入下一界面出现键盘不弹回的问题
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}




//-(UIViewController*)getPopViewController
//{
//
//}


- (void)showAuthType:(PhoneAuthType)authType successBlock:(authSuccessBlock)successBlock
        failureBlock:(authFailureBlock)failureBlock
{
    BOOL noAuth;
    NSString *title;
    NSString *message;
    switch (authType) {
        case PhoneAuthCamera:
        {
            title = @"未获得授权使用相机";
            message = @"请在IOS‘设置’-'隐私'-'相机'中打开";
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            noAuth = (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied);
        }
            break;
        case PhoneAuthPhoto:
        {
            title = @"未获得授权使用相册";
            message = @"请在IOS‘设置’-'隐私'-'相册'中打开";
            ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
            noAuth = (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied);
        }
            break;
        case PhoneAuthLocation:
        {
            title = @"未获得授权使用定位服务";
            message = @"请在IOS‘设置’-'隐私'-'定位服务'中打开";
            CLAuthorizationStatus authStatus = [CLLocationManager authorizationStatus];
            noAuth = (authStatus == kCLAuthorizationStatusRestricted || authStatus == kCLAuthorizationStatusDenied);
        }
            break;
        default:
            break;
    }
    if (noAuth) {
//        AppAlertViewController *alert = [[AppAlertViewController alloc] initWithParentController:self];
//        [alert showAlert:title message:message sureTitle:nil cancelTitle:@"知道了" sure:^{
//            
//        } cancel:^{
//            failureBlock();
//        }];
    }else{
        successBlock();
    }

}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [[SDImageCache sharedImageCache] clearMemory];
    NSLog(@"%@ 内存警告",[NSString stringWithUTF8String:object_getClassName(self)]);
    if ([self.view window] == nil)// 是否是正在使用的视图
    {
        [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        for (NSInteger i = 0;i < self.view.subviews.count; i++)
        {
            UIView *subview = [self.view.subviews objectAtIndex:0];
            subview = nil;
        }
        self.view = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
    }

}

-(void)addtableViewTap
{
    for (UIView *view in self.view.subviews)
    {
        if ([view isKindOfClass:[UIScrollView class]] || [view isKindOfClass:[UITableView class]])
        {
            UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
            //不加会屏蔽到TableView的点击事件等
            tapGr.cancelsTouchesInView = NO;
            [view addGestureRecognizer:tapGr];
        }
    }
}

-(void)hideKeyboard:(UIGestureRecognizer*)gesture
{
    UIView *view = gesture.view;
    [view endEditing:YES];
    [self.view endEditing:YES];
}


- (void)setLxcCellDictValue:(CGFloat)cellHeight WithKey:(NSIndexPath *)path{
    NSString *key = [NSString stringWithFormat:@"%lu-%lu",path.section,path.row];
    [self.cellHeight setObject:@(cellHeight) forKey:key];
}


- (CGFloat)getLxcCellDictValueWith:(NSIndexPath *)path{
    NSString *key = [NSString stringWithFormat:@"%lu-%lu",path.section,path.row];
    return [[self.cellHeight objectForKey:key] floatValue];
}


- (NSString *)returnControllerName
{
    NSString *className = NSStringFromClass([self class]);
    return className;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"dealloc - %@",[self returnControllerName]);
}

@end
