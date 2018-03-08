//
//  MainViewController.m
//  芥子帝国
//
//  Created by 纳里健康 on 2018/3/8.
//  Copyright © 2018年 songK. All rights reserved.
//

#import "MainViewController.h"
#import "LoginViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor cyanColor];
    
    self.navigationItem.title = @"首页";
    
    UIButton *login = [UIButton buttonWithType:UIButtonTypeCustom];
    
    login.frame = CGRectMake(100, 200, 100, 100);
    
    [login setTitle:@"login" forState:UIControlStateNormal];
    
    [login addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:login];
    
}

- (void)loginAction
{
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    
    JZNavigationViewController *loginNav = [[JZNavigationViewController alloc] initWithRootViewController:loginVC];
    
    [self presentViewController:loginNav animated:YES completion:nil];
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
