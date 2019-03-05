//
//  ZZPhotoPickerPreviewVideoView.h
//  JSPhotoSDK
//
//  Created by 刘猛 on 2017/6/15.
//  Copyright © 2017年 shan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@class ZZPhotoPickerAssetModel;

@interface ZZPhotoPickerPreviewVideoView : UIView

/**数据模型*/
@property (nonatomic ,   weak) ZZPhotoPickerAssetModel *assetModel;

@property (nonatomic , strong) AVPlayer *player;         /**视频播放器*/
@property (nonatomic ,   weak) UIButton *playButton;       /**中间播放的按钮,按钮不可以点击当做一个UIView*/
@property (nonatomic ,   weak) UIImageView *backVideoView; /**播放视频的界面*/

@end
