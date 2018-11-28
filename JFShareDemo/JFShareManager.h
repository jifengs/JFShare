//
//  JFShareManager.h
//  JFShareDemo
//
//  Created by Ji Feng on 2018/11/28.
//  Copyright © 2018 Ji Feng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JFShareType) {
    JFShareTypeDefault, //!<默认图文带连接的分享
    JFShareTypeImage,   //!<图片分享
    JFShareTypeMusic    //!<音乐分享
};

typedef NS_ENUM(NSInteger, JFSharePlatform) {
    JFSharePlatformWXSession = 100,   //!<微信聊天界面
    JFSharePlatformWXTimeline,        //!<微信朋友圈
    JFSharePlatformQQ,                //!<QQ
    JFSharePlatformQzone,             //!<QQ空间
    JFSharePlatformSina,              //!<新浪微博
    JFSharePlatformSms                //!<短信
};

@interface JFShareManager : UIView

/**
 presentedController 如果发送的平台微博只有一个并且没有授权，传入要授权的viewController，将弹出授权页面，进行授权。可以传nil，将不进行授权。
 */
@property (nonatomic, unsafe_unretained) UIViewController *presentedController;
@property (nonatomic, strong) NSString *shareTitle;//!<第三方平台显示分享的标题
@property (nonatomic, strong) NSString *shareContent;//!<第三方平台显示分享的内容
@property (nonatomic, strong) NSString *shareURL;//!<分享链接地址
@property (nonatomic, strong) UIImage *shareImage;//!<分享图片

//********************音乐分享用到的***************************
@property (nonatomic, strong) NSString *shareImageURL;//!<分享图片URL（qq分享音乐用）
@property (nonatomic, strong) NSString *musicURL;//!<音乐分享连接地址

/**
 *  分享的类型
 *  note:如果是音乐分享，在设置shareType前要先设置musicURL
 */
@property (nonatomic, unsafe_unretained) JFShareType shareType;

@property (nonatomic, copy) dispatch_block_t shareSuccessBlock;


+ (JFShareManager *)sharedManager;

- (void)showShareView;
- (void)showInviteFriendsShareView;//!<邀请好友显示的分享
- (void)showImageShare;//!<只分享图片
- (void)showMusicShare;//!<音乐分享

- (void)shareToWXSession;//!<微信聊天界面
- (void)shareToWXTimeline;//!<微信朋友圈
- (void)shareToQQ;
- (void)shareToQzone;
- (void)shareToSina;
- (void)shareToSms;
- (void)shareToPlatform:(JFSharePlatform)platform;

@end

NS_ASSUME_NONNULL_END
