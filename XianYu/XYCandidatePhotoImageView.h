//
//  XYCandidatePhotoImageView.h
//  XianYu
//
//  Created by YuanZhihao on 7/29/16.
//  Copyright © 2016 YuanZhihao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYPhoto;

@protocol XYCandidatePhotoImageViewDelegate <NSObject>

@optional

- (void)deleteCandidateImage:(UIButton *)sender;

@end

@interface XYCandidatePhotoImageView : UIImageView

@property (nonatomic, weak) UIButton *deleteButton;

@property (nonatomic, weak) id<XYCandidatePhotoImageViewDelegate> myDelegate;

@property (nonatomic, weak) NSIndexPath *path;

@property (nonatomic, weak) XYPhoto *photo;

@end
