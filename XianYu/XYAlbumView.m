//
//  XYAlbumView.m
//  XianYu
//
//  Created by YuanZhihao on 8/3/16.
//  Copyright © 2016 YuanZhihao. All rights reserved.
//

#import "XYAlbumView.h"
#import "UIView+LBExtension.h"
#import "XYPhotoAssetGroup.h"
#import <Photos/Photos.h>
#import "XYPhotoAsset.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface XYAlbumView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *groups;

@property (nonatomic, copy) NSString *selectedAlbumURL;

@end

@implementation XYAlbumView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor blackColor]];
        [self loadAlbums];
        [self tableView];
        [self createTopView];
    }
    return self;
}

- (UITableView *)tableView{
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, SCREEN_HEIGHT - 45) style:UITableViewStylePlain];
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = 45;
        [tableView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:tableView];
        self.tableView = tableView;
    }
    return _tableView;
}

- (void)createTopView {
    UIView *view = [UIView new];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 45);
    [view setBackgroundColor:[UIColor blackColor]];
     
    UILabel *title = [UILabel new];
    title.size = CGSizeMake(SCREEN_WIDTH / 2, 45 * 0.8);
    title.center = view.center;
    [title setBackgroundColor:[UIColor blackColor]];
    [title setTextColor:[UIColor whiteColor]];
    [title setText:@"相册"];
    title.textAlignment = NSTextAlignmentCenter;
    [self addSubview:title];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    dic[NSForegroundColorAttributeName] = [UIColor whiteColor];
    NSAttributedString *cancel = [[NSAttributedString alloc]initWithString:@"取消" attributes:dic];
    
    UIButton *cancelButton = [UIButton new];
    cancelButton.size = CGSizeMake(SCREEN_WIDTH / 5, 45 * 0.33);
    cancelButton.x = 0;
    cancelButton.centerY = view.centerY;
    [cancelButton setAttributedTitle:cancel forState:UIControlStateNormal];
    [cancelButton setAttributedTitle:cancel forState:UIControlStateSelected];
    [cancelButton setBackgroundColor:[UIColor blackColor]];
    [cancelButton addTarget:self action:@selector(cancelChooseAlbum) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelButton];
}

- (void)cancelChooseAlbum {
    for (UIView *view in self.subviews) {
        //[view setHidden:YES];
        [view removeFromSuperview];
    }
    [self removeFromSuperview];
}

- (void)loadAlbums {
    PHFetchResult<PHAssetCollection *> *result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
    [result enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XYPhotoAssetGroup *group = [XYPhotoAssetGroup new];
        group.group = obj;
        group.albumTitle = obj.localizedTitle;
        PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:obj options:nil];
        group.assetsCount = assets.count;
        if (assets.count > 0) {
            XYPhotoAsset *asset = [XYPhotoAsset new];
            asset.asset = assets[0];
            group.thumbImage = [asset thumbImage];
        }
        else {
            group.thumbImage = nil;
        }
        [self.groups addObject:group];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.groups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"album_cell";
    XYPhotoAssetGroup *group = self.groups[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = [group.albumTitle stringByAppendingFormat:@" (%ld)", (long)group.assetsCount];
    if (group.thumbImage) {
        cell.imageView.image = group.thumbImage;
    }
    else {
        cell.imageView.image = [UIImage imageNamed:@"placeholder68x68"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XYPhotoAssetGroup *group = self.groups[indexPath.row];
    if (self.callBack) {
        _callBack(group);
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self cancelChooseAlbum];
}

- (NSMutableArray *)groups {
    if (!_groups) {
        self.groups = [NSMutableArray array];
    }
    return _groups;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
