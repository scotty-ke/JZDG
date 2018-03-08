//
//  RegisterViewController.h
//  芥子帝国
//
//  Created by 纳里健康 on 2018/3/8.
//  Copyright © 2018年 songK. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum NSInteger{

    registerViewController = 1,
    
    forgetPwdViewController

}ViewControllerType;

@interface RegisterViewController :BaseViewController

@property (nonatomic, assign)ViewControllerType type;


@end
