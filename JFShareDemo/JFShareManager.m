//
//  JFShareManager.m
//  JFShareDemo
//
//  Created by Ji Feng on 2018/11/28.
//  Copyright © 2018 Ji Feng. All rights reserved.
//

#import "JFShareManager.h"
#import <UMSocialCore/UMSocialCore.h>
#import "UMSocialQQHandler.h"
#import "WXApi.h"
#import <MessageUI/MessageUI.h>
#import <TencentOpenAPI/QQApiInterface.h>
//#import "UIImage+Extension.h"

#pragma mark - 屏幕宽高
#define SHARE_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SHARE_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SHARE_TITLE_NORMALCOLOR SHARE_UICOLOR_FROMRGB(0x666666)
#define SHARE_TITLE_HCOLOR SHARE_UICOLOR_FROMRGB(0x818081)
#define SHARE_UICOLOR_FROMRGB(rgbValue) [UIColor colorWithRed:((float)(((rgbValue) & 0xFF0000) >> 16))/255.0 green:((float)(((rgbValue) & 0xFF00) >> 8))/255.0 blue:((float)((rgbValue) & 0xFF))/255.0 alpha:1.0]

@interface JFShareManager ()
{
    UIView *_bottomView;
    CGFloat _bottomHeight;
    UIButton *_cancelButton;
}

@end

@implementation JFShareManager

+ (JFShareManager *)sharedManager {
    static JFShareManager *shareManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[JFShareManager alloc] init];
    });
    return shareManager;
}

- (id)init {
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, SHARE_SCREEN_WIDTH, SHARE_SCREEN_HEIGHT);
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:.6];
        
        [self judgeBottomHeight];
        
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SHARE_SCREEN_HEIGHT, SHARE_SCREEN_WIDTH, _bottomHeight)];
        _bottomView.backgroundColor = SHARE_UICOLOR_FROMRGB(0xffffff);
        [self addSubview:_bottomView];
        
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(30, 25, SHARE_SCREEN_WIDTH - 60, .5)];
        topLine.backgroundColor = SHARE_UICOLOR_FROMRGB(0xe0e0e0);
        [_bottomView addSubview:topLine];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((SHARE_SCREEN_WIDTH - 68)/2.0, 25 - 10, 68, 20)];
        titleLabel.backgroundColor = _bottomView.backgroundColor;
        titleLabel.textColor = SHARE_UICOLOR_FROMRGB(0x999999);
        titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
        titleLabel.text = @"分享到";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [_bottomView addSubview:titleLabel];
        
        [self createShareButtons];
        
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [_cancelButton setBackgroundImage:[self imageWithColor:SHARE_UICOLOR_FROMRGB(0xebebeb)] forState:UIControlStateHighlighted];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:SHARE_TITLE_NORMALCOLOR forState:UIControlStateNormal];
        [_cancelButton setTitleColor:SHARE_TITLE_HCOLOR forState:UIControlStateHighlighted];
        [_cancelButton addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton.frame = CGRectMake(0, _bottomHeight - 44, SHARE_SCREEN_WIDTH, 44);
        [_bottomView addSubview:_cancelButton];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SHARE_SCREEN_WIDTH, .5)];
        line.backgroundColor = SHARE_UICOLOR_FROMRGB(0xe0e0e0);
        [_cancelButton addSubview:line];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

//根据第三方平台是否安装情况判断显示高度
- (void)judgeBottomHeight {
    //    if ([WXApi isWXAppInstalled] && [QQApiInterface isQQInstalled]){
    //        _bottomHeight = 265;
    //    }else{
    //        _bottomHeight = 265 - 80;
    _bottomHeight = 175;
    //    }
}

