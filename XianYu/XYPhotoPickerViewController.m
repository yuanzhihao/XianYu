//
//  XYPhotoPickerViewController.m
//  XianYu
//
//  Created by YuanZhihao on 7/26/16.
//  Copyright © 2016 YuanZhihao. All rights reserved.
//

#import "XYPhotoPickerViewController.h"
#import <Photos/Photos.h>
#import "XYPhotoPickerCollectionView.h"
#import "UIImage+Image.h"
#import "UIView+LBExtension.h"
#import "XYPhotoPickerCollectionViewCell.h"
#import "XYCandidatePhotoImageView.h"
#import "XYPhotoPreviewView.h"
#import "XYPhoto.h"
#import "XYAlbumView.h"
#import "XYPhotoAssetGroup.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

static CGFloat CELL_ROW = 4;
static CGFloat CELL_MARGIN = 2;
static CGFloat CELL_LINE_MARGIN = 2;
static CGFloat TOP_HEIGHT = 40;
static CGFloat BOTTOM_HEIGHT = 75;

@interface XYPhotoPickerViewController () <UICollectionViewDataSource, UICollectionViewDelegate, XYPhotoPickerCollectionViewCellDelegate, XYCandidatePhotoImageViewDelegate, XYPhotoPreviewViewDelegate>

/// 相片View
@property (nonatomic, strong) XYPhotoPickerCollectionView *collectionView;

@property (assign, nonatomic) NSUInteger privateTempMaxCount;

@property (nonatomic, strong) NSMutableArray *assets;

@property (nonatomic, strong) NSMutableArray *selectedAssets;

@property (nonatomic, strong) NSMutableArray *candidateImageViews;

@property (strong, nonatomic) NSMutableArray *takePhotoImages;

// 是否发送原图
@property (nonatomic, assign) BOOL isOriginal;

@property (nonatomic, weak) UIView *topView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, weak) UIButton *albumButton;

@property (nonatomic, weak) UIButton *cancelButton;

@property (nonatomic, weak) UIView *bottomView;

@property (nonatomic, strong) UIButton *sendButton;

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation XYPhotoPickerViewController

#pragma mark - getter
#pragma mark Get Data
- (NSMutableArray *)selectedAssets{
    if (!_selectedAssets) {
        _selectedAssets = [NSMutableArray array];
    }
    return _selectedAssets;
}

#pragma mark Get View
- (UIButton *)sendButton{
    if (!_sendButton) {
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        [rightBtn setBackgroundImage:[UIImage imageWithColor:[UIColor grayColor]] forState:UIControlStateDisabled];
        [rightBtn setBackgroundImage:[UIImage imageWithColor:[UIColor yellowColor]] forState:UIControlStateNormal];
        rightBtn.enabled = NO;
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:12.5];
        rightBtn.frame = CGRectMake(SCREEN_WIDTH - 50 - 12.5, 12.5, 50, 50);
        rightBtn.titleLabel.numberOfLines = 2;
        rightBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        NSString *title = [NSString stringWithFormat:@"确定\n%d/%lu",0, (unsigned long)self.privateTempMaxCount];
        [rightBtn setTitle:title forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(sendButtonTouched) forControlEvents:UIControlEventTouchUpInside];
        self.sendButton = rightBtn;
    }
    return _sendButton;
}

- (void)setUpTopView {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    dic[NSForegroundColorAttributeName] = [UIColor whiteColor];
    NSAttributedString *album = [[NSAttributedString alloc]initWithString:@"相册" attributes:dic];
    NSAttributedString *cancel = [[NSAttributedString alloc]initWithString:@"取消" attributes:dic];
    UIView *view = [UIView new];
    [view setBackgroundColor:[UIColor blackColor]];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, TOP_HEIGHT);
    self.topView = view;
    UILabel *titleLabel = [UILabel new];
    titleLabel.size = CGSizeMake(SCREEN_WIDTH / 2, TOP_HEIGHT * 0.8);
    titleLabel.center = view.center;
    [titleLabel setTextColor:[UIColor whiteColor]];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:titleLabel];
    self.titleLabel = titleLabel;
    UIButton *cancelButton = [UIButton new];
    cancelButton.size = CGSizeMake(SCREEN_WIDTH / 5, TOP_HEIGHT * 0.33);
    cancelButton.x = 0;
    cancelButton.centerY = view.centerY;
    [cancelButton setAttributedTitle:cancel forState:UIControlStateNormal];
    [cancelButton setAttributedTitle:cancel forState:UIControlStateSelected];
    [cancelButton setBackgroundColor:[UIColor blackColor]];
    [cancelButton addTarget:self action:@selector(cancelPhotoPicker) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:cancelButton];
    self.cancelButton = cancelButton;
    UIButton *albumButton = [UIButton new];
    albumButton.size = CGSizeMake(SCREEN_WIDTH / 5, TOP_HEIGHT * 0.33);
    albumButton.x = CGRectGetMaxX(view.frame) - albumButton.width;
    albumButton.centerY = view.centerY;
    [albumButton setAttributedTitle:album forState:UIControlStateNormal];
    [albumButton setAttributedTitle:album forState:UIControlStateSelected];
    [albumButton setBackgroundColor:[UIColor blackColor]];
    [albumButton addTarget:self action:@selector(openAlbum) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:albumButton];
    self.albumButton = albumButton;
    [self.view addSubview:view];
}

