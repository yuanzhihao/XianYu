//
//  XYPhotoAssets.h
//  XianYu
//
//  Created by YuanZhihao on 7/25/16.
//  Copyright © 2016 YuanZhihao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface XYPhotoAsset : NSObject

@property (strong, nonatomic) PHAsset *asset;

/**
 *  缩略图
 */
- (UIImage *)thumbImage;

/**
 *  压缩原图
 */
- (UIImage *)compressionImage;

/**
 *  原图
 */
- (UIImage *)originImage;

- (UIImage *)fullResolutionImage;

/**
 *  获取是否是视频类型, Default = false
 */
@property (assign,nonatomic) BOOL isVideoType;

/**
 *  获取相册的URL
 */
- (NSString *)assetURL;

@end
