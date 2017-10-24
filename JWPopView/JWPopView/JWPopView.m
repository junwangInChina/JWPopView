//
//  JWPopView.m
//  JWPopView
//
//  Created by wangjun on 16/6/24.
//  Copyright © 2016年 wangjun. All rights reserved.
//

#import "JWPopView.h"

#import "JWPopWindow.h"
#import "JWPopCategory.h"

#import <Masonry/Masonry.h>

@implementation JWPopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.type = JWPopTypeAlert;
    self.animationDuration = 0.3f;
    self.attachedView = [JWPopWindow shareWindow].attachView;
    self.touchDismiss = YES;
}

#pragma mark getter
- (BOOL)visible
{
    if (self.attachedView)
    {
        return !self.attachedView.jw_dimBackgroundView.hidden;
    }
    return NO;
}

#pragma mark - setter

- (void)setType:(JWPopType)type
{
    _type = type;
    switch (type) {
        case JWPopTypeAlert:
            self.showAnimationBlock = [self alertShowAnimationBlock];
            self.hideAnimationBlock = [self alertHideAnimationBlock];
            break;
        case JWPopTypeSheet:
            self.showAnimationBlock = [self sheetShowAnimationBlock];
            self.hideAnimationBlock = [self sheetHideAnimationBlock];
            break;
        case JWPopTypeCustom:
            self.showAnimationBlock = [self customShowAnimationBlock];
            self.hideAnimationBlock = [self customHideAnimationBlock];
            break;
        default:
            break;
    }
}

- (void)setAnimationDuration:(NSTimeInterval)animationDuration
{
    _animationDuration = animationDuration;
    
    self.attachedView.jw_dimAnimationDuration = animationDuration;
}

#pragma mark - Helper
- (JWPopAnimationBlock)alertShowAnimationBlock
{
    JWWeakify(self);
    JWPopAnimationBlock block = ^(JWPopView *popView){
        JWStrongify(self);
        
        if (!self.superview)
        {
            [self.attachedView.jw_dimBackgroundView addSubview:self];
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self.attachedView).centerOffset(CGPointMake(0, self.withKeyboard ? -216/2 : 0));
            }];
            [self.superview layoutIfNeeded];
        }
        self.layer.transform = CATransform3DMakeScale(1.3f, 1.3f, 1.3f);
        self.alpha = 0.0f;
        
        [UIView animateWithDuration:self.animationDuration delay:0.0 usingSpringWithDamping:0.7 initialSpringVelocity:0.1 options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
            
            self.layer.transform = CATransform3DIdentity;
            self.alpha = 1.0f;
            
        } completion:^(BOOL finished) {
            
            if (self.showCompletionBlock)
            {
                self.showCompletionBlock(self,finished);
            }
            
        }];
    };
    
    return block;
}

- (JWPopAnimationBlock)alertHideAnimationBlock
{
    JWWeakify(self);
    JWPopAnimationBlock block = ^(JWPopView *popView){
        JWStrongify(self);
        
        [UIView animateWithDuration:self.animationDuration delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.9 options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState animations:^{
            
            self.layer.transform = CATransform3DMakeScale(0.7f, 0.7f, 0.7f);
            self.alpha = 0.0f;
            
        } completion:^(BOOL finished) {
            
            if (finished)
            {
                [self removeFromSuperview];
            }
            if (self.hideCompletionBlock)
            {
                self.hideCompletionBlock(self,finished);
            }
        }];
    };
    
    return block;
}

- (JWPopAnimationBlock)sheetShowAnimationBlock
{
    JWWeakify(self);
    JWPopAnimationBlock block = ^(JWPopView *popView){
        JWStrongify(self);
        
        if (!self.superview)
        {
            [self.attachedView.jw_dimBackgroundView addSubview:self];
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(self.attachedView);
                make.centerX.equalTo(self.attachedView);
                make.bottom.equalTo(self.attachedView).offset(self.attachedView.frame.size.height);
            }];
            [self.superview layoutIfNeeded];
        }
        
        [UIView animateWithDuration:self.animationDuration delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.7 options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
            
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(self.attachedView);
                make.centerX.equalTo(self.attachedView);
                make.bottom.equalTo(self.attachedView);
            }];
            [self.superview layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            
            if (self.showCompletionBlock)
            {
                self.showCompletionBlock(self,finished);
            }
        }];
    };
    
    return block;
}