- (void)setUpBottomView {
    UIView *view = [UIView new];
    [view setBackgroundColor:[UIColor blackColor]];
    view.frame = CGRectMake(0, SCREEN_HEIGHT - BOTTOM_HEIGHT, SCREEN_WIDTH, BOTTOM_HEIGHT);
    [view addSubview:self.sendButton];
    self.bottomView = view;
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 75, BOTTOM_HEIGHT)];
    scrollView.bounces = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    //scrollView.contentSize = CGSizeMake(625, BOTTOM_HEIGHT);
    scrollView.contentSize = CGSizeMake(0, 0);
    [view addSubview:scrollView];
    self.scrollView = scrollView;
    [self.view addSubview:self.bottomView];
}

- (void)createCollectionView {
    CGFloat cellW = (self.view.frame.size.width - CELL_MARGIN * CELL_ROW + 1) / CELL_ROW;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(cellW, cellW);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = CELL_LINE_MARGIN;
    
    XYPhotoPickerCollectionView *collectionView = [[XYPhotoPickerCollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame), SCREEN_WIDTH, SCREEN_HEIGHT - self.topView.height - self.bottomView.height) collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.bounces = YES;
    
    [collectionView registerClass:[XYPhotoPickerCollectionViewCell class] forCellWithReuseIdentifier:@"photo_cell"];
    
    [collectionView setBackgroundColor:[UIColor whiteColor]];
    collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight;
    self.collectionView = collectionView;
    [self.view addSubview:collectionView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //[[UIApplication sharedApplication]setStatusBarHidden:YES];
    [self prefersStatusBarHidden];
    [self setNeedsStatusBarAppearanceUpdate];
    
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                [self setMaxCount:10];
                [self loadAlbum];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self setUpTopView];
                    [self setUpBottomView];
                    [self createCollectionView];
                });
            }
        }];
    }
//    else if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) {
//        [self setMaxCount:10];
//        [self loadAlbum];
//        [self setUpTopView];
//        [self setUpBottomView];
//        [self createCollectionView];
//    }
    else {
        [self setMaxCount:10];
        [self setUpTopView];
        [self setUpBottomView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setter
-(void)setMaxCount:(NSInteger)maxCount{
    _maxCount = maxCount;
    
    if (!_privateTempMaxCount) {
        _privateTempMaxCount = maxCount;
    }
}

- (void)sendButtonTouched {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)cancelPhotoPicker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)openAlbum {
    XYAlbumView *albumView = [[XYAlbumView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 70)];
    albumView.callBack = ^(XYPhotoAssetGroup *group) {
        [self changeAlbum:group];
    };
    [self.view bringSubviewToFront:self.bottomView];
    [self.view insertSubview:albumView belowSubview:self.bottomView];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"photo_cell";
    XYPhotoPickerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    if (cell) {
        [cell sizeToFit];
        cell.myDelegate = self;
        cell.tickButton.tag = indexPath.item;
        XYPhoto *photo = self.assets[indexPath.item];
        cell.imageView.image = photo.asset.thumbImage;
        if (photo.isSelected) {
            [cell.tickButton setSelected:YES];
            [cell.imageView setMaskViewFlag:YES];
        }
        else {
            [cell.tickButton setSelected:NO];
            [cell.imageView setMaskViewFlag:NO];
        }
    }
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assets.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self setUpPhotoBrowser:indexPath];
}

