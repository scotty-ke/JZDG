//
//  Document.h
//  easydoctor
//
//  Created by stone on 15/11/20.
//  Copyright © 2015年 easygroup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface Document : NSObject

@property(nonatomic,strong) NSObject *photo;// maybe is UIImage or ALAsset
@property(nonatomic,copy) NSString *text;
@property(nonatomic,assign) NSInteger key;//文档类型
@property(nonatomic,copy) NSString *docFormat;//13 jpg
@property(nonatomic,copy) NSString *docName;//文档名称
@property(nonatomic,assign) NSInteger docContent;//文档 内容 fileId


@end
