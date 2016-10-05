//
//  XYCandidatePhotoImageView.m
//  XianYu
//
//  Created by YuanZhihao on 7/29/16.
//  Copyright © 2016 YuanZhihao. All rights reserved.
//

#import "XYCandidatePhotoImageView.h"
#import "UIView+LBExtension.h"

@interface XYCandidatePhotoImageView ()

@end

@implementation XYCandidatePhotoImageView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIButton *deleteButton = [UIButton new];
        deleteButton.size = CGSizeMake(20, 20);
        deleteButton.center = CGPointMake(0, 0);
        [deleteButton setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteCandidateImage:) forControlEvents:UIControlEventTouchUpInside];
        self.deleteButton = deleteButton;
        [self addSubview:deleteButton];
    }
    return self;
}

- (void)deleteCandidateImage:(UIButton *)sender {
    if ([self.myDelegate respondsToSelector:@selector(deleteCandidateImage:)]) {
        [self.myDelegate deleteCandidateImage:sender];
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    CGPoint newP = [self convertPoint:point toView:self.deleteButton];
    if ([self.deleteButton pointInside:newP withEvent:event]) {
        return self.deleteButton;
    }else{
        //如果点不在发布按钮身上，直接让系统处理就可以了
        return [super hitTest:point withEvent:event];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