- (void)setUpPhotoBrowser:(NSIndexPath *)path {
    XYPhotoPreviewView *previewView = [[XYPhotoPreviewView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    previewView.indexPath = path;
    previewView.assets = self.assets;
    previewView.myDelegate = self;
    [self.view bringSubviewToFront:self.bottomView];
    [self.view insertSubview:previewView belowSubview:self.bottomView];
    [previewView prepareLeftAndRightImage];
    [previewView showCurrentImage];
}

- (void)loadAlbum {
    if (!self.assets) {
        self.assets = [NSMutableArray array];
    }
    
    __block NSMutableArray *tempAssets = [NSMutableArray array];
    __block NSString *title = nil;
    __weak typeof(self) weakSelf = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        PHFetchResult<PHAssetCollection *> *albums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
        [albums enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:obj options:nil];
            for (PHAsset *asset in assets) {
                XYPhotoAsset *tempAsset = [XYPhotoAsset new];
                XYPhoto *photo = [XYPhoto new];
                tempAsset.asset = asset;
                photo.asset = tempAsset;
                photo.isSelected = NO;
                [tempAssets addObject:photo];
            }
            if (!title) {
                title = obj.localizedTitle;
            }
        }];
        [weakSelf.assets setArray:tempAssets];
        [self.titleLabel setText:title];
    });
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)tickBtnTouched:(UIButton *)sender {
    NSIndexPath * indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
    XYPhotoPickerCollectionViewCell *cell = (XYPhotoPickerCollectionViewCell *) [self.collectionView cellForItemAtIndexPath:indexPath];
    XYPhoto *asset = self.assets[indexPath.item];
    XYPhotoImageView *pickerImageView = [cell.contentView.subviews objectAtIndex:0];
    NSUInteger count = self.selectedAssets.count;
    // 如果没有就添加到数组里面，存在就移除
    if ([pickerImageView isKindOfClass:[XYPhotoImageView class]] && pickerImageView.isMaskViewFlag) {
        int i = 0;
        for (XYCandidatePhotoImageView *candidate in self.candidateImageViews) {
            if ([candidate.path compare:indexPath] == NSOrderedSame) {
                [candidate removeFromSuperview];
                [self.candidateImageViews removeObject:candidate];
                
                if (self.scrollView.contentSize.width - 62.5 <= self.scrollView.width) {
                    CGFloat distance = self.scrollView.contentOffset.x;
                    if (distance != 0.0) {
                        self.scrollView.contentOffset = CGPointZero;
                    }
                    for (int j = i; j < self.candidateImageViews.count; j++) {
                        XYCandidatePhotoImageView *temp = self.candidateImageViews[j];
                        CGRect frame = temp.frame;
                        frame.origin = CGPointMake(temp.frame.origin.x - 62.5, temp.frame.origin.y);
                        temp.frame = frame;
                    }
                }
                else if(self.scrollView.contentOffset.x <= self.scrollView.contentSize.width - 62.5 - self.scrollView.width) {
                    for (int j = i; j < self.candidateImageViews.count; j++) {
                        XYCandidatePhotoImageView *temp = self.candidateImageViews[j];
                        CGRect frame = temp.frame;
                        frame.origin = CGPointMake(temp.frame.origin.x - 62.5, temp.frame.origin.y);
                        temp.frame = frame;
                    }
                }
                else {
                    for (int j = i; j < self.candidateImageViews.count; j++) {
                        XYCandidatePhotoImageView *temp = self.candidateImageViews[j];
                        CGRect frame = temp.frame;
                        frame.origin = CGPointMake(temp.frame.origin.x - 62.5, temp.frame.origin.y);
                        temp.frame = frame;
                    }
                    CGFloat distance = candidate.width - (self.scrollView.contentSize.width - self.scrollView.contentOffset.x - self.scrollView.width);
                    self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x - distance, self.scrollView.contentOffset.y);
                }
                self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width - 62.5, BOTTOM_HEIGHT);
                break;
            }
            i++;
        }
        [self.selectedAssets removeObject:asset];
        asset.isSelected = NO;
        count--;
    }
    else {
        if (count >= self.privateTempMaxCount) {
            NSString *format = [NSString stringWithFormat:@"最多只能选择%zd张图片",self.privateTempMaxCount];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:format preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
        [self.selectedAssets addObject:asset];
        XYCandidatePhotoImageView *candidateImageView = nil;
        if (self.candidateImageViews.count == 0) {
            candidateImageView = [[XYCandidatePhotoImageView alloc]initWithFrame:CGRectMake(12.5, 12.5, 50, 50)];
        }
        else {
            candidateImageView = [[XYCandidatePhotoImageView alloc]initWithFrame:CGRectMake(62.5 * self.candidateImageViews.count + 12.5, 12.5, 50, 50)];
        }
        candidateImageView.photo = asset;
        candidateImageView.deleteButton.tag = self.candidateImageViews.count;
        candidateImageView.path = indexPath;
        candidateImageView.image = cell.imageView.image;
        candidateImageView.myDelegate = self;
        [self.candidateImageViews addObject:candidateImageView];
        self.scrollView.contentSize = CGSizeMake(62.5 * self.candidateImageViews.count, BOTTOM_HEIGHT);
        [self.scrollView addSubview:candidateImageView];
        if (self.scrollView.contentSize.width > self.scrollView.width) {
            [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.contentSize.width - self.scrollView.width, 0, self.scrollView.width, BOTTOM_HEIGHT) animated:YES];
        }
        asset.isSelected = YES;
        count++;
    }
    pickerImageView.maskViewFlag = ([pickerImageView isKindOfClass:[XYPhotoImageView class]]) && !pickerImageView.isMaskViewFlag;
    
    [self updateSendButton:count];
}

