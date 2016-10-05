//
//  XYPhotoPickerCollectionViewCell.h
//  XianYu
//
//  Created by YuanZhihao on 7/27/16.
//  Copyright © 2016 YuanZhihao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYPhotoImageView.h"

@class XYPhotoPickerCollectionViewCellDelegate;

@protocol XYPhotoPickerCollectionViewCellDelegate <NSObject>

@optional

- (void)tickBtnTouched:(UIButton *)sender;

@end

@interface XYPhotoPickerCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) XYPhotoImageView *imageView;

@property (nonatomic, weak) UIButton *tickButton;

@property (nonatomic, weak) id<XYPhotoPickerCollectionViewCellDelegate> myDelegate;

@end
