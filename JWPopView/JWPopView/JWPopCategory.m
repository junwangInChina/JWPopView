//
//  JWPopCategory.m
//  JWPopView
//
//  Created by wangjun on 16/6/24.
//  Copyright © 2016年 wangjun. All rights reserved.
//

#import "JWPopCategory.h"

#import "JWPopWindow.h"

#import <objc/runtime.h>

#import <Masonry/Masonry.h>

#pragma mark - UIColor (JWPop)

@implementation UIColor (JWPop)

+ (UIColor *)jw_colorWithHex:(NSUInteger)hex
{
    float r = (hex & 0xff000000) >> 24;
    float g = (hex & 0x00ff0000) >> 16;
    float b = (hex & 0x0000ff00) >> 8;
    float a = (hex & 0x000000ff);
    
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a/255.0];
}

@end

#pragma mark - UIImage (JWPop)

@implementation UIImage (JWPop)

+ (UIImage *)jw_imageWithColor:(UIColor *)color
{
    return [UIImage jw_imageWithColor:color size:CGSizeMake(4.0f, 4.0f)];
}

+ (UIImage *)jw_imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect tempRect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(size);
    CGContextRef tempContext = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(tempContext, color.CGColor);
    CGContextFillRect(tempContext, tempRect);
    
    UIImage *tempImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [tempImage jw_imageStretched];
}

- (UIImage *)jw_imageStretched
{
    CGSize tempSize = self.size;
    UIEdgeInsets tempInsets = UIEdgeInsetsMake(truncf(tempSize.height - 1) / 2,
                                               truncf(tempSize.width - 1) / 2,
                                               truncf(tempSize.height - 1) / 2,
                                               truncf(tempSize.width - 1) / 2);
    return [self resizableImageWithCapInsets:tempInsets];
}

@end

#pragma mark - UIView (JWPopInner)

static const void *jw_dimReferenceCountKey = &jw_dimReferenceCountKey;

@interface UIView (JWPopInner)

@property (nonatomic, assign, readwrite) NSInteger jw_dimReferenceCount;

@end

@implementation UIView (JWPopInner)

@dynamic jw_dimReferenceCount;

- (NSInteger)jw_dimReferenceCount
{
    return [objc_getAssociatedObject(self, jw_dimReferenceCountKey) integerValue];
}

