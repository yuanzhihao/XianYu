//
//  XYGoodsCollectionViewCell.m
//  XianYu
//
//  Created by YuanZhihao on 7/4/16.
//  Copyright © 2016 YuanZhihao. All rights reserved.
//

#import "XYGoodsCollectionViewCell.h"

@interface XYGoodsCollectionViewCell ()

@end

@implementation XYGoodsCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width)];
        imageView.backgroundColor = [UIColor whiteColor];
        self.imageView = imageView;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5, self.frame.size.width + 5, self.frame.size.width - 10, 20)];
        label.backgroundColor = [UIColor whiteColor];
        self.label = label;
        UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, self.frame.size.width + 30, self.frame.size.width - 10, 25)];
        priceLabel.backgroundColor = [UIColor whiteColor];
        priceLabel.textColor = [UIColor redColor];
        self.priceLabel = priceLabel;
        UILabel *locationLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, self.frame.size.width + 60, (self.frame.size.width - 10) / 2, 15)];
        locationLabel.backgroundColor = [UIColor whiteColor];
        locationLabel.textColor = [UIColor grayColor];
        self.loactionLabel = locationLabel;
        UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(5 + (self.frame.size.width - 10) / 2, self.frame.size.width + 60, (self.frame.size.width - 10) / 2, 15)];
        dateLabel.backgroundColor = [UIColor whiteColor];
        self.dateLabel = dateLabel;
        
        [self.contentView addSubview:imageView];
        [self.contentView addSubview:label];
        [self.contentView addSubview:priceLabel];
        [self.contentView addSubview:locationLabel];
        [self.contentView addSubview:dateLabel];
    }
    return self;
}

@end
