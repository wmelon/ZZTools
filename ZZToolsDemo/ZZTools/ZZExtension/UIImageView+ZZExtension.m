//
//  UIImageView+ZZExtension.m
//  ZZToolsDemo
//
//  Created by 刘猛 on 2019/5/31.
//  Copyright © 2019 刘猛. All rights reserved.
//

#import "UIImageView+ZZExtension.h"

#define noDisableVerticalScrollTag 100013
#define noDisableHorizontalScrollTag 100014

@implementation UIImageView (ZZExtension)

///如果其父视图为UIScrollView且tag = 100013(垂直使用) / 100014(水平使用), 则imageView的alpha一直为1.
- (void)setAlpha:(CGFloat)alpha {
    
    if (self.superview.tag == noDisableVerticalScrollTag) {
        if (alpha == 0 && self.autoresizingMask == UIViewAutoresizingFlexibleLeftMargin) {
            if (self.frame.size.width < 10 && self.frame.size.height > self.frame.size.width) {
                UIScrollView *sc = (UIScrollView*)self.superview;
                if (sc.frame.size.height < sc.contentSize.height) {
                    return;
                }
            }
        }
    }
    
    if (self.superview.tag == noDisableHorizontalScrollTag) {
        if (alpha == 0 && self.autoresizingMask == UIViewAutoresizingFlexibleTopMargin) {
            if (self.frame.size.height < 10 && self.frame.size.height < self.frame.size.width) {
                UIScrollView *sc = (UIScrollView*)self.superview;
                if (sc.frame.size.width < sc.contentSize.width) {
                    return;
                }
            }
        }
    }
    
    [super setAlpha:alpha];
    
}

@end
