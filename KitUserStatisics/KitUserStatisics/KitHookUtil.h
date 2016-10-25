//
//  KitHookUtil.h
//  KitUserStatisics
//
//  Created by lijinhai on 9/1/16.
//  Copyright © 2016 gzkit. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Hook帮助类
 */
@interface KitHookUtil : NSObject
/**
 *  调换函数实现
 *
 *  @param cls              类
 *  @param originalSelector 原函数
 *  @param swizzledSelector 目标函数
 */
+ (void) swizzlingInClass: (Class)cls originalSelector: (SEL)originalSelector swizzledSelector: (SEL)swizzledSelector;
@end
