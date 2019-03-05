//
//  ZZPhotoPickerAlbumPickerCell.h
//  JSPhotoSDK
//
//  Created by 刘猛 on 2017/5/29.
//  Copyright © 2017年 shan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZPhotoPickerAlbumModel.h"
/*
 * 相册列表的cell
*/

@interface ZZPhotoPickerAlbumPickerCell : UITableViewCell

/**展示数据*/
@property (nonatomic ,   weak) ZZPhotoPickerAlbumModel *models;

@end
