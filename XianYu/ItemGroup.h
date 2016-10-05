//
//  ItemGroup.h
//  XianYu
//
//  Created by YuanZhihao on 7/8/16.
//  Copyright © 2016 YuanZhihao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemGroup : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *detail;

@property (nonatomic, strong) NSMutableArray *items;

@end
