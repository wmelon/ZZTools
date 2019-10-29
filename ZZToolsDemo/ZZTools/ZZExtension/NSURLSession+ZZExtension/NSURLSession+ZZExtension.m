//
//  NSURLSessionDownloadTask+ZZExtension.m
//  GoodsHunter
//
//  Created by 刘猛 on 2019/9/19.
//  Copyright © 2019 nvZhuangWang. All rights reserved.
//

static char ZZ_INDEX;
static char ZZ_SOURCE_URL;

#import <objc/message.h>
#import "NSURLSession+ZZExtension.h"

@implementation NSURLSession (ZZExtension)

-(void)setZz_index:(int)zz_index {
    objc_setAssociatedObject(self, &ZZ_INDEX, @(zz_index), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (int)zz_index {
    return [objc_getAssociatedObject(self, &ZZ_INDEX) intValue];
}

- (void)setZz_sourceURL:(NSString *)zz_sourceURL {
    objc_setAssociatedObject(self, &ZZ_SOURCE_URL, zz_sourceURL, OBJC_ASSOCIATION_COPY);
}

- (NSString *)zz_sourceURL {
    return objc_getAssociatedObject(self, &ZZ_SOURCE_URL);
}

@end
