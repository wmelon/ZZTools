//
//  ZZPhotoPickerChooseElementCell.h
//  JSPhotoSDK
//
//  Created by 刘猛 on 2017/6/2.
//  Copyright © 2017年 刘猛. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZZPhotoPickerAssetModel.h"
#define MarginTop 2
#define ButtonHeight 30
/**
 * 9宫格数据展示页面
*/
@protocol ZZPhotoPickerChooseElementCellDelegate;

@interface ZZPhotoPickerChooseElementCell : UICollectionViewCell

/**数据模型*/
@property (nonatomic ,   weak) ZZPhotoPickerAssetModel *model;

/**type 用于显示控件*/
@property (nonatomic , assign) JSAssetModelSourceType type;
/**选择gif*/
@property (nonatomic , assign) BOOL allowPickingGif;
/**选中照片*/

@property (nonatomic ,   weak) id<ZZPhotoPickerChooseElementCellDelegate> cellDelegate; // 代理属性

@end
///为了优化内存问题,使用代理方法
/*
 * 协议
*/
@protocol ZZPhotoPickerChooseElementCellDelegate <NSObject>

- (void)didClickCellButtonWithButton:(UIButton *)button  ButtonState:(BOOL)state buttonIndex:(NSInteger)currentIndex;

@end
