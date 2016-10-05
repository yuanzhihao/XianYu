//
//  XYPhotoQualitySettingViewController.m
//  XianYu
//
//  Created by YuanZhihao on 7/19/16.
//  Copyright © 2016 YuanZhihao. All rights reserved.
//

#import "XYPhotoQualitySettingViewController.h"
#import "ItemGroup.h"
#import "ListItem.h"

@interface XYPhotoQualitySettingViewController () <UITableViewDataSource, UITableViewDelegate> {
    NSInteger choice;
}

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *settings;

@property (nonatomic, strong) NSMutableArray *keys;

@property (nonatomic, weak) UIImageView *imageView;

@end

@implementation XYPhotoQualitySettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _keys = [NSMutableArray array];
    [_keys addObject:@"autoUploadZipPhoto"];
    [_keys addObject:@"onlyPublishGoodsUnderWIFI"];
    [_keys addObject:@"downloadPhotoQuality"];
    NSString *key = self.keys[self.keys.count - 1];
    NSUserDefaults *userSettings = [NSUserDefaults standardUserDefaults];
    choice = [userSettings integerForKey:key];
    [self createLocalData];
    [self createTableView];
}

- (void)loadView {
    UIView *view = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
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

- (void)createLocalData {
    ListItem *item1 = [ListItem new];
    item1.itemName = @"自动压缩图片上传";
    
    ListItem *item2 = [ListItem new];
    item2.itemName = @"只在WIFI环境下发布宝贝";
    
    ItemGroup *group1 = [ItemGroup new];
    group1.title = @"上传图片质量";
    group1.items = [NSMutableArray arrayWithArray:@[item1, item2]];
    
    ListItem *item3 = [ListItem new];
    item3.itemName = @"自动";
    
    ListItem *item4 = [ListItem new];
    item4.itemName = @"高清(建议在Wifi网络使用)";
    
    ListItem *item5 = [ListItem new];
    item5.itemName = @"普通(下载速度快，省流量)";
    
    ItemGroup *group2 = [ItemGroup new];
    group2.title = @"下载图片质量";
    group2.items = [NSMutableArray arrayWithArray:@[item3, item4, item5]];
    
    [self.settings addObject:group1];
    [self.settings addObject:group2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ItemGroup *group = self.settings[section];
    return [group.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemGroup *group = self.settings[indexPath.section];
    ListItem *item = group.items[indexPath.row];
    static NSString *ID = @"photoSetting";
    NSUserDefaults *userSettings = [NSUserDefaults standardUserDefaults];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    if (cell) {
        [cell.textLabel setText:item.itemName];
        if ([group.title isEqualToString:@"上传图片质量"]) {
            UISwitch *switches = [[UISwitch alloc]init];
            switches.tag = indexPath.row;
            CGRect frame = switches.frame;
            frame.size = CGSizeMake(40, 40);
            switches.frame = frame;
            [switches addTarget:self action:@selector(changeSetting:) forControlEvents:UIControlEventTouchUpInside];
            NSString *key = self.keys[indexPath.row];
            BOOL setting = [userSettings boolForKey:key];
            [switches setOn:setting];
            cell.accessoryView = switches;
        }
        else {
            UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"select"]];
            [imageView setHidden:YES];
            cell.accessoryView = imageView;
            if (indexPath.row == choice) {
                [imageView setHidden:NO];
                self.imageView = imageView;
            }
        }
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.settings count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    ItemGroup *group = self.settings[section];
    return  group.title;
}
             
- (void)changeSetting:(id)sender {
    UISwitch *switches = sender;
    NSUserDefaults *userSetting = [NSUserDefaults standardUserDefaults];
    if (switches.tag == 0) {
        [userSetting setBool:switches.on forKey:@"autoUploadZipPhoto"];
    }
    else if (switches.tag == 1) {
        [userSetting setBool:switches.on forKey:@"onlyPublishGoodsUnderWIFI"];
    }
    [userSetting synchronize];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != 0) {
        [self.imageView setHidden:YES];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UIImageView *view = (UIImageView *)cell.accessoryView;
        [view setHidden:NO];
        self.imageView = view;
    }
    NSUserDefaults *userSettings = [NSUserDefaults standardUserDefaults];
    NSString *key = self.keys[self.keys.count - 1];
    [userSettings setInteger:indexPath.row forKey:key];
    [userSettings synchronize];
}

- (NSMutableArray *)settings {
    if (!_settings) {
        self.settings = [NSMutableArray array];
    }
    return _settings;
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
