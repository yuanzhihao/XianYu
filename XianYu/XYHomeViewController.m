//
//  XYHomeViewController.m
//  XianYu
//
//  Created by YuanZhihao on 6/14/16.
//  Copyright © 2016 YuanZhihao. All rights reserved.
//

#import "XYHomeViewController.h"
#import "AdView.h"
#import "AdExtendView.h"
#import "UIView+LBExtension.h"
#import "XYCodeViewController.h"
#import "XYMenuViewController.h"
#import "XYGoodsTableViewCell.h"
#import "XYHomeGoodsFrame.h"
#import "XYHomeGoodsModel.h"
#import <UIScrollView+MJRefresh.h>
#import "XYRefreshHeader.h"
#import "XYLoadMoreFooter.h"
#import "XYSearchViewController.h"

#define SCREEN_WIDTH     [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT    [UIScreen mainScreen].bounds.size.height

@interface XYHomeViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,weak) UIView *headView;

@property (nonatomic,weak) AdView *adView;

@property (nonatomic,weak) AdExtendView *extendView;

@property (nonatomic,weak) UITableView *goodsListView;

@property (nonatomic,strong) NSMutableArray *goodsListFrame;

@property (nonatomic, assign) float test;

@end

@implementation XYHomeViewController

- (float)test {
    return _test;
}

- (NSMutableArray *)goodsListFrame
{
    if (!_goodsListFrame) {
        self.goodsListFrame = [NSMutableArray array];
    }
    return _goodsListFrame;
}

- (NSArray *)trendsFrameWithStatus:(NSArray *)trendsArray
{
    //将trends模型数组转化为trendsframe模型数组
    NSMutableArray *trendsFrameArray = [NSMutableArray array];
    for (XYHomeGoodsModel *goods in trendsArray) {
        XYHomeGoodsFrame *f =[[XYHomeGoodsFrame alloc] init];
        f.goodsModel = goods;
        [trendsFrameArray addObject:f];
    }
    return trendsFrameArray;
}

- (void)createLocalData
{
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
    NSArray *trendsFrame = [self trendsFrameWithStatus:arr];
    [self.goodsListFrame addObjectsFromArray:trendsFrame];
}

- (void)setupRefresh {
    XYRefreshHeader *header = [XYRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    
    self.goodsListView.mj_header = header;
}

- (void)setupLoadMore {
    XYLoadMoreFooter *footer = [XYLoadMoreFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    
    self.goodsListView.mj_footer = footer;
}

- (void)refresh {
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
    NSArray *trendsFrame = [self trendsFrameWithStatus:arr];
    for (int i = 0; i<10; i++) {
        [self.goodsListFrame insertObject:trendsFrame[i] atIndex:i];
    }
    [self.goodsListView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 结束刷新
        [self.goodsListView.mj_header endRefreshing];
    });
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
    NSArray *trendsFrame = [self trendsFrameWithStatus:arr];
    for (int i = 0; i<10; i++) {
        [self.goodsListFrame addObject:trendsFrame[i]];
    }
    [self.goodsListView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 结束刷新
        [self.goodsListView.mj_footer endRefreshing];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self changeNav];
    [self createHeadView];
    [self createAdView];
    [self createTableView];
    [self createLocalData];
    [self setupRefresh];
    [self setupLoadMore];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)changeNav {
    //通过titleView属性设置导航栏中间的视图
    UIButton *searchButton = [[UIButton alloc]init];
    searchButton.backgroundColor = [UIColor whiteColor];
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    dic[NSFontAttributeName]=[UIFont systemFontOfSize:12];
    dic[NSForegroundColorAttributeName]=[UIColor grayColor];
    NSAttributedString *text = [[NSAttributedString alloc]initWithString:@"🔍请输入宝贝关键字" attributes:dic];
    [searchButton setAttributedTitle:text forState:UIControlStateNormal];
    [searchButton setAttributedTitle:text forState:UIControlStateHighlighted];
    [searchButton addTarget:self action:@selector(searchButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    searchButton.size = CGSizeMake(self.navigationController.navigationBar.width * 0.7, self.navigationController.navigationBar.height * 0.7);
    searchButton.layer.cornerRadius = 5.0;
    self.navigationItem.titleView = searchButton;
    
    //设置导航栏左按钮
    UIBarButtonItem *codeButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"code"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(codeButtonClicked)];
    self.navigationItem.leftBarButtonItem = codeButton;
    
    //设置导航栏右按钮
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"menu"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(menuButtonClicked)];
    self.navigationItem.rightBarButtonItem = menuButton;
    
}

- (void)searchButtonClicked {
    XYSearchViewController *search = [[XYSearchViewController alloc]init];
    search.source = 0;
    [self.navigationController pushViewController:search animated:YES];
}

//响应导航栏左按钮点击事件
- (void)codeButtonClicked {
    XYCodeViewController *code = [[XYCodeViewController alloc]init];
    code.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:code animated:YES completion:nil];
}

//响应导航栏右按钮点击事件
- (void)menuButtonClicked {
    XYMenuViewController *menu = [[XYMenuViewController alloc]init];
    [self.navigationController pushViewController:menu animated:YES];
}

