//
//  DocumentTypeView.h
//  easydoctor
//
//  Created by stone on 15/11/20.
//  Copyright © 2015年 easygroup. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    DocumentTypeEdit,//编辑
    DocumentTypeChect,//查看
} DocumentTypeStatus;

@protocol DocumentTypeViewDelegate <NSObject>

- (void)clickDocumentTypeLabel:(id)documentType;

@end

@interface DocumentTypeView : UIView

@property(nonatomic,assign) DocumentTypeStatus documentTypeStatus;
@property(nonatomic,weak) id<DocumentTypeViewDelegate> documentTypeViewDelegate;
@property(nonatomic,strong) NSMutableArray *dataArray;//基础类型数据

- (instancetype)initWithFrame:(CGRect)frame status:(DocumentTypeStatus)status;

- (void)setSelectType:(NSInteger)key;

@end


@interface DocumentTypeViewCell : UICollectionViewCell

@property(nonatomic, strong) UILabel *textLabel;
@property(nonatomic,assign) DocumentTypeStatus documentTypeStatus;



- (void)setSelectStatus:(BOOL)status;

@end


