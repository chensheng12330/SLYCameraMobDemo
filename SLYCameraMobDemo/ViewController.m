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
    [SLYDevMan addDelegate:self];
    [SLYDevMan addDelegate:self];
    [SLYDevMan addDelegate:self];
    
    /*
    for (double i=0; i<(2*M_PI); i=i+(M_PI/6.0)) {
        double dSin = sin(i);
        NSLog(@"i=%lf  dSin=%lf",i,dSin);
    }*/
    
    return;
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
    [SLYDevMan asyncGetFileListWithCount:20 From:0];
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

//////////

- (void)didQueryCameraSettings:(SLYCameraInfo*) cameraInfo
                         error:(EMError *)error
{
    
    
    NSLog(@"%@",cameraInfo);
}

///////////
#warning 测试功能函数
- (IBAction)actionCameraSetting:(id)sender {
    
    //无法使用
    //[SLYDevMan asyncSetVideoRes:!eCA_VideoRes_1080P30fps];
    
    //[SLYDevMan asyncGetCameraRecordStatus];
    
    //[SLYDevMan asyncSetImageRes:eCA_ImageRes_5M];
    [SLYConnMan asyncChangeWiFiWithSSID:@"XCar_002" Password:@"123456789"];
    
}

-(void)didChangeWiFiInfo:(SLYWiFiInfo *)connectWiFiInfo error:(EMError *)error
{
    if (error) {
        NSLog(@"%@",error);
    }
    else{
        [SLYConnMan asyncReactivateDevice];
    }
    
    return;
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

- (IBAction)actionReactivateDevice:(id)sender {
    [SLYConnMan asyncReactivateDevice];
}

- (IBAction)videoRecoderControl:(UISegmentedControl *)sender {
    
    if (sender.selectedSegmentIndex ==0) {
        //查询录像状态
        [SLYDevMan asyncGetCameraRecordStatus];
    }
    else if (sender.selectedSegmentIndex ==1) {
        //开始
        //[SLYDevMan asyncGetCameraDateTime];
        [SLYDevMan asyncStartCameraRecord];
    }
    else if (sender.selectedSegmentIndex ==2) {
        //停止
        [SLYDevMan asyncStopCameraRecord];
    }
    
    return;
}

-(void) didGetCameraRecordStatus:(CAMERA_RecordStatus)recordStatus error:(EMError *)error
{
    
}





-(void) didStartCameraRecord:(EMError *)error
{
    
}

-(void) didStopCameraRecord:(EMError *)error
{
    
}


- (IBAction)startAutoConnet:(UIButton *)sender {
    
    [SLYConnMan asyncStartAutoConnect];
    
}

- (void)didAutoConnectWithError:(EMError *)error
{
    if (error) {
        NSLog(@"------------------------------");
        NSLog(@"----->设备断开连接..%@",error);
         NSLog(@"------------------------------");
    }
    else{
         NSLog(@"------------------------------");
        NSLog(@"----->设备已自动连接.....");
         NSLog(@"------------------------------");
    }
}


/*!
 @method
 @brief 自动重连操作完成后的回调（成功的话，error为nil，失败的话，查看error的错误信息）
 @discussion
 @result
 */
- (void)didStopAutoReconnect
{
    
}


- (IBAction)actionCameraSwitch:(UISegmentedControl*)sender {
    
    if (sender.selectedSegmentIndex ==0) {
        //使用前摄像头
        [SLYDevMan asyncSwitchCamera:eCA_Head_Front];
    }
    else if (sender.selectedSegmentIndex ==1) {
        //后摄像头
        //[SLYDevMan asyncGetCameraDateTime];
        [SLYDevMan asyncSwitchCamera:eCA_Head_Rear];
    }
    else if (sender.selectedSegmentIndex ==2) {
        //查询
        [SLYDevMan asyncGetCameraHead];
    }
    
    return;
}

-(void)didSwitchCamera:(CAMERA_Head) camer_head
                 error:(EMError *)error
{
    
}


-(void)didGetCameraHead:(CAMERA_Head) camer_head
                  error:(EMError *)error
{
    
}

@end
