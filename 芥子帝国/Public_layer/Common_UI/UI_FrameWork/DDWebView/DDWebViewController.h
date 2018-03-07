//
//  DDWebViewController.h
//  NagriHealth
//
//  Created by 丁东 on 2016/11/21.
//  Copyright © 2016年 丁东. All rights reserved.
//

#import "BaseViewController.h"

@interface DDWebViewController : BaseViewController

@property (nonatomic,strong) NSURL *url;


/**
 资讯单id   -- 资讯用
 */
@property (nonatomic,strong) NSString *infomationId;

-(void)loadViewWithUrl:(NSURL*)url;

@end
