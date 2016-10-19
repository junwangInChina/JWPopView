//
//  JWPopView.h
//  JWPopView
//
//  Created by wangjun on 16/6/24.
//  Copyright © 2016年 wangjun. All rights reserved.
//

#import <UIKit/UIKit.h>

#define JWWeakify(o)        __weak   typeof(self) mmwo = o;
#define JWStrongify(o)      __strong typeof(self) o = mmwo;
#define JW_SPLIT_WIDTH      (1/[UIScreen mainScreen].scale)

#define JWAlertTag      520
#define JWSheetTag      521

typedef NS_ENUM(NSInteger, JWPopType) {
    JWPopTypeAlert,
    JWPopTypeSheet,
    JWPopTypeCustom
};

@class JWPopView;

/**
 *  动画块
 *
 *  @param JWPopView 当前View
 */
typedef void(^JWPopAnimationBlock)(JWPopView *);

/**
 *  操作块
 *
 *  @param JWPopView 当前View
 *  @param BOOL      是否完成
 */
typedef void(^JWPopCompletionBlock)(JWPopView *, BOOL);

@interface JWPopView : UIView

/**
 *  是否可触摸，default is NO
 */
@property (nonatomic, assign ,readonly) BOOL           visible;
/**
 *  附加View，展示在哪个View上，default is JWWindow
 */
@property (nonatomic, strong          ) UIView         *attachedView;
/**
 *  弹出框类型，default is JWPopTypeAlert
 */
@property (nonatomic, assign          ) JWPopType      type;
/**
 *  动画执行时间，default is 0.3s
 */
@property (nonatomic, assign          ) NSTimeInterval animationDuration;
/**
 *  是否有键盘
 */
@property (nonatomic, assign          ) BOOL           withKeyboard;

/**
 *  展示完成代码块
 */
@property (nonatomic, copy) JWPopCompletionBlock showCompletionBlock;
/**
 *  隐藏完成代码块
 */
@property (nonatomic, copy) JWPopCompletionBlock hideCompletionBlock;
/**
 *  展示动画代码块
 */
@property (nonatomic, copy) JWPopAnimationBlock  showAnimationBlock;
/**
 *  隐藏动画代码块
 */
@property (nonatomic, copy) JWPopAnimationBlock  hideAnimationBlock;

/**
 *  展示方法
 */
- (void)show;

/**
 *  展示方法，带展示完成回调Block
 *
 *  @param block 展示完成回调Block
 */
- (void)showWithBlock:(JWPopCompletionBlock)block;

/**
 *  展示方法，带收起完成回调Block
 *
 *  @param block 收起完成回调Block
 */
- (void)showWithHideBlock:(JWPopCompletionBlock)block;

/**
 *  隐藏方法
 */
- (void)hide;

/**
 *  隐藏方法，带隐藏完成回调Block
 *
 *  @param block 隐藏完成回调Block
 */
- (void)hideWithBlock:(JWPopCompletionBlock)block;

/**
 *  展示所有
 */
- (void)hideAll;

/**
 *  当需要弹出键盘时，需要重写此方法
 */
- (void)showKeyboard;

/**
 *  与上一个方法对应
 */
- (void)hideKeyboard;

@end





























