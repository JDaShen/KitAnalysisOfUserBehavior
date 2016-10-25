//
//  KitUserStatisicsUtil.m
//  KitUserStatisics
//
//  Created by lijinhai on 9/5/16.
//  Copyright © 2016 gzkit. All rights reserved.
//

#import "KitUserStatisicsUtil.h"
#import "KitDeviceInfo.h"
#import "SSZipArchive.h"
#import "AFNetworking.h"

// 文件管理者
#define USU_FILE_MANAGER [NSFileManager defaultManager]
// sandbox中documents文件夹路径
#define USU_SANDBOX_DOCUMENTS_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
// 用户分析日志存储文件夹名
#define USU_USER_STATISICS_DIRECTORY_NAME @"userStatisics"
// 用户分析日志存储文件夹路径
#define USU_USER_STATISICS_DIRECTORY_PATH [USU_SANDBOX_DOCUMENTS_PATH stringByAppendingPathComponent:USU_USER_STATISICS_DIRECTORY_NAME]
// 用户分析日志文件路径
#define USU_USER_STATISICS_FILE_PATH(DATE_PREFIX) [USU_USER_STATISICS_DIRECTORY_PATH stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_userStatisics_%@.log", DATE_PREFIX, [KitDeviceInfo sharedInstance].uuid]]
// 用户分析日志zip文件路径
#define USU_USER_STATISICS_ZIP_PATH(DATE_PREFIX) [USU_USER_STATISICS_DIRECTORY_PATH stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_userStatisics_%@.zip", DATE_PREFIX, [KitDeviceInfo sharedInstance].uuid]]

/* 单例对象 */
static KitUserStatisicsUtil *sharedUserStatisicsUtil = nil;

@implementation KitUserStatisicsUtil

#pragma mark - 单例实现
+ (_Nonnull instancetype) sharedInstance {
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedUserStatisicsUtil = [[self alloc] init];
        NSLog(@"filepath: %@", USU_USER_STATISICS_DIRECTORY_PATH);
    });
    return sharedUserStatisicsUtil;
}

#pragma mark - 当前时间戳
- (NSString *)currentTimeInterval {
    return [NSString stringWithFormat:@"%.f", [[NSDate date] timeIntervalSince1970]];
}

#pragma mark - 当前日期
- (NSString*)currentDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter stringFromDate:[NSDate date]];
}

#pragma mark - 昨天日期
- (NSString*)yestedayDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:-24*60*60]];
}


#pragma mark - 写入用户分析日志内容到文件中
- (BOOL) writeUserStatisicsFileString: (NSString*)contentString {
    if (contentString == nil || contentString.length == 0) {
        return NO;
    }
    if (![USU_FILE_MANAGER fileExistsAtPath:USU_USER_STATISICS_DIRECTORY_PATH]) {
        if (![USU_FILE_MANAGER createDirectoryAtPath:USU_USER_STATISICS_DIRECTORY_PATH withIntermediateDirectories:YES attributes:nil error:nil]) {
            // 创建文件夹失败
            return NO;
        }
    }
    
    // 获取当日日期，一日只会产生一个用户分析日志文件
    NSString *currentDate = [self currentDate];
    
    if (![USU_FILE_MANAGER fileExistsAtPath:USU_USER_STATISICS_FILE_PATH(currentDate)]) {
        // 新建日志文件，写入初始化数据（设备名称,设备型号,系统名称,系统版本,UUID,应用版本,应用Build值）
        NSString *initString = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@",
                                [KitDeviceInfo sharedInstance].deviceName,
                                [KitDeviceInfo sharedInstance].deviceModel,
                                [KitDeviceInfo sharedInstance].systemName,
                                [KitDeviceInfo sharedInstance].systemVersion,
                                [KitDeviceInfo sharedInstance].uuid,
                                [KitDeviceInfo sharedInstance].appVersion,
                                [KitDeviceInfo sharedInstance].appBuild];
        if (![USU_FILE_MANAGER createFileAtPath:USU_USER_STATISICS_FILE_PATH(currentDate) contents:[initString dataUsingEncoding:NSUTF8StringEncoding] attributes:nil]) {
            return NO;
        }
    }
    // 用户分析日志内容插入文件尾部
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:USU_USER_STATISICS_FILE_PATH(currentDate)];
    [fileHandle seekToEndOfFile];       // 将节点跳到文件的末尾
    [fileHandle writeData:[[NSString stringWithFormat:@"\n%@", contentString] dataUsingEncoding:NSUTF8StringEncoding]];         // 追加写入数据
    [fileHandle closeFile];             // 关闭文件
    return YES;
}

