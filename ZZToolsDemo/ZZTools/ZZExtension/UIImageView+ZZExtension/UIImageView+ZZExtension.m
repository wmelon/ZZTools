//
//  UIImageView+ZZExtension.m
//  ZZToolsDemo
//
//  Created by 刘猛 on 2018/2/5.
//  Copyright © 2018年 刘猛. All rights reserved.
//

#import "SDAutoLayout.h"
#import "UIImageView+ZZExtension.h"

@implementation UIImageView (ZZExtension)

- (instancetype)initWithImage:(NSString *)imageName superView:(UIView *)superView {
    if (self == [super init]) {
        [superView addSubview:self];UIImage *image = [UIImage imageNamed:imageName];
        //self.image = image;self.sd_layout.widthIs(image.size.width).heightIs(image.size.height);
        if (UIScreen.mainScreen.bounds.size.width <= 320) {//5s尺寸及一下c尺寸
            self.image = image;self.sd_layout.widthIs(image.size.width * 320 / 375).heightIs(image.size.height * 320 / 375);
        } else {
            self.image = image;self.sd_layout.widthIs(image.size.width).heightIs(image.size.height);
        }
        
    }
    return self;
}

@end
