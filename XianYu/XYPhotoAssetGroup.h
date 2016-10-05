//
//  XYPhotoGroup.h
//  XianYu
//
//  Created by YuanZhihao on 7/26/16.
//  Copyright © 2016 YuanZhihao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface XYPhotoAssetGroup : NSObject

/**
 *  相册标题
 */
@property (nonatomic , copy) NSString *albumTitle;

/**
 *  缩略图
 */
@property (nonatomic , strong) UIImage *thumbImage;

/**
 *  组里面的图片个数
 */
@property (nonatomic , assign) NSInteger assetsCount;

/**
 *  类型 : Saved Photos...
 */
@property (nonatomic , copy) NSString *type;

@property (nonatomic , strong) PHAssetCollection *group;

@end
