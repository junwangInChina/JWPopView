//
//  JWSheetView.m
//  JWPopView
//
//  Created by wangjun on 16/6/24.
//  Copyright © 2016年 wangjun. All rights reserved.
//

#import "JWSheetView.h"

#import "JWPopCategory.h"
#import "JWPopItem.h"

#import <Masonry/Masonry.h>

@interface JWSheetView()

@property (nonatomic, strong) UILabel  *titleLabel;
@property (nonatomic, strong) UILabel  *contentLabel;
@property (nonatomic, strong) UIView   *buttonView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) NSArray  *items;

@end

@implementation JWSheetView

- (instancetype)initWithTitle:(NSString *)title
                        items:(NSArray *)items
{
    return [self initWithTitle:title
                       content:nil
                         items:items];
}

- (instancetype)initWithTitle:(NSString *)title
                      content:(NSString *)content
                        items:(NSArray *)items
{
    self = [super init];
    if (self)
    {
        NSAssert(items.count > 0, @"没有按钮怎么破，加几个呗。");
        
        JWSheetViewConfig *tempConfig = [JWSheetViewConfig globalConfig];
        
        self.type = JWPopTypeSheet;
        self.items = items;
        self.backgroundColor = tempConfig.backgroundColor;
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width);
        }];
        [self setContentCompressionResistancePriority:UILayoutPriorityRequired
                                              forAxis:UILayoutConstraintAxisHorizontal];
        [self setContentHuggingPriority:UILayoutPriorityFittingSizeLevel
                                forAxis:UILayoutConstraintAxisVertical];
        
        // 开始布局
        MASViewAttribute *lastAttribute = self.mas_top;
        // 有标题
        if (title.length > 0)
        {
            self.titleLabel = [UILabel new];
            _titleLabel.backgroundColor = tempConfig.backgroundColor;
            _titleLabel.textColor = tempConfig.titleColor;
            _titleLabel.font = tempConfig.titleFont;
            _titleLabel.numberOfLines = 0;
            _titleLabel.textAlignment = NSTextAlignmentCenter;
            _titleLabel.text = title;
            [self addSubview:_titleLabel];
            
            [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastAttribute).with.offset(tempConfig.margin);
                make.left.and.right.equalTo(self).with.insets(UIEdgeInsetsMake(0,
                                                                               tempConfig.margin,
                                                                               0,
                                                                               tempConfig.margin));
            }];
            
            // 更新底部约束
            lastAttribute = self.titleLabel.mas_bottom;
        }
        
        // 有内容
        if (content.length > 0)
        {
            self.contentLabel = [UILabel new];
            _contentLabel.backgroundColor = tempConfig.backgroundColor;
            _contentLabel.textColor = tempConfig.contentColor;
            _contentLabel.font = tempConfig.contentFont;
            _contentLabel.numberOfLines = 0;
            _contentLabel.textAlignment = NSTextAlignmentCenter;
            _contentLabel.text = content;
            [self addSubview:_contentLabel];
            
            [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastAttribute).with.offset((title.length > 0 ? 5 : tempConfig.margin));
                make.left.and.right.equalTo(self).insets(UIEdgeInsetsMake(0,
                                                                          tempConfig.margin,
                                                                          0,
                                                                          tempConfig.margin));
            }];
            
            // 更新底部约束
            lastAttribute = self.contentLabel.mas_bottom;
        }
        
        // 按钮
        self.buttonView = [UIView new];
        [self addSubview:_buttonView];
        [self.buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self);
            make.top.equalTo(lastAttribute).with.offset(tempConfig.margin);
        }];
        
        __block UIButton *tempFirstButton = nil;
        __block UIButton *tempLastButton = nil;
        for (NSInteger i = 0; i < items.count; i++)
        {
            JWPopItem *tempItem = items[i];
            
            UIButton *tempButton = [UIButton new];
            [tempButton setBackgroundImage:[UIImage jw_imageWithColor:tempConfig.backgroundColor]
                                  forState:UIControlStateNormal];
            [tempButton setBackgroundImage:[UIImage jw_imageWithColor:tempConfig.backgroundColor]
                                  forState:UIControlStateDisabled];
            [tempButton setBackgroundImage:[UIImage jw_imageWithColor:tempConfig.itemPressedColor]
                                  forState:UIControlStateHighlighted];
            [tempButton setTitle:tempItem.title
                        forState:UIControlStateNormal];
            [tempButton setTitleColor:(tempItem.highlight ? tempConfig.itemHighlightColor : (tempItem.disabled ? tempConfig.itemDisableColor : tempConfig.itemNormalColor))
                             forState:UIControlStateNormal];
            [tempButton addTarget:self
                           action:@selector(buttonDidSeletedAction:)
                 forControlEvents:UIControlEventTouchUpInside];
            tempButton.layer.borderWidth = JW_SPLIT_WIDTH;
            tempButton.layer.borderColor = tempConfig.splitColor.CGColor;
            tempButton.titleLabel.font = tempConfig.itemFont;
            tempButton.tag = i + 2000;
            tempButton.enabled = !tempItem.disabled;
            [self.buttonView addSubview:tempButton];
            
            [tempButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.and.right.equalTo(self.buttonView).with.insets(UIEdgeInsetsMake(0,
                                                                                          -JW_SPLIT_WIDTH,
                                                                                          0,
                                                                                          -JW_SPLIT_WIDTH));
                make.height.mas_equalTo(tempConfig.itemHeight);
                if (!tempFirstButton)
                {
                    tempFirstButton = tempButton;
                    make.top.equalTo(self.buttonView).with.offset(-JW_SPLIT_WIDTH);
                }
                else
                {
                    make.top.equalTo(tempLastButton.mas_bottom).with.offset(-JW_SPLIT_WIDTH);
                    make.height.equalTo(tempFirstButton);
                }
            }];
            tempLastButton = tempButton;
        }
        
        // 更新底部约束
        lastAttribute = tempLastButton.mas_bottom;
        
        // 修正ButtonView高度
        [self.buttonView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(lastAttribute);
        }];
        
        // 中间的灰色块
        UIView *tempSplitView = [UIView new];
        tempSplitView.backgroundColor = tempConfig.splitColor;
        [self addSubview:tempSplitView];
        [tempSplitView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastAttribute);
            make.left.and.right.equalTo(self);
            make.height.equalTo(@10);
        }];
        
        // 更新底部约束
        lastAttribute = tempSplitView.mas_bottom;
        
        // 底部的Cancel按钮
        self.cancelButton = [UIButton new];
        [_cancelButton setBackgroundImage:[UIImage jw_imageWithColor:tempConfig.backgroundColor]
                                 forState:UIControlStateNormal];
        [_cancelButton setBackgroundImage:[UIImage jw_imageWithColor:tempConfig.itemPressedColor]
                                 forState:UIControlStateHighlighted];
        [_cancelButton setTitle:tempConfig.itemTextCancel
                       forState:UIControlStateNormal];
        [_cancelButton setTitleColor:tempConfig.itemNormalColor
                            forState:UIControlStateNormal];
        [_cancelButton addTarget:self
                          action:@selector(cancelAction:)
                forControlEvents:UIControlEventTouchUpInside];
        _cancelButton.titleLabel.font = tempConfig.itemFont;
        [self addSubview:_cancelButton];
        
        [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self);
            make.height.equalTo(@(tempConfig.itemHeight));
            make.top.equalTo(lastAttribute);
        }];
        
        // 更新底部约束
        lastAttribute = self.cancelButton.mas_bottom;
        
        // 修正整个View的高度
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(lastAttribute);
        }];
    }
    return self;
}

