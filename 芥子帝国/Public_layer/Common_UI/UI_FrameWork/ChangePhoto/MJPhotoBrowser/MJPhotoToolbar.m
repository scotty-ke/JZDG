//
//  MJPhotoToolbar.m
//  FingerNews
//
//  Created by mj on 13-9-24.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MJPhotoToolbar.h"
#import "MJPhoto.h"
#import "MBProgressHUD+Add.h"


@interface MJPhotoToolbar()
{
    // 显示页码
    UILabel *_indexLabel;
    UIButton *_saveImageBtn;
    UITextView *_textView;
    //从相册过来的空间
    UIButton *_centerSaveBtn;
    UILabel *_textLabel;
    UIImageView *_selectNumImageView;
}
@end

@implementation MJPhotoToolbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = TEXT_COLOR_1;
        self.alpha = 0.8;
    }
    return self;
}

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    
    if (_sourceFromAblum) {
        [self makeAblumView];
    }else{
        [self makeCustomView];
    }
}

- (void)makeAblumView
{
    _textLabel = [[UILabel alloc] init];
    _textLabel.font = TEXT_FONT_15;
    _textLabel.frame = CGRectMake(self.width - 74, 10, 64, 44);
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.textColor = TOPCAIL_COLOR;
    _textLabel.text = [NSString stringWithFormat:@"完成(%ld)",_selectNum];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _textLabel.userInteractionEnabled = YES;
    UIGestureRecognizer *finishTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickFinish:)];
    [_textLabel addGestureRecognizer:finishTap];
    [self addSubview:_textLabel];
    
    _centerSaveBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    _centerSaveBtn.titleLabel.font = TEXT_FONT_18;
    [_centerSaveBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 120, 0, 0)];
    _centerSaveBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _centerSaveBtn.center = CGPointMake(SCREEN_WIDTH/2-20, self.height/2);
    [_centerSaveBtn addTarget:self action:@selector(clickSaveBtn:) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:_centerSaveBtn];
}

#pragma mark - 点击完成
- (void)clickFinish:(UIGestureRecognizer *)res
{
    MJPhoto *photo = _photos[_currentPhotoIndex];
    ALAsset *asset = photo.asset;
    BOOL ok = YES;
    for(int i = 0 ;i < _photos.count ; i++){
        MJPhoto *photo = _photos[i];
        ALAsset *asset = photo.asset;
        if (asset.isSelect) {
            ok = NO;
            break;
        }
    }
    if(!asset.isSelect && ok){
        asset.isSelect = !asset.isSelect;
        if ([self.toolBarDelegate respondsToSelector:@selector(clickToolBarALAsset:isSelect:)]) {
            [self.toolBarDelegate clickToolBarALAsset:asset isSelect:asset.isSelect];
        }
    }
    if ([self.toolBarDelegate respondsToSelector:@selector(finishToolBar)]) {
        [self.toolBarDelegate finishToolBar];
    }
}


- (void)makeSaveBtnStatus
{
    MJPhoto *photo = _photos[_currentPhotoIndex];
    ALAsset *asset = photo.asset;
    if (asset.isSelect) {
        [_centerSaveBtn setTitle:@"取消选中" forState:UIControlStateNormal];
        [_centerSaveBtn setImage:[UIImage imageNamed:@"xuan"] forState:UIControlStateNormal];
        [_centerSaveBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 135, 0, 0)];
        [_centerSaveBtn setTitleColor:TOPCAIL_COLOR forState:UIControlStateNormal];
    }else{
        [_centerSaveBtn setTitle:@"选中" forState:UIControlStateNormal];
        [_centerSaveBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 120, 0, 0)];
        [_centerSaveBtn setImage:[UIImage imageNamed:@"weixuan"] forState:UIControlStateNormal];
        [_centerSaveBtn setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
    }
}


