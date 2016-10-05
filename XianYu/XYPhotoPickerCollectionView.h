//
//  XYPhotoPickerCollectionView.h
//  XianYu
//
//  Created by YuanZhihao on 7/27/16.
//  Copyright © 2016 YuanZhihao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYPhotoAsset.h"

@class XYPhotoPickerCollectionView;

@protocol XYPhotoPickerCollectionViewDelegate <NSObject>

@optional

// 选择相片就会调用
- (void) pickerCollectionViewDidSelected:(XYPhotoPickerCollectionView *) pickerCollectionView deleteAsset:(XYPhotoAsset *)deleteAssets;

//点击cell会调用
- (void) pickerCollectionCellTouchedIndexPath:(NSIndexPath *)indexPath;

// 点击拍照就会调用
- (void)pickerCollectionViewDidCameraSelect:(XYPhotoPickerCollectionView *) pickerCollectionView;

@end

@interface XYPhotoPickerCollectionView : UICollectionView

// delegate
@property (nonatomic , weak) id <XYPhotoPickerCollectionViewDelegate> collectionViewDelegate;

@end
