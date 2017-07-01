//
//  RCTGPUCameraViewManager.m
//  RCTGPUImage
//
//  Created by Steven on 2017/7/1.
//  Copyright © 2017年 erica. All rights reserved.
//

#import "RCTGPUCameraViewManager.h"
#import "RCTGPUCameraView.h"

@implementation RCTGPUCameraViewManager

RCT_EXPORT_MODULE()

- (UIView *)view {
    return [[RCTGPUCameraView alloc] init];
}

RCT_EXPORT_VIEW_PROPERTY(capture, BOOL);
RCT_EXPORT_VIEW_PROPERTY(mirror, BOOL);
RCT_EXPORT_VIEW_PROPERTY(cameraPosition, NSString *);

@end
