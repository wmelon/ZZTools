//
//  UIImageView+ZZExtension.h
//  HDStore
//
//  Created by 刘猛 on 2018/2/5.
//  Copyright © 2018年 刘猛. All rights reserved.
//
//  类别,具体用法查看具体公开方法的单独注释
//

#import <UIKit/UIKit.h>

@interface UIImageView (ZZExtension)

/// 快速创建imageView
- (instancetype)initWithImage:(NSString *)imageName superView:(UIView *)superView;

@end
