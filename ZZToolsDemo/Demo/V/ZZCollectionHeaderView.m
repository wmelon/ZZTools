//
//  ZZCollectionHeaderView.m
//  ZZProjectOC
//
//  Created by 刘猛 on 2019/1/10.
//  Copyright © 2019 刘猛. All rights reserved.
//

#import "ZZCollectionHeaderView.h"

@implementation ZZCollectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.label = [[UILabel alloc] initWithFrame:self.bounds];
        [self addSubview:self.label];
        self.backgroundColor = [UIColor yellowColor];
    }
    return self;
}

@end
