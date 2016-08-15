//
//  JWAlertView.m
//  JWPopView
//
//  Created by wangjun on 16/6/24.
//  Copyright © 2016年 wangjun. All rights reserved.
//

#import "JWAlertView.h"

#import "JWPopItem.h"
#import "JWPopCategory.h"

#import <Masonry/Masonry.h>

@interface JWAlertView()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UITextField *inputTextField;
@property (nonatomic, strong) UIView *buttonView;

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, copy) JWAlertInputHandler inputHandler;

@end

@implementation JWAlertView

- (instancetype)initWithTitle:(NSString *)title
                      content:(NSString *)content
{
    JWAlertViewConfig *tempConfig = [JWAlertViewConfig globalConfig];
    NSArray *tempItems = @[
                           JWItemMake(tempConfig.itemTextOK, JWItemTypeHighlight, nil)
                           ];
    return [self initWithTitle:title
                       content:content
                         items:tempItems];
}

- (instancetype)initWithTitle:(NSString *)title
                      content:(NSString *)content
                        items:(NSArray *)items
{
    return [self initWithTitle:title
                       content:content
                         items:items
                   placeholder:nil
                       handler:nil];
}

- (instancetype)initWithTitle:(NSString *)title
                      content:(NSString *)content
                  placeholder:(NSString *)placeholder
                      handler:(JWAlertInputHandler)handler
{
    JWAlertViewConfig *tempConfig = [JWAlertViewConfig globalConfig];
    
    NSArray *tempItems = @[
                           JWItemMake(tempConfig.itemTextCancel, JWItemTypeNormal, nil),
                           JWItemMake(tempConfig.itemTextConfirm, JWItemTypeHighlight, nil)
                           ];
    
    return [self initWithTitle:title
                       content:content
                         items:tempItems
                   placeholder:placeholder
                       handler:handler];
}

- (instancetype)initWithTitle:(NSString *)title
                      content:(NSString *)content
                        items:(NSArray *)items
                  placeholder:(NSString *)placeholder
                      handler:(JWAlertInputHandler)handler
{
    self = [super init];
    if (self)
    {
        NSAssert(items.count > 0, @"没有按钮怎么破？");
        
        self.tag = JWAlertTag;
        
        JWAlertViewConfig *tempConfig = [JWAlertViewConfig globalConfig];
        
        self.type = JWPopTypeAlert;
        self.withKeyboard = (handler != nil);
        
        self.inputHandler = handler;
        self.items = items;
        
        self.layer.cornerRadius = tempConfig.cornerRadius;
        self.clipsToBounds = YES;
        self.backgroundColor = tempConfig.backgroundColor;
        self.layer.borderWidth = JW_SPLIT_WIDTH;
        self.layer.borderColor = tempConfig.splitColor.CGColor;
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(tempConfig.width);
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
                make.top.equalTo(lastAttribute).offset(tempConfig.margin);
                make.left.right.equalTo(self).insets(UIEdgeInsetsMake(0,
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
                make.left.right.equalTo(self).insets(UIEdgeInsetsMake(0,
                                                                      tempConfig.margin,
                                                                      0,
                                                                      tempConfig.margin));
            }];
            
            // 更新底部约束
            lastAttribute = self.contentLabel.mas_bottom;
        }
        
        // 有输入框
        if (handler)
        {
            self.inputTextField = [UITextField new];
            _inputTextField.backgroundColor = tempConfig.backgroundColor;
            _inputTextField.layer.borderWidth = JW_SPLIT_WIDTH;
            _inputTextField.layer.borderColor = tempConfig.splitColor.CGColor;
            _inputTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
            _inputTextField.leftViewMode = UITextFieldViewModeAlways;
            _inputTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
            _inputTextField.placeholder = placeholder;
            [self addSubview:_inputTextField];
            
            [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastAttribute).with.offset(10);
                make.left.right.equalTo(self).insets(UIEdgeInsetsMake(0,
                                                                      tempConfig.margin,
                                                                      0,
                                                                      tempConfig.margin));
                make.height.equalTo(@40);
            }];
            
            // 更新底部约束
            lastAttribute = self.inputTextField.mas_bottom;
        }
        
        // 按钮
        self.buttonView = [UIView new];
        [self addSubview:_buttonView];
        [self.buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastAttribute).with.offset(tempConfig.margin);
            make.left.and.right.equalTo(self);
        }];
        
        __block UIButton *tempFirstButton = nil;
        __block UIButton *tempLastButton = nil;
        for (NSInteger i = 0; i < items.count; i++)
        {
            JWPopItem *tempItem = items[i];
            
            UIButton *tempButton = [UIButton new];
            [tempButton setBackgroundImage:[UIImage jw_imageWithColor:tempConfig.backgroundColor]
                                  forState:UIControlStateNormal];
            [tempButton setBackgroundImage:[UIImage jw_imageWithColor:tempConfig.itemPressedColor]
                                  forState:UIControlStateHighlighted];
            [tempButton setTitle:tempItem.title
                        forState:UIControlStateNormal];
            [tempButton setTitleColor:(tempItem.highlight ? tempConfig.itemHighlightColor : tempConfig.itemNormalColor)
                             forState:UIControlStateNormal];
            [tempButton addTarget:self
                           action:@selector(buttonDidSeletedAction:)
                 forControlEvents:UIControlEventTouchUpInside];
            tempButton.layer.borderWidth = JW_SPLIT_WIDTH;
            tempButton.layer.borderColor = tempConfig.splitColor.CGColor;
            tempButton.titleLabel.font = tempConfig.itemFont;
            tempButton.tag = i + 1000;
            [self.buttonView addSubview:tempButton];
            
            [tempButton mas_makeConstraints:^(MASConstraintMaker *make) {
                
                // 2个或2个以下按钮数量时，横向排列即可
                if (items.count <= 2)
                {
                    make.top.and.bottom.equalTo(self.buttonView);
                    make.height.mas_equalTo(tempConfig.itemHeight);
                    if (!tempFirstButton)
                    {
                        tempFirstButton = tempButton;
                        make.left.equalTo(self.buttonView).with.offset(-JW_SPLIT_WIDTH);
                    }
                    else
                    {
                        make.left.equalTo(tempLastButton.mas_right).with.offset(-JW_SPLIT_WIDTH);
                        make.width.equalTo(tempFirstButton);
                    }
                }
                // 3个或以上按钮时，纵向排列
                else
                {
                    make.left.and.right.equalTo(self.buttonView);
                    make.height.mas_equalTo(tempConfig.itemHeight);
                    if (!tempFirstButton)
                    {
                        tempFirstButton = tempButton;
                        make.top.equalTo(self.buttonView).with.offset(-JW_SPLIT_WIDTH);
                    }
                    else
                    {
                        make.top.equalTo(tempLastButton.mas_bottom).with.offset(-JW_SPLIT_WIDTH);
                        make.width.equalTo(tempFirstButton);
                    }
                }
            }];
            
            tempLastButton = tempButton;
        }
        // 设置最后一个Button的约束
        [tempLastButton mas_updateConstraints:^(MASConstraintMaker *make) {
            
            // 2个或2个以下按钮数量时，横向排列时
            if (items.count <= 2)
            {
                make.right.equalTo(self.buttonView).with.offset(JW_SPLIT_WIDTH);
            }
            // 3个或以上按钮时，纵向排列时
            else
            {
                make.bottom.equalTo(self.buttonView).with.offset(JW_SPLIT_WIDTH);
            }
        }];
    
        // 修正整个View的高度
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.buttonView);
        }];
    }
    return self;
}

