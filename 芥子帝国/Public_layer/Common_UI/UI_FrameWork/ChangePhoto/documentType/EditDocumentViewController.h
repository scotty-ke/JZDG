//
//  EditDocumentViewController.h
//  easydoctor
//
//  Created by stone on 15/11/20.
//  Copyright © 2015年 easygroup. All rights reserved.
//

#import "BaseViewController.h"
#import "Document.h"


@protocol PhotoCollectionCellDelegate <NSObject>

- (void)clickDeletPhoto:(NSInteger)index;

@end

@interface PhotoCollectionCell : UICollectionViewCell

@property(nonatomic,strong) UIImageView *phpImageView;
@property(nonatomic,weak) id<PhotoCollectionCellDelegate> photoCellctionCellDelegate;


@end


@protocol EditDocumentViewControllerDelegate <NSObject>

- (void)clickFinishEdit:(NSArray *)documents;

@end

@interface EditDocumentViewController : BaseViewController

@property(nonatomic,strong) NSMutableArray *assets;
@property(nonatomic,weak) id<EditDocumentViewControllerDelegate> editDocumentDelegate;

@end
