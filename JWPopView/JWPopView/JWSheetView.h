//
//  JWSheetView.h
//  JWPopView
//
//  Created by wangjun on 16/6/24.
//  Copyright © 2016年 wangjun. All rights reserved.
//

#import "JWPopView.h"

@interface JWSheetView : JWPopView

/**
 *  初始化方法
 *
 *  @param title 标题
 *  @param items 按钮数组
 *
 *  @return 返回当前类的实例
 */
- (instancetype)initWithTitle:(NSString *)title
                        items:(NSArray *)items;

/**
 *  初始化方法
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

@end

@interface JWSheetViewConfig : NSObject

/**
 *  单利模式，初始化配置，保证配置项只有一份
 *
 *  @return 返回当前类的实例
 */
+ (JWSheetViewConfig *)globalConfig;

/**
 *  控件相对于View的偏移量，default is 20
 */
@property (nonatomic, assign) CGFloat margin;
/**
 *  item的高度，default is 50
 */
@property (nonatomic, assign) CGFloat itemHeight;

/**
 *  背景色，default is #FFFFFF
 */
@property (nonatomic, strong) UIColor *backgroundColor;
/**
 *  标题色，default is #333333
 */
@property (nonatomic, strong) UIColor *titleColor;
/**
 *  内容色，default is #666666
 */
@property (nonatomic, strong) UIColor *contentColor;
/**
 *  分割线、按钮border，色，default is #CCCCCC
 */
@property (nonatomic, strong) UIColor *splitColor;

/**
 *  标题字体大小，default is [UIFont systemFontOfSize:18]
 */
@property (nonatomic, strong) UIFont *titleFont;
/**
 *  内容字体大小，default is [UIFont systemFontOfSize:14]
 */
@property (nonatomic, strong) UIFont *contentFont;
/**
 *  item字体大小，default is [UIFont systemFontOfSize:17]
 */
@property (nonatomic, strong) UIFont *itemFont;

/**
 *  item字体Normal状态下的颜色，default is #333333
 */
@property (nonatomic, strong) UIColor *itemNormalColor;
/**
 *  item字体Disable状态下的颜色，default is #CCCCCC
 */
@property (nonatomic, strong) UIColor *itemDisableColor;
/**
 *  item字体Highlight状态下的颜色，default is #E76153
 */
@property (nonatomic, strong) UIColor *itemHighlightColor;
/**
 *  item被按下时的颜色，default is EFEDE7
 */
@property (nonatomic, strong) UIColor *itemPressedColor;

/**
 *  item默认的cancel按钮标题，default is 取消
 */
@property (nonatomic, copy) NSString *itemTextCancel;

/**
 *  蒙板颜色，Default is [UIColor jw_colorWithHex:0x0000007F]
 */
@property (nonatomic, strong) UIColor *attachedViewColor;

@end































