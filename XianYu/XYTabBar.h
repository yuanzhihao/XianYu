//
//  XYTabBar.h
//  XianYu
//
//  Created by YuanZhihao on 6/14/16.
//  Copyright © 2016 YuanZhihao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XYTabBar;

@protocol XYTabBarDelegate <NSObject>

@optional
- (void)publishButtonClicked:(XYTabBar *)tabBar;

@end

@interface XYTabBar : UITabBar

@property (nonatomic, weak) id<XYTabBarDelegate> myDelegate;

@end
