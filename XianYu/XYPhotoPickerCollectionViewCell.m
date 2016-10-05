//
//  XYPhotoPickerCollectionViewCell.m
//  XianYu
//
//  Created by YuanZhihao on 7/27/16.
//  Copyright © 2016 YuanZhihao. All rights reserved.
//

#import "XYPhotoPickerCollectionViewCell.h"
#import "XYPhotoImageView.h"

@implementation XYPhotoPickerCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        XYPhotoImageView *imageView = [[XYPhotoImageView alloc]initWithFrame:self.bounds];
        self.imageView = imageView;
        [self.contentView addSubview:imageView];
        UIButton *tickButton = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width - 40, 0, 40, 40)];
        [tickButton setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:tickButton];
        [tickButton addTarget:self action:@selector(tickBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
        self.tickButton = tickButton;
        [self.contentView addSubview:tickButton];
        imageView.maskViewFlag = NO;
    }
    return self;
}

- (void)tickBtnTouched:(UIButton *)sender {
    if ([self.myDelegate respondsToSelector:@selector(tickBtnTouched:)]) {
        [self.myDelegate tickBtnTouched:sender];
    }
}

@end
