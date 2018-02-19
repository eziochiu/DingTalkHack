//
//  LLPunchManager.m
//  test2
//
//  Created by fqb on 2017/12/21.
//  Copyright © 2017年 kevliule. All rights reserved.
//

#import "LLPunchManager.h"
#import <UIKit/UIKit.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <CoreLocation/CoreLocation.h>

#define iOS10 ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0)

static NSString * const defaultConfigFileNameKey = @"LLDefaultConfigFileName";

@implementation LLPunchManager

+ (LLPunchManager *)shared{
    static LLPunchManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LLPunchManager alloc] init];
    });
    return manager;
}

- (id)init{
    if (self = [super init]) {
        _defaultConfigFileName = [[[NSUserDefaults standardUserDefaults] stringForKey:defaultConfigFileNameKey] copy];
        [self reloadPunchConfig];
    }
    return self;
}

- (void)setDefaultConfigFileName:(NSString *)fileName{
    _defaultConfigFileName = [fileName copy];
    [[NSUserDefaults standardUserDefaults] setObject:fileName forKey:defaultConfigFileNameKey];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [self reloadPunchConfig];
}

//重装打卡配置
- (void)reloadPunchConfig{
    NSData *data = [NSData dataWithContentsOfFile:[kArchiverFileDoc stringByAppendingPathComponent:self.defaultConfigFileName]];
    @try{
        if(!(self.punchConfig = [NSKeyedUnarchiver unarchiveObjectWithData:data])){
            self.punchConfig = [[LLPunchConfig alloc] init];
        }
    }  @catch (NSException *exception) {
        return;
    }
}

//归档保存用户设置
- (void)saveUserSetting:(LLPunchConfig *)config{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = YES;
    if(![fileManager fileExistsAtPath:kArchiverFileDoc isDirectory:&isDir]){
        [fileManager createDirectoryAtPath:kArchiverFileDoc withIntermediateDirectories:YES attributes:nil error:nil];
    }

    NSString *filePath = [kArchiverFileDoc stringByAppendingPathComponent:[NSString stringWithFormat:@"config_item_%@",config.configAlias?:[NSDate date]]];

    if ([fileManager fileExistsAtPath:filePath]) {
        NSError *error = nil;
        [fileManager removeItemAtPath:filePath error:&error];
        if (error) {
            [self showMessage:[NSString stringWithFormat:@"%@",error] completion:nil];
            return;
        }
    }
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:config];
    if ([data writeToFile:filePath atomically:YES]) {
        _punchConfig = config;
    } else {
        [self showMessage:@"保存失败" completion:nil];
    }
}

//获取SSID信息
- (NSDictionary *)SSIDInfo
{
    NSArray *ifs = (NSArray *)CFBridgingRelease(CNCopySupportedInterfaces());
    NSDictionary *info = nil;
    for (NSString *ifnam in ifs) {
        info = (NSDictionary *)CFBridgingRelease(CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam));
        if (info && [info count]) {
            break;
        }
    }
    return info;
}

//是否有定位权限
- (BOOL)isLocationAuth{
    return ![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied ? NO : YES;
}

//显示提示消息
- (void)showMessage:(NSString *)message completion:(void(^)(BOOL isClickConfirm))completion{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (completion) {
            completion(YES);
        }
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (completion) {
            completion(NO);
        }
    }];
    [alert addAction:confirm];
    [alert addAction:cancel];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

//跳转到系统wifi列表
- (void)jumpToWifiList{
    NSString * urlString = @"App-Prefs:root=WIFI";
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlString]]) {
        if (iOS10) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
        }
    }
}


@end
