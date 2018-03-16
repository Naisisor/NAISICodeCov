//
//  NAISICodeCovManage.m
//  NAISICodeCov
//
//  Created by Z C on 2018/3/15.
//  Copyright © 2018年 naisi. All rights reserved.
//

#import "NAISICodeCovManage.h"
#import "SSZipArchive.h"
#import <AFNetworking/AFNetworking.h>
#import <SVProgressHUD.h>

@implementation NAISICodeCovManage

+ (void)generateGCDAFilesAndZip {
    NSString *codeCoveragePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/CodeCoverage"];
    NSString *coverageFilesPath = [[NSString alloc] initWithFormat:@"%@/%@", codeCoveragePath, @"CoverageFiles"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:codeCoveragePath error:nil]; // 删除已存在的文件夹
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; // 创建一个时间格式化对象
    [dateFormatter setDateFormat:@"YYYYMMddhhmmssSS"]; //设定时间格式,这里可以设置成自己需要的格式
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]]; //获取当前时间、日期，并将时间转化成字符串
    
    NSString *zipFileName = [[NSString alloc] initWithFormat:@"CoverageFiles %@.zip", dateString];
    NSString *zipFilePath = [[NSString alloc] initWithFormat:@"%@/%@", codeCoveragePath, zipFileName];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *armPath;
        // 生成 gcda 文件
        setenv("GCOV_PREFIX", [coverageFilesPath cStringUsingEncoding: NSUTF8StringEncoding], 1);
        setenv("GCOV_PREFIX_STRIP", "1", 1);
        
        // 调用此方法前，请务必确认 Test Project --> Build Settings 中 `Instrument Program Flow` 的值 Yes（release 不用设置为 YES）
        extern void __gcov_flush();
        __gcov_flush();
        
        // 获取 coverageFilesPath 路径下所有的子级文件的路径
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:coverageFilesPath];
        for (int i = 1; i < [files count]; i++) {
            if ([files[i] rangeOfString:@"/arm64"].location != NSNotFound) {
                NSArray *arr = [files[i] componentsSeparatedByString:@"/arm64"];
                armPath = [[NSString alloc] initWithFormat:@"%@/%@", coverageFilesPath, arr[0]];
                // arm64 文件夹重命名
                [fileManager moveItemAtPath:[[NSString alloc] initWithFormat:@"%@/%@", armPath, @"/arm64"] toPath:[[NSString alloc] initWithFormat:@"%@/%@ %@", armPath, @"/CoverageFiles", dateString] error:nil];
                break;
            }
        }
        
        [SSZipArchive createZipFileAtPath:zipFilePath withContentsOfDirectory:armPath];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [NAISICodeCovManage uplodaCoverageFilePath:zipFilePath fileName:zipFileName];
        });
    });
}

+ (void)uplodaCoverageFilePath:(NSString *)filePath fileName:(NSString *)fileName {
    //1.创建管理者对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //2.上传文件
    NSDictionary *params = @{@"type": @"iOS"};
    NSString *urlString = @"http://100.66.151.127:5000/upload";
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath] name:@"file" fileName:fileName mimeType:@"application/octet-stream" error:nil];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // returnCode 值为 0 则为上传成功，非 0 则为上传失败
        if (![(NSNumber *)responseObject[@"error"][@"returnCode"] intValue]) {
            [SVProgressHUD showSuccessWithStatus:responseObject[@"error"][@"returnUserMessage"]];
        } else {
            [SVProgressHUD showErrorWithStatus:responseObject[@"error"][@"returnUserMessage"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"上传失败"];
    }];
}

@end
