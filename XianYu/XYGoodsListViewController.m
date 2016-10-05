//
//  XYGoodsListViewController.m
//  XianYu
//
//  Created by YuanZhihao on 7/4/16.
//  Copyright © 2016 YuanZhihao. All rights reserved.
//

#import "XYGoodsListViewController.h"
#import "XYGoodsCollectionViewCell.h"
#import "XYHomeGoodsModel.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Image.h"
#import <UIScrollView+MJRefresh.h>
#import "XYLoadMoreFooter.h"
#import "XYSearchViewController.h"
#import "UIView+LBExtension.h"

#define SCREEN_WIDTH     [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT    [UIScreen mainScreen].bounds.size.height
#define CellPadding 5
#define NavBarColor [UIColor colorWithRed:250/255.0 green:227/255.0 blue:111/255.0 alpha:1.0]

@interface XYGoodsListViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate>

@property (nonatomic, weak) UICollectionView *goodsListView;

@property (nonatomic, strong) NSMutableArray *goods;

@property (nonatomic, weak) UISearchBar *searchBar;

@property (nonatomic, weak) UIImageView *regionArrow;

@property (nonatomic, weak) UIImageView *typeArrow;

@property (nonatomic, weak) UIImageView *orderArrow;

@property (nonatomic, assign) BOOL regionOn;

@property (nonatomic, assign) BOOL typeOn;

@property (nonatomic, assign) BOOL orderOn;

@end

@implementation XYGoodsListViewController

- (NSMutableArray *)goods
{
    if (!_goods) {
        self.goods = [NSMutableArray array];
    }
    return _goods;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self changeNav];
    [self createLocalData];
    [self setupLoadMore];
}

- (void)setupLoadMore {
    XYLoadMoreFooter *footer = [XYLoadMoreFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    
    self.goodsListView.mj_footer = footer;
}

- (void)loadMore {
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i<10; i++) {
        XYHomeGoodsModel *goodModel = [[XYHomeGoodsModel alloc] init];
        goodModel.nickname = [NSString stringWithFormat:@"张三%d",i];
        goodModel.date = @"1435912294000";
        goodModel.icon = @"";
        goodModel.price = @"100";
        goodModel.pictures = @[@"",@"",@""];
        goodModel.content = @"大菩萨挂件，贩子远离点 精品挂件，平安，吉祥，聚财，寓意深远，有想要此物者留言";
        goodModel.location = @"沈阳 沈阳音乐学院";
        [arr addObject:goodModel];
    }
    for (int i = 0; i<10; i++) {
        [self.goods addObject:arr[i]];
    }
    [self.goodsListView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 结束刷新
        [self.goodsListView.mj_footer endRefreshing];
    });
}

- (void)changeNav {
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"header_back_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(returnRoot)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UISearchBar *searchBar = [[UISearchBar alloc]init];
    searchBar.delegate = self;
    CGRect frame = searchBar.frame;
    frame.size = CGSizeMake(self.navigationController.navigationBar.bounds.size.width * 0.8, self.navigationController.navigationBar.bounds.size.height * 0.7);
    searchBar.frame = frame;
    searchBar.text = self.word;
    UITextField *textField = nil;
    UIView *temp = searchBar.subviews[0];
    for (UIView *subview in temp.subviews) {
        if ([subview isKindOfClass:[UITextField class]]) {
            textField = (UITextField *)subview;
            break;
        }
    }
    if (textField) {
        textField.clearButtonMode = UITextFieldViewModeNever;
        textField.layer.borderWidth = 0.5;
    }
    self.searchBar = searchBar;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:searchBar];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController setToolbarHidden:NO];
    
    UIView *regionView = [UIView new];
    regionView.frame = CGRectMake(0, 0, SCREEN_WIDTH / 3 - 1, self.navigationController.toolbar.height);
    [regionView setBackgroundColor:[UIColor whiteColor]];
    UILabel *regionLabel = [UILabel new];
    regionLabel.text = @"区域";
    [regionLabel sizeToFit];
    regionLabel.center = regionView.center;
    UIImageView *regionArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_normal"]];
    regionArrow.frame = CGRectMake(CGRectGetMaxX(regionLabel.frame) + 5, 0, 20, 20);
    regionArrow.centerY = regionView.centerY;
    regionArrow.tag = 0;
    self.regionArrow = regionArrow;
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapRegion)];
    [regionView addGestureRecognizer:recognizer];
    [regionView addSubview:regionLabel];
    [regionView addSubview:regionArrow];
    
    UIView *typeView = [UIView new];
    typeView.size = CGSizeMake(SCREEN_WIDTH / 3 - 1, self.navigationController.toolbar.height);
    typeView.centerX = self.goodsListView.centerX;
    typeView.y = 0;
    [typeView setBackgroundColor:[UIColor whiteColor]];
    UILabel *typeLabel = [UILabel new];
    typeLabel.text = @"分类";
    [typeLabel sizeToFit];
    typeLabel.center = regionView.center;
    UIImageView *typeArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_normal"]];
    typeArrow.frame = CGRectMake(CGRectGetMaxX(typeLabel.frame) + 5, 0, 20, 20);
    typeArrow.centerY = typeView.centerY;
    typeArrow.tag = 0;
    self.typeArrow = typeArrow;
    UITapGestureRecognizer *typerRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapType)];
    [typeView addGestureRecognizer:typerRecognizer];
    [typeView addSubview:typeLabel];
    [typeView addSubview:typeArrow];
    
    UIView *orderView = [UIView new];
    orderView.frame = CGRectMake(SCREEN_WIDTH / 3 * 2 + 1, 0, SCREEN_WIDTH / 3 - 1, self.navigationController.toolbar.height);
    [orderView setBackgroundColor:[UIColor whiteColor]];
    UILabel *orderLabel = [UILabel new];
    orderLabel.text = @"排序";
    [orderLabel sizeToFit];
    orderLabel.center = regionView.center;
    UIImageView *orderArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_normal"]];
    orderArrow.frame = CGRectMake(CGRectGetMaxX(orderLabel.frame) + 5, 0, 20, 20);
    orderArrow.centerY = orderView.centerY;
    orderArrow.tag = 0;
    self.orderArrow = orderArrow;
    UITapGestureRecognizer *oederrRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOrder)];
    [orderView addGestureRecognizer:oederrRecognizer];
    [orderView addSubview:orderLabel];
    [orderView addSubview:orderArrow];
    
    [self.navigationController.toolbar addSubview:regionView];
    [self.navigationController.toolbar addSubview:typeView];
    [self.navigationController.toolbar addSubview:orderView];
}

