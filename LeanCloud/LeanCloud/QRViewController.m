//
//  QRViewController.m
//  LeanCloud
//
//  Created by yuebin on 16/8/30.
//  Copyright © 2016年 yuebin. All rights reserved.
//

#import "QRViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface QRViewController () <AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic, strong)AVCaptureSession *captureSession;
@property (nonatomic, strong)UIView *animatedView;

@end

@implementation QRViewController {
    UIImageView *_redLine;
    NSInteger _time;
}

- (UIView *)animatedView {
    if (!_animatedView) {
//        _animatedView = [[[NSBundle mainBundle]loadNibNamed:@"animatedView" owner:nil options:nil]firstObject];
        _redLine = [[UIImageView alloc]initWithFrame:CGRectMake(KSC_W*50/320, KSC_H*195/480, KSC_W*220/320, 2)];
        [_redLine setImage:[UIImage imageNamed:@"扫描枪-横线@2x"]];
        _animatedView = (UIImageView *)[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"扫描枪bg"]];
        _animatedView.alpha = .5;
        [_animatedView addSubview:_redLine];
        
    }
    return _animatedView;
}

- (AVCaptureSession *)captureSession {
    if (!_captureSession) {
        //先设置输入输出流
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
        AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc]init];
        //设置识别区域
        output.rectOfInterest = CGRectMake(85.00/480, 50.00/320, 220.00/480, 220.00/320); //y,x,h,w
        
        //设置代理在主线程中刷新
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        //初始化连接对象
        _captureSession = [[AVCaptureSession alloc]init];
        
        //设置为高质量采集率
        _captureSession.sessionPreset = AVCaptureSessionPresetHigh;
        [_captureSession addInput:input];
        [_captureSession addOutput:output];
        output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
        
        //设置界面
        AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:_captureSession];
        layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        layer.frame = self.view.layer.bounds;
        [layer addSublayer:self.animatedView.layer];
        [self.view.layer insertSublayer:layer atIndex:0];
    }
    return _captureSession;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"扫描条形码/二维码";
    [self.captureSession startRunning];
    
    _time = 0;
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(changeLineColor) userInfo:nil repeats:YES];
}

- (void)changeLineColor {

    _redLine.alpha = _time%10/10.0;
    _time ++;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - CaptureDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    if (metadataObjects.count > 0) {
        [self.captureSession stopRunning];
        AVMetadataMachineReadableCodeObject *object = [metadataObjects firstObject];

        [[NSNotificationCenter defaultCenter]postNotificationName:@"codeResult" object:nil userInfo:@{@"code":object.stringValue}];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
