//
//  UIControl+KitUserStatisics.m
//  KitUserStatisics
//
//  Created by lijinhai on 9/5/16.
//  Copyright © 2016 gzkit. All rights reserved.
//

#import "UIControl+KitUserStatisics.h"
#import "KitHookUtil.h"
#import "KitUserStatisicsUtil.h"

@implementation UIControl (KitUserStatisics)
#pragma mark - load
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 调换函数实现
        [KitHookUtil swizzlingInClass:[self class] originalSelector:@selector(sendAction:to:forEvent:) swizzledSelector:@selector(swiz_sendAction:to:forEvent:)];
    });
}

#pragma mark - 置换sendAction:to:forEvent:
- (void) swiz_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    // 代码注入
    [self inject_sendAction:action to:target forEvent:event];
    // 调回原本的函数
    [self swiz_sendAction:action to:target forEvent:event];
}

#pragma mark - 注入用户分析代码
#pragma mark 注入sendAction中
- (void) inject_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    // 保存用户分析信息
    if ([self isKindOfClass:[UIButton class]]) {
        // UIButton
        // 用户分析信息(类型,时间,内容,备注)
        NSString *contentString = [NSString stringWithFormat:@"%@,%@,%@,%@",
                                   @"100",
                                   [KitUserStatisicsUtil sharedInstance].currentTimeInterval,
                                   [NSString stringWithFormat:@"%@|%@|%@|%ld|%@|%@",
                                    NSStringFromClass([self class]),
                                    NSStringFromClass([target class]),
                                    NSStringFromSelector(action),
                                    (long)self.tag,
                                    NSStringFromCGRect(self.frame),
                                    ((UIButton*)self).titleLabel.text ? ((UIButton*)self).titleLabel.text: @""],
                                   @"UIButton点击事件"];
        [[KitUserStatisicsUtil sharedInstance] writeUserStatisicsFileString:contentString];
    }
    else if ([self isKindOfClass:[UISegmentedControl class]]) {
        // UISegmentedControl
        // 获取选中的标题，没有标题获取index值
        UISegmentedControl *tempSc = (UISegmentedControl*)self;
        NSInteger selectedSegmentIndex = tempSc.selectedSegmentIndex;
        NSString *selectedSegmentTitle = [tempSc titleForSegmentAtIndex:selectedSegmentIndex];
        selectedSegmentTitle = selectedSegmentTitle == nil || selectedSegmentTitle.length == 0 ? [NSString stringWithFormat:@"%ld", selectedSegmentIndex] : selectedSegmentTitle;
        // 用户分析信息(类型,时间,内容,备注)
        NSString *contentString = [NSString stringWithFormat:@"%@,%@,%@,%@",
                                   @"101",
                                   [KitUserStatisicsUtil sharedInstance].currentTimeInterval,
                                   [NSString stringWithFormat:@"%@|%@|%@|%ld|%@|%@",
                                    NSStringFromClass([self class]),
                                    NSStringFromClass([target class]),
                                    NSStringFromSelector(action),
                                    (long)self.tag,
                                    NSStringFromCGRect(self.frame),
                                    selectedSegmentTitle ? selectedSegmentTitle : @""],
                                   @"UISegmentedControl选择事件"];
        [[KitUserStatisicsUtil sharedInstance] writeUserStatisicsFileString:contentString];
    }
    else if ([self isKindOfClass:[UISlider class]]) {
        // UISlider
        // 用户分析信息(类型,时间,内容,备注)
        NSString *contentString = [NSString stringWithFormat:@"%@,%@,%@,%@",
                                   @"102",
                                   [KitUserStatisicsUtil sharedInstance].currentTimeInterval,
                                   [NSString stringWithFormat:@"%@|%@|%@|%ld|%@|%f",
                                    NSStringFromClass([self class]),
                                    NSStringFromClass([target class]),
                                    NSStringFromSelector(action),
                                    (long)self.tag,
                                    NSStringFromCGRect(self.frame),
                                    ((UISlider*)self).value],
                                   @"UISlider选择事件"];
        [[KitUserStatisicsUtil sharedInstance] writeUserStatisicsFileString:contentString];
        
    }
    else if ([self isKindOfClass:[UISwitch class]]) {
        // UISwitch
        // 用户分析信息(类型,时间,内容,备注)
        NSString *contentString = [NSString stringWithFormat:@"%@,%@,%@,%@",
                                   @"102",
                                   [KitUserStatisicsUtil sharedInstance].currentTimeInterval,
                                   [NSString stringWithFormat:@"%@|%@|%@|%ld|%@|%@",
                                    NSStringFromClass([self class]),
                                    NSStringFromClass([target class]),
                                    NSStringFromSelector(action),
                                    (long)self.tag,
                                    NSStringFromCGRect(self.frame),
                                    ((UISwitch*)self).isOn ? @"isOn" : @"isOff"],
                                   @"UISwitch选择事件"];
        [[KitUserStatisicsUtil sharedInstance] writeUserStatisicsFileString:contentString];
    }
    else if ([self isKindOfClass:[UIStepper class]]) {
        // UIStepper
        // 用户分析信息(类型,时间,内容,备注)
        NSString *contentString = [NSString stringWithFormat:@"%@,%@,%@,%@",
                                   @"102",
                                   [KitUserStatisicsUtil sharedInstance].currentTimeInterval,
                                   [NSString stringWithFormat:@"%@|%@|%@|%ld|%@|%f",
                                    NSStringFromClass([self class]),
                                    NSStringFromClass([target class]),
                                    NSStringFromSelector(action),
                                    (long)self.tag,
                                    NSStringFromCGRect(self.frame),
                                    ((UIStepper*)self).value],
                                   @"UIStepper选择事件"];
        [[KitUserStatisicsUtil sharedInstance] writeUserStatisicsFileString:contentString];
    }
    else {
        // 其它
        // 用户分析信息(类型,时间,内容,备注)
        NSString *contentString = [NSString stringWithFormat:@"%@,%@,%@,%@",
                                   @"103",
                                   [KitUserStatisicsUtil sharedInstance].currentTimeInterval,
                                   [NSString stringWithFormat:@"%@|%@|%@|%ld|%@|%@",
                                    NSStringFromClass([self class]),
                                    NSStringFromClass([target class]),
                                    NSStringFromSelector(action),
                                    (long)self.tag,
                                    NSStringFromCGRect(self.frame),
                                    @""],
                                   @"其它UIControl事件"];
        [[KitUserStatisicsUtil sharedInstance] writeUserStatisicsFileString:contentString];
    }
}
@end
