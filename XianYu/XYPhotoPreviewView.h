//
//  XYPhotoPreviewView.h
//  XianYu
//
//  Created by YuanZhihao on 7/31/16.
//  Copyright © 2016 YuanZhihao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XYPhotoPreviewViewDelegate <NSObject>

@optional

- (BOOL)choose:(NSInteger)page;

@end

@interface XYPhotoPreviewView : UIView

@property (nonatomic, strong) NSMutableArray *assets;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, weak) id<XYPhotoPreviewViewDelegate> myDelegate;

- (void)showCurrentImage;

- (void)prepareLeftAndRightImage;

@end
