//
//  JWPopWindow.m
//  JWPopView
//
//  Created by wangjun on 16/6/24.
//  Copyright © 2016年 wangjun. All rights reserved.
//

#import "JWPopWindow.h"

#import "JWPopCategory.h"
#import "JWPopView.h"

@interface JWPopWindow ()<UIGestureRecognizerDelegate>

@end

@implementation JWPopWindow

+ (JWPopWindow *)shareWindow
{
    static JWPopWindow *window;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        window = [[JWPopWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        window.rootViewController = [UIViewController new];
    });
    return window;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.windowLevel = UIWindowLevelStatusBar + 1;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
        tapGesture.cancelsTouchesInView = NO;
        tapGesture.delegate = self;
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (UIView *)attachView
{
    return self.rootViewController.view;
}

- (void)cacheWindow
{
    [self makeKeyAndVisible];
    [[[UIApplication sharedApplication].delegate window] makeKeyAndVisible];
    
    [self attachView].jw_dimBackgroundView.hidden = YES;
    self.hidden = YES;
}

- (void)tapGestureAction:(UITapGestureRecognizer *)gesture
{
    if (!self.jw_dimBackgroundAnimating)
    {
        for (UIView *tempView in [self attachView].jw_dimBackgroundView.subviews)
        {
            if ([tempView isKindOfClass:[JWPopView class]])
            {
                JWPopView *tempPopView = (JWPopView *)tempView;
                [tempPopView hideInTouch];
            }
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return (touch.view == self.attachView.jw_dimBackgroundView);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