- (JWPopAnimationBlock)sheetHideAnimationBlock
{
    JWWeakify(self);
    JWPopAnimationBlock block = ^(JWPopView *popView){
        JWStrongify(self);
        
        [UIView animateWithDuration:self.animationDuration delay:0.0 options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState animations:^{
            
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.attachedView).offset(self.attachedView.frame.size.height);
            }];
            [self.superview layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            
            if (finished)
            {
                [self removeFromSuperview];
            }
            if (self.hideCompletionBlock)
            {
                self.hideCompletionBlock(self,finished);
            }
        }];
    };
    
    return block;
}

- (JWPopAnimationBlock)customShowAnimationBlock
{
    JWWeakify(self);
    JWPopAnimationBlock block = ^(JWPopView *popView){
        JWStrongify(self);
        
        if (!self.superview)
        {
            [self.attachedView.jw_dimBackgroundView addSubview:self];
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self.attachedView).with.centerOffset(CGPointMake(0, -self.attachedView.bounds.size.height));
            }];
            [self.superview layoutIfNeeded];
        }
        
        [UIView animateWithDuration:self.animationDuration delay:0.0 options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
            
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self.attachedView).with.centerOffset(CGPointMake(0, self.withKeyboard ? -216/2 : 0));
            }];
            [self.superview layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            
            if (self.showCompletionBlock)
            {
                self.showCompletionBlock(self,finished);
            }
        }];
    };
    
    return block;
}

- (JWPopAnimationBlock)customHideAnimationBlock
{
    JWWeakify(self);
    JWPopAnimationBlock block = ^(JWPopView *popView){
        JWStrongify(self);
        
        [UIView animateWithDuration:self.animationDuration delay:0.0 usingSpringWithDamping:0.0 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState animations:^{
            
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self.attachedView).with.centerOffset(CGPointMake(0, self.attachedView.bounds.size.height));
            }];
            [self layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            
            if (finished)
            {
                [self removeFromSuperview];
            }
            if (self.hideCompletionBlock)
            {
                self.hideCompletionBlock(self,finished);
            }
        }];
    };
    
    return block;
}

#pragma mark - Public Method
- (void)show
{
    // 过滤短时间内多次点击，重复弹出的问题
    for (UIView *subView in self.attachedView.jw_dimBackgroundView.subviews)
    {
        if (JWAlertTag == subView.tag) return;
        if (JWSheetTag == subView.tag) return;
    }
    [self showWithBlock:nil];
}

- (void)showWithBlock:(JWPopCompletionBlock)block
{
    self.showCompletionBlock = block;
    
    if (!self.attachedView)
    {
        self.attachedView = [JWPopWindow shareWindow].attachView;
    }
    [self.attachedView jw_showDimBackground];
    
    JWPopAnimationBlock showAnimation = self.showAnimationBlock;
    
    NSAssert(showAnimation, @"展示动画没有怎么行?");
    
    showAnimation(self);
    
    if (self.withKeyboard)
    {
        [self showKeyboard];
    }
}

- (void)showWithHideBlock:(JWPopCompletionBlock)block
{
    self.hideCompletionBlock = block;
    
    if (!self.attachedView)
    {
        self.attachedView = [JWPopWindow shareWindow].attachView;
    }
    [self.attachedView jw_showDimBackground];
    
    JWPopAnimationBlock showAnimation = self.showAnimationBlock;
    
    NSAssert(showAnimation, @"展示动画没有怎么行?");
    
    showAnimation(self);
    
    if (self.withKeyboard)
    {
        [self showKeyboard];
    }
}

- (void)hide
{
    [self hideWithBlock:(self.hideCompletionBlock ? self.hideCompletionBlock : nil)];
}

- (void)hideInTouch
{
    if (!self.touchDismiss) return;
    [self hideWithBlock:(self.hideCompletionBlock ? self.hideCompletionBlock : nil)];
}

- (void)hideWithBlock:(JWPopCompletionBlock)block
{
    self.hideCompletionBlock = block;
    
    if (!self.attachedView)
    {
        self.attachedView = [JWPopWindow shareWindow].attachView;
    }
    [self.attachedView jw_hideDimBackground];
    
    if (self.withKeyboard)
    {
        [self hideKeyboard];
    }
    
    JWPopAnimationBlock hideAnimation = self.hideAnimationBlock;
    
    NSAssert(hideAnimation, @"收起动画没有怎么行?");
    
    hideAnimation(self);
}

- (void)hideAll
{
    
}

- (void)showKeyboard
{
    
}

- (void)hideKeyboard
{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
