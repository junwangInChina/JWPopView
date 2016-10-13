//
//  JWAlertView.h
//  JWPopView
//
//  Created by wangjun on 16/6/24.
//  Copyright © 2016年 wangjun. All rights reserved.
//

#import "JWPopView.h"

typedef void(^JWAlertInputHandler)(NSString *inputText);

@interface JWAlertView : JWPopView

/**
 *  初始化方法，默认两个按钮（取消、确认）
 *
 *  @param title   标题
 *  @param content 内容
 *
 *  @return 返回当前类的实例
 */
- (instancetype)initWithTitle:(NSString *)title
                      content:(NSString *)content;

/**
 *  初始化方法，按钮由用户决定
 *
 *  @param title   标题
 *  @param content 内容
 *  @param items   按钮数组
 *
 *  @return 返回当前类的实例
 */
- (instancetype)initWithTitle:(NSString *)title
                      content:(NSString *)content
                        items:(NSArray *)items;

/**
 *  初始化方法，加输入框的
 *
 *  @param title       标题
 *  @param content     内容
 *  @param placeholder 输入框默认提示语
 *  @param handler     输入回调
 *
 *  @return 返回当前类的实例
 */
- (instancetype)initWithTitle:(NSString *)title
                      content:(NSString *)content
                  placeholder:(NSString *)placeholder
                      handler:(JWAlertInputHandler)handler;

/**
 *  初始化方法，总方法
 *
 *  @param title       标题
 *  @param content     内容
 *  @param items       按钮数组
 *  @param placeholder 输入框默认提示语
 *  @param handler     输入回调
 *
 *  @return 返回当前类的实例
 */
- (instancetype)initWithTitle:(NSString *)title
                      content:(NSString *)content
                        items:(NSArray *)items
                  placeholder:(NSString *)placeholder
                      handler:(JWAlertInputHandler)handler;

@end

@interface JWAlertViewConfig : NSObject

/**
 *  单利模式，初始化配置，保证配置项只有一份
 *
 *  @return 返回当前类的实例
 */
+ (JWAlertViewConfig *)globalConfig;

/**
 *  弹出框宽度 Default is 275
 */
@property (nonatomic, assign) CGFloat width;
/**
 *  item高度，Default is 50
 */
@property (nonatomic, assign) CGFloat itemHeight;
/**
 *  控件相对View的偏移量，Default is 25
 */
@property (nonatomic, assign) CGFloat margin;
/**
 *  弧度，Default is 5
 */
@property (nonatomic, assign) CGFloat cornerRadius;

/**
 *  标题字体大小，Default is [UIFont systemFontOfSize:18]
 */
@property (nonatomic, strong) UIFont *titleFont;
/**
 *  内容字体大小，Default is [UIFont systemFontOfSize:14]
 */
@property (nonatomic, strong) UIFont *contentFont;
/**
 *  按钮字体大小，Default is [UIFont systemFontOfSize:17]
 */
@property (nonatomic, strong) UIFont *itemFont;

/**
 *  背景色，Default is #FFFFFF
 */
@property (nonatomic, strong) UIColor *backgroundColor;
/**
 *  标题色，Default is #333333
 */
@property (nonatomic, strong) UIColor *titleColor;
/**
 *  内容色，Default is #333333
 */
@property (nonatomic, strong) UIColor *contentColor;
/**
 *  分割线的颜色，包括输入框border、按钮border，Default is #CCCCCC
 */
@property (nonatomic, strong) UIColor *splitColor;

/**
 *  按钮标题常态下的颜色，Default is #333333
 */
@property (nonatomic, strong) UIColor *itemNormalColor;
/**
 *  按钮标题点击状态下的颜色，Default is #E76153
 */
@property (nonatomic, strong) UIColor *itemHighlightColor;
/**
 *  按钮点击状态背景色，Default is #EFEDE7
 */
@property (nonatomic, strong) UIColor *itemPressedColor;

/**
 *  OK按钮的标题，Default is 好
 */
@property (nonatomic, copy) NSString *itemTextOK;
/**
 *  Cancel按钮的标题，Default is 取消
 */
@property (nonatomic, copy) NSString *itemTextCancel;
/**
 *  Confirm按钮的标题，Default is 确认
 */
@property (nonatomic, copy) NSString *itemTextConfirm;
/**
 *  蒙板颜色，Default is [UIColor jw_colorWithHex:0x0000007F]
 */
@property (nonatomic, strong) UIColor *attachedViewColor;

@end

