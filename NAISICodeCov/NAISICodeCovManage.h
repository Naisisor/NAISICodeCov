//
//  NAISICodeCovManage.h
//  NAISICodeCov
//
//  Created by Z C on 2018/3/15.
//  Copyright © 2018年 naisi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NAISICodeCovManage : NSObject

+ (void)generateGCDAFilesAndZip;

+ (void)uplodaCoverageFilePath:(NSString *)filePath fileName:(NSString *)fileName;

@end
