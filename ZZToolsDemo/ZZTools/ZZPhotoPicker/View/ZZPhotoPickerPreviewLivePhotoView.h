//
//  ZZPhotoPickerPreviewLivePhotoView.h
//  JSPhotoSDK
//
//  Created by 刘猛 on 2017/6/15.
//  Copyright © 2017年 shan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZZPhotoPickerAssetModel;

@interface ZZPhotoPickerPreviewLivePhotoView : UIView

/**数据模型*/
@property (nonatomic ,   weak) ZZPhotoPickerAssetModel *assetModel;

/**
 *  播放
*/
- (void)playLivePhotos;
- (void)stopLivePhotos;

@end
