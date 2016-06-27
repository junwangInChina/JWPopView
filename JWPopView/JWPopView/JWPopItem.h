//
//  JWPopItem.h
//  JWPopView
//
//  Created by wangjun on 16/6/24.
//  Copyright © 2016年 wangjun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^JWPopItemHandler)(NSInteger index);

@interface JWPopItem : NSObject

@property (nonatomic, assign) BOOL highlight;
@property (nonatomic, assign) BOOL disabled;

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) JWPopItemHandler handler;

@end

typedef NS_ENUM(NSInteger, JWItemType) {
    JWItemTypeNormal,
    JWItemTypeHighlight,
    JWItemTypeDisable
};

NS_INLINE JWPopItem *JWItemMake(NSString *title, JWItemType type, JWPopItemHandler handler)
{
    JWPopItem *item = [JWPopItem new];
    item.title = title;
    item.handler = handler;
    
    switch (type) {
        case JWItemTypeNormal:
            break;
        case JWItemTypeHighlight:
            item.highlight = YES;
            break;
        case JWItemTypeDisable:
            item.disabled = YES;
            break;
        default:
            break;
    }
    
    return item;
}
