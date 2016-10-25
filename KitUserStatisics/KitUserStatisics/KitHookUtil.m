//
//  KitHookUtil.m
//  KitUserStatisics
//
//  Created by lijinhai on 9/1/16.
//  Copyright © 2016 gzkit. All rights reserved.
//

#import "KitHookUtil.h"
#import <objc/message.h>

@implementation KitHookUtil
#pragma mark - 调换函数实现
+ (void) swizzlingInClass: (Class)cls originalSelector: (SEL)originalSelector swizzledSelector: (SEL)swizzledSelector {
    Class class = cls;
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }
    else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}
@end
