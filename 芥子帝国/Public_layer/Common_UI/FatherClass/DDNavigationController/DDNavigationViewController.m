//
//  DDNavigationViewController.m
//  Ask
//
//  Created by 铁木真 on 15/6/23.
//  Copyright (c) 2015年 铁木真. All rights reserved.
//

#import "DDNavigationViewController.h"

@interface DDNavigationViewController ()<UIGestureRecognizerDelegate>

@property (strong, nonatomic)UIPanGestureRecognizer *panGestureRecognizer;
@property (strong, nonatomic)UIImageView *backView;

@property (strong, nonatomic)NSMutableArray *backImgs;
@property (assign) CGPoint panBeginPoint;
@property (assign) CGPoint panEndPoint;
@property (nonatomic,assign) NSInteger toIndex;
@end

@implementation DDNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof (self) weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
    }
    self.navigationBar.titleTextAttributes =  [NSDictionary dictionaryWithObject:TITLE_FONT_19 forKey:NSFontAttributeName];
    [self.navigationBar setBarTintColor:WHITE_COLOR];
    
    [self loadBaseUI];
}

- (void)loadView{
    [super loadView];
    
    [self initilization];
}

- (void)initilization{
    self.backImgs = [[NSMutableArray alloc] init];
}

- (void)loadBaseUI{
    //原生方法无效
    self.interactivePopGestureRecognizer.enabled = NO;
    
    //设置手势
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerAction:)];
    self.panGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:self.panGestureRecognizer];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
    CGPoint translation = [pan translationInView:self.view];
    if (translation.x < 0) {
        return NO;
    }
    
    return YES;
}

#pragma mark- public method
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //截图
    UIGraphicsBeginImageContextWithOptions([UIScreen mainScreen].bounds.size, YES, 1.0);
    [[UIApplication sharedApplication].keyWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.backImgs addObject:img];
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    
    if (self.leftPanUse == YES)
    {
        UIViewController *viewcontroller = [self.viewControllers lastObject];
        self.toIndex = [self.viewControllers indexOfObject:viewcontroller] - 1;
        return nil;
    }
    else
    {
        [_backImgs removeLastObject];
        return [super popViewControllerAnimated:animated];
    }
}

- (nullable NSArray<__kindof UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.leftPanUse == YES)
    {
        self.toIndex = [self.viewControllers indexOfObject:viewController];
        return nil;
    }
    else
    {
        NSInteger index =  [self.viewControllers indexOfObject:viewController];
        [_backImgs removeObjectsInRange:NSMakeRange(index, _backImgs.count - index)];
        return [super popToViewController:viewController animated:animated];
    }
}

- (nullable NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated
{
    if (self.leftPanUse == YES)
    {
        self.toIndex = 0;
        return nil;
    }
    else
    {
        [_backImgs removeAllObjects];
        return [super popToRootViewControllerAnimated:animated];
    }
}



#pragma mark- private method
- (void)panGestureRecognizerAction:(UIPanGestureRecognizer*)panGestureRecognizer{
    if ([self.viewControllers count] == 1) {
        return ;
    }
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"滑动开始");
        self.leftPanUse = YES;
        BaseViewController *base = [self.viewControllers lastObject];
        
        [base popOrDismiss:nil];
        //存放滑动开始的位置
        self.panBeginPoint = [panGestureRecognizer locationInView:[UIApplication sharedApplication].keyWindow];
        //插入图片
        [self insertLastViewFromSuperView:self.view.superview index:self.toIndex];
        
        
    }else if(panGestureRecognizer.state == UIGestureRecognizerStateEnded){
        NSLog(@"滑动结束");
        //存放数据
        self.panEndPoint = [panGestureRecognizer locationInView:[UIApplication sharedApplication].keyWindow];
        self.leftPanUse = NO;

        if ((_panEndPoint.x - _panBeginPoint.x) > 150) {
            [UIView animateWithDuration:0.3 animations:^{
                [self moveNavigationViewWithLenght:[UIScreen mainScreen].bounds.size.width];
            } completion:^(BOOL finished) {
                [self moveNavigationViewWithLenght:0];
                [self removeLastViewFromSuperViewWithIndex:self.toIndex];
                UIViewController *viewControler = self.viewControllers[self.toIndex];
                [self popToViewController:viewControler animated:NO];
            }];
            
            
        }else{
            [UIView animateWithDuration:0.3 animations:^{
                [self moveNavigationViewWithLenght:0];
            } completion:^(BOOL finished) {
                [self removeLastViewFromSuperViewWithIndex:self.toIndex];
            }];
        }
    }else{
        //添加移动效果
        CGFloat panLength = ([panGestureRecognizer locationInView:[UIApplication sharedApplication].keyWindow].x - _panBeginPoint.x);
        if (panLength > 0) {
            [self moveNavigationViewWithLenght:panLength];
        }
    }
}

/**
 *  移动视图界面
 *
 *  @param lenght 移动的长度
 */
- (void)moveNavigationViewWithLenght:(CGFloat)lenght{
    
    //图片位置设置
    self.view.frame = CGRectMake(lenght, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    //图片动态阴影
    _backView.alpha = (lenght/[UIScreen mainScreen].bounds.size.width)*2/3 + 0.33;
    
    _backView.frame = CGRectMake(-150 + (lenght/SCREEN_WIDTH)*150, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    UIViewController *last = [self.viewControllers lastObject];
    
    last.navigationItem.leftBarButtonItem.customView.alpha = (150 - lenght)/150;
}

/**
 *  插图上一级图片
 *
 *  @param superView 图片的superView
 */
- (void)insertLastViewFromSuperView:(UIView *)superView index:(NSInteger)index
{
    //插入上一级视图背景
    if (_backView == nil) {
        _backView = [[UIImageView alloc] initWithFrame:CGRectMake(-150, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _backView.image = [_backImgs objectAtIndex:index];;
    }
    [self.view.superview insertSubview:_backView belowSubview:self.view];
}

/**
 *  移除上一级图片
 */
- (void)removeLastViewFromSuperViewWithIndex:(NSInteger)index
{
    [_backView removeFromSuperview];
    _backView = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
