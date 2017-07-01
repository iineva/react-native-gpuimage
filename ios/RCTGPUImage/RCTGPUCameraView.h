//
//  RCTGPUCameraView.h
//  RCTGPUImage
//
//  Created by Steven on 2017/7/1.
//  Copyright © 2017年 erica. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPUImage.h"

@interface RCTGPUCameraView : GPUImageView

// 是否开启相机
@property (nonatomic, assign) BOOL capture;

// 是否镜像预览
@property (nonatomic, assign) BOOL mirror;

// 摄像头位置 back|front
@property (nonatomic, strong) NSString * cameraPosition;

@end
