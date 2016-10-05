//
//  XYMineViewController.m
//  XianYu
//
//  Created by YuanZhihao on 6/16/16.
//  Copyright © 2016 YuanZhihao. All rights reserved.
//

#import "XYMineViewController.h"
#import "UIImageView+WebCache.h"
#import "ListItem.h"
#import "ItemGroup.h"
#import "XYSettingViewController.h"
#import "UIView+LBExtension.h"

#define SCREEN_WIDTH     [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT    [UIScreen mainScreen].bounds.size.height

@interface XYMineViewController () <UITableViewDataSource, UITableViewDelegate> {
    BOOL isLogin;
}

@property (nonatomic, weak) UIView *headView;

@property (nonatomic, weak) UIView *footerView;

@property (nonatomic, weak) UIImageView *icon;

@property (nonatomic, weak) UILabel *usernameLabel;

@property (nonatomic, weak) UILabel *comment;

@property (nonatomic, weak) UILabel *prompt;

@property (nonatomic, weak) UIButton *loginButton;

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, weak) UIButton *exitButton;

@property (nonatomic, strong) NSMutableArray *mineList;

@property (nonatomic, strong) NSMutableArray *list;

@end

@implementation XYMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    isLogin = NO;
    [self createLocalData];
    [self createHeadView];
    [self createTableView];
}

- (void)createLocalData {
    ListItem *myCell = [[ListItem alloc]init];
    myCell.imageURL = @"fish_cell";
    myCell.itemName = @"我的鱼贝";
    
    ItemGroup *group1 = [[ItemGroup alloc]init];
    group1.items = [NSMutableArray arrayWithObject:myCell];
    
    ListItem *myPublish = [[ListItem alloc]init];
    myPublish.itemName = @"我发布的";
    myPublish.imageURL = @"icon_account_selling";
    
    ListItem *mySale = [[ListItem alloc]init];
    mySale.itemName = @"我卖出的";
    mySale.imageURL = @"icon_account_sold";
    
    ListItem *myBuy = [[ListItem alloc]init];
    myBuy.itemName = @"我买到的";
    myBuy.imageURL = @"icon_account_buy";
    
    ListItem *myLike = [[ListItem alloc]init];
    myLike.itemName = @"我赞过的";
    myLike.imageURL = @"icon_account_selling";

    ItemGroup *group2 = [[ItemGroup alloc]init];
    group2.items = [NSMutableArray arrayWithArray:@[myPublish, mySale, myBuy, myLike]];
    
    ListItem *setting = [[ListItem alloc]init];
    setting.itemName = @"设置";
    setting.imageURL = @"icon_account_settings";
    
    ItemGroup *group3 = [[ItemGroup alloc]init];
    group3.items = [NSMutableArray arrayWithObject:setting];
    
    [self.mineList addObject:group1];
    [self.mineList addObject:group2];
    [self.mineList addObject:group3];
    
    ListItem *helpAndFeedback = [[ListItem alloc]init];
    helpAndFeedback.itemName = @"帮助与反馈";
    helpAndFeedback.imageURL = @"help";
    
    ItemGroup *group4 = [[ItemGroup alloc]init];
    group4.items = [NSMutableArray arrayWithObject:helpAndFeedback];
    
    [self.list addObject:group4];
}

- (void)createHeadView {
    UIView *headView = [[UIView alloc]init];
    headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT * 0.1);
    headView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(10, CGRectGetMidY(headView.frame) - 20, 40, 40)];
    [icon sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"avatar_placehold"]];
    [headView addSubview:icon];
    
    UILabel *usernameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(icon.frame) + 15, 20, 100, 8)];
    
    UILabel *comment = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(icon.frame) + 15, 40, 150, 8)];
    
    [headView addSubview:usernameLabel];
    [headView addSubview:comment];
    
    UIButton *loginButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headView.frame) - 110, headView.frame.size.height / 3, 100, headView.frame.size.height / 3)];
    loginButton.backgroundColor = [UIColor yellowColor];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[NSFontAttributeName] = [UIFont systemFontOfSize:12.5];
    NSAttributedString *title = [[NSAttributedString alloc]initWithString:@"马上登录" attributes:dic];
    [loginButton setAttributedTitle:title forState:UIControlStateNormal];
    [loginButton setAttributedTitle:title forState:UIControlStateSelected];
    [loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    
    NSAttributedString *text = [[NSAttributedString alloc]initWithString:@"你还没有登录哦。" attributes:dic];
    UILabel *prompt = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(icon.frame) + 15, CGRectGetMidY(headView.frame) - CGRectGetHeight(headView.frame) * 0.075, CGRectGetWidth(headView.frame) * 0.5, CGRectGetHeight(headView.frame) * 0.1)];
    [prompt setAttributedText:text];
    prompt.centerY = headView.centerY;
    
    [headView addSubview:loginButton];
    [headView addSubview:prompt];
    
    [usernameLabel setHidden:YES];
    [comment setHidden:YES];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [headView addGestureRecognizer:tap];
    
    self.icon = icon;
    self.usernameLabel = usernameLabel;
    self.comment = comment;
    self.prompt = prompt;
    self.loginButton = loginButton;
    
    [self.view addSubview:headView];
    self.headView = headView;
}