//在tableview上设置headview
- (void)createHeadView
{
    UIView *headView = [[UIView alloc] init];
    headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT * 0.3);
    headView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headView];
    self.headView = headView;
}

//在headview上设置广告视图
- (void)createAdView {
    NSArray *imagesURL = @[
                           @"https://img.alicdn.com/imgextra/i2/2278491860/TB2J4JcqFXXXXXQXXXXXXXXXXXX_!!2278491860.jpg",
                           @"https://img.alicdn.com/tps/TB1r6C9KpXXXXXjaXXXXXXXXXXX-315-160.jpg",
                           @"https://img.alicdn.com/imgextra/i3/894224787/TB2ahFgqpXXXXX0XpXXXXXXXXXX_!!894224787.jpg"
                           ];
    
    NSArray *URL = @[
                     @"https://img.alicdn.com/imgextra/i3/5/TB2dfbIqFXXXXbyXpXXXXXXXXXX_!!5-0-yamato.jpg_790x420q75s30.jpg",
                     @"https://img.alicdn.com/imgextra/i3/5/TB2CF.SqXXXXXaBXpXXXXXXXXXX_!!5-0-yamato.jpg_790x420q75s30.jpg",
                     @"https://img.alicdn.com/imgextra/i4/5/TB29tu_qFXXXXX4XXXXXXXXXXXX_!!5-0-yamato.jpg_790x420q75s30.jpg",
                     @"https://img.alicdn.com/imgextra/i4/5/TB2dKUJqXXXXXb0XpXXXXXXXXXX_!!5-0-yamato.jpg_790x420q75s30.jpg"
                     ];
    
    AdView *AdScrollView = [AdView adScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT * 0.2)imageLinkURL:imagesURL placeHoderImageName:@"page_loading_fish" pageControlShowStyle:UIPageControlShowStyleCenter];
    
    AdExtendView *extendView = [AdExtendView adExtendViewWithFrame:CGRectMake(0, SCREEN_HEIGHT * 0.2, SCREEN_WIDTH, SCREEN_HEIGHT * 0.1) imageLinkURL:URL placeHoderImageName:@"page_loading_fish"];
    
    //    是否需要支持定时循环滚动，默认为YES
    AdScrollView.isNeedCycleRoll = YES;
    
    //    设置图片滚动时间,默认3s
    AdScrollView.adMoveTime = 3.0;
    
    //图片被点击后回调的方法
    AdScrollView.callBack = ^(NSInteger index,NSString * imageURL)
    {
        NSLog(@"被点中图片的索引:%ld---地址:%@",index,imageURL);
    };
    [self.headView addSubview:AdScrollView];
    [self.headView addSubview:extendView];
    self.adView = AdScrollView;
    self.extendView = extendView;
}

- (void)createTableView
{
    //减去tabbar的高度
    UITableView *goodsListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,SCREEN_HEIGHT-49) style:UITableViewStyleGrouped];
    goodsListTableView.backgroundColor = [UIColor grayColor];
    goodsListTableView.delegate = self;
    goodsListTableView.dataSource = self;
    goodsListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    goodsListTableView.showsVerticalScrollIndicator = NO;
    goodsListTableView.sectionFooterHeight = 0.0;
    
    /*UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCell:)];
    recognizer.numberOfTapsRequired = 1;
    [goodsListTableView addGestureRecognizer:recognizer];*/
    
    self.goodsListView = goodsListTableView;
    [self.view addSubview:goodsListTableView];
    
    goodsListTableView.tableHeaderView = self.headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XYHomeGoodsFrame *goodsFrame = self.goodsListFrame[indexPath.row];
    return goodsFrame.cellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.goodsListFrame.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XYGoodsTableViewCell *cell = [XYGoodsTableViewCell cellWithTableView:tableView];
    if (cell) {
        __weak typeof(self) weakSelf = self;
        cell.tableView = tableView;
        cell.OnMyButtonClick = ^(NSIndexPath *path) {
            [weakSelf onMyButtonClick:indexPath];
        };
        cell.goodsFrame = self.goodsListFrame[indexPath.section];
    }
    return cell;
}

- (void)onMyButtonClick:(NSIndexPath *)path {
    NSLog(@"您点击的是第%ld行的按钮", (long)path.row);
}

- (void)tapCell:(UITapGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:self.goodsListView];
    NSIndexPath *path = [self.goodsListView indexPathForRowAtPoint:location];
    
    if (path) {
        XYGoodsTableViewCell *cell = [self.goodsListView cellForRowAtIndexPath:path];
        CGPoint point = [recognizer locationInView:cell.iconView];
        if (CGRectContainsPoint(cell.iconView.frame, point)) {
            NSLog(@"您点击的是第%ld行的头像", (long)path.row);
        }
        else {
            NSLog(@"您点击的是第%ld行的商品", (long)path.row);
        }
    }
    [self.goodsListView deselectRowAtIndexPath:path animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"您点击的是第%ld行的商品", (long)indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
