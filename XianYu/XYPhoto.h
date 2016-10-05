//
//  XYPhoto.h
//  XianYu
//
//  Created by YuanZhihao on 8/1/16.
//  Copyright © 2016 YuanZhihao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYPhotoAsset.h"

@interface XYPhoto : NSObject

@property (nonatomic, strong) XYPhotoAsset *asset;

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, assign) BOOL isSelected;

@end
