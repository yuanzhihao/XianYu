//
//  XYPhotoPickerViewController.h
//  XianYu
//
//  Created by YuanZhihao on 7/26/16.
//  Copyright © 2016 YuanZhihao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYPhotoAssetGroup;

@interface XYPhotoPickerViewController : UIViewController

@property (nonatomic, strong) XYPhotoAssetGroup *assetsGroup;

@property (nonatomic, assign) NSInteger maxCount;

// 需要记录选中的值的数据
@property (nonatomic, strong) NSArray *selectPickerAssets;

// 置顶展示图片
@property (nonatomic, assign) BOOL topShowPhotoPicker;

@property (nonatomic, copy) void(^selectedAssetsBlock)(NSMutableArray *selectedAssets);

@end