- (void)buttonDidSeletedAction:(id)sender
{
    UIButton *tempButton = (UIButton *)sender;
    JWPopItem *tempItem = self.items[tempButton.tag - 2000];
    
    [self hide];
    
    if (tempItem.handler)
    {
        tempItem.handler(tempButton.tag - 2000);
    }
    
}

- (void)cancelAction:(id)sender
{
    [self hide];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

@implementation JWSheetViewConfig

+ (JWSheetViewConfig *)globalConfig
{
    static JWSheetViewConfig *config;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [JWSheetViewConfig new];
    });
    return config;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.margin     = 20;
        self.itemHeight = 50;
        
        self.backgroundColor    = [UIColor jw_colorWithHex:0xFFFFFFFF];
        self.titleColor         = [UIColor jw_colorWithHex:0x333333FF];
        self.contentColor       = [UIColor jw_colorWithHex:0x666666FF];
        self.splitColor         = [UIColor jw_colorWithHex:0xCCCCCCFF];

        self.titleFont          = [UIFont systemFontOfSize:18];
        self.contentFont        = [UIFont systemFontOfSize:14];
        self.itemFont           = [UIFont systemFontOfSize:17];

        self.itemNormalColor    = [UIColor jw_colorWithHex:0x333333FF];
        self.itemDisableColor   = [UIColor jw_colorWithHex:0xCCCCCCFF];
        self.itemHighlightColor = [UIColor jw_colorWithHex:0xE76153FF];
        self.itemPressedColor   = [UIColor jw_colorWithHex:0xEFEDE7FF];

        self.itemTextCancel     = @"取消";
    }
    return self;
}

@end
