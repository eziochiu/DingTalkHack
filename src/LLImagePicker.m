//
//  LLImagePicker.m
//  StoreIntegral
//
//  Created by kevin on 2017/1/14.
//  Copyright © 2017年 Ecommerce. All rights reserved.
//

#import "LLImagePicker.h"
#import <Photos/Photos.h>

@interface LLImagePicker () <UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>

@property (nonatomic, copy) LLImagePickerCompletionBlock completion;

@property (nonatomic, assign) id object;

@property (nonatomic, assign) BOOL allowsEditing;

@end

@implementation LLImagePicker

/**
 单例

 @return 单例对象
 */
+ (LLImagePicker *)shared{
    static LLImagePicker *picker = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        picker = [[LLImagePicker alloc] init];
    });
    return picker;
}


/**
 显示图片选取器

 @param completion 完成回调
 */
- (void)showWithCompletion:(LLImagePickerCompletionBlock)completion object:(id)object allowsEditing:(BOOL)allowsEditing{
    _completion = completion;
    _object = object;
    _allowsEditing = allowsEditing;
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"上传图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self presentImagePickerController:UIImagePickerControllerSourceTypeCamera];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self presentImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [controller addAction:action1];
    [controller addAction:action2];
    [controller addAction:cancelAction];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:controller animated:YES completion:nil];
}

- (void)presentImagePickerController:(UIImagePickerControllerSourceType)sourceType{
    // 跳转到相机拍照或从相册选择
    if ([self checkAuthStatus:sourceType]) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = _allowsEditing;
        imagePickerController.sourceType = sourceType;
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:imagePickerController animated:YES completion:nil];
        if (@available(iOS 11, *)) {
            //[[imagePickerController rac_signalForSelector:@selector(viewDidLoad)] subscribeNext:^(RACTuple * _Nullable x) {
                [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAlways;
            //}];
        }
    }
}


/**
 检查相机或者相册授权状态

 @param sourceType 要检查的源类型
 @return YES: 授权了或者还未决定是否授权，NO：被禁止访问
 */
- (BOOL)checkAuthStatus:(UIImagePickerControllerSourceType)sourceType{
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        /* 先判断摄像头硬件是否好用*/
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            /*用户是否允许摄像头使用*/
            NSString *mediaType = AVMediaTypeVideo;
            AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
            /*不允许弹出提示框*/
            if (authorizationStatus == AVAuthorizationStatusRestricted || authorizationStatus == AVAuthorizationStatusDenied) {
                UIAlertAction *goSettingAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"无法访问相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:goSettingAction];
                [alertController addAction:cancelAction];
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
                return NO;
            } else {
                /*这里是摄像头可以使用的处理逻辑*/
                return YES;
            }
        } else {
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"手机摄像头设备损坏" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:confirmAction];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
            return NO;
        }
    } else {
        //访问相册，判断相册是否授权
        PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
        if (authStatus == PHAuthorizationStatusDenied || authStatus == PHAuthorizationStatusRestricted) {
            UIAlertAction *goSettingAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:goSettingAction];
            [alertController addAction:cancelAction];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
            return NO;
        } else {
            return YES;
        }
    }
}

#pragma mark - UIImagePickerControllerDelgate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self resetScrollViewInsetBehavior];
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *originImg = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *editedImg = [info objectForKey:UIImagePickerControllerEditedImage];
    if (_completion) {
        _completion(YES,originImg,editedImg,_object);
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self resetScrollViewInsetBehavior];
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (_completion) {
        _completion(NO,nil,nil,nil);
    }
}

- (void)resetScrollViewInsetBehavior{
    if (@available(iOS 11.0, *)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
}

@end
