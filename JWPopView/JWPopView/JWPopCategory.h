//
//  JWPopCategory.h
//  JWPopView
//
//  Created by wangjun on 16/6/24.
//  Copyright © 2016年 wangjun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (JWPop)

+ (UIColor *)jw_colorWithHex:(NSUInteger)hex;

@end

@interface UIImage (JWPop)

+ (UIImage *)jw_imageWithColor:(UIColor *)color;

+ (UIImage *)jw_imageWithColor:(UIColor *)color size:(CGSize)size;

- (UIImage *)jw_imageStretched;

@end

@interface UIView (JWPop)

@property (nonatomic, strong, readonly) UIView            *jw_dimBackgroundView;
@property (nonatomic, assign, readonly) BOOL              jw_dimBackgroundAnimating;
@property (nonatomic, assign          ) NSTimeInterval    jw_dimAnimationDuration;

@property (nonatomic, strong, readonly) UIView            *jw_dimBackgroundBlurView;
@property (nonatomic, assign          ) BOOL              jw_dimBackgroundBlurEnable;
@property (nonatomic, assign          ) UIBlurEffectStyle jw_dimBackgroundBlurEffectStyle;

- (void)jw_showDimBackground;
- (void)jw_hideDimBackground;

- (void)jw_distributeSpacingHorizontallyWith:(NSArray *)view;
- (void)jw_distributeSpacingVerticallyWith:(NSArray *)view;

@end





























