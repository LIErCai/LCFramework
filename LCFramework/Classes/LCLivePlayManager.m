//
//  LCLivePlayManager.m
//  wawaji_ios
//
//  Created by 奇艺果 on 2018/3/1.
//  Copyright © 2018年 yiguo qi. All rights reserved.
//

#import "LCLivePlayManager.h"



#define L_NULLString(string) ((![string isKindOfClass:[NSString class]])||[string isEqualToString:@""] || (string == nil) || [string isKindOfClass:[NSNull class]]||[[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)

#ifdef DEBUG
#define LCLog(...) NSLog(@"Y+W LINE=%d -> %@", __LINE__, [NSString stringWithFormat:__VA_ARGS__])
#else
#define LCLog(...) {}
#endif
@interface LCLivePlayManager()<TXLivePlayListener>
/**配置信息*/
@property (nonatomic, strong) TXLivePlayConfig * config;
/**播放器*/
@property (nonatomic, strong) TXLivePlayer * fLivePlayer;
/**播放器*/
@property (nonatomic, strong) TXLivePlayer * sLivePlayer;
/**正面流地址*/
@property (nonatomic, strong) NSString * fplayUrl;
/**正面流地址*/
@property (nonatomic, strong) NSString * splayUrl;
@end
@implementation LCLivePlayManager

/* getSDKVersionStr 获取SDK版本信息
 */
+ (NSString *)getSDKVersionStr{
    return @"1.0.0";
}
- (void)loginWithRoomID:(NSString *)roomID
                 userID:(NSString *)userID
                  token:(NSString *)token
          completeBlock:(CompleteBlock)completeBlock{
    
    if(L_NULLString(roomID)||L_NULLString(userID)||L_NULLString(token)){
        
        NSError *error = [NSError errorWithDomain:@"请求参数有误" code:-1 userInfo:@{NSLocalizedDescriptionKey : @"请求参数有误"}];
        completeBlock(error);
        return;
    }
    NSString *dollRootUrl = self.isTest ? @"https://testdoll.artqiyi.com" : @"https://doll.artqiyi.com";
    NSString *urlStr =[NSString stringWithFormat:@"%@/api/index.php?app=video&act=get_room_info&room_id=%@&type=app&user_id=%@&token=%@",dollRootUrl,roomID,userID,token] ;
    
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr] ;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url] ;
    //遍历请求头键值字段:
//    if (self.HTTPHeadersDic) {
//        for (NSString *key in self.HTTPHeadersDic.allKeys) {
//            [request setValue:[self.HTTPHeadersDic objectForKey:key] forHTTPHeaderField:key] ;
//        }
//    }
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (connectionError) {
            completeBlock(connectionError);
            
        } else {
            //            NSLog(@"网络请求成功 --> data = %@" , data) ;
            NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;
            
            NSError *error = [NSError errorWithDomain:@"无法获取数据" code:-1 userInfo:@{NSLocalizedDescriptionKey : @"无法获取数据"}];
            
            NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers |                                                                       NSJSONReadingMutableLeaves error:nil];
            NSDictionary *retvals = responseDic[@"retval"];
//            NSDictionary *retvalDic = [NSJSONSerialization JSONObjectWithData:retval options:NSJSONReadingMutableContainers |                                                                       NSJSONReadingMutableLeaves error:nil];
            
            self.fplayUrl = retvals[@"live_pull_address_front"];
            self.splayUrl = retvals[@"live_pull_address_side"];
            LCLog(@"正面流地址:%@",self.fplayUrl);
            LCLog(@"侧面流地址:%@",self.splayUrl);
            
            !dataStr ? completeBlock(error): completeBlock(nil) ;
        }
    }] ;
    
}


/*
 * setFrontRotation 设置正面摄像头画面的方向, 在播放前设置
 * 参数：
 *       rotation : 详见 TX_Enum_Type_HomeOrientation 的定义.
 */
