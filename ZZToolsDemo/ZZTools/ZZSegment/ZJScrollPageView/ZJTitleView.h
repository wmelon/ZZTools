//
//  ZJCustomLabel.h
//  ZZToolsDemo
//
//  Created by 刘猛 on 19/5/6.
//  Copyright © 2016年 刘猛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJSegmentStyle.h"

@interface ZJTitleView : UIView

@property (nonatomic, assign) CGFloat currentTransformSx;

@property (nonatomic, assign) TitleImagePosition        imagePosition;

@property (nonatomic, strong) NSString                  *text;
@property (nonatomic, strong) UIColor                   *textColor;
@property (nonatomic, strong) UIFont                    *font;
@property (nonatomic, assign, getter=isSelected) BOOL   selected;

/** 代理方法中推荐只设置下面的属性, 当然上面的属性设置也会有效, 不过建议上面的设置在style里面设置 */
@property (nonatomic, strong) UIImage                   *normalImage;
@property (nonatomic, strong) UIImage                   *selectedImage;

@property (nonatomic, strong, readonly) UIImageView     *imageView;
@property (nonatomic, strong, readonly) UILabel         *label;

- (CGFloat)titleViewWidth;
- (void)adjustSubviewFrame;

@end
