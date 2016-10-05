//
//  XYPhotoAssets.m
//  XianYu
//
//  Created by YuanZhihao on 7/25/16.
//  Copyright © 2016 YuanZhihao. All rights reserved.
//

#import "XYPhotoAsset.h"

@implementation XYPhotoAsset

//static CGFloat saveOriginImageRadio = 0.0001;

- (UIImage *)thumbImage {
    //在ios9上，用thumbnail方法取得的缩略图显示出来不清晰，所以用aspectRatioThumbnail
    PHImageManager *manager = [PHImageManager defaultManager];
    PHImageRequestOptions *options = [PHImageRequestOptions new];
    __block UIImage *temp;
    options.synchronous = YES;
    options.version = PHImageRequestOptionsVersionCurrent;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    [manager requestImageForAsset:self.asset targetSize:CGSizeMake(150, 150) contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage *image, NSDictionary *info){
        temp = image;
    }];
    return temp;
}

- (UIImage *)compressionImage {
    PHImageManager *manager = [PHImageManager defaultManager];
    PHImageRequestOptions *options = [PHImageRequestOptions new];
    __block UIImage *temp;
    options.synchronous = YES;
    options.version = PHImageRequestOptionsVersionCurrent;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    [manager requestImageForAsset:self.asset targetSize:[UIScreen mainScreen].bounds.size contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage *image, NSDictionary *info){
        temp = image;
    }];
    NSData *data2 = UIImageJPEGRepresentation(temp, 0.1);
    UIImage *image = [UIImage imageWithData:data2];
    temp = nil;
    data2 = nil;
    return image;
}

- (UIImage *)originImage{
    PHImageManager *manager = [PHImageManager defaultManager];
    PHImageRequestOptions *options = [PHImageRequestOptions new];
    __block UIImage *temp;
    options.synchronous = YES;
    options.version = PHImageRequestOptionsVersionCurrent;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    [manager requestImageForAsset:self.asset targetSize:[UIScreen mainScreen].bounds.size contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage *image, NSDictionary *info){
        temp = image;
    }];
    return temp;
}

- (UIImage *)fullResolutionImage{
    PHImageManager *manager = [PHImageManager defaultManager];
    PHImageRequestOptions *options = [PHImageRequestOptions new];
    __block UIImage *temp;
    options.synchronous = YES;
    options.version = PHImageRequestOptionsVersionCurrent;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    [manager requestImageForAsset:self.asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage *image, NSDictionary *info){
        temp = image;
    }];
    return temp;
}

- (BOOL)isVideoType{
    PHAssetMediaType type = self.asset.mediaType;
    //媒体类型是视频
    return type == PHAssetMediaTypeVideo;
}

- (NSString *)assetURL{
    return self.asset.localIdentifier;
}

@end
