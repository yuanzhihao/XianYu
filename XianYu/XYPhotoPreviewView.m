//
//  XYPhotoPreviewView.m
//  XianYu
//
//  Created by YuanZhihao on 7/31/16.
//  Copyright © 2016 YuanZhihao. All rights reserved.
//

#import "XYPhotoPreviewView.h"
#import "XYPhotoAsset.h"
#import "UIView+LBExtension.h"
#import "XYPhoto.h"

static NSString *ID = @"image_cell";

typedef NS_ENUM(NSInteger, DraggingDirection) {
    MIDDLE,
    LEFT,
    RIGHT
};

@interface XYPhotoPreviewView () <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>

@property (nonatomic, weak) UIView *topView;

@property (nonatomic, weak) UICollectionView *collectionView;

@property (nonatomic, strong) UIButton *selectButton;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, assign) CGFloat beginDraggingContentOffsetX;

@end

@implementation XYPhotoPreviewView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpTopView];
        [self createCollectionView];
    }
    return self;
}

- (void)setUpTopView {
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
    [topView setBackgroundColor:[UIColor blackColor]];
    
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 20, 30)];
    backButton.centerY = topView.centerY;
    [backButton setBackgroundImage:[UIImage imageNamed:@"header_back_icon_highlight"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backButton];
    
    UIButton *selectButton = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 30, 0, 20, 20)];
    selectButton.centerY = topView.centerY;
    [selectButton setBackgroundImage:[UIImage imageNamed:@"checkbox_pic_non"] forState:UIControlStateNormal];
    [selectButton setBackgroundImage:[UIImage imageNamed:@"checkbox_pic"] forState:UIControlStateSelected];
    self.selectButton = selectButton;
    [selectButton addTarget:self action:@selector(choose) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:selectButton];
    
    [self addSubview:topView];
    self.topView = topView;
}

- (void)createCollectionView {
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 115);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame), [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 115) collectionViewLayout:layout];
    collectionView.pagingEnabled = YES;
    [collectionView setBackgroundColor:[UIColor blackColor]];
    collectionView.bounces = YES;
    collectionView.delegate = self;
    collectionView.dataSource =self;
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:ID];
    self.collectionView = collectionView;
    [self addSubview:collectionView];
}

- (void)back {
    [self setHidden:YES];
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    [self removeFromSuperview];
}

- (void)choose {
    BOOL canChanged = NO;
    if ([self.myDelegate respondsToSelector:@selector(choose:)]) {
        canChanged = [self.myDelegate choose:self.page];
    }
    if (canChanged) {
        [self.selectButton setSelected:!self.selectButton.selected];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    if (cell) {
        XYPhoto *photo = self.assets[indexPath.item];
        if ([[cell.contentView.subviews lastObject] isKindOfClass:[UIView class]]) {
            [[cell.contentView.subviews lastObject]removeFromSuperview];
        }
        UIImageView *imageView = [UIImageView new];
        imageView.frame = self.collectionView.frame;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        if (!photo.image) {
            photo.image = [photo.asset originImage];
            imageView.image = photo.image;
        }
        else {
            imageView.image = photo.image;
        }
        [cell.contentView addSubview:imageView];
    }
    return cell;
}

- (void)showCurrentImage {
    if (self.page <= 0) {
        self.page = self.indexPath.item;
    }
    else {
        --self.page;
    }
    
    if (self.page >= self.assets.count) {
        self.page = self.assets.count - 1;
    }
    
    if (self.page >= 0) {
        CGPoint point = CGPointMake(self.page * self.collectionView.width, 0);
        self.collectionView.contentOffset = point;
        self.beginDraggingContentOffsetX = point.x;
    }
    XYPhoto *photo = self.assets[self.page];
    if (photo.isSelected) {
        [self.selectButton setSelected:YES];
    }
    else {
        [self.selectButton setSelected:NO];
    }
}

/*- (void)setAssets:(NSMutableArray *)assets {
    if (!_assets) {
        _assets = [NSMutableArray array];
    }
    else {
        [_assets removeAllObjects];
    }
    for (XYPhotoAsset *asset in assets) {
        XYPhoto *photo = [XYPhoto new];
        photo.asset = asset;
        [_assets addObject:photo];
    }
}*/

- (void)prepareLeftAndRightImage {
    if (self.assets.count > 1) {
        if (self.page == 0) {
            if (!((XYPhoto *)self.assets[1]).image) {
                XYPhotoAsset *asset = ((XYPhoto *)self.assets[1]).asset;
                ((XYPhoto *)self.assets[1]).image = [asset originImage];
            }
        }
        else if (self.page == self.assets.count - 1) {
            if (!((XYPhoto *)self.assets[self.page - 1]).image) {
                XYPhotoAsset *asset = ((XYPhoto *)self.assets[self.page - 1]).asset;
                ((XYPhoto *)self.assets[self.page - 1]).image = [asset originImage];
            }
        }
        else {
            if (!((XYPhoto *)self.assets[self.page + 1]).image) {
                XYPhotoAsset *asset = ((XYPhoto *)self.assets[self.page + 1]).asset;
                ((XYPhoto *)self.assets[self.page + 1]).image = [asset originImage];
            }
            if (!((XYPhoto *)self.assets[self.page - 1]).image) {
                XYPhotoAsset *asset = ((XYPhoto *)self.assets[self.page - 1]).asset;
                ((XYPhoto *)self.assets[self.page - 1]).image = [asset originImage];
            }
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.beginDraggingContentOffsetX = self.collectionView.contentOffset.x;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (targetContentOffset -> x != _beginDraggingContentOffsetX) {
        DraggingDirection diretion = [self getDraggingDirection];
        if (diretion == LEFT) {
            self.page = (NSInteger)(scrollView.contentOffset.x / scrollView.frame.size.width + 0.9);
            if (self.page > self.assets.count - 1) {
                self.page--;
            }
        }
        else if (diretion == RIGHT) {
            self.page = (NSInteger)(scrollView.contentOffset.x / scrollView.frame.size.width);
        }
        
        dispatch_queue_t queue = dispatch_queue_create("EndDragging", DISPATCH_QUEUE_SERIAL);
        dispatch_async(queue, ^{
            [self loadNextImageWithDirection:diretion];
        });
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    XYPhoto *photo = self.assets[self.page];
    if (photo.isSelected) {
        [self.selectButton setSelected:YES];
    }
    else {
        [self.selectButton setSelected:NO];
    }
}

- (void)loadNextImageWithDirection:(DraggingDirection)direction {
    if (direction == LEFT && self.page < self.assets.count - 1) {
        if (!((XYPhoto *)self.assets[self.page + 1]).image) {
            XYPhotoAsset *asset = ((XYPhoto *)self.assets[self.page + 1]).asset;
            ((XYPhoto *)self.assets[self.page + 1]).image = [asset originImage];
        }
    }
    else if (direction == RIGHT && self.page > 0) {
        if (!((XYPhoto *)self.assets[self.page - 1]).image) {
            XYPhotoAsset *asset = ((XYPhoto *)self.assets[self.page - 1]).asset;
            ((XYPhoto *)self.assets[self.page - 1]).image = [asset originImage];
        }
    }
}

- (DraggingDirection)getDraggingDirection {
    DraggingDirection direction;
    if (self.beginDraggingContentOffsetX == self.collectionView.contentOffset.x) {
        direction = MIDDLE;
    }
    else if (self.beginDraggingContentOffsetX > self.collectionView.contentOffset.x) {
        direction = RIGHT;
    }
    else {
        direction = LEFT;
    }
    return direction;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
