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

// capture
@property (nonatomic, assign) BOOL capture;

// mirror
@property (nonatomic, assign) BOOL mirror;

// camera position: back|front
@property (nonatomic, strong) NSString * cameraPosition;

// filters
@property (nonatomic, strong) NSArray * filters;

@end
