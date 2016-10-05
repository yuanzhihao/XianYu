//
//  XYRefreshHeader.m
//  XianYu
//
//  Created by YuanZhihao on 6/24/16.
//  Copyright © 2016 YuanZhihao. All rights reserved.
//

#import "XYRefreshHeader.h"
#import "UIView+LBExtension.h"

#define SCREEN_WIDTH     [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT    [UIScreen mainScreen].bounds.size.height

@interface XYRefreshHeader()
@property (nonatomic,weak) UIImageView *topImageView;
@property (nonatomic,weak) UIImageView *secondImageView;
@end

@implementation XYRefreshHeader

-(void)prepare
{
    [super prepare];
    
    self.mj_h = 50;
    
    self.lastUpdatedTimeLabel.hidden = YES;
    [self setTitle:@"下拉看看" forState:MJRefreshStateIdle];
    [self setTitle:@"松开看看" forState:MJRefreshStatePulling];
    [self setTitle:@"" forState:MJRefreshStateRefreshing];
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i<20; i++) {
        if (i<10) {
            [arr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"loading_v1_0000%d",i]]];
        }else{
            [arr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"loading_v1_000%d",i]]];
        }
    }
    
    [self setImages:arr duration:1.0  forState:MJRefreshStateRefreshing];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [self addSubview:imageView];
    self.topImageView = imageView;
    
    UIImageView *secondImageView = [[UIImageView alloc] init];
    [imageView addSubview:secondImageView];
    self.secondImageView = secondImageView;
    
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    self.gifView.contentMode = UIViewContentModeCenter;
    self.gifView.mj_w = self.mj_w;
    self.topImageView.frame = CGRectMake(SCREEN_WIDTH / 2 + 40, -5, 60, 60);
    self.secondImageView.frame = CGRectMake(0, 0, 60, 60);
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

-(void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
        {
            self.gifView.hidden = YES;
            self.topImageView.image = [UIImage imageNamed:@"refresh_nomal"];
            self.secondImageView.image =nil;
        }
            break;
        case MJRefreshStatePulling:
        {
            
            self.gifView.hidden = YES;
            [UIView animateWithDuration:0.5 animations:^{
                self.secondImageView.height +=10;
            } completion:^(BOOL finished) {
            }];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.topImageView.image = [UIImage imageNamed:@"refresh_pulling"];
                self.secondImageView.image = [UIImage imageNamed:@"refresh_pulling_0"];
            });
        }
            break;
        case MJRefreshStateRefreshing:
        {
            self.gifView.centerX = SCREEN_WIDTH/2;
            self.gifView.hidden = NO;
            self.secondImageView.height -=10;
            self.topImageView.image = [UIImage imageNamed:@"refresh_loading"];
            self.secondImageView.image = [UIImage imageNamed:@"refresh_loading_0"];
            [UIView animateKeyframesWithDuration:0.5 delay:0.5 options:UIViewKeyframeAnimationOptionRepeat animations:^{
                self.secondImageView.x -=2;
            } completion:^(BOOL finished) {
                self.secondImageView.x +=2;
            }];
        }
            break;
        default:
            break;
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
