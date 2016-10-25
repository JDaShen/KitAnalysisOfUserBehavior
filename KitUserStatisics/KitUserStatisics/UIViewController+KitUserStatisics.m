//
//  UIViewController+KitUserStatisics.m
//  KitUserStatisics
//
//  Created by lijinhai on 8/31/16.
//  Copyright © 2016 gzkit. All rights reserved.
//

#import "UIViewController+KitUserStatisics.h"
#import "KitHookUtil.h"
#import "KitUserStatisicsUtil.h"

@implementation UIViewController (KitUserStatisics)
#pragma mark - load
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 调换函数实现
        [KitHookUtil swizzlingInClass:[self class] originalSelector:@selector(viewWillAppear:) swizzledSelector:@selector(swiz_viewWillAppear:)];
        [KitHookUtil swizzlingInClass:[self class] originalSelector:@selector(viewWillDisappear:) swizzledSelector:@selector(swiz_viewWillDisappear:)];
    });
}

#pragma mark - 置换viewWillAppear
- (void)swiz_viewWillAppear:(BOOL)animated {
    // 代码注入
    [self inject_viewWillAppear];
    // 调回原本的函数
    [self swiz_viewWillAppear:animated];
}

#pragma mark - 置换viewWillDisappear
- (void)swiz_viewWillDisappear:(BOOL)animated {
    // 代码注入
    [self inject_viewWillDisAppear];
    // 调回原本的函数
    [self swiz_viewWillDisappear:animated];
}

#pragma mark - 注入用户分析代码
#pragma mark 注入viewWillAppear
- (void) inject_viewWillAppear {
    // 保存用户分析信息
    // 用户分析信息(类型,时间,内容,备注)
    NSString *contentString = [NSString stringWithFormat:@"%@,%@,%@,%@",
                               @"1",
                               [KitUserStatisicsUtil sharedInstance].currentTimeInterval,
                               NSStringFromClass([self class]),
                               @"进入ViewController"];
    [[KitUserStatisicsUtil sharedInstance] writeUserStatisicsFileString:contentString];
}

#pragma mark 注入viewWillDisappear
- (void) inject_viewWillDisAppear {
    // 保存用户分析信息
    // 用户分析信息(类型,时间,内容,备注)
    NSString *contentString = [NSString stringWithFormat:@"%@,%@,%@,%@",
                               @"2",
                               [KitUserStatisicsUtil sharedInstance].currentTimeInterval,
                               NSStringFromClass([self class]),
                               @"离开ViewController"];
    [[KitUserStatisicsUtil sharedInstance] writeUserStatisicsFileString:contentString];
}
@end