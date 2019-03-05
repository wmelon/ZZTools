//
//  ZZPhotoPickerPreviewLivePhotoView.m
//  JSPhotoSDK
//
//  Created by 刘猛 on 2017/6/15.
//  Copyright © 2017年 刘猛. All rights reserved.
//

#import "ZZPhotoPickerPreviewLivePhotoView.h"
#import <PhotosUI/PhotosUI.h>
#import "ZZPhotoPickerImageManager.h"
#import "ZZPhotoPickerAssetModel.h"
#import "ZZPhotoPickerConst.h"

API_AVAILABLE(ios(9.1))
@interface ZZPhotoPickerPreviewLivePhotoView ()

/**播放视图*/
@property (nonatomic ,   weak) PHLivePhotoView *backLivePhtotoView;
@property(nonatomic ,strong) UIImageView *backImageView;  // 裁剪结束后将不再是动态图

@end

@implementation ZZPhotoPickerPreviewLivePhotoView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _createdUI];
    }
    return self;
}

- (void)_createdUI {
    if (iOS9_1Later) {
        if (@available(iOS 9.1, *)) {
            PHLivePhotoView *backLivePhotoView = [PHLivePhotoView new];
            backLivePhotoView.backgroundColor = [UIColor whiteColor];
            self.backLivePhtotoView = backLivePhotoView;
            self.backLivePhtotoView.userInteractionEnabled = NO;
            [self addSubview:backLivePhotoView];
            
            UIImageView *backImageView =[UIImageView new];
            [backLivePhotoView addSubview:backImageView];
        } else {
            // Fallback on earlier versions
        }
        self.backImageView = _backImageView;
    }
}

- (void)layoutSubviews {
    self.backLivePhtotoView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.backImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

- (void)setAssetModel:(ZZPhotoPickerAssetModel *)assetModel {
    _assetModel = assetModel;
    self.backImageView.image = nil;
    if (iOS9_1Later) {
        if (assetModel.outputPath) {//编辑完成的image 
            NSData *imageData = [NSData dataWithContentsOfURL:assetModel.outputPath];
            self.backImageView.image = [UIImage imageWithData:imageData];
        } else {
            __weak typeof(self) weakSelf = self;
            if (assetModel.imageRequestID) {
                [[PHImageManager defaultManager] cancelImageRequest:assetModel.imageRequestID];  // 取消加载
            }
            if (@available(iOS 9.1, *)) {
                assetModel.imageRequestID = [[ZZPhotoPickerImageManager shareManager] getLivePhotoWithAsset:assetModel.asset photoWidth:JSScreenWidth networkAccessAllowed:YES completion:^(PHLivePhoto *livePhoto, NSDictionary *info) {
                    weakSelf.backLivePhtotoView.livePhoto = livePhoto;
                } progressHandler:^(double progress, NSError *error, BOOL *stop, NSDictionary *info){
                    if (error)
                    {
                        assetModel.imageRequestID = 0;
                    }
                }];
            } else {
                // Fallback on earlier versions
            }
        }
    }
}

- (void)playLivePhotos {
    if (iOS9_1Later) {
        if (@available(iOS 9.1, *)) {
            [self.backLivePhtotoView startPlaybackWithStyle:PHLivePhotoViewPlaybackStyleFull];
        } else {
            // Fallback on earlier versions
        }
    }
}
- (void)stopLivePhotos {
    [self.backLivePhtotoView stopPlayback];
}

@end
