//
//  XYSearchViewController.h
//  XianYu
//
//  Created by YuanZhihao on 7/2/16.
//  Copyright © 2016 YuanZhihao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYSearchViewController : UIViewController

@property (nonatomic, assign) NSInteger source;

@property (nonatomic, strong) void (^callBack)(NSString *word);

@property (nonatomic, copy) NSString *word;

@end
