//
//  KitUserStatisicsUtil.h
//  KitUserStatisics
//
//  Created by lijinhai on 9/5/16.
//  Copyright © 2016 gzkit. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  用户分析帮助类
 */
@interface KitUserStatisicsUtil : NSObject<NSURLSessionDelegate>
/** 当前时间戳 */
@property (nonatomic, copy)  NSString * _Nullable currentTimeInterval;

/**
 *  单例实现
 *
 *  @return UserStatisicsUtil单例对象
 */
+ (_Nonnull instancetype) sharedInstance;

/**
 *  写入用户分析日志内容到文件中
 *
 *  @param contentString 用户分析日志内容
 *
 *  @return 写入成功与否
 */
- (BOOL) writeUserStatisicsFileString: (NSString* _Nonnull)contentString;

/**
 *  压缩昨天及之前的用户分析日志文件
 */
- (void) zipUserStatiscsFile;

/**
 *  发送用户分析日志压缩文件
 */
- (void) sendUserStatisicsFiles;
@end
