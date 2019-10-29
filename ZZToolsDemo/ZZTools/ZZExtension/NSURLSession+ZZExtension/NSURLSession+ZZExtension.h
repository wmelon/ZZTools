//
//  NSURLSessionDownloadTask+ZZExtension.h
//  ZZToolsDemo
//
//  Created by 刘猛 on 2019/9/19.
//  Copyright © 2019 nvZhuangWang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURLSession (ZZExtension)

///
@property (nonatomic, assign) int       zz_index;

///
@property (nonatomic,   copy) NSString  *zz_sourceURL;

@end

NS_ASSUME_NONNULL_END