- (void)makeCustomView
{
    if (_photos.count > 1) {
        _indexLabel = [[UILabel alloc] init];
        _indexLabel.font = [UIFont boldSystemFontOfSize:20];
        _indexLabel.frame = CGRectMake(0, 50, 320, 44);
        _indexLabel.backgroundColor = [UIColor clearColor];
        _indexLabel.textColor = [UIColor whiteColor];
        _indexLabel.textAlignment = NSTextAlignmentCenter;
        _indexLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:_indexLabel];
    }
    
    // 保存图片按钮
    CGFloat btnWidth = 44;
    _saveImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _saveImageBtn.frame = CGRectMake(20, 50, btnWidth, btnWidth);
    _saveImageBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [_saveImageBtn setImage:[UIImage imageNamed:@"MJPhotoBrowser.bundle/save_icon.png"] forState:UIControlStateNormal];
    [_saveImageBtn setImage:[UIImage imageNamed:@"MJPhotoBrowser.bundle/save_icon_highlighted.png"] forState:UIControlStateHighlighted];
    [_saveImageBtn addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_saveImageBtn];
    
    _textView = [[UITextView alloc] init];
    [_textView setFrame:CGRectMake(0, 0, 320, 50)];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.editable = NO;
    _textView.textAlignment = NSTextAlignmentLeft;
    _textView.textColor = [UIColor whiteColor];
    _textView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self addSubview:_textView];
}

#pragma mark -
#pragma mark  点击保存
- (void)clickSaveBtn:(UIButton *)btn
{
    MJPhoto *photo = _photos[_currentPhotoIndex];
    ALAsset *asset = photo.asset;
    asset.isSelect = !asset.isSelect;
    
    if (asset.isSelect) {
        BOOL add = YES;
        if([self.toolBarDelegate respondsToSelector:@selector(shouldClickToolBarALAsset:isSelect:)]){
            add = [self.toolBarDelegate shouldClickToolBarALAsset:asset isSelect:asset.isSelect];
        }
        if (add) {
            [_centerSaveBtn setTitle:@"取消选中" forState:UIControlStateNormal];
            [_centerSaveBtn setImage:[UIImage imageNamed:@"xuan"] forState:UIControlStateNormal];
            [_centerSaveBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 135, 0, 0)];
            [_centerSaveBtn setTitleColor:TOPCAIL_COLOR forState:UIControlStateNormal];
            _textLabel.text = [NSString stringWithFormat:@"完成(%ld)",++_selectNum];
        }else{
            asset.isSelect = !asset.isSelect;
        }
        if ([self.toolBarDelegate respondsToSelector:@selector(clickToolBarALAsset:isSelect:)] && add) {
            [self.toolBarDelegate clickToolBarALAsset:asset isSelect:asset.isSelect];
        }
    }else{
            [_centerSaveBtn setTitle:@"选中" forState:UIControlStateNormal];
            [_centerSaveBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 120, 0, 0)];
            [_centerSaveBtn setImage:[UIImage imageNamed:@"weixuan"] forState:UIControlStateNormal];
            [_centerSaveBtn setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
            _textLabel.text = [NSString stringWithFormat:@"完成(%ld)",--_selectNum];
        if ([self.toolBarDelegate respondsToSelector:@selector(clickToolBarALAsset:isSelect:)]) {
            [self.toolBarDelegate clickToolBarALAsset:asset isSelect:asset.isSelect];
        }
    }

}

- (void)saveImage
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        MJPhoto *photo = _photos[_currentPhotoIndex];
        UIImageWriteToSavedPhotosAlbum(photo.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    });
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        [MBProgressHUD showSuccess:@"保存失败" toView:nil];
    } else {
        MJPhoto *photo = _photos[_currentPhotoIndex];
        photo.save = YES;
        _saveImageBtn.enabled = NO;
        [MBProgressHUD showSuccess:@"成功保存到相册" toView:nil];
    }
}

- (void)setCurrentPhotoIndex:(NSUInteger)currentPhotoIndex
{
    _currentPhotoIndex = currentPhotoIndex;
    
    if (_sourceFromAblum) {
        [self makeSaveBtnStatus];
    }else{
        // 更新页码
        _indexLabel.text = [NSString stringWithFormat:@"%lu / %lu", _currentPhotoIndex + 1, (unsigned long)_photos.count];
        
        MJPhoto *photo = _photos[_currentPhotoIndex];
        [_textView setText:photo.photoDescription];
        // 按钮
        _saveImageBtn.enabled = photo.image != nil && !photo.save;
    }

}

@end