#pragma mark - 创建所有的分享按钮（每次show的时候都需要调用，因为本地的第三方软件随时可能发生变化，删除或者下载）
- (void)createShareButtons {
    int i = 0;
    CGFloat buttonWidth = 65;
    CGFloat buttonHeighh = 85;
    CGFloat top = (_bottomHeight - 44 - buttonHeighh)/2.0;
    
    for (int j = 0; j < 7; j++) {
        
        CGFloat space = (SHARE_SCREEN_WIDTH - buttonWidth * 4)/5.0;
        CGRect buttonFrame = CGRectMake(space + (i%4) * (buttonWidth + space), top + (i/4) * (buttonHeighh + 5), buttonWidth, buttonHeighh);
        UIButton *shareButton;
        switch (j) {
            case 0:
            {//微信
                if ([WXApi isWXAppInstalled]) {
                    i++;
                    shareButton = [self createShareButtonWithFrame:buttonFrame
                                                               tag:JFSharePlatformWXSession
                                                             title:@"微信好友"
                                                       normalImage:@"share_wx"
                                                  highlightedImage:@"share_wx_h"];
                }
            }
                break;
            case 1:
            {//微信朋友圈
                if ([WXApi isWXAppInstalled]) {
                    i++;
                    shareButton = [self createShareButtonWithFrame:buttonFrame
                                                               tag:JFSharePlatformWXTimeline
                                                             title:@"微信朋友圈"
                                                       normalImage:@"share_wxfc"
                                                  highlightedImage:@"share_wxfc_h"];
                }
            }
                break;
            case 2:
            {//新浪微博
                i++;
                shareButton = [self createShareButtonWithFrame:buttonFrame
                                                           tag:JFSharePlatformSina
                                                         title:@"新浪微博"
                                                   normalImage:@"share_sina"
                                              highlightedImage:@"share_sina_h"];
            }
                break;
                
            case 3:
            {//QQ
                if ([QQApiInterface isQQInstalled]) {
                    i++;
                    shareButton = [self createShareButtonWithFrame:buttonFrame
                                                               tag:JFSharePlatformQQ
                                                             title:@"QQ"
                                                       normalImage:@"share_qq"
                                                  highlightedImage:@"share_qq_h"];
                }
            }
                break;
            case 4:
            {//QQ空间
                if ([QQApiInterface isQQInstalled]) {
                    i++;
                    shareButton = [self createShareButtonWithFrame:buttonFrame
                                                               tag:JFSharePlatformQzone
                                                             title:@"QQ空间"
                                                       normalImage:@"share_qqzone"
                                                  highlightedImage:@"share_qqzone_h"];
                }
            }
                break;
            case 5:
            {//短信
                if([MFMessageComposeViewController canSendText]) {
                    i++;
                    shareButton = [self createShareButtonWithFrame:buttonFrame
                                                               tag:JFSharePlatformSms
                                                             title:@"短信"
                                                       normalImage:@"share_sms"
                                                  highlightedImage:@"share_sms_h"];
                }
            }
                break;
            default:
                break;
        }
    }
}

- (UIButton *)createShareButtonWithFrame:(CGRect)frame
                                     tag:(int)tag
                                   title:(NSString *)title
                             normalImage:(NSString *)normalImage
                        highlightedImage:(NSString *)highlightedImage {
    UIButton *button = (UIButton *)[_bottomView viewWithTag:tag];
    if ([button isKindOfClass:[UIButton class]]) {
        button.frame = frame;
        return button;
    }
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.tag = tag;
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    //    [button setImage:[UIImage imageNamed:highlightedImage] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    button.titleEdgeInsets = UIEdgeInsetsMake(80, -65, 0, 0);
    if ([UIDevice currentDevice].systemVersion.floatValue < 7.0) {
        button.titleEdgeInsets = UIEdgeInsetsMake(80, -56, 0, 0);
    }
    [button setTitleColor:SHARE_TITLE_NORMALCOLOR forState:UIControlStateNormal];
    [button setTitleColor:SHARE_TITLE_HCOLOR forState:UIControlStateHighlighted];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
    button.exclusiveTouch = YES;
    [_bottomView addSubview:button];
    return button;
}