- (void)buttonDidSeletedAction:(id)sender
{
    UIButton *tempButton = (UIButton *)sender;
    
    JWPopItem *tempItem = self.items[tempButton.tag - 1000];
    if (tempItem.disabled) return;
    
    if (self.withKeyboard && tempButton.tag == 1001)
    {
        if (self.inputTextField.text.length > 0)
        {
            [self hide];
        }
    }
    else
    {
        [self hide];
    }
    
    if (self.inputHandler && tempButton.tag > 1000)
    {
        self.inputHandler(self.inputTextField.text);
    }
    else
    {
        if (tempItem.handler)
        {
            tempItem.handler(tempButton.tag - 1000);
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

@interface JWAlertViewConfig()

/**
 *  宽度比，根据设置的弹出框宽度计算出来的
 */
@property (nonatomic, assign) CGFloat widthScale;

@end

@implementation JWAlertViewConfig

+ (JWAlertViewConfig *)globalConfig
{
    static JWAlertViewConfig *config;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [JWAlertViewConfig new];
    });
    return config;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.width      = 275.0f;
        self.widthScale = 275.0f/([[UIScreen mainScreen] bounds].size.width);

        self.itemHeight   = 50;
        self.margin       = 25.0f;
        self.cornerRadius = 5.0f;
        
        self.titleFont   = [UIFont systemFontOfSize:18];
        self.contentFont = [UIFont systemFontOfSize:14];
        self.itemFont    = [UIFont systemFontOfSize:17];
        
        self.backgroundColor = [UIColor jw_colorWithHex:0xFFFFFFFF];
        self.titleColor      = [UIColor jw_colorWithHex:0x333333FF];
        self.contentColor    = [UIColor jw_colorWithHex:0x333333FF];
        self.splitColor      = [UIColor jw_colorWithHex:0xCCCCCCFF];
        
        self.itemNormalColor    = [UIColor jw_colorWithHex:0x333333FF];
        self.itemHighlightColor = [UIColor jw_colorWithHex:0xE76153FF];
        self.itemPressedColor   = [UIColor jw_colorWithHex:0xEFEDE7FF];

        self.itemTextOK      = @"好";
        self.itemTextCancel  = @"取消";
        self.itemTextConfirm = @"确定";
    }
    return self;
}

- (void)setWidth:(CGFloat)width
{
    _width = width;
    
    _widthScale = width / ([[UIScreen mainScreen] bounds].size.width);
}

@end