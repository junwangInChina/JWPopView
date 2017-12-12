//
//  ViewController.m
//  JWPopView
//
//  Created by wangjun on 16/6/24.
//  Copyright © 2016年 wangjun. All rights reserved.
//

#import "ViewController.h"



#import "JWPopView/JWPopViewDefine.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *alertButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[JWPopWindow shareWindow] clearAll];
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)alertAction:(id)sender {
    
    JWPopItem *okItem = JWItemMake(@"OK", JWItemTypeNormal, ^(NSInteger index) {
        
    });
    JWPopItem *cancelItem = JWItemMake(@"cancel", JWItemTypeDisable, ^(NSInteger index) {
        
    });
    JWPopItem *confirmItem = JWItemMake(@"Confirm", JWItemTypeHighlight, ^(NSInteger index) {
        
    });
    
    NSArray *tempItems = @[cancelItem,okItem,confirmItem];
    
    JWAlertView *alert = [[JWAlertView alloc] initWithTitle:@"警告" content:@"这是一个弹框警告" items:tempItems];
    //[alert show];
    
    [[JWAlertViewConfig globalConfig] setAttachedViewColor:[UIColor jw_colorWithHex:0x0000007F]];
    
    NSArray *tempItems2 = @[cancelItem,confirmItem];
    JWAlertView *alert2 = [[JWAlertView alloc] initWithTitle:@"警告" content:@"这是一个弹框警告" items:tempItems2];
    alert2.touchDismiss = NO;
    [alert2 showWithHideBlock:^(JWPopView *p, BOOL b) {
        NSLog(@"收起完成");
    }];
}

- (IBAction)alertClearColor:(id)sender {
    
    [[JWAlertViewConfig globalConfig] setAttachedViewColor:[UIColor clearColor]];
    
    JWPopItem *cancelItem = JWItemMake(@"cancel", JWItemTypeDisable, ^(NSInteger index) {
        
    });
    JWPopItem *confirmItem = JWItemMake(@"Confirm", JWItemTypeHighlight, ^(NSInteger index) {
        
    });
    
    NSArray *tempItems2 = @[cancelItem,confirmItem];
    JWAlertView *alert2 = [[JWAlertView alloc] initWithTitle:@"警告" content:@"这是一个弹框警告" items:tempItems2];
    [alert2 show];
}

- (IBAction)sheetAction:(id)sender {
    
    JWPopItem *okItem = JWItemMake(@"OK", JWItemTypeNormal, ^(NSInteger index) {
        
    });
    JWPopItem *cancelItem = JWItemMake(@"cancel", JWItemTypeNormal, ^(NSInteger index) {
        
    });
    JWPopItem *confirmItem = JWItemMake(@"Confirm", JWItemTypeDisable, ^(NSInteger index) {
        
    });
    
    NSArray *tempItems = @[cancelItem,okItem,confirmItem];
    
    JWSheetView *sheet = [[JWSheetView alloc] initWithTitle:@"标题" content:@"这是一个ActionSheet,这是一个ActionSheet,这是一个ActionSheet,这是一个ActionSheet,这是一个ActionSheet,这是一个ActionSheet,这是一个ActionSheet,这是一个ActionSheet,这是一个ActionSheet,这是一个ActionSheet,这是一个ActionSheet,这是一个ActionSheet,这是一个ActionSheet,这是一个ActionSheet,这是一个ActionSheet,这是一个ActionSheet,这是一个ActionSheet,这是一个ActionSheet,这是一个ActionSheet," items:tempItems fitToiPhoneX:YES];
    [sheet show];
}

@end
