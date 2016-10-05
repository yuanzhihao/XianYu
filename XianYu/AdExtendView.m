//
//  AdExtendView.m
//  XianYu
//
//  Created by YuanZhihao on 6/18/16.
//  Copyright © 2016 YuanZhihao. All rights reserved.
//

#import "AdExtendView.h"
#import "UIImageView+WebCache.h"

@interface AdExtendView()
{
    UIImageView *adOne;
    UIImageView *adTwo;
    UIImageView *adThree;
    UIImageView *adFour;
}
@end

@implementation AdExtendView

+ (id)adExtendViewWithFrame:(CGRect)frame imageLinkURL:(NSArray *)imageLinkURL placeHoderImageName:(NSString *)imageName {
    if (imageLinkURL.count < 1) {
        return nil;
    }
    
    NSInteger count = (imageLinkURL.count < 4 ? imageLinkURL.count : 4);
    
    CGFloat width = frame.size.width / count;
    CGFloat height = frame.size.height;
    CGFloat x = 0;
    CGFloat y = 0;
    
    AdExtendView *extend = [[AdExtendView alloc]initWithFrame:frame];
    for (int i = 0; i < count; i++) {
        UIImageView *temp = [[UIImageView alloc]initWithFrame:CGRectMake(x, y, width, height)];
        [temp sd_setImageWithURL:imageLinkURL[i] placeholderImage:[UIImage imageNamed:imageName]];
        temp.tag = i;
        temp.userInteractionEnabled = YES;
        [temp addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:extend.self action:@selector(tapAd:)]];
        [extend addSubview:temp];
        x += width;
    }
    return extend;
}

- (void)tapAd:(UIGestureRecognizer *)recognizer {
    NSInteger n = recognizer.view.tag;
    switch (n) {
        case 0:
            NSLog(@"1号广告");
            break;
        case 1:
            NSLog(@"2号广告");
            break;
        case 2:
            NSLog(@"3号广告");
            break;
        case 3:
            NSLog(@"4号广告");
        default:
            break;
    }
}

@end