- (void)updateSendButton:(NSUInteger)count {
    self.sendButton.enabled = (count > 0);
    NSString *title = [NSString stringWithFormat:@"确定\n%lu/%lu" ,(unsigned long)count ,(unsigned long)self.privateTempMaxCount];
    [self.sendButton setTitle:title forState:UIControlStateNormal];
}

- (void)deleteCandidateImage:(UIButton *)sender {
    int i = 0;
    for (XYCandidatePhotoImageView *candidate in self.candidateImageViews) {
        if (sender.tag == candidate.deleteButton.tag) {
            [candidate removeFromSuperview];
            XYPhotoPickerCollectionViewCell *cell = (XYPhotoPickerCollectionViewCell *) [self.collectionView cellForItemAtIndexPath:candidate.path];
            XYPhotoImageView *pickerImageView = [cell.contentView.subviews objectAtIndex:0];
            XYPhoto *asset = nil;
            if (candidate.path.item < self.assets.count) {
                asset = self.assets[candidate.path.item];
            }
            if (asset && [[asset.asset assetURL]isEqualToString:[candidate.photo.asset assetURL]]) {
                pickerImageView.maskViewFlag = ([pickerImageView isKindOfClass:[XYPhotoImageView class]]) && !pickerImageView.isMaskViewFlag;
            }
            [self.candidateImageViews removeObject:candidate];
            [self.selectedAssets removeObject:candidate.photo];
            
            if (self.scrollView.contentSize.width - 62.5 <= self.scrollView.width) {
                CGFloat distance = self.scrollView.contentOffset.x;
                if (distance != 0.0) {
                    self.scrollView.contentOffset = CGPointZero;
                }
                for (int j = i; j < self.candidateImageViews.count; j++) {
                    XYCandidatePhotoImageView *temp = self.candidateImageViews[j];
                    CGRect frame = temp.frame;
                    frame.origin = CGPointMake(temp.frame.origin.x - 62.5, temp.frame.origin.y);
                    temp.frame = frame;
                }
            }
            else if(self.scrollView.contentOffset.x <= self.scrollView.contentSize.width - 62.5 - self.scrollView.width) {
                for (int j = i; j < self.candidateImageViews.count; j++) {
                    XYCandidatePhotoImageView *temp = self.candidateImageViews[j];
                    CGRect frame = temp.frame;
                    frame.origin = CGPointMake(temp.frame.origin.x - 62.5, temp.frame.origin.y);
                    temp.frame = frame;
                }
            }
            else {
                for (int j = i; j < self.candidateImageViews.count; j++) {
                    XYCandidatePhotoImageView *temp = self.candidateImageViews[j];
                    CGRect frame = temp.frame;
                    frame.origin = CGPointMake(temp.frame.origin.x - 62.5, temp.frame.origin.y);
                    temp.frame = frame;
                }
                CGFloat distance = candidate.width - (self.scrollView.contentSize.width - self.scrollView.contentOffset.x - self.scrollView.width);
                self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x - distance, self.scrollView.contentOffset.y);
            }
            self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width - 62.5, BOTTOM_HEIGHT);
            asset.isSelected = NO;
            break;
        }
        i++;
    }
    [self updateSendButton:self.selectedAssets.count];
}

- (NSMutableArray *)candidateImageViews {
    if (!_candidateImageViews) {
        self.candidateImageViews = [NSMutableArray array];
    }
    return _candidateImageViews;
}

