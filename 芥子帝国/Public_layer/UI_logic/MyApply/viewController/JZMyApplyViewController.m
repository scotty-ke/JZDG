//
//  JZMyApplyViewController.m
//  芥子帝国
//
//  Created by 纳里健康 on 2018/3/9.
//  Copyright © 2018年 JZDG. All rights reserved.
//

#import "JZMyApplyViewController.h"
#import <WMPageController/WMPageController.h>

@interface JZMyApplyViewController ()<WMPageControllerDataSource>

@end

@implementation JZMyApplyViewController
{
    WMPageController *_pageVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)makeMenu
{
    if (_pageVC) {
        [_pageVC.view removeFromSuperview];
        [_pageVC removeFromParentViewController];
        _pageVC = nil;
    }
//    _pageVC = [self p_defaultController];
//    [self addChildViewController:pageVC];
    _pageVC.view.frame = CGRectMake(0, CGRectGetMaxY(_recordHeader.frame) + 1, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
    [self.view addSubview:_pageVC.view];

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
