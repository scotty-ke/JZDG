//
//  RegisterViewController.h
//  NagriHealth
//
//  Created by 纳里健康 on 16/8/23.
//  Copyright © 2016年 丁东. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum NSInteger{

    registerViewController = 1,
    
    forgetPwdViewController

}ViewControllerType;

@interface RegisterViewController :BaseViewController

@property (nonatomic, assign)ViewControllerType type;


@end
