//
//  XYSettingViewController.m
//  XianYu
//
//  Created by YuanZhihao on 7/16/16.
//  Copyright © 2016 YuanZhihao. All rights reserved.
//

#import "XYSettingViewController.h"
#import "ListItem.h"
#import "ItemGroup.h"
#import "XYPhotoQualitySettingViewController.h"

@interface XYSettingViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, weak) UISwitch *switches;

@property (nonatomic, strong) NSMutableArray *settings;

@end

@implementation XYSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createLocalData];
    [self createTableView];
}

- (void)loadView {
    UIView *view = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
}

- (void)createLocalData {
    if (self.isLogin) {
        ListItem *userInformation = [[ListItem alloc]init];
        userInformation.itemName = @"个人资料设置";
        
        ListItem *blackList = [[ListItem alloc]init];
        blackList.itemName = @"黑名单";
        
        ItemGroup *group0 = [[ItemGroup alloc]init];
        group0.items = [NSMutableArray arrayWithArray:@[userInformation, blackList]];
        
        [self.settings addObject:group0];
    }
    
    ListItem *photoQualitySetting = [[ListItem alloc]init];
    photoQualitySetting.itemName = @"图片质量设置";
    
    ListItem *messageRemindSetting = [[ListItem alloc]init];
    messageRemindSetting.itemName = @"消息提醒设置";
    
    ListItem *enableEarphoneMode = [[ListItem alloc]init];
    enableEarphoneMode.itemName = @"开启听筒模式";
    
    ItemGroup *group1 = [[ItemGroup alloc]init];
    group1.items = [NSMutableArray arrayWithArray:@[photoQualitySetting, messageRemindSetting, enableEarphoneMode]];
    
    ListItem *aboutXianYu = [[ListItem alloc]init];
    aboutXianYu.itemName = @"关于闲鱼";
    
    ListItem *helpAndFeedback = [[ListItem alloc]init];
    helpAndFeedback.itemName = @"帮助与反馈";
    
    ItemGroup *group2 = [[ItemGroup alloc]init];
    group2.items = [NSMutableArray arrayWithArray:@[aboutXianYu, helpAndFeedback]];
    
    ListItem *clearCache = [[ListItem alloc]init];
    clearCache.itemName = @"清除缓存";
    
    ItemGroup *group3 = [[ItemGroup alloc]init];
    group3.items = [NSMutableArray arrayWithObject:clearCache];
    
    [self.settings addObject:group1];
    [self.settings addObject:group2];
    [self.settings addObject:group3];
}

- (void)createTableView {
    UITableView *tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.rowHeight = 45;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ItemGroup *group = self.settings[section];
    return [group.items count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.settings count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemGroup *group = self.settings[indexPath.section];
    ListItem *item = group.items[indexPath.row];
    static NSString *ID = @"setting";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.backgroundColor = [UIColor whiteColor];
    }
    if (cell) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[NSFontAttributeName] = [UIFont systemFontOfSize:10];
        [cell.textLabel setAttributedText:[[NSAttributedString alloc]initWithString:item.itemName attributes:dic]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if ([item.itemName isEqualToString:@"开启听筒模式"]) {
            UISwitch *switches = [[UISwitch alloc]init];
            CGRect frame = switches.frame;
            frame.size = CGSizeMake(40, 40);
            switches.frame = frame;
            [switches addTarget:self action:@selector(changeSetting) forControlEvents:UIControlEventTouchUpInside];
            self.switches = switches;
            cell.accessoryView = switches;
        }
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (NSMutableArray *)settings {
    if (!_settings) {
        self.settings = [NSMutableArray array];
    }
    return _settings;
}

- (void)changeSetting {
    NSUserDefaults *userSettings = [NSUserDefaults standardUserDefaults];
    [userSettings setBool:self.switches.on forKey:@"enableEarphoneMode"];
    [userSettings synchronize];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        XYPhotoQualitySettingViewController *photoSetting = [XYPhotoQualitySettingViewController new];
        [self.navigationController pushViewController:photoSetting animated:YES];
    }
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
