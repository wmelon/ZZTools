//
//  ZZCollectionFooterView.m
//  ZZToolsDemo
//
//  Created by 刘猛 on 2019/2/3.
//  Copyright © 2019年 刘猛. All rights reserved.
//

#import "ZZCollectionFooterView.h"

@implementation ZZCollectionFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.label = [[UILabel alloc] initWithFrame:self.bounds];
        [self addSubview:self.label];
        self.backgroundColor = [UIColor yellowColor];
    }
    return self;
}

@end
