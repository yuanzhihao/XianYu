//
//  XYAlbumView.h
//  XianYu
//
//  Created by YuanZhihao on 8/3/16.
//  Copyright © 2016 YuanZhihao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XYPhotoAssetGroup;

@interface XYAlbumView : UIView

@property (nonatomic, strong) void (^callBack)(XYPhotoAssetGroup *group);

@end
