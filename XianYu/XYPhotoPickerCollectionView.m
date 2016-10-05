//
//  XYPhotoPickerCollectionView.m
//  XianYu
//
//  Created by YuanZhihao on 7/27/16.
//  Copyright © 2016 YuanZhihao. All rights reserved.
//

#import "XYPhotoPickerCollectionView.h"
#import "XYPhotoPickerCollectionViewCell.h"
#import "XYPhotoImageView.h"

@interface XYPhotoPickerCollectionView ()



@end

@implementation XYPhotoPickerCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
