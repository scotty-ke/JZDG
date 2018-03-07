//
//  ImageZoomViewController.m
//  easydoctor
//
//  Created by shenyang on 16/1/20.
//  Copyright © 2016年 easygroup. All rights reserved.
//

#import "ImageZoomViewController.h"
static CGRect oldframe;

@interface ImageZoomViewController ()

@end

@implementation ImageZoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"1/1";
    self.view.backgroundColor = [UIColor blackColor];
    
    [self setNavgationBar];
}

- (void)setNavgationBar {
    UIButton *rightButton = [[UIButton alloc]init];
    rightButton.frame = CGRectMake(0, 0, 30, 40);
    [rightButton setImage:[UIImage imageNamed:@"lajitong"]
                 forState:UIControlStateNormal];
    [rightButton addTarget:self
                    action:@selector(barbuttonAction:)
          forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
}

//删除照片的操作
- (void)barbuttonAction:(UIButton *)button {
    
    if ([self.deletePhotoDelegate respondsToSelector:@selector(deletePhoto)]) {
        [self.deletePhotoDelegate deletePhoto];
    }

}

-  (void)zoomImage:(UIImageView *)avatarImageView {
    
    UIImage *image=avatarImageView.image;
    UIView *backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH,SCREEN_HEIGHT)];
    oldframe=[avatarImageView convertRect:avatarImageView.bounds toView:self.view];
    backgroundView.alpha=0;
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:oldframe];
    imageView.image=image;
    imageView.tag=1;
    [backgroundView addSubview:imageView];
    [self.view addSubview:backgroundView];
        
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=CGRectMake(0,(SCREEN_HEIGHT-NAVIGATOR_HEIGHT-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
        backgroundView.alpha=1;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)tapClick:(UITapGestureRecognizer*)tap{
    UIView *backgroundView=tap.view;
    UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=oldframe;
        backgroundView.alpha=0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
    }];
}



@end
