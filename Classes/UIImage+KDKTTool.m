//
//  UIImage+Tool.m
//  Geehacker
//
//  Created by 王乐乐 on 2017/6/8.
//  Copyright © 2017年 Zhihui. All rights reserved.
//

#import "UIImage+KDKTTool.h"

@implementation UIImage (KDKTTool)


#pragma mark - 绘制
/**
 根据颜色绘制图片
 */
+ (UIImage *)kdkt_imageWithColor:(UIColor *)color size:(CGSize)size{
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    //创建位图上下文，并设置为当前上下文
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //设置填充
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark - 缩放
/**
 缩放图片到指定Size
 */
- (UIImage *)kdkt_scaleImageWithSize:(CGSize)size{
    
    //创建上下文
    UIGraphicsBeginImageContextWithOptions(size, NO,[UIScreen mainScreen].scale);
    
    //绘图
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    //获取新图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

/**
 按比例缩放图片
 */
- (UIImage *)kdkt_scaleImageWithScale:(CGFloat)scale{
    
    if (scale < 0) {
        return self;
    }
    
    CGSize scaleSize = CGSizeMake(self.size.width * scale, self.size.height * scale);
    return [self kdkt_scaleImageWithSize:scaleSize];
}


/**
 缩放图片到指定宽
 */
- (UIImage *)kdkt_scaleImageToTargetWidth:(CGFloat)targetW{
    
    CGSize size = self.size;
    if (size.width <= targetW) {
        return self;
    }
    
    CGFloat scale = targetW / size.width;
    return [self kdkt_scaleImageWithScale:scale];
}

/**
 缩放图片到指定高
 */
- (UIImage *)kdkt_scaleImageToTargetHeight:(CGFloat)targetH{
    
    CGSize size = self.size;
    if (size.height <= targetH) {
        return self;
    }
    
    CGFloat scale = targetH / size.height;
    return [self kdkt_scaleImageWithScale:scale];
}



#pragma mark - 裁剪
- (UIImage *)kdkt_clipImageWithPath:(UIBezierPath *)path bgColor:(UIColor *)bgColor{
    
    CGSize imageSize = self.size;
    CGRect rect = CGRectMake(0, 0, imageSize.width, imageSize.height);
    
    //创建位图上下文
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, [UIScreen mainScreen].scale);
    if (bgColor) {
        UIBezierPath *bgRect = [UIBezierPath bezierPathWithRect:rect];
        [bgColor setFill];
        [bgRect fill];
    }
    //裁剪
    [path addClip];
    //绘制
    [self drawInRect:rect];
    UIImage *clipImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return clipImage;
}

/**
 裁剪圆角图片
 */
- (UIImage *)kdkt_clipImageWithCornerRadius:(CGFloat)cornerRadius bgColor:(UIColor *)bgColor{
    
    CGSize imageSize = self.size;
    CGRect rect = CGRectMake(0, 0, imageSize.width, imageSize.height);
    
    UIBezierPath *roundRectPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
    return [self kdkt_clipImageWithPath:roundRectPath bgColor:bgColor];
}

/**
 从指定的rect裁剪出图片
 */
- (UIImage *)kdkt_clipImageWithRect:(CGRect)rect{
    
    CGFloat scale = self.scale;
    CGImageRef clipImageRef = CGImageCreateWithImageInRect(self.CGImage,
                                                           CGRectMake(rect.origin.x * scale,
                                                                      rect.origin.y  * scale,
                                                                      rect.size.width * scale,
                                                                      rect.size.height * scale));
    
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(clipImageRef)/scale, CGImageGetHeight(clipImageRef)/scale);
    
    
    UIGraphicsBeginImageContextWithOptions(smallBounds.size, YES, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // clipImage是将要绘制的UIImage图片(防止图片上下颠倒)
    CGContextTranslateCTM(context, 0, smallBounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGRectMake(0, 0, smallBounds.size.width, smallBounds.size.height), clipImageRef);
    
    //    CGContextDrawImage(context, smallBounds, clipImageRef);
    UIImage* clipImage = UIGraphicsGetImageFromCurrentImageContext();
    CGImageRelease(clipImageRef);//释放位图对象 否则内存泄漏
    UIGraphicsEndImageContext();
    return clipImage;
}

@end