- (void)setFrontRotation:(TX_Enum_Type_HomeOrientation)rotation{
    [self.fLivePlayer setRenderRotation:rotation];
}

/*
 * setFrontRotation 设置侧面摄像头画面的方向, 在播放前设置
 * 参数：
 *       rotation : 详见 TX_Enum_Type_HomeOrientation 的定义.
 */
- (void)setSideRotation:(TX_Enum_Type_HomeOrientation)rotation{
    [self.sLivePlayer setRenderRotation:rotation];
}

/**
 开始正摄像头播放
 @param view 该控件承载着视频内容的展示。
 */
- (void)startPlayFrontWithContainView:(UIView *)view{
    
    [self.fLivePlayer stopPlay];
    self.fLivePlayer.enableHWAcceleration = YES;
    
    [self.fLivePlayer setupVideoWidget:CGRectMake(0, 0, 0, 0) containView:view insertIndex:0];
    [self.fLivePlayer setConfig:self.config];
    [self.fLivePlayer startPlay:self.fplayUrl type:PLAY_TYPE_LIVE_RTMP_ACC];
}

/**
 开始侧面摄像头播放
 @param view 该控件承载着视频内容的展示。
 */
- (void)startPlaySideWithContainView:(UIView *)view{
    
    [self.sLivePlayer stopPlay];
    self.sLivePlayer.enableHWAcceleration = YES;
    
    [self.sLivePlayer setupVideoWidget:CGRectMake(0, 0, 0, 0) containView:view insertIndex:0];
    [self.sLivePlayer setConfig:self.config];
    [self.sLivePlayer startPlay:self.splayUrl type:PLAY_TYPE_LIVE_RTMP_ACC];
}

/**
 停止正面视频播放
 */
- (void)stopPlayFront{
    if(_fLivePlayer != nil)
    {
        _fLivePlayer.delegate = nil;
        [_fLivePlayer stopPlay];
        [_fLivePlayer removeVideoWidget];
    }
}
/**
 停止侧面视频播放
 */
- (void)stopPlaySide{
    
    if(_sLivePlayer != nil)
    {
        _sLivePlayer.delegate = nil;
        [_sLivePlayer stopPlay];
        [_sLivePlayer removeVideoWidget];
    }
}
#pragma  mark TXLivePlayListener(围观)
-(void) onPlayEvent:(int)EvtID withParam:(NSDictionary*)param {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if([self.delegate respondsToSelector:@selector(onPlayEvent:withParam:)]){
            [self.delegate onPlayEvent:EvtID withParam:param];
        }
    });
}

- (void)onNetStatus:(NSDictionary *)param {
}

- (TXLivePlayer *)sLivePlayer{
    if(!_sLivePlayer){
        _sLivePlayer = [[TXLivePlayer alloc] init];
        [_sLivePlayer setRenderMode:RENDER_MODE_FILL_SCREEN];
        _sLivePlayer.delegate = self;
        
        _sLivePlayer.config = self.config;
        _sLivePlayer.enableHWAcceleration = YES;
    }
    return _sLivePlayer;
}
- (TXLivePlayer *)fLivePlayer{
    if(!_fLivePlayer){
        _fLivePlayer = [[TXLivePlayer alloc] init];
        [_fLivePlayer setRenderMode:RENDER_MODE_FILL_SCREEN];
        _fLivePlayer.delegate = self;
        _fLivePlayer.config = self.config;
        _fLivePlayer.enableHWAcceleration = YES;
    }
    return _fLivePlayer;
}

- (TXLivePlayConfig *)config{
    if(!_config){
        _config = [[TXLivePlayConfig alloc] init];
        _config.playerPixelFormatType = kCVPixelFormatType_420YpCbCr8BiPlanarFullRange;//极速模式
        _config.bAutoAdjustCacheTime   = YES;
        _config.minAutoAdjustCacheTime = 1;
        _config.maxAutoAdjustCacheTime = 1;
    }
    return _config;
}
@end
