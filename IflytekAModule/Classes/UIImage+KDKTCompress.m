//
//  UIImage+KDKTCompress.m
//  KDKTStudentFrameWork
//
//  Created by sunlunmao on 2020/7/16.
//  Copyright © 2020 李斌. All rights reserved.
//

#import "UIImage+KDKTCompress.h"

@implementation UIImage (KDKTCompress)

static char isCustomImage;
static char customImageName;

+ (NSData *)kdkt_compressWithImage:(UIImage *)image {
    
    double size;
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    
    NSLog(@"Image data size before compressed == %f Kb",imageData.length/1024.0);
    
    int fixelW = (int)image.size.width;
    int fixelH = (int)image.size.height;
    int thumbW = fixelW % 2  == 1 ? fixelW + 1 : fixelW;
    int thumbH = fixelH % 2  == 1 ? fixelH + 1 : fixelH;
    
    double scale = ((double)fixelW/fixelH);
    
    if (scale <= 1 && scale > 0.5625) {
        
        if (fixelH < 1664) {
            if (imageData.length/1024.0 < 150) {
                return imageData;
            }
            size = (fixelW * fixelH) / pow(1664, 2) * 150;
            size = size < 60 ? 60 : size;
        }
        else if (fixelH >= 1664 && fixelH < 4990) {
            thumbW = fixelW / 2;
            thumbH = fixelH / 2;
            size   = (thumbH * thumbW) / pow(2495, 2) * 300;
            size = size < 60 ? 60 : size;
        }
        else if (fixelH >= 4990 && fixelH < 10240) {
            thumbW = fixelW / 4;
            thumbH = fixelH / 4;
            size = (thumbW * thumbH) / pow(2560, 2) * 300;
            size = size < 100 ? 100 : size;
        }
        else {
            int multiple = fixelH / 1280 == 0 ? 1 : fixelH / 1280;
            thumbW = fixelW / multiple;
            thumbH = fixelH / multiple;
            size = (thumbW * thumbH) / pow(2560, 2) * 300;
            size = size < 100 ? 100 : size;
        }
    }
    else if (scale <= 0.5625 && scale > 0.5) {
        
        if (fixelH < 1280 && imageData.length/1024 < 200) {
            
            return imageData;
        }
        int multiple = fixelH / 1280 == 0 ? 1 : fixelH / 1280;
        thumbW = fixelW / multiple;
        thumbH = fixelH / multiple;
        size = (thumbW * thumbH) / (1440.0 * 2560.0) * 400;
        size = size < 100 ? 100 : size;
    }
    else {
        int multiple = (int)ceil(fixelH / (1280.0 / scale));
        thumbW = fixelW / multiple;
        thumbH = fixelH / multiple;
        size = ((thumbW * thumbH) / (1280.0 * (1280 / scale))) * 500;
        size = size < 100 ? 100 : size;
    }
    return [self compressWithImage:image thumbW:thumbW thumbH:thumbH size:size];
}

+ (NSData *)kdkt_compressWithImage:(UIImage *)image withCustomImage:(NSString *)imageName {
    
    if (imageName) {
        objc_setAssociatedObject(self, &isCustomImage, @(1), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(self, &customImageName, imageName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return [self kdkt_compressWithImage:image];
}

+ (NSData *)compressWithImage:(UIImage *)image thumbW:(int)width thumbH:(int)height size:(double)size {
    
    UIImage *thumbImage = [image fixOrientation];
    thumbImage = [thumbImage resizeImage:image thumbWidth:width thumbHeight:height];
    
    int qualityCompress = 1.0;
    
    NSData *imageData = UIImageJPEGRepresentation(thumbImage, qualityCompress);
    
    NSUInteger lenght = imageData.length;
    while (lenght / 1024 > size && qualityCompress > 0.06) {
        
        qualityCompress -= 0.06;
        imageData    = UIImageJPEGRepresentation(thumbImage, qualityCompress);
        lenght     = imageData.length;
        thumbImage = [UIImage imageWithData:imageData];
    }
//    NSString *path = NSTemporaryDirectory();
//    NSString *fileName = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",@"left_10"]];
//
//    [UIImageJPEGRepresentation(thumbImage,1.0) writeToFile:fileName atomically:YES];
//    NSLog(@"%@",path);
    NSLog(@"Image data size after compressed ==%f kb",imageData.length/1024.0);
    
    
    return imageData;
}

// specify the size
- (UIImage *)resizeImage:(UIImage *)image thumbWidth:(int)width thumbHeight:(int)height {
    
    int outW = (int)image.size.width;
    int outH = (int)image.size.height;
    
    int inSampleSize = 1;
    
    if (outW > width || outH > height) {
        int halfW = outW / 2;
        int halfH = outH / 2;
        
        while ((halfH / inSampleSize) > height && (halfW / inSampleSize) > width) {
            inSampleSize *= 2;
        }
    }
    int heightRatio = (int)ceil(outH / (float) height);
    int widthRatio  = (int)ceil(outW / (float) width);
    
    if (heightRatio > 1 || widthRatio > 1) {
        
        inSampleSize = heightRatio > widthRatio ? heightRatio : widthRatio;
    }
    CGSize thumbSize = CGSizeMake((NSUInteger)((CGFloat)outW/widthRatio), (NSUInteger)((CGFloat)outH/heightRatio));
    
    UIGraphicsBeginImageContext(thumbSize);
    
    [image drawInRect:CGRectMake(0, 0, thumbSize.width, thumbSize.height)];

    NSNumber *iscustom = objc_getAssociatedObject(self, &isCustomImage);
    BOOL      isCustom = [iscustom boolValue];
    if (isCustom) {
        NSString *imageName = objc_getAssociatedObject(self, &customImageName);
        UIImage *imageMask = [UIImage imageNamed:imageName];
        if (imageMask) {
            [imageMask drawInRect:CGRectMake(0, 0, thumbSize.width, thumbSize.height)];
        }
    }
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    objc_setAssociatedObject(self, &isCustomImage, @(NO), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    return resultImage;
}

- (UIImage *)fixOrientation {
    
    UIImageOrientation imageOrientation = self.imageOrientation;
    CGFloat imageWidth = self.size.width;
    CGFloat imageHeight = self.size.height;
    CGImageRef cgImage = self.CGImage;
    
    if (imageOrientation == UIImageOrientationUp) return self;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, imageWidth, imageHeight);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, imageWidth, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, imageHeight);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    switch (imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, imageWidth, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, imageHeight, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    CGContextRef ctx = CGBitmapContextCreate(NULL, imageWidth, imageHeight,
                                             CGImageGetBitsPerComponent(cgImage), 0,
                                             CGImageGetColorSpace(cgImage),
                                             CGImageGetBitmapInfo(cgImage));
    CGContextConcatCTM(ctx, transform);
    switch (imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,imageHeight,imageWidth), cgImage);
            break;
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,imageWidth,imageHeight), cgImage);
            break;
    }
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

@end
