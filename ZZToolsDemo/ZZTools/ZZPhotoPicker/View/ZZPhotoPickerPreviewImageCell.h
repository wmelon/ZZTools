//
//  ZZPhotoPickerPreviewImageCell.h
//  JSPhotoSDK
//
//  Created by 刘猛 on 2017/6/6.
//  Copyright © 2017年 刘猛. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 * 展示图片视频预览的大cell
*/
#import "ZZPhotoPickerAssetModel.h"
#import "ZZPhotoPickerPreviewVideoView.h"
// 展示用的cell
@protocol ZZPhotoPickerPreviewImageCellDelegate;

@interface ZZPhotoPickerPreviewImageCell : UICollectionViewCell

/**所有的数据*/
@property (nonatomic ,   weak) ZZPhotoPickerAssetModel *assetModel;
/**视频界面*/
@property (nonatomic ,   weak) ZZPhotoPickerPreviewVideoView *videoView;
/**缩放用的scrollview*/
@property (nonatomic , strong) UIScrollView *scrollView;

@property (nonatomic ,   weak) id<ZZPhotoPickerPreviewImageCellDelegate> cellDelegate; // cell的代理方法

- (void)playLivePhotos;
- (void)stopLivePhotos;

@end
///为了优化内存问题,使用代理方法
/*
 * 协议
*/
@protocol ZZPhotoPickerPreviewImageCellDelegate <NSObject>

- (void)didClickCellToHiddenNavigationAndToosWithCell:(ZZPhotoPickerPreviewImageCell *)cell hiddenToolsStatus:(BOOL)hiddenToolsStatus;

@end
