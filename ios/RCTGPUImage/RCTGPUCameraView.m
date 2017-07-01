//
//  RCTGPUCameraView.m
//  RCTGPUImage
//
//  Created by Steven on 2017/7/1.
//  Copyright © 2017年 erica. All rights reserved.
//

#import "RCTGPUCameraView.h"

@interface RCTGPUCameraView()
@property (nonatomic, strong) GPUImageVideoCamera * videoCamera;
@property (nonatomic, strong) GPUImageFilterGroup * filterGroup;
@property (nonatomic, assign) AVCaptureDevicePosition cameraPositionCache;
@end

@implementation RCTGPUCameraView

- (void)updateVideoCamera {
    _videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPresetHigh cameraPosition:self.cameraPositionCache];
    _videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    self.mirror = self.mirror;
    self.capture = self.capture;
    [_videoCamera addTarget:self.filterGroup];
    [_filterGroup addTarget:self];
}

- (GPUImageFilterGroup *)filterGroup {
    if (!_filterGroup) {
        _filterGroup = [[GPUImageFilterGroup alloc] init];
        
        GPUImageRGBFilter *filter1         = [[GPUImageRGBFilter alloc] init];
        GPUImageToonFilter *filter2        = [[GPUImageToonFilter alloc] init];
        GPUImageColorInvertFilter *filter3 = [[GPUImageColorInvertFilter alloc] init];
        GPUImageSepiaFilter       *filter4 = [[GPUImageSepiaFilter alloc] init];
        [self addGPUImageFilter:filter1];
        [self addGPUImageFilter:filter2];
        [self addGPUImageFilter:filter3];
        [self addGPUImageFilter:filter4];
    }
    return  _filterGroup;
}

- (void)setCapture:(BOOL)capture {
    _capture = capture;
    if (capture) {
        [_videoCamera startCameraCapture];
    } else {
        [_videoCamera stopCameraCapture];
    }
}

- (void)setCameraPosition:(NSString *)position {
    AVCaptureDevicePosition cameraPosition = AVCaptureDevicePositionUnspecified;
    if ([[position lowercaseString] isEqualToString:@"back"]) {
        cameraPosition = AVCaptureDevicePositionBack;
    } else if ([[position lowercaseString] isEqualToString:@"front"]) {
        cameraPosition = AVCaptureDevicePositionFront;
    }
    if (_cameraPositionCache != cameraPosition) {
        _cameraPositionCache = cameraPosition;
        [_videoCamera stopCameraCapture];
        [_videoCamera removeAllTargets];
        [self updateVideoCamera];
    }
}

- (void)setMirror:(BOOL)mirror {
    _mirror = mirror;
    switch (self.cameraPositionCache) {
        case AVCaptureDevicePositionFront:
            _videoCamera.horizontallyMirrorFrontFacingCamera = mirror;
            break;
        case AVCaptureDevicePositionBack:
            _videoCamera.horizontallyMirrorRearFacingCamera = mirror;
            break;
        default:
            break;
    }
}

- (void)addGPUImageFilter:(GPUImageOutput<GPUImageInput> *)filter {
    [_filterGroup addFilter:filter];
    
    GPUImageOutput<GPUImageInput> *newTerminalFilter = filter;
    
    NSInteger count = _filterGroup.filterCount;
    
    if (count == 1) {
        _filterGroup.initialFilters = @[newTerminalFilter];
        _filterGroup.terminalFilter = newTerminalFilter;
        
    } else {
        GPUImageOutput<GPUImageInput> *terminalFilter    = _filterGroup.terminalFilter;
        NSArray *initialFilters                          = _filterGroup.initialFilters;
        
        [terminalFilter addTarget:newTerminalFilter];
        
        _filterGroup.initialFilters = @[initialFilters[0]];
        _filterGroup.terminalFilter = newTerminalFilter;
    }
}

@end