- (void)createFooterView {
    UIView *footerView = [[UIView alloc]init];
    CGRect frame = footerView.frame;
    frame.origin = CGPointMake(0, CGRectGetMaxY(self.tableView.frame));
    frame.size = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT * 0.1);
    footerView.frame = frame;
    footerView.backgroundColor = [UIColor clearColor];
    
    UIButton *exitButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 15, SCREEN_WIDTH - 40, CGRectGetHeight(footerView.frame) - 30)];
    [exitButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [exitButton setTitle:@"退出登录" forState:UIControlStateSelected];
    [exitButton addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    [exitButton setTintColor:[UIColor whiteColor]];
    [exitButton setBackgroundColor:[UIColor redColor]];
    [footerView addSubview:exitButton];
    [self.view addSubview:footerView];
    
    self.tableView.tableFooterView = footerView;
    
    self.footerView = footerView;
    self.exitButton = exitButton;
}

- (void)logout {
    self.tableView.tableFooterView = nil;
    [self.exitButton removeFromSuperview];
    [self.footerView removeFromSuperview];
    
    [self.mineList removeObjectAtIndex:[self.mineList count] - 2];
    
    [self.tableView reloadData];
    
    [_loginButton setHidden:NO];
    [_prompt setHidden:NO];
    [_usernameLabel setHidden:YES];
    [_comment setHidden:YES];
}

- (void)tap {
    NSLog(@"个人信息");
}

- (void)login {
    [_loginButton setHidden:YES];
    [_prompt setHidden:YES];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    [_usernameLabel setAttributedText:[[NSAttributedString alloc]initWithString:@"XXOO" attributes:dic]];
    [_usernameLabel setHidden:NO];
    NSMutableDictionary *dicForComment = [NSMutableDictionary dictionary];
    dicForComment[NSFontAttributeName] = [UIFont systemFontOfSize:6];
    [_comment setAttributedText:[[NSAttributedString alloc]initWithString:@"虽然没挣到钱，但在闲鱼开心就好" attributes:dicForComment]];
    [_comment setHidden:NO];
    
    for (int i = 0; i < self.list.count; i++) {
        ItemGroup *group = self.list[i];
        NSInteger end = [self.mineList count];
        [self.mineList insertObject:group atIndex:end - 1];
    }
    
    [self.tableView reloadData];
    
    [self createFooterView];
    
    isLogin = YES;
}

- (void)createTableView {
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,SCREEN_HEIGHT - 49) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.rowHeight = 40;
    tableView.bounces = YES;
    tableView.sectionFooterHeight = 0.0;
    tableView.tableHeaderView = self.headView;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ItemGroup *group = self.mineList[section];
    return [group.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemGroup *group = self.mineList[indexPath.section];
    ListItem *item = group.items[indexPath.row];
    static NSString *ID = @"item";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.backgroundColor = [UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (cell) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[NSFontAttributeName] = [UIFont systemFontOfSize:10];
        [cell.imageView setImage:[UIImage imageNamed:item.imageURL]];
        [cell.textLabel setAttributedText:[[NSAttributedString alloc]initWithString:item.itemName attributes:dic]];
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.mineList count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ;
    }
    else if (indexPath.section == 1 && indexPath.row == 0) {
        ;
    }
    else if (indexPath.section == 1 && indexPath.row == 1) {
        ;
    }
    else if (indexPath.section == 1 && indexPath.row == 2) {
        ;
    }
    else if (indexPath.section == 1 && indexPath.row == 3) {
        ;
    }
    else if (indexPath.section == 2 && indexPath.row == 0 && isLogin == NO) {
        XYSettingViewController *setting = [[XYSettingViewController alloc]init];
        setting.isLogin = isLogin;
        [self.navigationController pushViewController:setting animated:YES];
    }
    else if (indexPath.section == 2 && indexPath.row == 0 && isLogin == YES) {
        ;
    }
    else if (indexPath.section == 3 && indexPath.row == 0) {
        XYSettingViewController *setting = [[XYSettingViewController alloc]init];
        setting.isLogin = isLogin;
        [self.navigationController pushViewController:setting animated:YES];
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSMutableArray *)mineList {
    if (!_mineList) {
        self.mineList = [NSMutableArray array];
    }
    return _mineList;
}

- (NSMutableArray *)list {
    if (!_list) {
        self.list = [NSMutableArray array];
    }
    return _list;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
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
