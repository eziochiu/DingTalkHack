//
//  LLPunchConfig.h
//  test2
//
//  Created by fqb on 2017/12/22.
//  Copyright © 2017年 kevliule. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLPunchConfig : NSObject <NSCoding,NSCopying>

@property (nonatomic, assign) BOOL isOpenPunchHelper; //是否开启打卡助手
@property (nonatomic, assign) BOOL isLocationPunchMode; //是否是定位打卡模式
@property (nonatomic, copy) NSString *wifiName; //wifi名称
@property (nonatomic, copy) NSString *wifiMacIp; //wifi mac 地址
@property (nonatomic, copy) NSString *accuracy; //定位精度
@property (nonatomic, copy) NSString *latitude; //定位纬度
@property (nonatomic, copy) NSString *longitude; //定位经度

@property (nonatomic, copy) NSString *configAlias;//配置别名

@property (nonatomic, assign) BOOL isOpenAutoReplacePhoto; //是否打卡自动替换图片
@property (nonatomic, strong) UIImage *replacePhoto; //要替换的图片
@end
