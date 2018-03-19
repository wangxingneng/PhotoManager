//
//  PhotoAlbumManage.h
//  PIFlow
//
//  Created by WangXingNeng on 15/9/22.
//  Copyright © 2015年 Inveno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>


@interface AlbumModel : NSObject

@property (strong, nonatomic) ALAssetsGroup *group;//相册
@property (strong, nonatomic) NSMutableArray<ALAsset *> *groupImages;//相册中的照片

@end


@interface PhotoAlbumManage : NSObject

@property (strong, nonatomic) ALAssetsLibrary *assetsLibrary;
@property (strong, nonatomic) NSMutableArray *albumArray;//object为相册照片数组，key为相册名称

+ (PhotoAlbumManage *)shareAlbumManage;

/**
 *  获取照片中的相册组
 *
 *  @param photoGroup 相册组
 */
- (void)getAssetsGroupOfAllPhotos:(void (^)(NSArray<AlbumModel *>* albumImages))albumImages;


/**
 *  筛选指定相册中的资源，仅保留照片
 *
 *  @param group        指定的相册
 *  @param resultImages 筛选完成后指定相册中的图片
 */
- (void)filterImageWithGroup:(ALAssetsGroup *)group
            withResultImages:(void (^)(NSArray<ALAsset *>* groupImages))resultImages;

@end
