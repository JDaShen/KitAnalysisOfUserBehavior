//
//  KitDeviceInfo.h
//  KitUserStatisics
//
//  Created by lijinhai on 9/2/16.
//  Copyright © 2016 gzkit. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  设备信息获取类
 */
@interface KitDeviceInfo : NSObject
/** 设备名称 */
@property (nonatomic, copy) NSString *deviceName;
/** 设备型号 */
@property (nonatomic, copy) NSString *deviceModel;
/** 系统名称 */
@property (nonatomic, copy) NSString *systemName;
/** 系统版本 */
@property (nonatomic, copy) NSString *systemVersion;
/** UUID */
@property (nonatomic, copy) NSString *uuid;
/** 应用Version */
@property (nonatomic, copy) NSString *appVersion;
/** 应用Build */
@property (nonatomic, copy) NSString *appBuild;

/**
 *  单例实现
 *
 *  @return DeviceInfo单例对象
 */
+ (instancetype) sharedInstance;
@end
