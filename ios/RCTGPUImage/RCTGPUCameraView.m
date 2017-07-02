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

- (void)setFilters:(NSArray *)filters {
    NSMutableArray * newFilters = [NSMutableArray array];
    for (id f in filters) {
        NSDictionary * dic = f;
        if ([f isKindOfClass:NSString.class]) {
            dic = @{@"name": f};
        }
        [newFilters addObject:dic];
    }
    _filters = newFilters;
    [self reloadFilterGroups];
}

- (void)reloadFilterGroups {
    BOOL needUpdate = NO;
    NSInteger count = _filters.count;
    if (count != [_filterGroup filterCount]) {
        needUpdate = YES;
    } else {
        for (int i = 0; i< count; i++) {
            NSDictionary *filterDic = _filters[i];
            NSString *name = filterDic[@"name"];

            GPUImageOutput<GPUImageInput> * filter = [_filterGroup filterAtIndex:i];
            if (![name isEqualToString:NSStringFromClass(filter.class)]) {
                needUpdate = YES;
                break;
            }
        }
    }

    // update filters
    if (needUpdate) {
        [_filterGroup removeAllTargets];
        _filterGroup = [[GPUImageFilterGroup alloc] init];

        NSMutableArray *filterList = [NSMutableArray new];
        for (NSDictionary * f in _filters) {
            NSDictionary * filter = f;
            NSString *name = filter[@"name"];
            if (name) {
                Class filterClass = NSClassFromString(name);
                GPUImageFilter *imageFilter = [filterClass new];
                if ([imageFilter isKindOfClass:[GPUImageFilter class]]) {
                    [filterList.lastObject addTarget:imageFilter];
                    [_filterGroup addFilter:imageFilter];
                    [filterList addObject:imageFilter];
                }
            }
        }
        if (filterList.firstObject) {
            [_filterGroup setInitialFilters:@[filterList.firstObject]];
        }
        if (filterList.lastObject) {
            [_filterGroup setTerminalFilter:filterList.lastObject];
        }

        [_videoCamera addTarget:_filterGroup];
        [_filterGroup addTarget:self];
    }

    // update filter params
    for (int i = 0; i< count; i++) {
        NSDictionary *filterDic = _filters[i];
        NSDictionary *params = filterDic[@"params"];
        if (params) {
            GPUImageOutput<GPUImageInput> * filter = [_filterGroup filterAtIndex:i];
            if ([filter isKindOfClass:[GPUImageTransformFilter class]]) {
                CATransform3D transform = CATransform3DIdentity;
                CGFloat *p = (CGFloat *)&transform;
                NSArray *modelViewMatrix = params[@"transform3D"];
                for (int i = 0; i < 16; ++i) {
                    *p = [[modelViewMatrix objectAtIndex:i] floatValue];
                    ++p;
                }
                [(GPUImageTransformFilter *)filter setTransform3D:transform];
            } else {
                for (NSString *key in params.allKeys) {
                    if ([filter respondsToSelector:NSSelectorFromString(key)]) {
                        [filter setValue:params[key] forKeyPath:key];
                    }
                }
            }
        }
    }

}

@end
