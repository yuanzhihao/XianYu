//
//  XYMenuViewController.m
//  XianYu
//
//  Created by YuanZhihao on 6/23/16.
//  Copyright © 2016 YuanZhihao. All rights reserved.
//

#import "XYMenuViewController.h"
#import "UIImage+Image.h"

#define NavBarColor [UIColor colorWithRed:250/255.0 green:227/255.0 blue:111/255.0 alpha:1.0]

@interface XYMenuViewController ()

@end

@implementation XYMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self changeNav];
}

- (void)changeNav {
    self.navigationItem.title = @"类别";
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"header_back_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = left;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView {
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
}

- (void)goBack {
    UINavigationController *temp = self.navigationController;
    [self.navigationController popViewControllerAnimated:YES];
    [temp.navigationBar setBackgroundImage:[UIImage imageWithColor:NavBarColor] forBarMetrics:UIBarMetricsDefault];
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