- (void)returnRoot {
    __weak UINavigationBar *navigation = self.navigationController.navigationBar;
    [self.navigationController setToolbarHidden:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
    [navigation setBackgroundImage:[UIImage imageWithColor:NavBarColor] forBarMetrics:UIBarMetricsDefault];
}

- (void)createLocalData {
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        XYHomeGoodsModel *goodModel = [[XYHomeGoodsModel alloc] init];
        goodModel.nickname = [NSString stringWithFormat:@"张三%d",i];
        goodModel.date = @"1435912294000";
        goodModel.icon = @"";
        goodModel.price = @"100";
        goodModel.pictures = @[@"",@"",@""];
        goodModel.content = @"大菩萨挂件，贩子远离点 精品挂件，平安，吉祥，聚财，寓意深远，有想要此物者留言";
        goodModel.location = @"沈阳 沈阳音乐学院";
        [arr addObject:goodModel];
    }
    [self.goods addObjectsFromArray:arr];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView {
    UIView *view = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 3 * CellPadding) / 2, (SCREEN_WIDTH - 3 * CellPadding) / 2 + 80);
    
    flowLayout.minimumLineSpacing = CellPadding;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, CellPadding, CellPadding, CellPadding);
    
    UICollectionView *goodsListView = [[UICollectionView alloc]initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:flowLayout];
    
    [goodsListView registerClass:[XYGoodsCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    goodsListView.showsVerticalScrollIndicator = NO;
    goodsListView.delegate = self;
    goodsListView.dataSource = self;
    
    goodsListView.backgroundColor = [UIColor whiteColor];
    goodsListView.autoresizingMask = UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight;
    self.goodsListView = goodsListView;
    self.view = view;
    [self.view addSubview:goodsListView];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"选择了%ld", (long)indexPath.item);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.goods.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    XYGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    if (cell) {
        [cell sizeToFit];
        
        XYHomeGoodsModel *goods = self.goods[indexPath.item];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:goods.pictures[0]] placeholderImage:[UIImage imageNamed:@"placeholder240x240"]];
        cell.label.text = goods.content;
        cell.priceLabel.text = goods.price;
        cell.loactionLabel.text = goods.location;
        cell.dateLabel.text = goods.date;
    }
    return cell;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (velocity.y > 0) {
        [self.navigationController setNavigationBarHidden:YES];
        [self.navigationController setToolbarHidden:YES];
    }
    else {
        [self.navigationController setNavigationBarHidden:NO];
        [self.navigationController setToolbarHidden:NO];
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    //[self.navigationController popViewControllerAnimated:YES];
    XYSearchViewController *search = [[XYSearchViewController alloc]init];
    search.word = self.searchBar.text;
    search.source = 1;
    search.callBack = ^(NSString *word) {
        self.word = word;
        self.searchBar.text = word;
    };
    [self.navigationController pushViewController:search animated:YES];
    return NO;
}

- (void)tapRegion {
    [UIView animateWithDuration:0.5 animations:^{
        self.regionArrow.transform = CGAffineTransformRotate(self.regionArrow.transform, M_PI);
    }];
    if (self.regionArrow.tag == 0) {
        [self.regionArrow setImage:[UIImage imageNamed:@"arrow_highlight"]];
        self.regionArrow.tag = 1;
    }
    else {
        [self.regionArrow setImage:[UIImage imageNamed:@"arrow_normal"]];
        self.regionArrow.tag = 0;
    }
}

- (void)tapType {
    [UIView animateWithDuration:0.5 animations:^{
        self.typeArrow.transform = CGAffineTransformRotate(self.typeArrow.transform, M_PI);
    }];
    if (self.typeArrow.tag == 0) {
        [self.typeArrow setImage:[UIImage imageNamed:@"arrow_highlight"]];
        self.typeArrow.tag = 1;
    }
    else {
        [self.typeArrow setImage:[UIImage imageNamed:@"arrow_normal"]];
        self.typeArrow.tag = 0;
    }
}

- (void)tapOrder {
    [UIView animateWithDuration:0.5 animations:^{
        self.orderArrow.transform = CGAffineTransformRotate(self.orderArrow.transform, M_PI);
    }];
    if (self.orderArrow.tag == 0) {
        [self.orderArrow setImage:[UIImage imageNamed:@"arrow_highlight"]];
        self.orderArrow.tag = 1;
    }
    else {
        [self.orderArrow setImage:[UIImage imageNamed:@"arrow_normal"]];
        self.orderArrow.tag = 0;
    }
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