- (void)tapAction {
    [self dismissView];
}

- (void)showShareView {
    //每次显示分享界面的时候，需要重新判断显示的分享平台
    for (UIButton *button in _bottomView.subviews) {
        if ([button isKindOfClass:[UIButton class]]) {
            button.frame = CGRectZero;
        }
    }
    [self judgeBottomHeight];
    _bottomView.frame = CGRectMake(0, SHARE_SCREEN_HEIGHT, SHARE_SCREEN_WIDTH, _bottomHeight);
    _cancelButton.frame = CGRectMake(0, _bottomHeight - 50, SHARE_SCREEN_WIDTH, 50);
    [self createShareButtons];
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [window addSubview:self];
    
    __weak typeof(self) weakSelf = self;
    
    UIView *weakBottomView = _bottomView;
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakSelf.backgroundColor = [UIColor colorWithWhite:0 alpha:.6];
        weakBottomView.frame = CGRectMake(0, SHARE_SCREEN_HEIGHT - _bottomHeight, SHARE_SCREEN_WIDTH, _bottomHeight);
        
    } completion:^(BOOL finished){
        
    }];
}

- (void)dismissView {
    __weak typeof(self) weakSelf = self;
    UIView *weakBottomView = _bottomView;
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakSelf.backgroundColor = [UIColor colorWithWhite:0 alpha:.0];
        weakBottomView.frame = CGRectMake(0, SHARE_SCREEN_HEIGHT, SHARE_SCREEN_WIDTH, _bottomHeight);
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

- (void)setShareType:(JFShareType)shareType {
    _shareType = shareType;
    
    switch (shareType) {
        case JFShareTypeDefault:
        {
            //            [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeDefault url:nil];
            self.musicURL = nil;
        }
            break;
        case JFShareTypeImage:
        {
            //            [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:nil];
            self.musicURL = nil;
            self.shareContent = nil;
        }
            break;
        case JFShareTypeMusic:
        {
            //            [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeMusic url:self.musicURL];
        }
            break;
    }
}

#pragma mark - 邀请好友的分享
- (void)showInviteFriendsShareView {
    self.shareType = JFShareTypeDefault;
    [self showShareView];
}

#pragma mark - 只分享图片
- (void)showImageShare {
    self.shareType = JFShareTypeImage;
    [self showShareView];
}

#pragma mark -  带音乐的分享
- (void)showMusicShare {
    self.shareType = JFShareTypeMusic;
    [self showShareView];
}

- (void)shareMusicToWXWithType:(int)type {
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = self.shareTitle;
    message.description = self.shareContent;
    [message setThumbImage:self.shareImage];
    
    WXMusicObject *musicObject = [WXMusicObject object];
    musicObject.musicUrl = self.shareURL;
    musicObject.musicDataUrl = self.musicURL;
    
    message.mediaObject = musicObject;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = type;
    
    [WXApi sendReq:req];
}

- (void)shareMusicToQQWithType:(int)type {
    QQApiAudioObject *audioObj =
    [QQApiAudioObject objectWithURL:[NSURL URLWithString:self.shareURL]
                              title:self.shareTitle
                        description:self.shareContent
                    previewImageURL:[NSURL URLWithString:self.shareImageURL]];
    [audioObj setFlashURL:[NSURL URLWithString:self.musicURL]];
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:audioObj];
    //将内容分享到qq
    if (0 == type) {
        [QQApiInterface sendReq:req];
    }else{//将内容分享到qzone
        [QQApiInterface SendReqToQZone:req];
    }
}

- (void)shareToWXSession {
    [self shareToPlatform:JFSharePlatformWXSession];
}

- (void)shareToWXTimeline {
    [self shareToPlatform:JFSharePlatformWXTimeline];
}

- (void)shareToQQ {
    [self shareToPlatform:JFSharePlatformQQ];
}

- (void)shareToQzone {
    [self shareToPlatform:JFSharePlatformQzone];
}

