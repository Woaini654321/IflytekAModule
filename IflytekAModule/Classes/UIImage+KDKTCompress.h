//
//  UIImage+KDKTCompress.h
//  KDKTStudentFrameWork
//
//  Created by sunlunmao on 2020/7/16.
//  Copyright © 2020 李斌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (KDKTCompress)

/**
 图片压缩+图片方向调整
 */
+ (NSData *)kdkt_compressWithImage:(UIImage *)image;
/**
 图片压缩+图片方向调整+图片名称
 */
+ (NSData *)kdkt_compressWithImage:(UIImage *)image withCustomImage:(NSString *)imageName;

@end

NS_ASSUME_NONNULL_END
