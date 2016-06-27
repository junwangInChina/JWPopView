//
//  JWPopWindow.h
//  JWPopView
//
//  Created by wangjun on 16/6/24.
//  Copyright © 2016年 wangjun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JWPopWindow : UIWindow

/**
 *  点击背景收起弹框属性，default is YES
 */
@property (nonatomic, assign) BOOL touchWhildHide;
/**
 *  展示弹框的View
 */
@property (nonatomic, readonly) UIView *attachView;

+ (JWPopWindow *)shareWindow;

- (void)cacheWindow;

@end
