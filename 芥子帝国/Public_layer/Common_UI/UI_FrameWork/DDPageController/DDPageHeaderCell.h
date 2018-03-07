//
//  DDPageHeaderCell.h
//  easydoctor
//
//  Created by 丁东 on 15/11/16.
//  Copyright © 2015年 easygroup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDPageConfig.h"
@interface DDPageHeaderCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *icon;

@property (nonatomic,strong) DDPageConfig *config;
@end
