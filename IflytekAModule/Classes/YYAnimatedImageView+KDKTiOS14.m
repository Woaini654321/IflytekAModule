//
//  YYAnimatedImageView+KDKTiOS14.m
//  KDKTStudentFrameWork
//
//  Created by admin on 2020/10/9.
//  Copyright © 2020 李斌. All rights reserved.
//

#import "YYAnimatedImageView+KDKTiOS14.h"
#import <objc/runtime.h>

@implementation YYAnimatedImageView (KDKTiOS14)

+ (void)load
{
    Method origin = class_getInstanceMethod(self, @selector(displayLayer:));
    Method swizz = class_getInstanceMethod(self, @selector(swizz_displayLayer:));
    method_exchangeImplementations(origin, swizz);
}

- (void)swizz_displayLayer:(CALayer *)layer
{
    //通过变量名称获取类中的实例成员变量
    Ivar ivar = class_getInstanceVariable(self.class, "_curFrame");
    UIImage *_curFrame = object_getIvar(self, ivar);

    if (_curFrame) {
        layer.contents = (__bridge id)_curFrame.CGImage;
    } else {
        if (@available(iOS 14.0, *)) {
            [super displayLayer:layer];
        }
    }
}

@end
