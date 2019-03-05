
//
//  ZZPhotoPickerAssetModel.m
//  JSPhotoSDK
//
//  Created by 刘猛 on 2017/6/2.
//  Copyright © 2017年 刘猛. All rights reserved.
//

#import "ZZPhotoPickerConst.h"
#import "IJSExtension.h"
#import "ZZPhotoPickerAssetModel.h"
#import "ZZPhotoPickerImageManager.h"

@implementation ZZPhotoPickerAssetModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{};

+ (instancetype)setAssetModelAsset:(id)asset type:(JSAssetModelSourceType)type timeLength:(NSString *)timeLength {
    ZZPhotoPickerAssetModel *model = [self setAssetModelAsset:asset type:type];
    model.timeLength = timeLength;
    return model;
}

+ (instancetype)setAssetModelAsset:(id)asset type:(JSAssetModelSourceType)type {
    ZZPhotoPickerAssetModel *model = [[ZZPhotoPickerAssetModel alloc] init];
    model.asset = asset;
    model.type = type;
    return model;
}

// 缓存模型的高度
- (CGFloat)assetHeight {
    if (_assetHeight) {
        return _assetHeight;
    }
    CGSize imageSize = [[ZZPhotoPickerImageManager shareManager] photoSizeWithAsset:self.asset];
    if (imageSize.width == 0) {
        return JSScreenHeight;
    }
    CGFloat imageHeight = JSScreenWidth * imageSize.height / imageSize.width;
    if (imageHeight > JSScreenHeight - IJSGStatusBarAndNavigationBarHeight - IJSGTabbarSafeBottomMargin - IJSGNavigationBarHeight) {
        return JSScreenHeight - IJSGStatusBarAndNavigationBarHeight - IJSGTabbarSafeBottomMargin - IJSGNavigationBarHeight;
    }
    return imageHeight;
}

@end
