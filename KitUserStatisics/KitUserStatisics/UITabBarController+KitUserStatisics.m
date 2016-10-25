//
//  UITabBarController+KitUserStatisics.m
//  KitUserStatisics
//
//  Created by lijinhai on 9/8/16.
//  Copyright © 2016 gzkit. All rights reserved.
//

#import "UITabBarController+KitUserStatisics.h"
#import "KitHookUtil.h"
#import "KitUserStatisicsUtil.h"

@implementation UITabBarController (KitUserStatisics)
#pragma mark - load
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 调换函数实现
        [KitHookUtil swizzlingInClass:[self class] originalSelector:@selector(setSelectedViewController:) swizzledSelector:@selector(swiz_setSelectedViewController:)];
    });
}

#pragma mark - 置换swiz_setSelectedViewController:
- (void) swiz_setSelectedViewController: (__kindof UIViewController *)selectedViewController {
    // 代码注入
    [self inject_setSelectedViewController:selectedViewController];
    // 调回原本的函数
    [self swiz_setSelectedViewController:selectedViewController];
}

#pragma mark - 注入用户分析代码
#pragma mark 注入setSelectedViewController:中
- (void) inject_setSelectedViewController: (__kindof UIViewController *)selectedViewController {
    // 保存用户分析信息
    // 用户分析信息(类型,时间,内容,备注)
    NSString *contentString = [NSString stringWithFormat:@"%@,%@,%@,%@",
                               @"3",
                               [KitUserStatisicsUtil sharedInstance].currentTimeInterval,
                               NSStringFromClass([selectedViewController class]),
                               @"Tabbar切换ViewController"];
    [[KitUserStatisicsUtil sharedInstance] writeUserStatisicsFileString:contentString];
}
@end
