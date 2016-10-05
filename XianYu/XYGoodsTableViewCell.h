//
//  XYGoodsTableViewCell.h
//  XianYu
//
//  Created by YuanZhihao on 6/23/16.
//  Copyright © 2016 YuanZhihao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYHomeGoodsFrame;

@interface XYGoodsTableViewCell : UITableViewCell

@property (nonatomic,strong) XYHomeGoodsFrame *goodsFrame;

@property (nonatomic,weak) UITableView *tableView;

@property (nonatomic,strong) void (^OnMyButtonClick)(NSIndexPath *indexPath);

@property (nonatomic,weak) UIImageView *iconView;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
