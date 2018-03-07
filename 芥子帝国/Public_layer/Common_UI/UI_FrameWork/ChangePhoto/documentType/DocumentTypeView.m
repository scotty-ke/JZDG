//
//  DocumentTypeView.m
//  easydoctor
//
//  Created by stone on 15/11/20.
//  Copyright © 2015年 easygroup. All rights reserved.
//

#import "DocumentTypeView.h"

#pragma mark -
#pragma mark  DocumentTypeViewCell
@implementation DocumentTypeViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _textLabel.font = TEXT_FONT_15;
        _textLabel.numberOfLines = 0;
        _textLabel.center = CGPointMake(frame.size.width/2, frame.size.height/2);
        _textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _textLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_textLabel];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.documentTypeStatus == DocumentTypeEdit) {
        self.backgroundColor = WHITE_COLOR;
        _textLabel.textColor = TEXT_COLOR_1;
    }else{
        self.backgroundColor = TEXT_COLOR_1;
        _textLabel.textColor = WHITE_COLOR;
    }
}



- (void)setSelectStatus:(BOOL)status
{
    if (status) {
        _textLabel.textColor = TOPCAIL_COLOR;
        _textLabel.layer.borderColor = TOPCAIL_COLOR.CGColor;
        _textLabel.layer.borderWidth = 1.0f;
    }else{
        if (self.documentTypeStatus == DocumentTypeEdit) {
            _textLabel.textColor = TEXT_COLOR_1;
            _textLabel.layer.borderWidth = 0.f;
        }else{
            _textLabel.textColor = WHITE_COLOR;
            _textLabel.layer.borderWidth = 0.f;
        }

    }
}


@end


#pragma mark -
#pragma mark  DocumentTypeView
@interface DocumentTypeView (private)<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@end

@implementation DocumentTypeView
{
    UICollectionView *dataCollectionView;
    NSInteger selectIndex;
    
}

@synthesize documentTypeStatus;

- (instancetype)initWithFrame:(CGRect)frame status:(DocumentTypeStatus)status
{
   
    if (self = [super initWithFrame:frame]) {
        selectIndex = 100;
        documentTypeStatus = status;
        self.layer.borderColor = TEXT_COLOR_4.CGColor;
        self.layer.borderWidth = 0.2f;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//        APPLOG(@"%f %f",frame.size.width,frame.size.height);
        dataCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) collectionViewLayout:layout];
        dataCollectionView.backgroundColor = [UIColor clearColor];
        dataCollectionView.dataSource = self;
        dataCollectionView.delegate = self;
        dataCollectionView.hidden = YES;
        dataCollectionView.scrollEnabled = NO;
        [dataCollectionView registerClass:[DocumentTypeViewCell class] forCellWithReuseIdentifier:@"DocumentTypeViewCell"];
        [self addSubview:dataCollectionView];
        [self makeStyle];
        if (self.dataArray == nil) {
            
        }
    }
    return self;
}


- (void)makeStyle
{
    if (documentTypeStatus == DocumentTypeEdit) {
        self.backgroundColor = BACKGROUND_COLOR;
//        dataCollectionView.userInteractionEnabled = YES;
    }else{
        self.backgroundColor = WHITE_COLOR;
//        dataCollectionView.userInteractionEnabled = NO;
        dataCollectionView.layer.borderColor = TEXT_COLOR_4.CGColor;
        dataCollectionView.layer.borderWidth = 0.2f;
    }
}


- (void)setSelectType:(NSInteger)key
{
    for (int i = 0; i < self.dataArray.count; i++) {
        NSDictionary *dic = [self.dataArray objectAtIndex:i];
        if (key == [[dic objectForKey:@"key"] integerValue]) {
            selectIndex = i;
            [dataCollectionView reloadData];
            break;
        }
    }
}

#pragma mark -
#pragma mark  UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return  1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger other = 4-fmod(self.dataArray.count, 4);
    return self.dataArray.count+other;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DocumentTypeViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DocumentTypeViewCell" forIndexPath:indexPath];
    cell.documentTypeStatus = self.documentTypeStatus;
    if (indexPath.row < self.dataArray.count) {
        cell.textLabel.hidden = NO;
        NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
        NSString *text = [dic objectForKey:@"text"];
        if (text.length > 2) {
            text = [NSString stringWithFormat:@"%@\n%@",[text substringToIndex:2],[text substringFromIndex:2]];
        }
        cell.textLabel.text = text;
        if (indexPath.row == selectIndex) {
            [cell setSelectStatus:YES];
        }else{
            [cell setSelectStatus:NO];
        }
    }else{
        cell.textLabel.hidden = YES;
    }
    return cell;
}

#pragma mark -
#pragma mark  UICollectionViewDelegate
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float tempWidth = (self.width-3)/4;
    float tempHeight = tempWidth / 3 * 2;
    return  CGSizeMake(tempWidth,tempHeight);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.0;
}

//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(20, 1, 1, 1);
//}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
//{
//    return CGSizeZero;
//}

#pragma mark -
#pragma mark  点击item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.dataArray.count) {
        selectIndex = indexPath.row;
        [collectionView reloadData];
        NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
        if ([self.documentTypeViewDelegate respondsToSelector:@selector(clickDocumentTypeLabel:)]) {
            [self.documentTypeViewDelegate clickDocumentTypeLabel:dic];
        }
    }

}


@end




