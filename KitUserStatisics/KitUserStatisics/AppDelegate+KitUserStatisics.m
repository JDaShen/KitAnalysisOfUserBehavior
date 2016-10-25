//
//  AppDelegate+KitUserStatisics.m
//  KitUserStatisics
//
//  Created by lijinhai on 9/7/16.
//  Copyright © 2016 gzkit. All rights reserved.
//

#import "AppDelegate+KitUserStatisics.h"
#import "KitHookUtil.h"
#import "KitUserStatisicsUtil.h"

@implementation AppDelegate (KitUserStatisics)
#pragma mark - load
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [KitHookUtil swizzlingInClass:[self class] originalSelector:@selector(application:didFinishLaunchingWithOptions:) swizzledSelector:@selector(swiz_application:didFinishLaunchingWithOptions:)];
    });
}

#pragma mark - 置换application:didFinishLaunchingWithOptions:
- (BOOL)swiz_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self inject_application:application didFinishLaunchingWithOptions:launchOptions];
    return [self swiz_application:application didFinishLaunchingWithOptions:launchOptions];
}

#pragma mark - 注入代码
- (void) inject_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 压缩用户日志文件
    [[KitUserStatisicsUtil sharedInstance] zipUserStatiscsFile];
    // 发送用户日志压缩文件
    [[KitUserStatisicsUtil sharedInstance] sendUserStatisicsFiles];
    // 启动App信息日志
    // 用户分析信息(类型,时间,内容,备注)
    NSString *contentString = [NSString stringWithFormat:@"%@,%@,%@,%@",
                               @"0",
                               [KitUserStatisicsUtil sharedInstance].currentTimeInterval,
                               NSStringFromClass([self class]),
                               @"启动App"];
    [[KitUserStatisicsUtil sharedInstance] writeUserStatisicsFileString:contentString];
    
}
@end