- (void)shareToSina {
    [self shareToPlatform:JFSharePlatformSina];
}

- (void)shareToSms {
    [self shareToPlatform:JFSharePlatformSms];
}

#pragma mark - 分享
- (void)shareButtonAction:(UIButton *)button {
    [self dismissView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.27 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self shareToPlatform:button.tag];
    });
}

- (void)shareToPlatform:(JFSharePlatform)platform {
    
    NSString *shareContent = [self getShortShareContent];
    UMSocialPlatformType platformType;
    
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    messageObject.text = shareContent;
    
    if (_shareType == JFShareTypeDefault) {//图文分享
        UMShareWebpageObject *shareObject = [[UMShareWebpageObject alloc] init];
        if (_shareURL) {
            shareObject.webpageUrl = _shareURL;
        }
        if (self.shareTitle) {
            shareObject.title = _shareTitle;
        }
        shareObject.thumbImage = _shareImage;
        shareObject.descr = shareContent;
        messageObject.shareObject = shareObject;
        
    }else if (_shareType == JFShareTypeImage) {
        UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
        shareObject.shareImage = self.shareImage;
        messageObject.shareObject = shareObject;
        
    }else if (_shareType == JFShareTypeMusic) {
        UMShareMusicObject *shareObject = [[UMShareMusicObject alloc] init];
        shareObject.musicUrl = _musicURL;
        shareObject.musicDataUrl = _musicURL;
        
        if (self.shareTitle) {
            shareObject.title = _shareTitle;
        }
        shareObject.thumbImage = _shareImage;
        shareObject.descr = shareContent;
        messageObject.shareObject = shareObject;
        
        //音乐分享需要单独调用微信的，否则音乐url与跳转url冲突
        //        [self shareMusicToWXWithType:WXSceneSession];
        //        return;
    }
    
    
    switch (platform) {
        case JFSharePlatformWXSession:
        {//微信
            platformType = UMSocialPlatformType_WechatSession;
        }
            break;
        case JFSharePlatformWXTimeline:
        {//朋友圈
            platformType = UMSocialPlatformType_WechatTimeLine;
            //            if (self.shareType == JFShareTypeMusic) {
            //                //音乐分享需要单独调用微信的，否则音乐url与跳转url冲突
            //                [self shareMusicToWXWithType:WXSceneTimeline];
            //                return;
            //            }
        }
            break;
        case JFSharePlatformQQ:
        {//QQ好友
            platformType = UMSocialPlatformType_QQ;
            
            if (self.shareType == JFShareTypeMusic) {
                //音乐分享需要单独调用腾讯的，否则音乐url与跳转url冲突
                //                [self shareMusicToQQWithType:0];
                //                return;
            }
        }
            break;
        case JFSharePlatformQzone:
        {//QQ空间
            platformType = UMSocialPlatformType_Qzone;
            if (self.shareType == JFShareTypeMusic) {
                //音乐分享需要单独调用腾讯的，否则音乐url与跳转url冲突
                //                [self shareMusicToQQWithType:1];
                //                return;
            }
        }
            break;
        case JFSharePlatformSina:
        {//新浪微博
            platformType = UMSocialPlatformType_Sina;
            if (self.shareType == JFShareTypeMusic) {
                shareContent = [NSString stringWithFormat:@"%@%@", self.shareTitle, self.shareURL];
            }
            
        }
            break;
        case JFSharePlatformSms:
        {//短信
            platformType = UMSocialPlatformType_Sms;
        }
            break;
        default:
            break;
    }
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self.presentedController completion:^(id data, NSError *error) {
        if (!error) {
            if (self.shareSuccessBlock) {
                self.shareSuccessBlock();
            }
        }
    }];
}

- (NSString *)getShortShareContent {
    if (self.shareContent.length > 150) {
        self.shareContent = [[self.shareContent substringToIndex:147] stringByAppendingString:@"..."];
    }
    return self.shareContent;
}

- (UIImage *)imageWithColor:(UIColor*)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
