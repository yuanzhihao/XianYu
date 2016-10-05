//
//  XYSearchViewController.m
//  XianYu
//
//  Created by YuanZhihao on 7/2/16.
//  Copyright © 2016 YuanZhihao. All rights reserved.
//

#import "XYSearchViewController.h"
#import "UIImage+Image.h"
#import "XYSearchAdviceModel.h"
#import "XYGoodsListViewController.h"

#define NavBarColor [UIColor colorWithRed:250/255.0 green:227/255.0 blue:111/255.0 alpha:1.0]

@interface XYSearchViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UISearchBarDelegate>

@property (nonatomic, weak) UISearchBar *searchBar;

@property (nonatomic, weak) UITableView *adviceListView;

@property (nonatomic, strong) NSMutableArray *searchAdvice;

@end

@implementation XYSearchViewController

- (NSMutableArray *)searchAdvice
{
    if (!_searchAdvice) {
        self.searchAdvice = [NSMutableArray array];
    }
    return _searchAdvice;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self changeNav];
    if (self.source == 1) {
        [self loadData];
        self.adviceListView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self.adviceListView reloadData];
    }
}

- (void)loadData {
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < 5; i++) {
        XYSearchAdviceModel *model = [[XYSearchAdviceModel alloc]init];
        model.advice = @"advice";
        [arr addObject:model];
    }
    if (self.searchAdvice.count != 0) {
        [self.searchAdvice removeAllObjects];
        [self.searchAdvice addObjectsFromArray:arr];
    }
    else {
        [self.searchAdvice addObjectsFromArray:arr];
    }
}

- (void)loadView {
    UIView *view = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor = [UIColor whiteColor];
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCell:)];
    recognizer.numberOfTapsRequired = 1;
    [tableView addGestureRecognizer:recognizer];
    self.adviceListView = tableView;
    self.view = view;
    [self.view addSubview:tableView];
}

- (void)changeNav {
    UISearchBar *searchBar = [[UISearchBar alloc]init];
    searchBar.placeholder = @"请输入宝贝关键字";
    searchBar.showsCancelButton = NO;
    searchBar.delegate = self;
    CGRect frame = searchBar.frame;
    frame.size = CGSizeMake(self.navigationController.navigationBar.bounds.size.width * 0.8, self.navigationController.navigationBar.bounds.size.height * 0.7);
    searchBar.frame = frame;
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithCustomView:searchBar];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelSearch)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    
    [searchBar becomeFirstResponder];
    
    if (self.source == 1 && self.word) {
        searchBar.text = self.word;
    }
    
    self.searchBar = searchBar;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchAdvice.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    XYSearchAdviceModel *advice = self.searchAdvice[indexPath.row];
    static NSString *ID = @"Advice";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    if (cell) {
        //__weak typeof(self) weakSelf = self;
        cell.textLabel.text = advice.advice;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (void)cancelSearch {
    if (self.source == 0) {
        __weak UINavigationController *temp = self.navigationController;
        [self.navigationController popViewControllerAnimated:YES];
        [temp.navigationBar setBackgroundImage:[UIImage imageWithColor:NavBarColor] forBarMetrics:UIBarMetricsDefault];
    }
    else if (self.source == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        [self.searchAdvice removeAllObjects];
        self.adviceListView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.adviceListView reloadData];
    }
    else {
        [self loadData];
        self.adviceListView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self.adviceListView reloadData];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"检索");
}

- (void)tapCell:(UITapGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:self.adviceListView];
    NSIndexPath *path = [self.adviceListView indexPathForRowAtPoint:location];
    
    if (path) {
        NSLog(@"您点击的是第%ld行的建议",(long)path.row);
        XYSearchAdviceModel *advice = self.searchAdvice[path.row];
        if (self.source == 0) {
            self.searchBar.text = advice.advice;
            XYGoodsListViewController *goodsList = [[XYGoodsListViewController alloc]init];
            goodsList.word = self.searchBar.text;
            [self.navigationController pushViewController:goodsList animated:YES];
        }
        else if (self.source == 1) {
            if (self.callBack) {
                _callBack(advice.advice);
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
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