#pragma mark - 压缩昨天及之前的用户分析日志文件
- (void) zipUserStatiscsFile {
    NSArray *subpaths = [USU_FILE_MANAGER subpathsAtPath:USU_USER_STATISICS_DIRECTORY_PATH];
    NSMutableArray *zippaths = [[NSMutableArray alloc] init];
    if (subpaths == nil || [subpaths count] == 0) {
        return ;
    }
    else {
        // 保存完整路径，并去除隐藏文件、当天的用户行为分析文件和zip后缀文件
        for (NSString *tempsubpath in subpaths) {
            if (![@".DS_Store" isEqualToString:tempsubpath] && [tempsubpath rangeOfString:[self currentDate]].location == NSNotFound) {
                if ([tempsubpath rangeOfString:@"zip"].location == NSNotFound) {
                    [zippaths addObject:[USU_USER_STATISICS_DIRECTORY_PATH stringByAppendingPathComponent:tempsubpath]];
                }
                else {
                    [USU_FILE_MANAGER removeItemAtPath:[USU_USER_STATISICS_DIRECTORY_PATH stringByAppendingPathComponent:tempsubpath] error:nil];
                }
            }
        }
    }
    // 压缩昨天之前的所有用户行为分析文件
    if ([zippaths count] != 0) {
        [SSZipArchive createZipFileAtPath:USU_USER_STATISICS_ZIP_PATH([self yestedayDate]) withFilesAtPaths:zippaths];
    }
}

#pragma mark - 发送昨天及之前的用户分析日志压缩文件
- (void) sendUserStatisicsFiles {
    if ([USU_FILE_MANAGER fileExistsAtPath:USU_USER_STATISICS_ZIP_PATH([self yestedayDate])]) {
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer.timeoutInterval = 8.0f;
        
        NSString *userStatisicsInfoPlistPath = [[NSBundle mainBundle] pathForResource:@"KitUserStatisicsInfo" ofType:@"plist"];
        NSDictionary *userStatisicsInfoDictionary = [[NSDictionary alloc] initWithContentsOfFile:userStatisicsInfoPlistPath];
        NSString *urlString = [userStatisicsInfoDictionary objectForKey:@"UploadFileURL"];
        if (!urlString || urlString.length == 0) {
            NSException *e = [NSException
                              exceptionWithName: @"KitUserStatisics Exception"
                              reason: @"KitUserStatisicsInfo.plist中UploadFileURL没有正确设置"
                              userInfo: nil];
            @throw e;
        }
        
        NSData * data = [NSData dataWithContentsOfFile:USU_USER_STATISICS_ZIP_PATH([self yestedayDate])];
        NSLog(@"%@", USU_USER_STATISICS_ZIP_PATH([self yestedayDate]));
        NSLog(@"%@", [USU_USER_STATISICS_ZIP_PATH([self yestedayDate]) lastPathComponent]);
        [manager POST:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [formData appendPartWithFileData:data name:@"file" fileName:[USU_USER_STATISICS_ZIP_PATH([self yestedayDate]) lastPathComponent] mimeType:@"zip"];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            ;
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"upload success: %@", responseObject);
                NSString *stateCode = [NSString stringWithFormat:@"%@", [responseObject objectForKey:@"statusCode"]];
                if (stateCode && [stateCode isEqualToString:@"200"]) {
                    // 上传成功，删除zip文件和其中的包含的log文件
                    [self removeUserStatisicsZipFileAndIsRemoveLogFile:YES];
                }
                else {
                    // 上传失败，删除zip文件
                    [self removeUserStatisicsZipFileAndIsRemoveLogFile:NO];
                }
            });
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                // 上传失败，删除zip文件
                NSLog(@"upload error: %@", error);
                [self removeUserStatisicsZipFileAndIsRemoveLogFile:NO];
            });
        }];
    }
}

#pragma mark - 移除用户分析文件及压缩文件
- (void) removeUserStatisicsZipFileAndIsRemoveLogFile: (BOOL)removeLogFile {
    NSArray *subpaths = [USU_FILE_MANAGER subpathsAtPath:USU_USER_STATISICS_DIRECTORY_PATH];
    if (subpaths == nil || [subpaths count] == 0) {
        return ;
    }
    else {
        // 去除文件
        for (NSString *tempsubpath in subpaths) {
            if (![@".DS_Store" isEqualToString:tempsubpath]) {
                // 1. removeLogFile为YES且不为当日日志文件，删除
                // 2. 文件为zip文件，删除
                if ((removeLogFile && [tempsubpath rangeOfString:[self currentDate]].location == NSNotFound) || [tempsubpath rangeOfString:@"zip"].location != NSNotFound) {
                    [USU_FILE_MANAGER removeItemAtPath:[USU_USER_STATISICS_DIRECTORY_PATH stringByAppendingPathComponent:tempsubpath] error:nil];
                }
            }
        }
    }
}
@end
