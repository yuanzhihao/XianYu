//
//  HomeGoodsFrame.h
//  XianYu
//
//  Created by ZpyZp on 15/10/26.
//  Copyright © 2015年 berchina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class XYHomeGoodsModel;
@interface XYHomeGoodsFrame : NSObject
@property (nonatomic,strong) XYHomeGoodsModel *goodsModel;

@property (nonatomic,assign) CGRect nicknameLabel;
@property (nonatomic,assign) CGRect dateLabel;
@property (nonatomic,assign) CGRect iconView;
@property (nonatomic,assign) CGRect picturesView;
@property (nonatomic,assign) CGRect locationButton;
@property (nonatomic,assign) CGRect accessButton;
@property (nonatomic,assign) CGRect contentLabel;
@property (nonatomic,assign) CGRect priceLabel;

@property (nonatomic,assign) CGRect backgroundView;
@property (nonatomic,assign) CGFloat cellHeight;
@end
