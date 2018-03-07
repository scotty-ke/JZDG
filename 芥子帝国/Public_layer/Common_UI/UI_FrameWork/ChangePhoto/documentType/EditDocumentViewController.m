//
//  EditDocumentViewController.m
//  easydoctor
//
//  Created by stone on 15/11/20.
//  Copyright © 2015年 easygroup. All rights reserved.
//

#import "EditDocumentViewController.h"
#import "DocumentTypeView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "Document.h"
#import "DQAlertView.h"


@implementation PhotoCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _phpImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _phpImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:_phpImageView];
        UIImage *checkedIcon = [UIImage imageNamed:@"shang"];
        UIImageView *selectView=[[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width-checkedIcon.size.width - 5,5, checkedIcon.size.width, checkedIcon.size.height)];
        [selectView setImage:checkedIcon];
        selectView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickDelet:)];
        [selectView addGestureRecognizer:tap];
        [_phpImageView addSubview:selectView];
    }
    return self;
}


- (void)clickDelet:(UIGestureRecognizer *)res
{
    if ([self.photoCellctionCellDelegate respondsToSelector:@selector(clickDeletPhoto:)]) {
        [self.photoCellctionCellDelegate clickDeletPhoto:self.tag];
    }
}

@end


@interface EditDocumentViewController ()<DocumentTypeViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,PhotoCollectionCellDelegate>

@end

@implementation EditDocumentViewController
{
    DocumentTypeView *docTypeView;
    UIButton *_rightButton;
    UICollectionView *photoCollectionView;
    NSDictionary *labelDic;//选中的标签
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择图片类型";

    [self setNavigationBar];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    photoCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 2, SCREEN_WIDTH, SCREEN_HEIGHT - TABBAR_HEIGHT-NAVIGATOR_HEIGHT) collectionViewLayout:layout];
    photoCollectionView.backgroundColor = BACKGROUND_COLOR;
    photoCollectionView.dataSource = self;
    photoCollectionView.delegate = self;
    [photoCollectionView registerClass:[PhotoCollectionCell class] forCellWithReuseIdentifier:@"PhotoCollectionCell"];
    [self.view addSubview:photoCollectionView];
    
    float tempWidth = (SCREEN_WIDTH-3)/4;
    float tempHeight = tempWidth / 3 * 2 * 3;
    docTypeView = [[DocumentTypeView alloc] initWithFrame:CGRectMake(0, self.view.height - tempHeight-NAVIGATOR_HEIGHT, SCREEN_WIDTH, tempHeight) status:DocumentTypeEdit];
    docTypeView.documentTypeViewDelegate = self;
    [self.view addSubview:docTypeView];

}

- (void)setNavigationBar
{
    UIButton *leftButton = [[UIButton alloc]init];
    
    leftButton.frame = CGRectMake(0, 0, 30, 40);
    
    leftButton.titleLabel.font = TEXT_FONT_15;
    
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    [leftButton sizeToFit];
    [leftButton setTitleColor:TEXT_COLOR_1
                     forState:UIControlStateNormal];
    
    [leftButton addTarget:self
                   action:@selector(popOrDismiss:)
         forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    
    _rightButton = [[UIButton alloc]init];
    
    _rightButton.frame = CGRectMake(0, 0, 30, 40);
    
    _rightButton.titleLabel.font = TEXT_FONT_15;
    
    [_rightButton setTitle:@"完成"
                  forState:UIControlStateNormal];
    
    [_rightButton setTitleColor:TEXT_COLOR_4
                       forState:UIControlStateNormal];
    
    [_rightButton sizeToFit];
    
    [_rightButton addTarget:self
                     action:@selector(subMit)
           forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_rightButton];
    
    self.navigationItem.rightBarButtonItem.enabled = NO;

}

#pragma mark -
#pragma mark  UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return  1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCollectionCell" forIndexPath:indexPath];
    cell.photoCellctionCellDelegate = self;
    NSObject *object = [_assets objectAtIndex:indexPath.row];
    if ([object isKindOfClass:[UIImage class]]) {
        cell.phpImageView.image = (UIImage *)object;
    }else{
        ALAsset *asset = (ALAsset *)object;
        cell.phpImageView.image = [UIImage imageWithCGImage:[asset thumbnail]];
    }
    cell.tag = indexPath.row;
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
    float tempWidth = (self.view.width-3)/4;
//    float tempHeight = tempWidth / 3 * 2;
    return  CGSizeMake(tempWidth,tempWidth);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.0;
}

#pragma mark -
#pragma mark  PhotoCollectionCellDelegate 删除
- (void)clickDeletPhoto:(NSInteger)index
{
    if(_assets.count == 1){
        
//        AppAlertViewController *alert = [[AppAlertViewController alloc] initWithParentController:self];
//        [alert showAlert:nil message:@"请至少上传1张照片" sureTitle:nil cancelTitle:@"确定" sure:nil cancel:nil];
//        return;
        DQAlertView * alertView = [[DQAlertView alloc] initWithTitle:nil message:@"请至少上传1张照片" cancelButtonTitle:nil otherButtonTitle:@"确定"];
        alertView.messageLabel.font = TEXT_FONT_17;
//        alertView.messageBottomPadding = 10;
        [alertView show];
        return;
    }
    [_assets removeObjectAtIndex:index];
    [photoCollectionView reloadData];
    if (_assets.count == 0) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
        [_rightButton setTitleColor:TEXT_COLOR_4
                           forState:UIControlStateNormal];
    }
}


#pragma mark -
#pragma mark  保存
- (void)subMit
{
    
    if ([self.editDocumentDelegate respondsToSelector:@selector(clickFinishEdit:)]) {
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:_assets.count];
        for (int i = 0; i < _assets.count; i++) {
            Document *document = [[Document alloc] init];
            document.photo = [_assets objectAtIndex:i];
            document.key = [[labelDic objectForKey:@"key"] integerValue];
            document.text = [labelDic objectForKey:@"text"];
            [array addObject:document];
        }
        [self.editDocumentDelegate clickFinishEdit:array];
        
    }
    [self.navigationController popViewControllerAnimated:NO];
}


#pragma mark -
#pragma mark  DocumentTypeViewDelegate
- (void)clickDocumentTypeLabel:(id)documentType
{
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [_rightButton setTitleColor:TOPCAIL_COLOR
                       forState:UIControlStateNormal];
    labelDic = documentType;
}

-(void)popOrDismiss:(UIButton*)buuton
{
    if (self.navigationController.viewControllers.count == 1)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
