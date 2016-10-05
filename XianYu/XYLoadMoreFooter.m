//
//  XYLoadMoreFooter.m
//  XianYu
//
//  Created by YuanZhihao on 6/24/16.
//  Copyright © 2016 YuanZhihao. All rights reserved.
//

#import "XYLoadMoreFooter.h"

@implementation XYLoadMoreFooter

- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 50;
    
    self.stateLabel.hidden = YES;
    
    NSMutableArray *arr = [NSMutableArray array];
    
    for (int i = 0; i<20; i++) {
        if (i<10) {
            [arr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"loading_v1_0000%d",i]]];
        }else{
            [arr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"loading_v1_000%d",i]]];
        }
    }
    
    [self setImages:arr duration:1.0  forState:MJRefreshStateRefreshing];
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    
    self.gifView.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height * 0.5);
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
