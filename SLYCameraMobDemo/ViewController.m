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
        NSLog(@"连接成功，设备正常工作，可获取实时视频.");
    }
}

//! 获取WiFi信息
- (IBAction)btnDeviceWiFiInfo:(id)sender {
    
    //[SLYConnMan asyncGetWiFiInfoFromDevice];
    
    [SLYDevMan asyncControlCameraRecord];
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
    //[SLYDevMan asyncQueryCameraPreviewInfo];
    
    [SLYDevMan asyncCatchCameraSnapshot];

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
    
}

- (IBAction)btnDelFile:(id)sender {
}


-(void)didCatchCameraSnapshot:(EMError *)error
{
    
}

-(void)didControlCameraRecord:(EMError *)error
{
    
}

@end