- (BOOL)choose:(NSInteger)page {
    XYPhoto *selectedPhoto = self.assets[page];
    
    if (!selectedPhoto.isSelected && self.selectedAssets.count >= self.privateTempMaxCount) {
        NSString *format = [NSString stringWithFormat:@"最多只能选择%zd张图片",self.privateTempMaxCount];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:format preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    }
    
    NSIndexPath * indexPath = [NSIndexPath indexPathForItem:page inSection:0];
    
    if (!selectedPhoto.isSelected) {
        [self.selectedAssets addObject:selectedPhoto];
        XYPhotoPickerCollectionViewCell *cell = (XYPhotoPickerCollectionViewCell *) [self.collectionView cellForItemAtIndexPath:indexPath];
        XYPhoto *asset = self.assets[indexPath.item];
        NSUInteger count = self.selectedAssets.count;
        XYCandidatePhotoImageView *candidateImageView = nil;
        if (self.candidateImageViews.count == 0) {
            candidateImageView = [[XYCandidatePhotoImageView alloc]initWithFrame:CGRectMake(12.5, 12.5, 50, 50)];
        }
        else {
            candidateImageView = [[XYCandidatePhotoImageView alloc]initWithFrame:CGRectMake(62.5 * self.candidateImageViews.count + 12.5, 12.5, 50, 50)];
        }
        candidateImageView.deleteButton.tag = self.candidateImageViews.count;
        candidateImageView.path = indexPath;
        candidateImageView.image = cell.imageView.image;
        candidateImageView.myDelegate = self;
        [self.candidateImageViews addObject:candidateImageView];
        self.scrollView.contentSize = CGSizeMake(62.5 * self.candidateImageViews.count, BOTTOM_HEIGHT);
        [self.scrollView addSubview:candidateImageView];
        if (self.scrollView.contentSize.width > self.scrollView.width) {
            [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.contentSize.width - self.scrollView.width, 0, self.scrollView.width, BOTTOM_HEIGHT) animated:YES];
        }
        asset.isSelected = YES;
        count++;
    }
    else {
        int i = 0;
        for (XYCandidatePhotoImageView *candidate in self.candidateImageViews) {
            if ([candidate.path compare:indexPath] == NSOrderedSame) {
                [candidate removeFromSuperview];
                [self.candidateImageViews removeObject:candidate];
                
                if (self.scrollView.contentSize.width - 62.5 <= self.scrollView.width) {
                    CGFloat distance = self.scrollView.contentOffset.x;
                    if (distance != 0.0) {
                        self.scrollView.contentOffset = CGPointZero;
                    }
                    for (int j = i; j < self.candidateImageViews.count; j++) {
                        XYCandidatePhotoImageView *temp = self.candidateImageViews[j];
                        CGRect frame = temp.frame;
                        frame.origin = CGPointMake(temp.frame.origin.x - 62.5, temp.frame.origin.y);
                        temp.frame = frame;
                    }
                }
                else if(self.scrollView.contentOffset.x <= self.scrollView.contentSize.width - 62.5 - self.scrollView.width) {
                    for (int j = i; j < self.candidateImageViews.count; j++) {
                        XYCandidatePhotoImageView *temp = self.candidateImageViews[j];
                        CGRect frame = temp.frame;
                        frame.origin = CGPointMake(temp.frame.origin.x - 62.5, temp.frame.origin.y);
                        temp.frame = frame;
                    }
                }
                else {
                    for (int j = i; j < self.candidateImageViews.count; j++) {
                        XYCandidatePhotoImageView *temp = self.candidateImageViews[j];
                        CGRect frame = temp.frame;
                        frame.origin = CGPointMake(temp.frame.origin.x - 62.5, temp.frame.origin.y);
                        temp.frame = frame;
                    }
                    CGFloat distance = candidate.width - (self.scrollView.contentSize.width - self.scrollView.contentOffset.x - self.scrollView.width);
                    self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x - distance, self.scrollView.contentOffset.y);
                }
                self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width - 62.5, BOTTOM_HEIGHT);
                break;
            }
            i++;
        }
        [self.selectedAssets removeObject:selectedPhoto];
    }
    [self updateSendButton:self.selectedAssets.count];
    return YES;
}

- (void)changeAlbum:(XYPhotoAssetGroup *)group {
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:group.group options:nil];
    
    __block NSMutableArray *tempAssets = [NSMutableArray array];
    
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XYPhotoAsset *tempAsset = [XYPhotoAsset new];
        XYPhoto *photo = [XYPhoto new];
        tempAsset.asset = obj;
        photo.asset = tempAsset;
        photo.isSelected = NO;
        [tempAssets addObject:photo];
    }];
    
    [self.assets removeAllObjects];
    for (XYPhoto *photo in tempAssets) {
        [self.assets addObject:photo];
    }
    [self.titleLabel setText:group.group.localizedTitle];
    for (XYPhoto *asset in self.selectedAssets) {
        for (XYPhoto *photo in self.assets) {
            if ([asset.asset.asset.localIdentifier isEqualToString:photo.asset.asset.localIdentifier]) {
                photo.isSelected = asset.isSelected;
            }
        }
    }
    [self.collectionView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
