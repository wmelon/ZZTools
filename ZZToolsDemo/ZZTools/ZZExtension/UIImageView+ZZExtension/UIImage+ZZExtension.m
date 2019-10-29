//
//  UIImage+ZZExtension.m
//  ZZToolsDemo
//
//  Created by 刘猛 on 2019/12/26.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "UIImage+ZZExtension.h"

@implementation UIImage (ZZExtension)

- (UIImage *)zz_blurryWithBlurLevel:(CGFloat)blur {
    if (self == nil) {return nil;}
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *ciImage = [CIImage imageWithCGImage:self.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:ciImage forKey:kCIInputImageKey];
    //设置模糊程度
    [filter setValue:@(blur) forKey: @"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef outImage = [context createCGImage: result fromRect:ciImage.extent];
    UIImage * blurImage = [UIImage imageWithCGImage:outImage];
    CGImageRelease(outImage);
    return blurImage;
}

- (UIImage *)zz_circleImage {
    
    // 开始图形上下文
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    
    // 获得图形上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 设置一个范围
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    
    // 根据一个rect创建一个椭圆
    CGContextAddEllipseInRect(ctx, rect);
    
    // 裁剪
    CGContextClip(ctx);
    
    // 将原照片画到图形上下文
    [self drawInRect:rect];
    
    // 从上下文上获取剪裁后的照片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (NSData *)zz_getDataWithMaxM:(CGFloat)M {
    
    NSData *data1;

    
    if ([[self zz_getImageFormat] isEqualToString:@"jpg"]) {
        data1 = UIImageJPEGRepresentation(self, 1.0);
    } else {
        data1 = UIImagePNGRepresentation(self);
    }
    
    CGFloat f = 1;
    if (data1.length/1024/1024.0 > M) {
        f = data1.length/1024/1024.0 / (M - 0.0001);f = 1 / f;
    }
    
    NSData *data;//UIImageJPEGRepresentation(self, f);
    
    if ([[self zz_getImageFormat] isEqualToString:@"jpg"]) {
        data = UIImageJPEGRepresentation(self, f);
    } else {
        data = UIImagePNGRepresentation(self);
    }
    
    //NSLog(@"data.len === %f",data.length/1024/1024.0);
    
    return data;
    
}
    
- (NSString *)zz_getImageFormat {
    NSData *data1 = UIImageJPEGRepresentation(self, 1);
    uint8_t c;[data1 getBytes:&c length:1];
    
    switch (c) {
            
        case 0xFF:
            
            return @"jpg";
            
        case 0x89:
            
            return @"png";
            
        case 0x47:
            
            return @"gif";
            
        case 0x49:
            
        case 0x4D:
            
            return @"tiff";
            
    }
    
    return nil;
    
}

+ (UIImage*)imageWithColor:(UIColor*)color {
    
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return theImage;
}


@end
