//
//  IconTitleValueCell.h
//  NagriHealth
//
//  Created by 丁东 on 2016/10/17.
//  Copyright © 2016年 丁东. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IconTitleValueCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *icon;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@property (weak, nonatomic) IBOutlet UIView *line;

-(void)setValueText:(NSString*)value withCellWidth:(CGFloat)with;

@end
