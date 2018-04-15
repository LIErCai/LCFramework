//
//  LCLivePlayManager.h
//  wawaji_ios
//
//  Created by 奇艺果 on 2018/3/1.
//  Copyright © 2018年 yiguo qi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TXLiteAVSDK_Player/TXLivePlayer.h>


@protocol LCLivePlayManagerDelegate <NSObject>

-(void) onPlayEvent:(int)EvtID withParam:(NSDictionary*)param;
@end


typedef void (^CompleteBlock) (NSError *error);

@interface LCLivePlayManager : NSObject

@property (nonatomic, assign) BOOL isTest;

@property (nonatomic, weak) id <LCLivePlayManagerDelegate>delegate;


/* getSDKVersionStr 获取SDK版本信息
 */
+ (NSString *)getSDKVersionStr;
/**
 登录房间
 
 @param roomID 房间号
 @param userID 当前用户
 @param token  用户签名
 @param completeBlock 登录成功与否回调
 */
- (void)loginWithRoomID:(NSString *)roomID
                 userID:(NSString *)userID
                  token:(NSString *)token
          completeBlock:(CompleteBlock)completeBlock;
/*
 * setFrontRotation 设置正面摄像头画面的方向, 在播放前设置
 * 参数：
 *       rotation : 详见 TX_Enum_Type_HomeOrientation 的定义.
 */
- (void)setFrontRotation:(TX_Enum_Type_HomeOrientation)rotation;

/*
 * setFrontRotation 设置侧面摄像头画面的方向, 在播放前设置
 * 参数：
 *       rotation : 详见 TX_Enum_Type_HomeOrientation 的定义.
 */
- (void)setSideRotation:(TX_Enum_Type_HomeOrientation)rotation;


/**
 开始正摄像头播放
 @param view 该控件承载着视频内容的展示。
 */
- (void)startPlayFrontWithContainView:(UIView *)view;

/**
 开始侧面摄像头播放
 @param view 该控件承载着视频内容的展示。
 */
- (void)startPlaySideWithContainView:(UIView *)view;

/**
 停止正面视频播放
 */
- (void)stopPlayFront;
/**
 停止侧面视频播放
 */
- (void)stopPlaySide;
@end

