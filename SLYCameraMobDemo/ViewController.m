//
//  ViewController.m
//  SLYCameraMobDemo
//
//  Created by sherwin on 16/1/21.
//  Copyright © 2016年 SLY深蓝蕴. All rights reserved.
//

#import "ViewController.h"
#import "SLYCameraMob.h"
#import "SLYConnectManagerLoginDelegate.h"


@interface ViewController ()<IConnecttManagerDelegate,IDeviceManagerDelegate>

@property (nonatomic, strong) NSMutableString* mStrLog;

@property (weak, nonatomic) IBOutlet UITextView *tvLogView;
@property (weak, nonatomic) IBOutlet UILabel *lbWiFi;

@property (nonatomic, strong) SLYWiFiInfo * mWiFiInfo;


@property (nonatomic, strong) NSArray *fileList;
@end

@implementation ViewController

-(void)log:(NSString*) strLog
{
     NSLog(@"%@",strLog);
    
    
    [self.mStrLog  appendFormat:@"%@\r\n",strLog];
    
    dispatch_async(dispatch_get_main_queue(), ^{
         [self.tvLogView setText:self.mStrLog];
    });
   
    return;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mStrLog = [NSMutableString new];
    // Do any additional setup after loading the view, typically from a nib.
    [SLYMob setDebugLog:YES];
    
    [self log:@"准备就绪..."];
    [SLYConnMan addDelegate:self];
    [SLYDevMan addDelegate:self];
}

- (void)dealloc
{
    [SLYConnMan removeDelegate:self];
    [SLYDevMan removeDelegate:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//! 设备连接
- (IBAction)btnDeviceConnet:(UIButton *)sender {
    [self log:@"正在连接设备..."];
    [SLYConnMan asyncConnect];
    return;
}

- (void)didConnectWithError:(EMError *)error
{
    if (error) {
        [self log:@"连接失败 %@"];
      
    }
    else{
        [self log:@"连接成功，设备正常工作，可获取实时视频."];
    }
}

//! 获取WiFi信息
- (IBAction)btnDeviceWiFiInfo:(id)sender {
    
    [SLYConnMan asyncGetWiFiInfoFromDevice];
    
    //[SLYDevMan asyncControlCameraRecord];
}

- (void)didGetWiFiInfo:(SLYWiFiInfo *)connectWiFiInfo error:(EMError *)error
{
    if (error) {
        [self log:error.emDescription];
    }
    else{
        self.mWiFiInfo = connectWiFiInfo;
        
        NSString *info = [NSString stringWithFormat:@"%@",self.mWiFiInfo];
        
        dispatch_async(dispatch_get_main_queue(), ^{
           [self.lbWiFi setText:info];
        });
        
        [self log:info];
    }
}

//! 获取摄像头视频预览信息
- (IBAction)btnQueryCameraInfo:(id)sender {
    [SLYDevMan asyncQueryCameraPreviewInfo];
    
    //[SLYDevMan asyncCatchCameraSnapshot];

    //[SLYDevMan asyncControlCameraRecord];
}

-(void) didQueryCameraPreviewInfo
{
    
}


- (IBAction)btnGetFileList:(id)sender {
    [SLYDevMan asyncGetFileListWithCount:40 From:0];
}

- (void)didGetFileList:(NSArray*)fileList
                 error:(EMError *)error
{
    NSLog(@"%@",fileList);
    
    self.fileList = fileList;
    
}

- (IBAction)btnDelFile:(id)sender {
    
    if (self.fileList.count<1) {
        NSLog(@"没文件列表.");
        return;
    }
    SLYDeviceFile *file = [self.fileList lastObject];
    
    [SLYDevMan asyncDeleteFileWithName:nil];
    
}

-(void) didDeleteFile:(NSString *)strFileName error:(EMError *)error
{
    
}



-(void)didCatchCameraSnapshot:(EMError *)error
{
    
}

-(void)didControlCameraRecord:(EMError *)error
{
    
}
- (IBAction)setDataTime:(id)sender {
    [SLYDevMan asyncSetCameraDateTime:[NSDate date]];
}

- (IBAction)getAllSetting:(id)sender {
    [SLYDevMan asyncQueryCameraSettings];
}

- (void)didQueryCameraSettings:(SLYCameraInfo*) cameraInfo
                         error:(EMError *)error
{
    
    
    NSLog(@"%@",cameraInfo);
}

///////////

- (IBAction)actionCameraSetting:(id)sender {
    
    //无法使用
   // [SLYDevMan asyncSetVideoRes:!eCA_VideoRes_1080P30fps];
    
    [SLYDevMan asyncSetImageRes:eCA_ImageRes_5M];
}

- (void)didSetVideoRes:(CAMERA_VideoRes) videoRes
                 error:(EMError *)error
{
    if (error==NULL) {
        [self getAllSetting:nil];
    }
    else{
        NSLog(@"%@",error);
    }
}

- (IBAction)imageValueCh:(UISegmentedControl *)sender {
    switch (sender.tag) {
        case 1:
            //一些可用
            [SLYDevMan asyncSetImageRes:sender.selectedSegmentIndex];
            break;
        case 2:
            //不可用
            [SLYDevMan asyncSetCameraFlicker:sender.selectedSegmentIndex];
            break;
        case 3:
            //可用
            [SLYDevMan asyncSetCameraAWB:sender.selectedSegmentIndex];
            break;
        case 4:
            //不可用
            [SLYDevMan asyncSetCameraMTD:sender.selectedSegmentIndex];
            break;
        case 5:
            //一些可用
            [SLYDevMan asyncSetCameraEV:sender.selectedSegmentIndex];
            break;
        default:
            break;
    }
    
}

- (void)didSetImageRes:(CAMERA_ImageRes) imageRes
                 error:(EMError *)error
{
    if (error==NULL) {
        [self getAllSetting:nil];
    }
    else{
        NSLog(@"%@",error);
    }
}

- (void)didSetCameraFlicker:(CAMERA_FLICKER) camera_ficker
                     error:(EMError *)error
{
    if (error==NULL) {
        [self getAllSetting:nil];
    }
    else{
        NSLog(@"%@",error);
    }
}

- (void)didSetCameraEv:(CAMERA_Video_EV) camera_ev
                 error:(EMError *)error
{
    if (error==NULL) {
        [self getAllSetting:nil];
    }
    else{
        NSLog(@"%@",error);
    }
}

- (void)didSetCameraMTD:(CAMERA_MTD) camera_MTD
                  error:(EMError *)error
{
    if (error==NULL) {
        [self getAllSetting:nil];
    }
    else{
        NSLog(@"%@",error);
    }
}

/*!
 @brief 设置视频白平衡参数的回调
 */
- (void)didSetCameraAWB:(CAMERA_AWB) camera_awb
                  error:(EMError *)error
{
    if (error==NULL) {
        [self getAllSetting:nil];
    }
    else{
        NSLog(@"%@",error);
    }
}
@end
