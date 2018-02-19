//
//  LLImagePicker.h
//  StoreIntegral
//
//  Created by kevin on 2017/1/14.
//  Copyright © 2017年 Ecommerce. All rights reserved.
//

typedef void(^LLImagePickerCompletionBlock)(BOOL isSuccess,UIImage *originImg,UIImage *editedImg,id object);

#import <Foundation/Foundation.h>

@interface LLImagePicker : NSObject

/**
 单例
 
 @return 单例对象
 */
+ (LLImagePicker *)shared;
/**
 显示图片选取器
 
 @param completion 完成回调
 */
- (void)showWithCompletion:(LLImagePickerCompletionBlock)completion object:(id)object allowsEditing:(BOOL)allowsEditing;

@end
