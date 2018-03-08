//
//  TabbarViewController.m
//  芥子帝国
//
//  Created by 纳里健康 on 2018/3/8.
//  Copyright © 2018年 songK. All rights reserved.
//

#import "TabbarViewController.h"
#import "MainViewController.h"
#import "BusCircleViewController.h"
#import "PersonCenterViewController.h"


@interface TabbarViewController ()
{
    MainViewController *_mainVC;
    BusCircleViewController *_busCircleVC;
    PersonCenterViewController *_personCenterVC;
}

@end

@implementation TabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self makeChildViewController];
}

#pragma mark -- 设置容器
- (void)makeChildViewController
{
    /**
     首页
     */
    _mainVC  = [[MainViewController alloc]init];
    JZNavigationViewController *mainNVC = [[JZNavigationViewController alloc]initWithRootViewController:_mainVC];
    _mainVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"首页"
                                                      image:[[UIImage  imageNamed:@"main"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                              selectedImage:[[UIImage imageNamed:@"main"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    
    
    
    /**
     消息
     */
    _busCircleVC  = [[BusCircleViewController alloc]init];
    JZNavigationViewController *busCircleNVC = [[JZNavigationViewController alloc]initWithRootViewController:_busCircleVC];
    _busCircleVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"商业圈"
                                                          image:[[UIImage  imageNamed:@"message"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                  selectedImage:[[UIImage imageNamed:@"message"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    
    _personCenterVC  = [[PersonCenterViewController alloc]init];
    JZNavigationViewController *personCenterNVC = [[JZNavigationViewController alloc]initWithRootViewController:_personCenterVC];
    _personCenterVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"我的"
                                                              image:[[UIImage  imageNamed:@"self"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                      selectedImage:[[UIImage imageNamed:@"self"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    
    self.tabBar.tintColor = TOPCAIL_COLOR;
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:TOPCAIL_COLOR, NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
    self.viewControllers = @[mainNVC,busCircleNVC,personCenterNVC];
    
    self.tabBar.translucent = NO;
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
