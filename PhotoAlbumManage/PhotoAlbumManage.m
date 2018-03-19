//
//  PhotoAlbumManage.m
//  PIFlow
//
//  Created by WangXingNeng on 15/9/22.
//  Copyright © 2015年 Inveno. All rights reserved.
//

#import "PhotoAlbumManage.h"

@implementation AlbumModel
@synthesize group;
@synthesize groupImages;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.groupImages = [NSMutableArray array];
        self.group = [[ALAssetsGroup alloc] init];
    }
    return self;
}

@end



static PhotoAlbumManage *photoAlbumManage = nil;

@interface PhotoAlbumManage ()


@end

@implementation PhotoAlbumManage
@synthesize assetsLibrary;
@synthesize albumArray;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.assetsLibrary      = [[ALAssetsLibrary alloc] init];
        self.albumArray         = [NSMutableArray array];
    }
    return self;
}

+ (PhotoAlbumManage *)shareAlbumManage {
    
    if (photoAlbumManage == nil) {
        photoAlbumManage = [[PhotoAlbumManage alloc] init];
    }
    return photoAlbumManage;
}

#pragma mark - 获取照片中所有相册
-(void)getAssetsGroupOfAllPhotos:(void (^)(NSArray<AlbumModel *> *))albumImages {
    
    [albumArray removeAllObjects];
    
    //执行步骤1
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *albumOpenFailError) {
        //执行步骤6
        albumImages(nil);
    };
    
    //执行步骤2
    ALAssetsLibraryGroupsEnumerationResultsBlock libraryGroupsEnumeration = ^(ALAssetsGroup *group ,BOOL *stop) {
        if (group != nil) {
            //执行步骤4
            //相册名
            long groupType     = [[group valueForProperty:ALAssetsGroupPropertyType] longValue];
            [self filterImageWithGroup:group withResultImages:^(NSArray<ALAsset *> *groupImages) {
                if (groupImages&&groupImages.count) {
                    AlbumModel *album = [[AlbumModel alloc] init];
                    album.group = group;
                    album.groupImages = [NSMutableArray arrayWithArray:groupImages];
                    if (groupType == 16) {//groupType=16是相机胶卷（用户默认拍照相册）
                        [albumArray insertObject:album atIndex:0];
                    } else {
                        [albumArray addObject:album];
                    }
                }
            }];
        } else {
            //执行步骤5
            albumImages(albumArray);
        }
    };
    
    //执行步骤3，用户同意访问照片则执行步骤4，否则执行步骤6
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:libraryGroupsEnumeration failureBlock:failureBlock];
}

#pragma mark - 过滤相册里面的非照片资源
- (void)filterImageWithGroup:(ALAssetsGroup *)group
            withResultImages:(void (^)(NSArray<ALAsset *> *))resultImages {
    //执行步骤1
    NSMutableArray *imageArray = [NSMutableArray array];
    ALAssetsGroupEnumerationResultsBlock groupEnumerAtion = ^(ALAsset *result, NSUInteger index,BOOL *stop) {
        if (result != NULL) {
            //执行步骤3
            //筛选出图片
            if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                [imageArray addObject:result];
            }
        } else {
            //执行步骤4
            //图片筛选完毕
            resultImages(imageArray);
        }
    };
    
    //执行步骤2
    [group enumerateAssetsUsingBlock:groupEnumerAtion];
}

@end
