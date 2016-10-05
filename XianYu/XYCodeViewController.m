//
//  XYCodeViewController.m
//  XianYu
//
//  Created by YuanZhihao on 6/22/16.
//  Copyright © 2016 YuanZhihao. All rights reserved.
//

#import "XYCodeViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface XYCodeViewController () <AVCaptureMetadataOutputObjectsDelegate> {
    AVCaptureDevice *_device;
    AVCaptureDeviceInput *_input;
    AVCaptureMetadataOutput *_output;
    AVCaptureSession *_session;
    AVCaptureVideoPreviewLayer *_preview;
}

@property (assign, nonatomic, readonly) NSTimer *timer;

@end

@implementation XYCodeViewController 

@synthesize timer;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self checkAuthorizationStatus];
}

- (void)checkAuthorizationStatus {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusAuthorized) {
        [self setupCamera];
    }
    else {
        NSLog(@"您没有权限访问相机");
    }
}

- (void)setupCamera {
    //耗时操作
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:nil];
        _output = [[AVCaptureMetadataOutput alloc]init];
        [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        _session = [[AVCaptureSession alloc]init];
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
        if ([_session canAddInput:_input]) {
            [_session addInput:_input];
        }
        
        if ([_session canAddOutput:_output]) {
            [_session addOutput:_output];
        }
        
        //条码类型 AVMetadataObjectTypeQRCode
        //_output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
        [_output setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
        dispatch_async(dispatch_get_main_queue(), ^{
            //更新界面
            _preview = [AVCaptureVideoPreviewLayer layerWithSession:_session];
            _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
            _preview.frame = self.view.bounds;
            [self.view.layer insertSublayer:_preview atIndex:0];
            [_session startRunning];
        });
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_session && ![_session isRunning]) {
        [_session startRunning];
    }
    //timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [timer invalidate];
}

@end