- (void)setJw_dimReferenceCount:(NSInteger)jw_dimReferenceCount
{
    objc_setAssociatedObject(self, jw_dimReferenceCountKey, @(jw_dimReferenceCount), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

#pragma mark - UIView (JWPop)

static const void *jw_dimBackgroundViewKey            = &jw_dimBackgroundViewKey;
static const void *jw_dimAnimationDuritionKey         = &jw_dimAnimationDuritionKey;
static const void *jw_dimBackgroundAnimatingKey       = &jw_dimBackgroundAnimatingKey;

static const void *jw_dimBackgroundBlurViewKey        = &jw_dimBackgroundBlurViewKey;
static const void *jw_dimBackgroundBlurEnableKey      = &jw_dimBackgroundBlurEnableKey;
static const void *jw_dimBackgroundBlurEffectStyleKey = &jw_dimBackgroundBlurEffectStyleKey;

@implementation UIView (JWPop)

@dynamic jw_dimBackgroundView;
@dynamic jw_dimAnimationDuration;
@dynamic jw_dimBackgroundAnimating;
@dynamic jw_dimBackgroundBlurView;

#pragma mark - Getter
- (UIView *)jw_dimBackgroundView
{
    UIView *tempBackgroundView = objc_getAssociatedObject(self, jw_dimBackgroundViewKey);
    
    if (!tempBackgroundView)
    {
        tempBackgroundView = [UIView new];
        tempBackgroundView.alpha = 0.0f;
        tempBackgroundView.backgroundColor = [UIColor jw_colorWithHex:0x0000007F];
        tempBackgroundView.layer.zPosition = FLT_MAX;
        [self addSubview:tempBackgroundView];
        [tempBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        self.jw_dimAnimationDuration = 0.3f;
        
        objc_setAssociatedObject(self, jw_dimBackgroundViewKey, tempBackgroundView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return tempBackgroundView;
}

- (BOOL)jw_dimBackgroundBlurEnable
{
    return objc_getAssociatedObject(self, jw_dimBackgroundAnimatingKey);
}

- (UIBlurEffectStyle)jw_dimBackgroundBlurEffectStyle
{
    return [objc_getAssociatedObject(self, jw_dimBackgroundBlurEffectStyleKey) integerValue];
}

- (UIView *)jw_dimBackgroundBlurView
{
    UIView *tempBlurView = objc_getAssociatedObject(self, jw_dimBackgroundBlurViewKey);
    
    if (!tempBlurView)
    {
        tempBlurView = [UIView new];
        
        if ([UIVisualEffectView class])
        {
            UIVisualEffectView *tempEffecView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:self.jw_dimBackgroundBlurEffectStyle]];
            [tempBlurView addSubview:tempEffecView];
            [tempEffecView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(tempBlurView);
            }];
        }
        else
        {
            tempBlurView.backgroundColor = @[[UIColor jw_colorWithHex:0x000007F],
                                             [UIColor jw_colorWithHex:0xFFFFFF7F],
                                             [UIColor jw_colorWithHex:0xFFFFFF7F]][self.jw_dimBackgroundBlurEffectStyle];
        }
        tempBlurView.userInteractionEnabled = NO;
        
        objc_setAssociatedObject(self, jw_dimBackgroundBlurViewKey, tempBlurView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    
    return tempBlurView;
}

- (BOOL)jw_dimBackgroundAnimating
{
    return [objc_getAssociatedObject(self, jw_dimBackgroundAnimatingKey) boolValue];
}

- (NSTimeInterval)jw_dimAnimationDuration
{
    return [objc_getAssociatedObject(self, jw_dimAnimationDuritionKey) doubleValue];
}

#pragma mark - Setter
- (void)setJw_dimBackgroundBlurEnable:(BOOL)jw_dimBackgroundBlurEnable
{
    objc_setAssociatedObject(self, jw_dimBackgroundBlurEnableKey, @(jw_dimBackgroundBlurEnable), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (jw_dimBackgroundBlurEnable)
    {
        self.jw_dimBackgroundView.backgroundColor = [UIColor jw_colorWithHex:0x00000000];
        self.jw_dimBackgroundBlurEffectStyle = self.jw_dimBackgroundBlurEffectStyle;
        self.jw_dimBackgroundBlurView.hidden = NO;
    }
    else
    {
        self.jw_dimBackgroundView.backgroundColor = [UIColor jw_colorWithHex:0x0000007F];
        self.jw_dimBackgroundBlurView.hidden = YES;
    }
}

- (void)setJw_dimBackgroundBlurEffectStyle:(UIBlurEffectStyle)jw_dimBackgroundBlurEffectStyle
{
    objc_setAssociatedObject(self, jw_dimBackgroundBlurEffectStyleKey, @(jw_dimBackgroundBlurEffectStyle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.jw_dimBackgroundBlurEnable)
    {
        [self.jw_dimBackgroundBlurView removeFromSuperview];
        self.jw_dimBackgroundBlurView = nil;
        
        UIView *tempBlurView = [self jw_dimBackgroundBlurView];
        [self.jw_dimBackgroundView addSubview:tempBlurView];
        [tempBlurView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.jw_dimBackgroundView);
        }];
    }
}

- (void)setJw_dimBackgroundBlurView:(UIView *)jw_dimBackgroundBlurView
{
    objc_setAssociatedObject(self, jw_dimBackgroundBlurViewKey, jw_dimBackgroundBlurView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setJw_dimBackgroundAnimating:(BOOL)jw_dimBackgroundAnimating
{
    objc_setAssociatedObject(self, jw_dimBackgroundAnimatingKey, @(jw_dimBackgroundAnimating), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setJw_dimAnimationDuration:(NSTimeInterval)jw_dimAnimationDuration
{
    objc_setAssociatedObject(self, jw_dimAnimationDuritionKey, @(jw_dimAnimationDuration), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - extend

- (void)jw_showDimBackground
{
    ++self.jw_dimReferenceCount;
    
    if (self.jw_dimReferenceCount > 1) return;
    
    self.jw_dimBackgroundView.hidden = NO;
    self.jw_dimBackgroundAnimating = YES;
    
    if (self == [JWPopWindow shareWindow].attachView)
    {
        [JWPopWindow shareWindow].hidden = NO;
        [[JWPopWindow shareWindow] makeKeyAndVisible];
    }
    else if ([self isKindOfClass:[UIWindow class]])
    {
        self.hidden = NO;
        [(UIWindow *)self makeKeyAndVisible];
    }
    else
    {
        [self bringSubviewToFront:self.jw_dimBackgroundView];
    }
    
    [UIView animateWithDuration:self.jw_dimAnimationDuration delay:0.0f options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        self.jw_dimBackgroundView.alpha = 1.0f;
        
    } completion:^(BOOL finished) {
        
        if (finished)
        {
            self.jw_dimBackgroundAnimating = NO;
        }
        
    }];
}

- (void)jw_hideDimBackground
{
    --self.jw_dimReferenceCount;
    if (self.jw_dimReferenceCount > 0) return;
    
    self.jw_dimBackgroundAnimating = YES;
    [UIView animateWithDuration:self.jw_dimAnimationDuration delay:0.0f options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        self.jw_dimBackgroundView.alpha = 0.0f;
        
    } completion:^(BOOL finished) {
        
        if (finished)
        {
            self.jw_dimBackgroundAnimating = NO;
            
            if (self == [JWPopWindow shareWindow].attachView)
            {
                [JWPopWindow shareWindow].hidden = YES;
                [[[UIApplication sharedApplication].delegate window] makeKeyAndVisible];
            }
            else if (self == [JWPopWindow shareWindow])
            {
                self.hidden = YES;
                [[[UIApplication sharedApplication].delegate window] makeKeyAndVisible];
            }
        }
    }];
}

- (void)jw_distributeSpacingHorizontallyWith:(NSArray *)view
{
    
}

- (void)jw_distributeSpacingVerticallyWith:(NSArray *)view
{
    
}

@end










































