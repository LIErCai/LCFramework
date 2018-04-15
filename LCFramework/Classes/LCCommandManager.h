

#import <Foundation/Foundation.h>
#import <SocketRocket/SocketRocket.h>
#import <CoreGraphics/CoreGraphics.h>

extern NSString * const kNeedPayOrderNote;
extern NSString * const kWebSocketDidOpenNote;
extern NSString * const kWebSocketDidCloseNote;
extern NSString * const kWebSocketdidReceiveMessageNote;

typedef NS_ENUM(NSInteger, ACTIONType) {
    ACTION_FORWARD     =  1 ,
    ACTION_BACK        =  2 ,
    ACTION_LEFT        =  3 ,
    ACTION_RIGHT       =  4 ,
    ACTION_DONE        =  5 ,
    ACTION_FORWARD_STOP = 6 ,
    ACTION_BACK_STOP    = 7 ,
    ACTION_LEFT_STOP    = 8 ,
    ACTION_RIGHT_STOP   = 9
};


@protocol LCCommandManagerDelegate <NSObject>

@optional
- (void)webSocketDidOpend;
- (void)webSocketDidReceiveMsg:(id)message;
- (void)webSocketLinkIsNotNormalWithMessage:(NSError *)error;
- (void)webSocketDidClosedWithCode:(NSInteger)code reason:(NSString *)reason;
- (void)webSocketDidFailed;
@end

@interface LCCommandManager : NSObject

// 获取连接状态
@property (nonatomic,assign,readonly) SRReadyState socketReadyState;

@property (nonatomic, weak) id <LCCommandManagerDelegate>delegate;

+ (LCCommandManager *)instance;

/**
 开启连接
 @param urlStr 连接地址
 */
-(void)connectWithUrlStr:(NSString *)urlStr;

/**
 关闭连接
 */
-(void)disConnect;

/**
 发送数据
 */
- (void)sendCommand:(ACTIONType)command;

@end

