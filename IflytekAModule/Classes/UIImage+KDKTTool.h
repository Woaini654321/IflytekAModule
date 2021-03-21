//
//  UIImage+Tool.h
//  Geehacker
//
//  Created by 王乐乐 on 2017/6/8.
//  Copyright © 2017年 Zhihui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (KDKTTool)

#pragma mark - 绘制
/**
 根据颜色绘制图片
 */
+ (UIImage *)kdkt_imageWithColor:(UIColor *)kdkt_color size:(CGSize)size;


#pragma mark - 缩放
/**
 缩放图片到指定Size
 */
- (UIImage *)kdkt_scaleImageWithSize:(CGSize)size;

/**
 按比例缩放图片，scale就是缩放比例
 */
- (UIImage *)kdkt_scaleImageWithScale:(CGFloat)scale;

/**
 缩放图片到指定宽
 */
- (UIImage *)kdkt_scaleImageToTargetWidth:(CGFloat)targetW;

/**
 缩放图片到指定高
 */
- (UIImage *)kdkt_scaleImageToTargetHeight:(CGFloat)targetH;


#pragma mark - 裁剪

/**
 裁剪出圆角矩形
 
 @param cornerRadius 圆角半径
 @param kdkt_bgColor 背景色
 */
- (UIImage *)kdkt_clipImageWithCornerRadius:(CGFloat)cornerRadius bgColor:(UIColor *)kdkt_bgColor;

/**
 根据贝塞尔路径来裁剪
 */
- (UIImage *)kdkt_clipImageWithPath:(UIBezierPath *)kdkt_path bgColor:(UIColor *)kdkt_bgColor;

/**
 从指定的rect裁剪出图片
 */
- (UIImage *)kdkt_clipImageWithRect:(CGRect)rect;

@end
